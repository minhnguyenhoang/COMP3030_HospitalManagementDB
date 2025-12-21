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

-- ==========================================
-- UPDATE PROCEDURES
-- ==========================================

-- Procedure: Update Patient Information
CREATE PROCEDURE sp_UpdatePatient(
    IN p_patient_id INT,
    IN p_first_name VARCHAR(50),
    IN p_middle_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_dob DATE,
    IN p_gender VARCHAR(20),
    IN p_biological_sex VARCHAR(20),
    IN p_phone VARCHAR(20),
    IN p_email VARCHAR(100),
    IN p_blood_type VARCHAR(10),
    IN p_ethnicity VARCHAR(50),
    IN p_preferred_language VARCHAR(50),
    IN p_insurance_id VARCHAR(50),
    IN p_insurance_provider VARCHAR(100)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Patient WHERE id = p_patient_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Patient does not exist.';
    ELSE
        UPDATE Patient
        SET first_name = p_first_name,
            middle_name = p_middle_name,
            last_name = p_last_name,
            dob = p_dob,
            gender = p_gender,
            biological_sex = p_biological_sex,
            phone = p_phone,
            email = p_email,
            blood_type = p_blood_type,
            ethnicity = p_ethnicity,
            preferred_language = p_preferred_language,
            insurance_id = p_insurance_id,
            insurance_provider = p_insurance_provider,
            last_visit_date = CURDATE()
        WHERE id = p_patient_id;
    END IF;
END //

-- Procedure: Update Doctor Information
CREATE PROCEDURE sp_UpdateDoctor(
    IN p_doctor_id INT,
    IN p_first_name VARCHAR(50),
    IN p_middle_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_phone VARCHAR(20),
    IN p_email VARCHAR(100),
    IN p_address VARCHAR(255),
    IN p_expertise VARCHAR(100),
    IN p_doctor_level_id INT,
    IN p_active_status_id INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Doctor WHERE id = p_doctor_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Doctor does not exist.';
    ELSE
        UPDATE Doctor
        SET first_name = p_first_name,
            middle_name = p_middle_name,
            last_name = p_last_name,
            phone = p_phone,
            email = p_email,
            address = p_address,
            expertise = p_expertise,
            doctor_level_id = p_doctor_level_id,
            active_status_id = p_active_status_id
        WHERE id = p_doctor_id;
    END IF;
END //

-- Procedure: Update Appointment
CREATE PROCEDURE sp_UpdateAppointment(
    IN p_appointment_id INT,
    IN p_visit_date DATETIME,
    IN p_diagnosis VARCHAR(255),
    IN p_treatment VARCHAR(255),
    IN p_note VARCHAR(255)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Appointments WHERE id = p_appointment_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Appointment does not exist.';
    ELSE
        UPDATE Appointments
        SET visit_date = p_visit_date,
            diagnosis = p_diagnosis,
            treatment = p_treatment,
            note = p_note
        WHERE id = p_appointment_id;
    END IF;
END //

-- Procedure: Update Medicine Information
CREATE PROCEDURE sp_UpdateMedicine(
    IN p_medicine_id INT,
    IN p_medicine_name VARCHAR(100),
    IN p_producer VARCHAR(100),
    IN p_medicine_unit VARCHAR(50),
    IN p_price DECIMAL(10, 2)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Medicine WHERE id = p_medicine_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Medicine does not exist.';
    ELSE
        UPDATE Medicine
        SET medicine_name = p_medicine_name,
            producer = p_producer,
            medicine_unit = p_medicine_unit,
            price = p_price
        WHERE id = p_medicine_id;
    END IF;
END //

-- ==========================================
-- DELETE PROCEDURES
-- ==========================================

-- Procedure: Delete Patient
CREATE PROCEDURE sp_DeletePatient(
    IN p_patient_id INT
)
BEGIN
    DECLARE appointment_count INT;

    IF NOT EXISTS (SELECT 1 FROM Patient WHERE id = p_patient_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Patient does not exist.';
    ELSE
        SELECT COUNT(*) INTO appointment_count
        FROM Appointments
        WHERE patient_id = p_patient_id;

        IF appointment_count > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Cannot delete patient with existing appointments.';
        ELSE
            DELETE FROM PatientEmergencyContact WHERE patient_id = p_patient_id;
            DELETE FROM PatientPersonalInformation WHERE patient_id = p_patient_id;
            DELETE FROM Patient WHERE id = p_patient_id;
        END IF;
    END IF;
END //

-- Procedure: Delete Doctor
CREATE PROCEDURE sp_DeleteDoctor(
    IN p_doctor_id INT
)
BEGIN
    DECLARE appointment_count INT;

    IF NOT EXISTS (SELECT 1 FROM Doctor WHERE id = p_doctor_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Doctor does not exist.';
    ELSE
        SELECT COUNT(*) INTO appointment_count
        FROM Appointments
        WHERE doctor_id = p_doctor_id;

        IF appointment_count > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Cannot delete doctor with existing appointments.';
        ELSE
            DELETE FROM Doctor WHERE id = p_doctor_id;
        END IF;
    END IF;
END //

-- Procedure: Delete Appointment
CREATE PROCEDURE sp_DeleteAppointment(
    IN p_appointment_id INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Appointments WHERE id = p_appointment_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Appointment does not exist.';
    ELSE
        DELETE FROM PrescriptionHistory WHERE appointment_id = p_appointment_id;
        DELETE FROM MedicineStockHistory WHERE appointment_id = p_appointment_id;
        DELETE FROM Appointments WHERE id = p_appointment_id;
    END IF;
END //

-- Procedure: Delete Medicine
CREATE PROCEDURE sp_DeleteMedicine(
    IN p_medicine_id INT
)
BEGIN
    DECLARE usage_count INT;

    IF NOT EXISTS (SELECT 1 FROM Medicine WHERE id = p_medicine_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Medicine does not exist.';
    ELSE
        SELECT COUNT(*) INTO usage_count
        FROM PrescriptionHistory
        WHERE medicine_id = p_medicine_id;

        IF usage_count > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Cannot delete medicine with prescription history.';
        ELSE
            DELETE FROM MedicineStockHistory WHERE medicine_id = p_medicine_id;
            DELETE FROM Medicine WHERE id = p_medicine_id;
        END IF;
    END IF;
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
