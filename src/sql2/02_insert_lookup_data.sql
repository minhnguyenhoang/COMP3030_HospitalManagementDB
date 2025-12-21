-- FILE: 02_insert_lookup_data.sql
-- PURPOSE: Populate lookup tables with reference data
-- NOTE: Django will auto-generate IDs starting from 1, so we let AUTO_INCREMENT handle it

USE HospitalDB;

-- ==========================================
-- 1. POPULATE LOOKUP TABLES
-- ==========================================

-- Type_CoreMedInfo (information types for patient medical info)
INSERT INTO Type_CoreMedInfo (name) VALUES
('Allergies'),
('Priority/Treatment Status'),
('Medical Condition'),
('Genetic Condition'),
('Substance Use'),
('Lifestyle Information'),
('Dietary Information'),
('Other');

-- Type_MedicineFunction (medicine categories/purposes)
INSERT INTO Type_MedicineFunction (name) VALUES
('Analgesic'),
('Antibiotic'),
('Antifungal'),
('Antihistamine'),
('Antipyretic'),
('Antiviral'),
('Anticoagulant'),
('Antidepressant'),
('Antineoplastic'),
('Antipsychotic'),
('Bronchodilator'),
('Corticosteroid'),
('Mood Stabiliser'),
('Statin'),
('Antacid'),
('Proton Pump Inhibitor'),
('H2 receptor antagonist'),
('Antiemetic'),
('Anticonvulsant'),
('Diuretic'),
('Beta Blocker'),
('Calcium Channel Blocker'),
('ACE Inhibitor'),
('Antidiabetic'),
('Thyroid Hormones'),
('Hormonal Contraceptive'),
('Sedative'),
('Stimulant'),
('Immunosuppressant'),
('Vaccine');

-- Type_MedicineAdministration (how medicine is administered)
INSERT INTO Type_MedicineAdministration (name) VALUES
('Oral'),
('Sublingual'),
('Buccal'),
('Topical'),
('Ophthalmic'),
('Otic'),
('Nasal'),
('Suppositories'),
('Transdermal'),
('Inhalers'),
('Nebulised'),
('Intramuscular'),
('Subcutaneous'),
('Intravenous'),
('Intradermal'),
('Intrathecal'),
('Epidural'),
('Intraarticular'),
('Intraosseous'),
('Implant');

-- Type_DoctorLevel (doctor ranks/positions)
INSERT INTO Type_DoctorLevel (title) VALUES
('Medical Student'),
('Intern'),
('Junior Resident'),
('Senior Resident'),
('Chief Resident'),
('Fellow'),
('Attending Physician'),
('Head of Department'),
('Medical Director');

-- Type_DoctorActiveStatus (doctor availability status)
INSERT INTO Type_DoctorActiveStatus (status_name) VALUES
('Inactive'),
('Off-duty'),
('On-Demand'),
('Active');

-- ==========================================
-- NOTES:
-- ==========================================
-- 1. We use INSERT without specifying ID values to let AUTO_INCREMENT handle them
-- 2. IDs will start from 1 and increment automatically
-- 3. Django code should reference these by status_name/name, not hardcoded IDs
-- 4. Example: Doctor.active_status.status_name in ('On-Demand', 'Active')
-- 5. This approach is safer than hardcoded ID checks like "status_id IN (2,3)"
