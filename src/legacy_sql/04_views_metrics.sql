-- FILE: 04_views_metrics.sql
-- PURPOSE: Views used by the frontend dashboard and reporting (PostgreSQL compatible)

-- Overview view: high-level KPIs (uses Django table/column names)
CREATE OR REPLACE VIEW view_hospital_overview AS
SELECT
    (SELECT COUNT(DISTINCT patient_id) FROM "Appointments" WHERE visit_date = CURRENT_DATE) AS total_patients_today,
    (SELECT COUNT(*) FROM "Appointments" WHERE visit_date >= CURRENT_DATE) AS pending_appointments,
    (SELECT COUNT(*) FROM "Doctor" WHERE active_status_id IN (2,3)) AS doctors_on_duty,
    (
      SELECT COUNT(*) FROM (
        SELECT medicine_id, SUM(CASE WHEN add_remove THEN amount ELSE -amount END) AS current_stock
        FROM "MedicineStockHistory"
        GROUP BY medicine_id
        HAVING SUM(CASE WHEN add_remove THEN amount ELSE -amount END) <= 10
      ) AS low_stock
    ) AS low_stock_alerts;

-- Weekly patient counts (last 7 days)
CREATE OR REPLACE VIEW view_weekly_patient_counts AS
SELECT
    visit_date::date AS date,
    COUNT(DISTINCT patient_id) AS patients
FROM "Appointments"
WHERE visit_date BETWEEN CURRENT_DATE - INTERVAL '6 days' AND CURRENT_DATE
GROUP BY visit_date
ORDER BY visit_date;

-- Top conditions (by appointment diagnosis)
CREATE OR REPLACE VIEW view_top_conditions AS
SELECT
    diagnosis AS condition,
    COUNT(*) AS cnt
FROM "Appointments"
WHERE diagnosis IS NOT NULL AND diagnosis <> ''
GROUP BY diagnosis
ORDER BY cnt DESC;