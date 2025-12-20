from django.test import TestCase
from django.contrib.auth import get_user_model
from rest_framework.test import APIClient
from appointments.models import Appointment
from doctors.models import Doctor, DoctorActiveStatus, Department, DoctorLevel
from patients.models import Patient
from pharmacy.models import Medicine, MedicineStockHistory
from datetime import date, timedelta


class MetricsAPITest(TestCase):
    def setUp(self):
        User = get_user_model()
        self.user = User.objects.create_user(username='testuser', password='pass')
        self.client = APIClient()
        self.client.force_authenticate(user=self.user)

        # create doctor status and doctor
        DoctorLevel.objects.create(id=1, title='Junior')
        active_status = DoctorActiveStatus.objects.create(id=2, status_name='On-Demand')
        dept = Department.objects.create(department_name='Cardiology')
        self.doc = Doctor.objects.create(first_name='John', last_name='Doc', dob='1980-01-01', gender='Male', national_id='D123', expertise='Cardio', doctor_level_id=1, active_status=active_status, department=dept)

        # patients and appointments
        self.p1 = Patient.objects.create(first_name='A', last_name='One', dob='1990-01-01', gender='Female', biological_sex='F', first_visit_date=date.today(), last_visit_date=date.today())
        self.p2 = Patient.objects.create(first_name='B', last_name='Two', dob='1991-02-02', gender='Male', biological_sex='M', first_visit_date=date.today(), last_visit_date=date.today())

        Appointment.objects.create(patient=self.p1, doctor=self.doc, visit_date=date.today())
        Appointment.objects.create(patient=self.p2, doctor=self.doc, visit_date=date.today() + timedelta(days=1))

        # medicines and stock
        from pharmacy.models import TypeMedicineFunction, TypeMedicineAdministration
        TypeMedicineFunction.objects.get_or_create(id=1, defaults={'name': 'Generic'})
        TypeMedicineAdministration.objects.get_or_create(id=1, defaults={'name': 'Oral'})
        med = Medicine.objects.create(medicine_name='TestMed', producer='Acme', medicine_type_id=1, medicine_administration_method_id=1, medicine_unit='tabs')
        MedicineStockHistory.objects.create(medicine=med, add_remove=True, amount=5)
        MedicineStockHistory.objects.create(medicine=med, add_remove=False, amount=2)

    def test_overview_metrics(self):
        resp = self.client.get('/api/metrics/overview/')
        self.assertEqual(resp.status_code, 200)
        data = resp.json()
        self.assertIn('total_patients_today', data)
        self.assertEqual(data['total_patients_today'], 1)
        self.assertEqual(data['pending_appointments'], 2)
        self.assertEqual(data['doctors_on_duty'], 1)
        self.assertEqual(data['low_stock_alerts'], 1)