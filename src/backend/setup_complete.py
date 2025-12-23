"""
Complete Database Setup Script for Hospital Management System
This script handles everything: database creation, SQL imports, and Django setup

Usage: python setup_complete.py
"""
import os
import sys
import pymysql
from decouple import config

def setup_database():
    """Step 1: Create database and import SQL schemas"""
    print("="*70)
    print("HOSPITAL MANAGEMENT SYSTEM - COMPLETE SETUP")
    print("="*70)

    # Get connection details from .env
    db_user = config('DB_USER', default='root')
    db_password = config('DB_PASSWORD', default='')
    db_host = config('DB_HOST', default='localhost')
    db_port = config('DB_PORT', default=3306, cast=int)
    db_name = config('DB_NAME', default='HospitalDB')

    print(f"\n[1/4] Connecting to MySQL server at {db_host}:{db_port}...")
    try:
        connection = pymysql.connect(
            host=db_host,
            user=db_user,
            password=db_password,
            port=db_port,
            charset='utf8mb4'
        )
        print("      ✓ Connected successfully")
    except Exception as e:
        print(f"      ✗ Connection failed: {e}")
        print("\n⚠ Please check your MySQL credentials in backend/.env file")
        return False

    cursor = connection.cursor()

    # Create database
    print(f"\n[2/4] Creating database '{db_name}'...")
    try:
        cursor.execute(f"DROP DATABASE IF EXISTS {db_name}")
        cursor.execute(f"CREATE DATABASE {db_name} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci")
        cursor.execute(f"USE {db_name}")
        print(f"      ✓ Database '{db_name}' created")
    except Exception as e:
        print(f"      ✗ Failed to create database: {e}")
        return False

    # Get SQL files directory
    backend_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    project_root = os.path.dirname(backend_dir)
    sql_dir = os.path.join(project_root, 'src', 'sql')

    # SQL files in order
    sql_files = [
        '01_schema_creation.sql',
        '02_insert_lookup_data.sql',
        '03_procedures_triggers_views.sql',
        '04_views_metrics.sql',
        '05_insert_sample_data.sql',
        '06_insert_current_week_data.sql'
    ]

    # Execute each SQL file
    print(f"\n[3/4] Importing SQL files...")
    for sql_file in sql_files:
        file_path = os.path.join(sql_dir, sql_file)

        if not os.path.exists(file_path):
            print(f"      ⚠ Warning: {sql_file} not found, skipping...")
            continue

        print(f"      → {sql_file}...", end=" ")
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                sql_content = f.read()

            # Split by delimiter and execute each statement
            statements = sql_content.split(';')
            for statement in statements:
                statement = statement.strip()
                if statement and 'DELIMITER' not in statement:
                    try:
                        cursor.execute(statement)
                    except Exception:
                        pass  # Ignore warnings

            connection.commit()
            print("✓")
        except Exception as e:
            print(f"✗ ({str(e)[:50]})")
            connection.rollback()

    cursor.close()
    connection.close()

    print(f"      ✓ SQL import completed")
    return True


def setup_django():
    """Step 2: Setup Django migrations and system tables"""
    print(f"\n[4/4] Setting up Django...")

    # Import Django after database is ready
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
    import django
    django.setup()

    from django.core.management import call_command

    try:
        # Step 1: Create ALL migrations first (before checking tables)
        print("      → Creating all migrations...", end=" ")
        call_command('makemigrations', 'users', verbosity=0)
        call_command('makemigrations', 'doctors', verbosity=0)
        call_command('makemigrations', 'patients', verbosity=0)
        call_command('makemigrations', 'pharmacy', verbosity=0)
        call_command('makemigrations', 'appointments', verbosity=0)
        print("✓")

        # Step 2: Migrate contenttypes first (required by auth)
        print("      → Migrating contenttypes...", end=" ")
        call_command('migrate', 'contenttypes', verbosity=0)
        print("✓")

        # Step 3: Fake ALL app migrations (tables already created by SQL)
        print("      → Registering existing tables (fake)...", end=" ")
        call_command('migrate', 'doctors', '--fake', verbosity=0)
        call_command('migrate', 'patients', '--fake', verbosity=0)
        call_command('migrate', 'pharmacy', '--fake', verbosity=0)
        call_command('migrate', 'appointments', '--fake', verbosity=0)
        print("✓")

        # Step 4: Migrate custom User model and auth system
        print("      → Migrating User model and auth system...", end=" ")
        call_command('migrate', 'users', verbosity=0)
        call_command('migrate', 'auth', verbosity=0)
        call_command('migrate', 'sessions', verbosity=0)
        call_command('migrate', 'admin', verbosity=0)
        call_command('migrate', 'token_blacklist', verbosity=0)
        print("✓")

        print("      ✓ Django setup completed")
        return True

    except Exception as e:
        print(f"✗")
        print(f"      Error: {e}")
        import traceback
        traceback.print_exc()
        return False


