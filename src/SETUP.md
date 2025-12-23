# Hospital Management System - Setup Guide

## Prerequisites
- Python 3.8+
- MySQL Server (running on port 3306 or configure in `.env`)
- Node.js 16+ (for frontend)

## Quick Setup (3 Steps)

### 1. Install Python Dependencies
```bash
cd backend
pip install -r requirements.txt
```
Or if you use `uv`, do `uv pip install -r -requirements.txt` and make sure that the corresponding (virtual) environment used with uv is enabled.

### 2. Configure Database
Run the file `test_mysql_connection.py` to setup the `.env` file and test the connection:
```bash
python test_mysql_connection.py
```
Alternatively, manually edit `backend/.env` with your MySQL credentials:
```env
DB_USER=root
DB_PASSWORD=your_password_here
DB_HOST=localhost
DB_PORT=3306
```

### 3. Run Complete Setup
```bash
python setup_complete.py
```
After run this command, it will create 3 kinds of account:

admin - admin123
doctor - doctor123
receptionist - receptionist123

This single script will:
- Create HospitalDB database
- Import all SQL schemas and lookup data
- Setup Django system tables
- Verify installation

Do not need to run the step 4 any more
<!-- ### 4. Create Admin User
```bash
python manage.py createsuperuser

# Example: enter: admin and admin123 for the password
``` -->

### 5. Start Backend Server
```bash
python manage.py runserver
```

Backend will run at: http://localhost:8000. To access the login portal, go to http://localhost:3000.

### 6. Start Frontend (New Terminal)
Install Node.js and `npm` on your system. On Windows and macOS, go to https://nodejs.org/en/download/. On Linux, use your appropriate package manager and install.
## Debian-based
```bash
sudo apt update && sudo apt upgrade
sudo apt install nodejs npm
```
## Arch-based
```bash
pacman -S nodejs npm
```
If you use `paru`, `yay` or similar package managers, you can substitute that for `pacman`.
## Frontend intialisation
Go to the `medicore-hms` folder, install `npm` and run the app `dev`.
```bash
cd ../medicore-hms
npm install
npm run dev
```

Frontend will run at: http://localhost:3000

## What's Included

### Database Tables (Created from MySQL Scripts)
- **Main Tables**: Department, Doctor, Patient, Medicine, Appointments, etc.
- **Lookup Tables**: Type_DoctorLevel, Type_MedicineFunction, Type_MedicineAdministration
- **System Tables**: auth_user, django_content_type, django_session (Django-managed)
- **Views & Procedures**: Dashboard metrics, stored procedures, triggers

### Lookup Data Pre-loaded
- 30 Medicine function types (Analgesic, Antibiotic, etc.)
- 20 Administration methods (Oral, IV, Topical, etc.)
- 9 Doctor levels (Intern, Resident, Attending, etc.)
- 4 Doctor statuses (Inactive, Off-duty, On-demand, Active)

## Troubleshooting

### MySQL Connection Error
```
✗ Connection failed: (1045, "Access denied")
```
**Solution**: Update your MySQL credentials in `backend/.env`

### Port Already in Use
```
Error: That port is already in use.
```
**Solution**:
- Backend: Change port with `python manage.py runserver 8001`
- Frontend: Update port in `vite.config.ts`

### Table Already Exists
If you need to reset everything:
```bash
python setup_complete.py
```
The script automatically drops and recreates the database.
