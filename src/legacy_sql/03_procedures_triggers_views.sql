-- FILE: 03_procedures_triggers_views.sql
-- PURPOSE: Views, Procedures, and Triggers

USE HospitalDB;

-- ==========================================
-- 1. VIEWS
-- ==========================================

-- View: Patient Summary (Joins Patient, Personal, and Emergency Contact)
CREATE OR REPLACE VIEW View_PatientFullProfile AS
SELECT 
    p.PatientID,
    CONCAT(p.FirstName, ' ', p.LastName) AS FullName,
    p.DOB,
    p.Phone,
    ppi.City,
    pec.ContactInformation AS EmergencyContact
FROM Patient p
LEFT JOIN PatientPersonalInformation ppi ON p.PatientID = ppi.PatientID
LEFT JOIN PatientEmergencyContact pec ON p.PatientID = pec.PatientID;

-- View: Patient History (Joins Patient, Personal, and Emergency Contact)
CREATE OR REPLACE VIEW View_PatientFullProfile AS
SELECT 
    p.PatientID,
    CONCAT(p.FirstName, ' ', p.LastName) AS FullName,
    p.DOB,
    p.Phone,
    ppi.City,
    pec.ContactInformation AS EmergencyContact
FROM Patient p
LEFT JOIN PatientPersonalInformation ppi ON p.PatientID = ppi.PatientID
LEFT JOIN PatientEmergencyContact pec ON p.PatientID = pec.PatientID;

-- View: Active Doctors
-- This will now show "John Doe" because we added him in File 2
CREATE OR REPLACE VIEW View_AvailableDoctors AS
SELECT 
    d.DoctorID,
    CONCAT(d.FirstName, ' ', d.LastName) AS Name,
    dept.DepartmentName,
    lvl.Title
FROM Doctor d
JOIN Department dept ON d.DepartmentID = dept.DepartmentID
JOIN Type_DoctorLevel lvl ON d.DoctorLevel = lvl.ID
WHERE d.ActiveStatus IN (2, 3); -- On-demand or Active



-- ==========================================
-- 2. STORED PROCEDURES
-- ==========================================

DELIMITER //

-- Procedure: Create Appointment (Validates Active Doctor)
CREATE PROCEDURE sp_CreateAppointment(
    IN p_PatientID INT,
    IN p_DoctorID INT,
    IN p_Date DATE,
    IN p_Note VARCHAR(255)
)
BEGIN
    DECLARE v_Status INT;
    
    -- Check if doctor exists and get status
    SELECT ActiveStatus INTO v_Status FROM Doctor WHERE DoctorID = p_DoctorID;
    
    -- If variable is null (doctor doesn't exist) or status < 2 (inactive)
    IF v_Status IS NULL OR v_Status < 2 THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Doctor is not available or does not exist.';
    ELSE
        INSERT INTO Appointments (PatientID, DoctorID, VisitDate, Note, Category)
        VALUES (p_PatientID, p_DoctorID, p_Date, p_Note, 0);
    END IF;
END //

-- Procedure: Prescribe Medicine
CREATE PROCEDURE sp_PrescribeMedicine(
    IN p_AppointmentID INT,
    IN p_VisitDate DATE,
    IN p_MedicineID INT,
    IN p_Amount INT
)
BEGIN
    INSERT INTO PrescriptionHistory (AppointmentID, VisitDate, MedicineID, Amount)
    VALUES (p_AppointmentID, p_VisitDate, p_MedicineID, p_Amount);
END //

-- CREATE PROCEDURE sp_TrackMedicineStock(
-- 	IN p_
-- );
-- END //

DELIMITER ;

-- ==========================================
-- 3. TRIGGERS
-- ==========================================

DELIMITER //

-- Trigger: Update Stock after Prescription
-- Requirement: When a prescription is added, reduce stock and log it
CREATE TRIGGER trg_UpdateStockAfterPrescription
AFTER INSERT ON PrescriptionHistory
FOR EACH ROW
BEGIN
    -- Insert into MedicineStockHistory
    -- AddRemove: 0 (Remove/Deduct), defined as BIT
    INSERT INTO MedicineStockHistory (MedicineID, AddRemove, Amount, AppointmentID, Note)
    VALUES (NEW.MedicineID, 0, NEW.Amount, NEW.AppointmentID, 'Prescription Deduction');
END //

-- Trigger: To disallow stock removals if not enough
-- Requirement: Adding a MedicineStockHistory entry with AddRemove = 0 will check if 
CREATE TRIGGER trg_PreventNegativeMedicineStock
BEFORE INSERT ON MedicineStockHistory
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;

    -- Calculate current stock for this medicine
    SELECT COALESCE(SUM(CASE WHEN AddRemove = 1 THEN Amount ELSE -Amount END), 0)
    INTO current_stock
    FROM MedicineStockHistory
    WHERE MedicineID = NEW.MedicineID;

    -- If this is a removal, check stock
    IF NEW.AddRemove = 0 AND current_stock < NEW.Amount THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Insufficient medicine stock';
    END IF;
END //

DELIMITER ;