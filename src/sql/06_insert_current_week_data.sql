-- FILE: 06_insert_current_week_data.sql
-- PURPOSE: Insert appointments for current week to populate Patient Trends chart
-- NOTE: This should be run to generate data for the last 7 days

USE HospitalDB;

-- ==========================================
-- CURRENT WEEK APPOINTMENTS
-- ==========================================
-- Generate appointments from 7 days ago to today
-- Using DATE_SUB(CURDATE(), INTERVAL N DAY) for dynamic dates

INSERT INTO Appointments (patient_id, doctor_id, visit_date, diagnosis, category, note) VALUES
-- 6 days ago (5 unique patients: 1, 2, 3, 4, 5)
(1, 1, DATE_SUB(CURDATE(), INTERVAL 6 DAY), 'Hypertension', 'Follow-up', 'Blood pressure check'),
(2, 4, DATE_SUB(CURDATE(), INTERVAL 6 DAY), 'Type 2 Diabetes', 'Follow-up', 'Blood sugar monitoring'),
(3, 8, DATE_SUB(CURDATE(), INTERVAL 6 DAY), 'Fever', 'Check-up', 'Routine examination'),
(4, 15, DATE_SUB(CURDATE(), INTERVAL 6 DAY), 'Hypertension', 'Consultation', 'Cardiac evaluation'),
(5, 2, DATE_SUB(CURDATE(), INTERVAL 6 DAY), 'Minor Injury', 'Emergency', 'Laceration treatment'),

-- 5 days ago (7 unique patients: 6, 7, 8, 9, 10, 11, 12)
(6, 4, DATE_SUB(CURDATE(), INTERVAL 5 DAY), 'Type 2 Diabetes', 'Consultation', 'Blood sugar review'),
(7, 8, DATE_SUB(CURDATE(), INTERVAL 5 DAY), 'Fever', 'Consultation', 'Viral infection'),
(8, 18, DATE_SUB(CURDATE(), INTERVAL 5 DAY), 'Headache', 'Consultation', 'Chronic migraines'),
(9, 20, DATE_SUB(CURDATE(), INTERVAL 5 DAY), 'Back Pain', 'Consultation', 'Joint examination'),
(10, 4, DATE_SUB(CURDATE(), INTERVAL 5 DAY), 'Type 2 Diabetes', 'Follow-up', 'Lipid panel review'),
(11, 15, DATE_SUB(CURDATE(), INTERVAL 5 DAY), 'Hypertension', 'Follow-up', 'Medication adjustment'),
(12, 20, DATE_SUB(CURDATE(), INTERVAL 5 DAY), 'Back Pain', 'Consultation', 'Lumbar strain'),

-- 4 days ago (10 unique patients: 13, 14, 15, 16, 17, 18, 19, 20, 21, 22) - PEAK
(13, 8, DATE_SUB(CURDATE(), INTERVAL 4 DAY), 'Asthma', 'Follow-up', 'Inhaler refill'),
(14, 11, DATE_SUB(CURDATE(), INTERVAL 4 DAY), 'Hypertension', 'Consultation', 'Blood pressure monitoring'),
(15, 25, DATE_SUB(CURDATE(), INTERVAL 4 DAY), 'Prenatal Check-up', 'Check-up', 'Third trimester screening'),
(16, 1, DATE_SUB(CURDATE(), INTERVAL 4 DAY), 'Hypertension', 'Emergency', 'Acute chest discomfort'),
(17, 4, DATE_SUB(CURDATE(), INTERVAL 4 DAY), 'Type 2 Diabetes', 'Consultation', 'GERD symptoms'),
(18, 15, DATE_SUB(CURDATE(), INTERVAL 4 DAY), 'Angina', 'Follow-up', 'Cardiac stress test results'),
(19, 23, DATE_SUB(CURDATE(), INTERVAL 4 DAY), 'Fever', 'Imaging', 'Chest radiography'),
(20, 15, DATE_SUB(CURDATE(), INTERVAL 4 DAY), 'Hypertension', 'Follow-up', 'Heart rhythm check'),
(21, 8, DATE_SUB(CURDATE(), INTERVAL 4 DAY), 'Fever', 'Consultation', 'Pharyngitis'),
(22, 20, DATE_SUB(CURDATE(), INTERVAL 4 DAY), 'Back Pain', 'Consultation', 'Rotator cuff strain'),