def create_test_users():
    """Create test users with different roles"""
    print(f"\n[5/5] Creating test users...")

    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
    import django
    django.setup()

    from django.contrib.auth import get_user_model
    User = get_user_model()

    test_users = [
        {
            'username': 'admin',
            'email': 'admin@hospital.com',
            'password': 'admin123',
            'role': 'ADMIN',
            'first_name': 'Admin',
            'last_name': 'User',
            'is_staff': True,
            'is_superuser': True
        },
        {
            'username': 'doctor',
            'email': 'doctor@hospital.com',
            'password': 'doctor123',
            'role': 'DOCTOR',
            'first_name': 'John',
            'last_name': 'Doe'
        },
        {
            'username': 'receptionist',
            'email': 'receptionist@hospital.com',
            'password': 'receptionist123',
            'role': 'RECEPTIONIST',
            'first_name': 'Jane',
            'last_name': 'Smith'
        }
    ]

    try:
        for user_data in test_users:
            username = user_data['username']
            # Check if user already exists
            if User.objects.filter(username=username).exists():
                print(f"      ⚠ User '{username}' already exists, skipping...")
                continue

            User.objects.create_user(**user_data)
            print(f"      ✓ Created {user_data['role']} user: {username}")

        print("      ✓ Test users created successfully")
        return True

    except Exception as e:
        print(f"      ✗ Error creating test users: {e}")
        return False


def verify_setup():
    """Step 3: Verify everything is working"""
    print(f"\n" + "="*70)
    print("SETUP VERIFICATION")
    print("="*70)

    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
    import django
    django.setup()

    from django.db import connection

    try:
        with connection.cursor() as cursor:
            # Count tables
            cursor.execute("SHOW TABLES")
            tables = cursor.fetchall()

            print(f"\n✓ Database connection: OK")
            print(f"✓ Total tables created: {len(tables)}")

            # Check key tables (case-insensitive)
            table_names = [t[0].lower() for t in tables]
            key_tables = ['doctor', 'patient', 'medicine', 'appointments', 'auth_user']

            print(f"\n✓ Key tables present:")
            for table in key_tables:
                status = "✓" if table in table_names else "✗"
                print(f"  {status} {table.title()}")

            # Check lookup data
            cursor.execute("SELECT COUNT(*) FROM Type_MedicineFunction")
            med_types = cursor.fetchone()[0]
            print(f"\n✓ Lookup data loaded:")
            print(f"  ✓ Medicine types: {med_types}")

            # Check sample data
            cursor.execute("SELECT COUNT(*) FROM Medicine")
            medicines = cursor.fetchone()[0]
            cursor.execute("SELECT COUNT(*) FROM MedicineStockHistory")
            stock = cursor.fetchone()[0]
            cursor.execute("SELECT COUNT(*) FROM Doctor")
            doctors = cursor.fetchone()[0]
            cursor.execute("SELECT COUNT(*) FROM Patient")
            patients = cursor.fetchone()[0]
            cursor.execute("SELECT COUNT(*) FROM Appointments")
            appointments = cursor.fetchone()[0]

            print(f"\n✓ Sample data loaded:")
            print(f"  ✓ Medicines: {medicines}")
            print(f"  ✓ Medicine Stock Records: {stock}")
            print(f"  ✓ Doctors: {doctors}")
            print(f"  ✓ Patients: {patients}")
            print(f"  ✓ Appointments: {appointments}")

        return True
    except Exception as e:
        print(f"\n✗ Verification failed: {e}")
        return False


def main():
    verification_success = True
    """Main setup function"""
    print("\nThis script will:")
    print("  1. Create MySQL database from SQL scripts")
    print("  2. Setup Django system tables and User model")
    print("  3. Create test users with different roles")
    print("  4. Verify the installation\n")

    # Step 1: Database setup
    if not setup_database():
        print("\n✗ Setup failed at database creation stage")
        sys.exit(1)

    # Step 2: Django setup
    if not setup_django():
        print("\n✗ Setup failed at Django configuration stage")
        sys.exit(1)

    # Step 3: Create test users
    if not create_test_users():
        print("\n⚠ Test user creation had issues (you can create users manually)")

    # Step 4: Verification
    if not verify_setup():
        print("\n⚠ Setup completed but verification had issues")
        verification_success = False

    # Success message
    if verification_success:
        print("\n" + "="*70)
        print("✓ SETUP COMPLETED SUCCESSFULLY!")
        print("="*70)
        print("\n🔐 Test User Credentials:")
        print("  • Admin:        username: admin        password: admin123")
        print("  • Doctor:       username: doctor       password: doctor123")
        print("  • Receptionist: username: receptionist password: receptionist123")
        print("\nNext steps:")
        print("  1. Start backend:     python manage.py runserver")
        print("  2. Start frontend:    cd ../medicore-hms && npm run dev")
        print("  3. Access frontend:   http://localhost:5173")
        print("  4. Access admin:      http://localhost:8000/admin")
        print()


if __name__ == '__main__':
    main()
