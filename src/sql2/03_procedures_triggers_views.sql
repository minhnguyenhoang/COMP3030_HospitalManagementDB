-- FILE: 03_procedures_triggers_views.sql
-- PURPOSE: Views, Stored Procedures, and Triggers (updated for Django table/column names)

USE HospitalDB;

-- ==========================================
-- 1. VIEWS
-- ==========================================

-- View: Patient Full Profile
-- Joins Patient with PersonalInformation and EmergencyContact
CREATE OR REPLACE VIEW View_PatientFullProfile AS
SELECT
    p.id AS patient_id,
    CONCAT(p.first_name, ' ', IFNULL(p.last_name, '')) AS full_name,
    p.dob,
    p.phone,
    p.email,
    ppi.city,
    ppi.state,
    ppi.country,
    pec.contact_information AS emergency_contact,
    pec.relationship AS emergency_relationship
FROM Patient p
LEFT JOIN PatientPersonalInformation ppi ON p.id = ppi.patient_id
LEFT JOIN PatientEmergencyContact pec ON p.id = pec.patient_id;

-- View: Available Doctors
-- Shows doctors who are available (On-Demand or Active status)
CREATE OR REPLACE VIEW View_AvailableDoctors AS
SELECT
    d.id AS doctor_id,
    CONCAT(d.first_name, ' ', IFNULL(d.last_name, '')) AS doctor_name,
    dept.department_name,
    d.expertise,
    lvl.title AS doctor_level,
    status.status_name AS active_status
FROM Doctor d
JOIN Department dept ON d.department_id = dept.id
JOIN Type_DoctorLevel lvl ON d.doctor_level_id = lvl.id
JOIN Type_DoctorActiveStatus status ON d.active_status_id = status.id
WHERE status.status_name IN ('On-Demand', 'Active');

-- View: Medicine Stock Levels
-- Shows current stock level for each medicine
CREATE OR REPLACE VIEW View_MedicineStock AS
SELECT
    m.id AS medicine_id,
    m.medicine_name,
    m.producer,
    m.medicine_unit,
    COALESCE(SUM(CASE WHEN msh.add_remove = 1 THEN msh.amount ELSE -msh.amount END), 0) AS current_stock
FROM Medicine m
LEFT JOIN MedicineStockHistory msh ON m.id = msh.medicine_id
GROUP BY m.id, m.medicine_name, m.producer, m.medicine_unit;

-- ==========================================
-- 2. STORED PROCEDURES
-- ==========================================

DELIMITER //

-- Procedure: Create Appointment
-- Validates that doctor is available before creating appointment
CREATE PROCEDURE sp_CreateAppointment(
    IN p_patient_id INT,
    IN p_doctor_id INT,
    IN p_visit_date DATETIME,
    IN p_note VARCHAR(255)
)
BEGIN
    DECLARE v_status_name VARCHAR(50);

    -- Check if doctor exists and get status
    SELECT status_name INTO v_status_name
    FROM Doctor d
    JOIN Type_DoctorActiveStatus s ON d.active_status_id = s.id
    WHERE d.id = p_doctor_id;

    -- Validate doctor availability
    IF v_status_name IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Doctor does not exist.';
    ELSEIF v_status_name NOT IN ('On-Demand', 'Active') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Doctor is not available.';
    ELSE
        INSERT INTO Appointments (patient_id, doctor_id, visit_date, note)
        VALUES (p_patient_id, p_doctor_id, p_visit_date, p_note);
    END IF;
END //

-- Procedure: Prescribe Medicine
-- Creates a prescription record for an appointment
CREATE PROCEDURE sp_PrescribeMedicine(
    IN p_appointment_id INT,
    IN p_medicine_id INT,
    IN p_amount INT,
    IN p_prescription_date DATE
)
BEGIN
    INSERT INTO PrescriptionHistory (appointment_id, medicine_id, amount, prescription_date)
    VALUES (p_appointment_id, p_medicine_id, p_amount, p_prescription_date);
END //

-- Procedure: Add Medicine Stock
-- Adds stock for a medicine (restocking)
CREATE PROCEDURE sp_AddMedicineStock(
    IN p_medicine_id INT,
    IN p_amount INT,
    IN p_note VARCHAR(255)
)
BEGIN
    INSERT INTO MedicineStockHistory (medicine_id, add_remove, amount, note)
    VALUES (p_medicine_id, 1, p_amount, p_note);
END //

DELIMITER ;

-- ==========================================
-- 3. TRIGGERS
-- ==========================================

DELIMITER //

-- Trigger: Update Stock After Prescription
-- Automatically reduces stock when a prescription is created
CREATE TRIGGER trg_UpdateStockAfterPrescription
AFTER INSERT ON PrescriptionHistory
FOR EACH ROW
BEGIN
    -- Insert stock history record (add_remove = 0 means remove/deduct)
    INSERT INTO MedicineStockHistory (medicine_id, add_remove, amount, appointment_id, note)
    VALUES (NEW.medicine_id, 0, NEW.amount, NEW.appointment_id, 'Prescription Deduction');
END //

-- Trigger: Prevent Negative Medicine Stock
-- Validates sufficient stock exists before allowing removal
CREATE TRIGGER trg_PreventNegativeMedicineStock
BEFORE INSERT ON MedicineStockHistory
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;

    -- Calculate current stock for this medicine
    SELECT COALESCE(SUM(CASE WHEN add_remove = 1 THEN amount ELSE -amount END), 0)
    INTO current_stock
    FROM MedicineStockHistory
    WHERE medicine_id = NEW.medicine_id;

    -- If this is a removal (add_remove = 0), check if sufficient stock exists
    IF NEW.add_remove = 0 AND current_stock < NEW.amount THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Insufficient medicine stock.';
    END IF;
END //

DELIMITER ;

-- ==========================================
-- NOTES:
-- ==========================================
-- 1. All table and column names updated to match Django models
-- 2. Views use snake_case column names (e.g., patient_id, doctor_id)
-- 3. Procedures validate data before insertion
-- 4. Triggers automatically maintain data integrity
-- 5. Stock trigger prevents negative inventory
-- 6. Available doctors view uses status_name instead of hardcoded IDs
