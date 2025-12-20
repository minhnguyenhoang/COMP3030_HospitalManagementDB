-- FILE: 01_schema_creation_minimal.sql
-- PURPOSE: Create ONLY lookup tables, let Django migrations create main tables
-- This avoids conflicts between SQL scripts and Django migrations

DROP DATABASE IF EXISTS HospitalDB;
CREATE DATABASE HospitalDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE HospitalDB;

-- ==========================================
-- LOOKUP TABLES ONLY
-- (Django migrations will create main tables)
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
-- NOTES:
-- ==========================================
-- 1. This minimal schema only creates lookup tables
-- 2. Main tables (Department, Doctor, Patient, etc.) will be created by Django migrations
-- 3. This avoids conflicts between SQL scripts and Django ORM
-- 4. After running this script, run: python manage.py migrate
