-- FILE: 04_views_metrics.sql
-- PURPOSE: Dashboard and reporting views with KPIs and metrics
-- NOTE: Adapted for MySQL (uses MySQL date functions instead of PostgreSQL)

USE HospitalDB;

-- ==========================================
-- DASHBOARD VIEWS
-- ==========================================

-- View: Hospital Overview
-- High-level KPIs for dashboard (today's stats, doctor availability, low stock alerts)
CREATE OR REPLACE VIEW view_hospital_overview AS
SELECT
    (
        SELECT COUNT(DISTINCT patient_id)
        FROM Appointments
        WHERE DATE(visit_date) = CURDATE()
    ) AS total_patients_today,
    (
        SELECT COUNT(*)
        FROM Appointments
        WHERE visit_date >= CURDATE()
    ) AS pending_appointments,
    (
        SELECT COUNT(*)
        FROM Doctor d
        JOIN Type_DoctorActiveStatus s ON d.active_status_id = s.id
        WHERE s.status_name IN ('On-Demand', 'Active')
    ) AS doctors_on_duty,
    (
        SELECT COUNT(*)
        FROM (
            SELECT medicine_id
            FROM MedicineStockHistory
            GROUP BY medicine_id
            HAVING SUM(CASE WHEN add_remove = 1 THEN amount ELSE -amount END) <= 10
        ) AS low_stock
    ) AS low_stock_alerts;

-- View: Weekly Patient Counts
-- Count of unique patients per day for the last 7 days
CREATE OR REPLACE VIEW view_weekly_patient_counts AS
SELECT
    DATE(visit_date) AS date,
    COUNT(DISTINCT patient_id) AS patients
FROM Appointments
WHERE DATE(visit_date) BETWEEN DATE_SUB(CURDATE(), INTERVAL 6 DAY) AND CURDATE()
GROUP BY DATE(visit_date)
ORDER BY DATE(visit_date);

-- View: Top Conditions
-- Most common diagnoses based on appointment records
CREATE OR REPLACE VIEW view_top_conditions AS
SELECT
    diagnosis AS condition,
    COUNT(*) AS cnt
FROM Appointments
WHERE diagnosis IS NOT NULL AND diagnosis <> ''
GROUP BY diagnosis
ORDER BY cnt DESC
LIMIT 10;

-- View: Medicine Low Stock Alert
-- Shows medicines with stock levels at or below threshold (10 units)
CREATE OR REPLACE VIEW view_medicine_low_stock AS
SELECT
    m.id AS medicine_id,
    m.medicine_name,
    m.producer,
    m.medicine_unit,
    COALESCE(SUM(CASE WHEN msh.add_remove = 1 THEN msh.amount ELSE -msh.amount END), 0) AS current_stock
FROM Medicine m
LEFT JOIN MedicineStockHistory msh ON m.id = msh.medicine_id
GROUP BY m.id, m.medicine_name, m.producer, m.medicine_unit
HAVING current_stock <= 10
ORDER BY current_stock ASC;

-- View: Doctor Workload
-- Number of appointments per doctor (useful for load balancing)
CREATE OR REPLACE VIEW view_doctor_workload AS
SELECT
    d.id AS doctor_id,
    CONCAT(d.first_name, ' ', IFNULL(d.last_name, '')) AS doctor_name,
    dept.department_name,
    COUNT(a.id) AS total_appointments,
    COUNT(CASE WHEN DATE(a.visit_date) >= CURDATE() THEN 1 END) AS upcoming_appointments
FROM Doctor d
LEFT JOIN Department dept ON d.department_id = dept.id
LEFT JOIN Appointments a ON d.id = a.doctor_id
GROUP BY d.id, d.first_name, d.last_name, dept.department_name
ORDER BY total_appointments DESC;

-- View: Department Statistics
-- Overview of each department (doctor count, appointment count)
CREATE OR REPLACE VIEW view_department_stats AS
SELECT
    dept.id AS department_id,
    dept.department_name,
    COUNT(DISTINCT d.id) AS total_doctors,
    COUNT(DISTINCT CASE WHEN s.status_name IN ('On-Demand', 'Active') THEN d.id END) AS available_doctors,
    COUNT(a.id) AS total_appointments
FROM Department dept
LEFT JOIN Doctor d ON dept.id = d.department_id
LEFT JOIN Type_DoctorActiveStatus s ON d.active_status_id = s.id
LEFT JOIN Appointments a ON d.id = a.doctor_id
GROUP BY dept.id, dept.department_name
ORDER BY total_appointments DESC;

-- View: Recent Prescriptions
-- Last 30 days of prescription activity
CREATE OR REPLACE VIEW view_recent_prescriptions AS
SELECT
    ph.id AS prescription_id,
    ph.prescription_date,
    m.medicine_name,
    ph.amount,
    m.medicine_unit,
    a.id AS appointment_id,
    CONCAT(p.first_name, ' ', IFNULL(p.last_name, '')) AS patient_name,
    CONCAT(d.first_name, ' ', IFNULL(d.last_name, '')) AS doctor_name
FROM PrescriptionHistory ph
JOIN Medicine m ON ph.medicine_id = m.id
LEFT JOIN Appointments a ON ph.appointment_id = a.id
LEFT JOIN Patient p ON a.patient_id = p.id
LEFT JOIN Doctor d ON a.doctor_id = d.id
WHERE ph.prescription_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
ORDER BY ph.prescription_date DESC;

-- View: Patient Visit History Summary
-- Patient visit counts and date ranges
CREATE OR REPLACE VIEW view_patient_visit_summary AS
SELECT
    p.id AS patient_id,
    CONCAT(p.first_name, ' ', IFNULL(p.last_name, '')) AS patient_name,
    p.dob,
    p.phone,
    p.email,
    COUNT(a.id) AS total_visits,
    MIN(DATE(a.visit_date)) AS first_visit,
    MAX(DATE(a.visit_date)) AS last_visit
FROM Patient p
LEFT JOIN Appointments a ON p.id = a.patient_id
GROUP BY p.id, p.first_name, p.last_name, p.dob, p.phone, p.email
ORDER BY total_visits DESC;

-- ==========================================
-- NOTES:
-- ==========================================
-- 1. All views use Django-compatible table and column names
-- 2. MySQL-specific functions used:
--    - CURDATE() instead of CURRENT_DATE
--    - DATE_SUB() instead of PostgreSQL's INTERVAL syntax
--    - DATE() for date extraction
--    - IFNULL() instead of COALESCE where appropriate
-- 3. Views designed for dashboard and reporting functionality
-- 4. All foreign key relationships use Django's _id convention
-- 5. Status checks use status_name instead of hardcoded IDs for reliability
