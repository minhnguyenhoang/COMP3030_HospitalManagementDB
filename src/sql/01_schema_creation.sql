-- FILE: 01_schema_creation.sql
-- PURPOSE: Create tables matching Django models exactly
-- MAPPING: Table names use PascalCase (db_table), columns use snake_case lowercase

DROP DATABASE IF EXISTS HospitalDB;
CREATE DATABASE HospitalDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE HospitalDB;

-- ==========================================
-- 1. LOOKUP TABLES
-- ==========================================

-- Type_CoreMedInfo (pharmacy.TypeCoreMedInfo)
CREATE TABLE Type_CoreMedInfo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

-- Type_MedicineFunction (pharmacy.TypeMedicineFunction)
CREATE TABLE Type_MedicineFunction (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

-- Type_MedicineAdministration (pharmacy.TypeMedicineAdministration)
CREATE TABLE Type_MedicineAdministration (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

-- Type_DoctorLevel (doctors.DoctorLevel)
CREATE TABLE Type_DoctorLevel (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

-- Type_DoctorActiveStatus (doctors.DoctorActiveStatus)
CREATE TABLE Type_DoctorActiveStatus (
    id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

-- ==========================================
-- 2. MAIN ENTITIES
-- ==========================================

-- Department (doctors.Department)
CREATE TABLE Department (
    id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    description VARCHAR(255) NULL,
    head_of_department_id INT NULL
) ENGINE=InnoDB;

-- Doctor (doctors.Doctor)
CREATE TABLE Doctor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    department_id INT NOT NULL,
    medical_license_id VARCHAR(50) NULL,
    dob DATE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50) NULL,
    last_name VARCHAR(50) NULL,
    gender VARCHAR(20) NOT NULL,
    national_id VARCHAR(20) NOT NULL UNIQUE,
    phone VARCHAR(20) NULL,
    email VARCHAR(100) NULL,
    address VARCHAR(255) NULL,
    expertise VARCHAR(100) NOT NULL,
    doctor_level_id INT NOT NULL,
    active_status_id INT NOT NULL,
    INDEX idx_doctor_license (medical_license_id),
    FOREIGN KEY (department_id) REFERENCES Department(id) ON DELETE RESTRICT,
    FOREIGN KEY (doctor_level_id) REFERENCES Type_DoctorLevel(id) ON DELETE RESTRICT,
    FOREIGN KEY (active_status_id) REFERENCES Type_DoctorActiveStatus(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Add Foreign Key to Department for head_of_department (circular dependency)
ALTER TABLE Department
ADD CONSTRAINT fk_dept_head
FOREIGN KEY (head_of_department_id) REFERENCES Doctor(id) ON DELETE SET NULL;

-- Patient (patients.Patient)
CREATE TABLE Patient (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50) NULL,
    last_name VARCHAR(50) NOT NULL,
    dob DATE NOT NULL,
    ethnicity VARCHAR(50) NULL,
    preferred_language VARCHAR(50) NULL,
    gender VARCHAR(20) NOT NULL,
    biological_sex VARCHAR(20) NOT NULL,
    phone VARCHAR(20) NULL,
    email VARCHAR(100) NULL,
    first_visit_date DATE NOT NULL,
    last_visit_date DATE NOT NULL,
    insurance_id VARCHAR(50) NULL,
    insurance_provider VARCHAR(100) NULL,
    blood_type VARCHAR(10) NULL,
    height INT NULL,
    weight INT NULL,
    dnr_status TINYINT(1) NOT NULL DEFAULT 0,
    organ_donor_status TINYINT(1) NOT NULL DEFAULT 0,
    INDEX idx_patient_lastname (last_name)
) ENGINE=InnoDB;

-- PatientPersonalInformation (patients.PatientPersonalInformation)
CREATE TABLE PatientPersonalInformation (
    patient_id INT PRIMARY KEY,
    occupation VARCHAR(100) NULL,
    nat_id VARCHAR(50) NULL,
    passport_no VARCHAR(50) NULL,
    drivers_license_no VARCHAR(50) NULL,
    address VARCHAR(255) NULL,
    city VARCHAR(100) NULL,
    state VARCHAR(100) NULL,
    country VARCHAR(100) NULL,
    FOREIGN KEY (patient_id) REFERENCES Patient(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- PatientCoreMedicalInformation (patients.PatientCoreMedicalInformation)
CREATE TABLE PatientCoreMedicalInformation (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    information_type INT NOT NULL,
    note VARCHAR(255) NULL,
    FOREIGN KEY (patient_id) REFERENCES Patient(id) ON DELETE CASCADE,
    FOREIGN KEY (information_type) REFERENCES Type_CoreMedInfo(id)
) ENGINE=InnoDB;

-- PatientEmergencyContact (patients.PatientEmergencyContact)
CREATE TABLE PatientEmergencyContact (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    contact_type VARCHAR(50) NOT NULL,
    contact_information VARCHAR(255) NOT NULL,
    relationship VARCHAR(50) NOT NULL,
    last_updated DATE NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES Patient(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Medicine (pharmacy.Medicine)
CREATE TABLE Medicine (
    id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_name VARCHAR(100) NOT NULL,
    producer VARCHAR(100) NULL,
    medicine_type_id INT NULL,
    medicine_administration_method_id INT NULL,
    medicine_unit VARCHAR(20) NOT NULL,
    FOREIGN KEY (medicine_type_id) REFERENCES Type_MedicineFunction(id) ON DELETE RESTRICT,
    FOREIGN KEY (medicine_administration_method_id) REFERENCES Type_MedicineAdministration(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Appointments (appointments.Appointment)
CREATE TABLE Appointments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    visit_date DATETIME NOT NULL,
    diagnosis VARCHAR(255) NULL,
    category VARCHAR(50) NULL,
    note VARCHAR(255) NULL,
    INDEX idx_appt_patient (patient_id),
    INDEX idx_appt_doctor (doctor_id),
    FOREIGN KEY (patient_id) REFERENCES Patient(id) ON DELETE RESTRICT,
    FOREIGN KEY (doctor_id) REFERENCES Doctor(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- MedicineStockHistory (pharmacy.MedicineStockHistory)
CREATE TABLE MedicineStockHistory (
    id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_id INT NOT NULL,
    add_remove TINYINT(1) NOT NULL,
    amount INT NOT NULL,
    appointment_id INT,
    note VARCHAR(255) NULL,
    FOREIGN KEY (medicine_id) REFERENCES Medicine(id) ON DELETE CASCADE,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ALTER TABLE MedicineStockHistory
-- ADD CONSTRAINT CHK_AppointmentID CHECK (appointment_id IS NOT NULL OR add_remove = 1);

-- ==========================================
-- NOTES:
-- ==========================================
-- 1. All table names use PascalCase as defined in Django's db_table Meta option
-- 2. All column names use lowercase snake_case as per Django conventions
-- 3. Primary keys are 'id' (Django auto-generated) instead of TableNameID
-- 4. Foreign keys use 'tablename_id' format (e.g., department_id, patient_id)
-- 5. TINYINT(1) is used for BooleanField (dnr_status, organ_donor_status, add_remove)
-- 6. DATETIME is used for DateTimeField (visit_date in Appointments)
-- 7. NULL/NOT NULL constraints match Django's blank=True, null=True settings
-- 8. UNIQUE constraints added where specified in Django models (national_id)
-- 9. Indexes added to match Django's db_index and Meta.indexes settings
-- 10. ON DELETE behaviors match Django's on_delete settings:
--     - CASCADE: Delete related objects
--     - PROTECT: Prevent deletion if referenced
--     - SET NULL: Set to NULL when referenced object deleted
