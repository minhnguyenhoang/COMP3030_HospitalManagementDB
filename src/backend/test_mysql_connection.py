"""
Interactive MySQL Credential Tester
This script helps you find the correct MySQL credentials
"""
import pymysql
import getpass

def test_connection():
    print("="*60)
    print("MySQL Connection Tester")
    print("="*60)
    print("\nPlease enter the MySQL credentials you use in Workbench:")

    host = input("Host [localhost]: ").strip() or "localhost"
    port = input("Port [3306]: ").strip() or "3306"
    user = input("Username: ").strip()
    password = getpass.getpass("Password: ")

    print(f"\nTesting connection to {user}@{host}:{port}...")

    try:
        connection = pymysql.connect(
            host=host,
            user=user,
            password=password,
            port=int(port),
            charset='utf8mb4'
        )
        print("✓ Connection successful!")

        # Get user info
        cursor = connection.cursor()
        cursor.execute("SELECT USER(), CURRENT_USER();")
        result = cursor.fetchone()
        print(f"\n✓ Connected as: {result[0]}")
        print(f"✓ Current user: {result[1]}")

        # Check privileges
        cursor.execute("SHOW GRANTS FOR CURRENT_USER();")
        grants = cursor.fetchall()
        print(f"\n✓ User has {len(grants)} privilege(s)")

        cursor.close()
        connection.close()

        print("\n" + "="*60)
        print("SUCCESS! Use these credentials in .env:")
        print("="*60)
        print(f"DB_USER={user}")
        print(f"DB_PASSWORD={password}")
        print(f"DB_HOST={host}")
        print(f"DB_PORT={port}")
        print("="*60)

        # Ask if user wants to update .env
        update = input("\nUpdate .env file with these credentials? (y/n): ").strip().lower()
        if update == 'y':
            with open('.env', 'r') as f:
                lines = f.readlines()

            with open('.env', 'w') as f:
                for line in lines:
                    if line.startswith('DB_USER='):
                        f.write(f'DB_USER={user}\n')
                    elif line.startswith('DB_PASSWORD='):
                        f.write(f'DB_PASSWORD={password}\n')
                    elif line.startswith('DB_HOST='):
                        f.write(f'DB_HOST={host}\n')
                    elif line.startswith('DB_PORT='):
                        f.write(f'DB_PORT={port}\n')
                    else:
                        f.write(line)

            print("✓ .env file updated!")
            print("\nYou can now run: python setup_mysql.py")

    except Exception as e:
        print(f"✗ Connection failed: {e}")
        print("\nPlease check:")
        print("  - MySQL server is running")
        print("  - Username and password are correct")
        print("  - User has proper privileges")

if __name__ == '__main__':
    test_connection()
