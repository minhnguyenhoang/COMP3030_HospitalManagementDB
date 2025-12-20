# API Endpoints (quick reference)

This file documents important API endpoints added during integration.

Authentication
- POST /api/auth/token/ — obtain JWT (body: username, password)
- POST /api/auth/token/refresh/ — refresh access token

Metrics
- GET /api/metrics/overview/ — KPIs for dashboard (authenticated)

Patients
- GET /api/patients/ — list patients
- POST /api/patients/ — create patient
- GET /api/patients/{id}/ — retrieve patient
- PUT /api/patients/{id}/ — update patient

Appointments
- GET /api/appointments/ — list
- POST /api/appointments/ — create (fields: patient, doctor or patient, doctor_id)

Prescriptions
- GET /api/prescriptions/ — list
- POST /api/prescriptions/ — create (fields: appointment_id, visit_date, medicine, amount)

Pharmacy / Stock
- GET /api/medicine-stock/ — list medicine stock history
- POST /api/medicine-stock/ — create stock change record (fields: medicine, add_remove (true=add), amount, note)

Doctors / Staff
- GET /api/doctors/
- POST /api/doctors/
- GET /api/doctor-levels/
- GET /api/doctor-statuses/

DB Views & SQL
- All DB view/trigger/procedure SQL files are stored in `src/sql/`.
- A management command `apply_sql_views` runs any SQL in `src/sql` (used during container startup).

Notes
- All API endpoints require authentication (except the root health check).
- Frontend uses these endpoints under `http://localhost:8000/api` by default; see `medicore-hms/.env.example` to override.
