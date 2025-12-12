-- FILE: 02_insert_lookup_and_sample_data.sql
-- PURPOSE: Populate Enum tables AND insert dummy data for testing

USE HospitalDB;

-- ==========================================
-- 1. POPULATE LOOKUP TABLES (Enums)
-- ==========================================

-- Type_CoreMedInfo
INSERT IGNORE INTO Type_CoreMedInfo VALUES 
(0, 'Allergies'), (1, 'Priority/Treatment Status'), (2, 'Medical Condition'),
(3, 'Genetic Condition'), (4, 'Substance Use'), (5, 'Lifestyle Information'),
(6, 'Dietary Information'), (7, 'Other');

-- Type_MedicineFunction
INSERT IGNORE INTO Type_MedicineFunction VALUES 
(0, 'Analgesic'), (1, 'Antibiotic'), (2, 'Antifungal'), (3, 'Antihistamine'),
(4, 'Antipyretic'), (5, 'Antiviral'), (6, 'Anticoagulant'), (7, 'Antidepressant'),
(8, 'Antineoplastic'), (9, 'Antipsychotic'), (10, 'Bronchodilator'), (11, 'Corticosteroid'),
(12, 'Mood Stabiliser'), (13, 'Statin'), (14, 'Antacid'), (15, 'Proton Pump Inhibitor'),
(16, 'H2 receptor antagonist'), (17, 'Antiemetic'), (18, 'Anticonvulsant'), (19, 'Diuretic'),
(20, 'Beta Blocker'), (21, 'Calcium Channel Blocker'), (22, 'ACE Inhibitor'), (23, 'Antidiabetic'),
(24, 'Thyroid Hormones'), (25, 'Hormonal Contraceptive'), (26, 'Sedative'), (27, 'Stimulant'),
(28, 'Immunosuppressant'), (29, 'Vaccine');

-- Type_MedicineAdministration
INSERT IGNORE INTO Type_MedicineAdministration VALUES 
(0, 'Oral'), (1, 'Sublingual'), (2, 'Buccal'), (3, 'Topical'), (4, 'Ophthalmic'),
(5, 'Otic'), (6, 'Nasal'), (7, 'Suppositories'), (8, 'Transdermal'), (9, 'Inhalers'),
(10, 'Nebulised'), (11, 'Intramuscular'), (12, 'Subcutaneous'), (13, 'Intravenous'),
(14, 'Intradermal'), (15, 'Intrathecal'), (16, 'Epidural'), (17, 'Intraarticular'),
(18, 'Intraosseous'), (19, 'Implant');

-- Type_DoctorLevel
INSERT IGNORE INTO Type_DoctorLevel VALUES 
(0, 'Medical Student'), (1, 'Intern'), (2, 'Junior Resident'), (3, 'Senior Resident'),
(4, 'Chief Resident'), (5, 'Fellow'), (6, 'Attending Physician'), (7, 'Head of Department'),
(8, 'Medical Director');

-- Type_DoctorActiveStatus
INSERT IGNORE INTO Type_DoctorActiveStatus VALUES 
(0, 'Inactive'), (1, 'Off-duty'), (2, 'On-demand'), (3, 'Active');

-- ==========================================
-- 2. INSERT SAMPLE DATA (So your views are not empty)
-- ==========================================

-- Create a Department
INSERT INTO Department (DepartmentName, Description) 
VALUES ('Cardiology', 'Heart and Vascular health');

-- Create a Doctor (ID: 1, Active, Attending Physician)
INSERT INTO Doctor (DepartmentID, DoctorLevel, ActiveStatus, FirstName, LastName, Gender, MedicalLicenseID, DOB, Phone, Email)
VALUES (1, 6, 3, 'John', 'Doe', 'Male', 'LIC-99999', '1980-01-01', '555-0199', 'dr.doe@hospital.com');

-- Create a Patient (ID: 1)
INSERT INTO Patient (FirstName, LastName, DOB, Gender, Phone, Email)
VALUES ('Jane', 'Smith', '1995-05-20', 'Female', '555-0100', 'jane.smith@email.com');

-- Create a Medicine (ID: 1)
INSERT INTO Medicine (MedicineName, Producer, MedicineType, MedicineAdministrationMethod, MedicineUnit)
VALUES ('Ibuprofen', 'PharmaInc', 0, 0, 'mg');