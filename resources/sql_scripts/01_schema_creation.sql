-- FILE: 01_schema_creation.sql
-- PURPOSE: Create tables, relationships, and partitioning
-- FIXED: Removed FKs from partitioned tables to resolve Error 1506

DROP DATABASE IF EXISTS HospitalDB;
CREATE DATABASE HospitalDB;
USE HospitalDB;

-- ==========================================
-- 1. LOOKUP TABLES (ENUMS)
-- ==========================================
CREATE TABLE Type_CoreMedInfo (ID INT PRIMARY KEY, Name VARCHAR(50));
CREATE TABLE Type_MedicineFunction (ID INT PRIMARY KEY, Name VARCHAR(50));
CREATE TABLE Type_MedicineAdministration (ID INT PRIMARY KEY, Name VARCHAR(50));
CREATE TABLE Type_DoctorLevel (ID INT PRIMARY KEY, Title VARCHAR(50));
CREATE TABLE Type_DoctorActiveStatus (ID INT PRIMARY KEY, StatusName VARCHAR(50));

-- ==========================================
-- 2. MAIN ENTITIES
-- ==========================================

-- Department
CREATE TABLE Department (
    DepartmentID INT AUTO_INCREMENT PRIMARY KEY,
    DepartmentName VARCHAR(100),
    Description VARCHAR(255),
    HeadOfDepartment INT
);

-- Doctor
CREATE TABLE Doctor (
    DoctorID INT AUTO_INCREMENT PRIMARY KEY,
    DepartmentID INT,
    MedicalLicenseID VARCHAR(50),
    DOB DATE,
    FirstName VARCHAR(50),
    MiddleName VARCHAR(50),
    LastName VARCHAR(50),
    Gender VARCHAR(20),
    NationalID VARCHAR(20),
    Phone VARCHAR(20),
    Email VARCHAR(100),
    Address VARCHAR(255),
    Expertise VARCHAR(100),
    DoctorLevel INT,
    ActiveStatus INT,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (DoctorLevel) REFERENCES Type_DoctorLevel(ID),
    FOREIGN KEY (ActiveStatus) REFERENCES Type_DoctorActiveStatus(ID)
);

-- Fix Circular Dependency
ALTER TABLE Department
ADD CONSTRAINT fk_dept_head
FOREIGN KEY (HeadOfDepartment) REFERENCES Doctor(DoctorID);

-- Patient
CREATE TABLE Patient (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50),
    MiddleName VARCHAR(50),
    LastName VARCHAR(50),
    DOB DATE,
    Ethnicity VARCHAR(50),
    PreferredLanguage VARCHAR(50),
    Gender VARCHAR(20),
    BiologicalSex VARCHAR(20),
    Phone VARCHAR(20),
    Email VARCHAR(100),
    FirstVisitDate DATE,
    LastVisitDate DATE,
    InsuranceID VARCHAR(50),
    InsuranceProvider VARCHAR(100),
    BloodType INT,
    Height INT,
    Weight INT,
    DNRStatus BIT(1),
    OrganDonorStatus BIT(1)
);

-- Patient Personal Info
CREATE TABLE PatientPersonalInformation (
    PatientID INT PRIMARY KEY,
    Occupation VARCHAR(100),
    NatID VARCHAR(50),
    PassportNo VARCHAR(50),
    DriversLicenseNo VARCHAR(50),
    Address VARCHAR(255),
    City VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100),
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID) ON DELETE CASCADE
);

-- Patient Core Medical Info
CREATE TABLE PatientCoreMedicalInformation (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    InformationType INT,
    Note VARCHAR(255),
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
    FOREIGN KEY (InformationType) REFERENCES Type_CoreMedInfo(ID)
);

-- Patient Emergency Contact
CREATE TABLE PatientEmergencyContact (
    ContactID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    ContactType VARCHAR(50),
    ContactInformation VARCHAR(255),
    Relationship VARCHAR(50),
    LastUpdated DATE,
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID)
);

-- Medicine
CREATE TABLE Medicine (
    MedicineID INT AUTO_INCREMENT PRIMARY KEY,
    MedicineName VARCHAR(100),
    Producer VARCHAR(100),
    MedicineType INT,
    MedicineAdministrationMethod INT,
    MedicineUnit VARCHAR(20),
    FOREIGN KEY (MedicineType) REFERENCES Type_MedicineFunction(ID),
    FOREIGN KEY (MedicineAdministrationMethod) REFERENCES Type_MedicineAdministration(ID)
);

-- ==========================================
-- 3. PARTITIONED TABLES (FIXED)
-- ==========================================

-- Appointments
-- FIX: Removed FOREIGN KEYS to Patient/Doctor because MySQL forbids them in Partitioned tables.
-- We added Manual Indexes below instead.
CREATE TABLE Appointments (
    AppointmentID INT AUTO_INCREMENT,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    VisitDate DATE NOT NULL,
    Diagnosis VARCHAR(255),
    Category INT,
    Note VARCHAR(255),
    PRIMARY KEY (AppointmentID, VisitDate)
)
PARTITION BY RANGE (YEAR(VisitDate)) (
    PARTITION p_old VALUES LESS THAN (2024),
    PARTITION p_2024 VALUES LESS THAN (2025),
    PARTITION p_2025 VALUES LESS THAN (2026),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- Manual Indexes for Appointments (since FKs were removed)
CREATE INDEX idx_appt_patient ON Appointments(PatientID);
CREATE INDEX idx_appt_doctor ON Appointments(DoctorID);

-- Prescription History
-- FIX: Cannot FK to 'Appointments' because 'Appointments' is partitioned.
CREATE TABLE PrescriptionHistory (
    HistoryID INT AUTO_INCREMENT PRIMARY KEY,
    AppointmentID INT,
    VisitDate DATE, 
    MedicineID INT,
    Amount INT,
    FOREIGN KEY (MedicineID) REFERENCES Medicine(MedicineID)
);

-- Manual Index to link back to appointments
CREATE INDEX idx_presc_appt ON PrescriptionHistory(AppointmentID, VisitDate);

-- Medicine Stock History
CREATE TABLE MedicineStockHistory (
    StockID INT AUTO_INCREMENT PRIMARY KEY,
    MedicineID INT,
    AddRemove BIT(1),
    Amount INT,
    AppointmentID INT, 
    Note VARCHAR(255),
    FOREIGN KEY (MedicineID) REFERENCES Medicine(MedicineID)
);

-- ==========================================
-- 4. GENERAL INDEXING
-- ==========================================
CREATE INDEX idx_patient_lastname ON Patient(LastName);
CREATE INDEX idx_doctor_license ON Doctor(MedicalLicenseID);