-- 3 days ago (9 unique patients: 23, 24, 25, 26, 27, 28, 29, 30, 31)
(23, 4, DATE_SUB(CURDATE(), INTERVAL 3 DAY), 'Type 2 Diabetes', 'Check-up', 'Routine physical examination'),
(24, 15, DATE_SUB(CURDATE(), INTERVAL 3 DAY), 'Hypertension', 'Consultation', 'Irregular heartbeat'),
(25, 28, DATE_SUB(CURDATE(), INTERVAL 3 DAY), 'Cancer', 'Follow-up', 'Post-treatment monitoring'),
(26, 4, DATE_SUB(CURDATE(), INTERVAL 3 DAY), 'Anemia', 'Follow-up', 'Iron supplement review'),
(27, 20, DATE_SUB(CURDATE(), INTERVAL 3 DAY), 'Back Pain', 'Follow-up', 'Joint pain management'),
(28, 28, DATE_SUB(CURDATE(), INTERVAL 3 DAY), 'Cancer', 'Treatment', 'Cancer treatment cycle'),
(29, 11, DATE_SUB(CURDATE(), INTERVAL 3 DAY), 'Hernia', 'Consultation', 'Surgical evaluation'),
(30, 18, DATE_SUB(CURDATE(), INTERVAL 3 DAY), 'Seizure', 'Follow-up', 'Epilepsy management'),
(31, 2, DATE_SUB(CURDATE(), INTERVAL 3 DAY), 'Minor Injury', 'Follow-up', 'Healing assessment'),

-- 2 days ago (6 unique patients: 32, 33, 34, 35, 36, 37)
(32, 4, DATE_SUB(CURDATE(), INTERVAL 2 DAY), 'Type 2 Diabetes', 'Follow-up', 'TSH level monitoring'),
(33, 8, DATE_SUB(CURDATE(), INTERVAL 2 DAY), 'Fever', 'Consultation', 'Skin rash treatment'),
(34, 20, DATE_SUB(CURDATE(), INTERVAL 2 DAY), 'Back Pain', 'Follow-up', 'Cast removal consultation'),
(35, 15, DATE_SUB(CURDATE(), INTERVAL 2 DAY), 'Hypertension', 'Follow-up', 'Hypertension monitoring'),
(36, 4, DATE_SUB(CURDATE(), INTERVAL 2 DAY), 'Type 2 Diabetes', 'Follow-up', 'HbA1c results review'),
(37, 8, DATE_SUB(CURDATE(), INTERVAL 2 DAY), 'Fever', 'Prevention', 'Routine immunization'),

-- Yesterday (4 unique patients: 38, 39, 40, 41)
(38, 4, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 'Pneumonia', 'Follow-up', 'Recovery assessment'),
(39, 11, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 'Back Pain', 'Follow-up', 'Post-op wound check'),
(40, 25, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 'Prenatal Visit', 'Check-up', 'Routine pregnancy check'),
(41, 20, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 'Back Pain', 'Consultation', 'Joint assessment'),

-- Today (8 unique patients: 42, 43, 44, 45, 46, 47, 48, 49)
(42, 15, CURDATE(), 'Hypertension', 'Consultation', 'Cardiac evaluation'),
(43, 4, CURDATE(), 'Type 2 Diabetes', 'Consultation', 'General weakness'),
(44, 11, CURDATE(), 'Hypertension', 'Consultation', 'Surgery preparation'),
(45, 1, CURDATE(), 'Minor Injury', 'Emergency', 'Cut finger'),
(46, 4, CURDATE(), 'Type 2 Diabetes', 'Consultation', 'Abdominal discomfort'),
(47, 8, CURDATE(), 'Fever', 'Consultation', 'Upper respiratory infection'),
(48, 28, CURDATE(), 'Cancer', 'Follow-up', 'Treatment response evaluation'),
(49, 18, CURDATE(), 'Headache', 'Consultation', 'Vertigo symptoms');

-- ==========================================
-- PRESCRIPTIONS FOR CURRENT WEEK
-- ==========================================
-- Add some prescriptions for the recent appointments

-- Get the last appointment IDs (assuming sequential IDs)
-- We'll prescribe medicines for some of the appointments

SET @last_appt_id = (SELECT MAX(id) FROM Appointments);

-- Today's prescriptions
INSERT INTO MedicineStockHistory (appointment_id, medicine_id, add_remove, amount) VALUES
(@last_appt_id - 0, 1, 0, 20),      -- Paracetamol
(@last_appt_id - 2, 15, 0, 28),     -- Omeprazole
(@last_appt_id - 3, 28, 0, 2),      -- Salbutamol
(@last_appt_id - 5, 2, 0, 30);      -- Ibuprofen

-- Yesterday's prescriptions
INSERT INTO MedicineStockHistory (appointment_id, medicine_id, add_remove, amount) VALUES
(@last_appt_id - 10, 25, 0, 60),  -- Metformin
(@last_appt_id - 11, 21, 0, 30),  -- Amlodipine
(@last_appt_id - 12, 32, 0, 30);  -- Vitamin C

-- ==========================================
-- SUMMARY
-- ==========================================
-- This script adds:
-- - 49 appointments spread across the last 7 days
-- - Distribution pattern (curved): 5 → 7 → 10 (peak) → 9 → 6 → 4 → 8 = 49 appointments
-- - Creates a bell curve with peak in the middle of the week
-- - Common Conditions distribution (for better chart visualization):
--   * Hypertension: 11 cases (most common)
--   * Type 2 Diabetes: 10 cases
--   * Fever: 8 cases
--   * Back Pain: 7 cases
--   * Minor Injury: 2 cases
--   * Cancer: 2 cases
--   * Other conditions: 1-2 cases each
-- - This ensures both Patient Trends and Common Conditions charts display properly
-- - Some prescriptions for recent appointments
-- ==========================================
