from django.test import TestCase
from rest_framework.test import APIClient
from django.contrib.auth import get_user_model
from doctors.models import DoctorLevel, DoctorActiveStatus, Department, Doctor
from patients.models import Patient
from pharmacy.models import Medicine, MedicineStockHistory, TypeMedicineFunction, TypeMedicineAdministration
from django.db import models

class PrescriptionTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        # create and authenticate test user
        User = get_user_model()
        self.user = User.objects.create_user(username='testuser', password='pass')
        self.client.force_authenticate(user=self.user)

        lvl = DoctorLevel.objects.create(title='Senior')
        status_active = DoctorActiveStatus.objects.create(status_name='Active')
        dept = Department.objects.create(department_name='General')
        self.doc = Doctor.objects.create(department=dept, dob='1980-01-01', first_name='John', last_name='Doe', gender='Male', national_id='D124', expertise='General', doctor_level=lvl, active_status=status_active)
        self.patient = Patient.objects.create(first_name='Alice', last_name='Smith', dob='1990-05-05', gender='Female', biological_sex='F', first_visit_date='2023-01-01', last_visit_date='2023-01-01')
        # ensure medicine type / administration lookup exist
        TypeMedicineFunction.objects.get_or_create(id=1, defaults={'name': 'Generic'})
        TypeMedicineAdministration.objects.get_or_create(id=1, defaults={'name': 'Oral'})

        self.m = Medicine.objects.create(medicine_name='Paracetamol', medicine_unit='tablets', medicine_type_id=1, medicine_administration_method_id=1)
        # seed stock: 10 add
        MedicineStockHistory.objects.create(medicine=self.m, add_remove=True, amount=10)

    def test_prescribe_reduces_stock(self):
        # create appointment
        appt_url = '/api/appointments/'
        resp = self.client.post(appt_url, data={'patient': self.patient.id, 'doctor': self.doc.id, 'visit_date': '2023-12-21', 'note': 'For test'})
        self.assertEqual(resp.status_code, 201)
        appt_id = resp.json()['id']

        pres_url = '/api/prescriptions/'
        res = self.client.post(pres_url, data={'appointment_id': appt_id, 'visit_date': '2023-12-21', 'medicine': self.m.id, 'amount': 3})
        self.assertEqual(res.status_code, 201)

        current_stock = MedicineStockHistory.objects.filter(medicine=self.m).aggregate(total=models.Sum(models.Case(models.When(add_remove=True, then='amount'), models.When(add_remove=False, then=models.F('amount') * -1), output_field=models.IntegerField())))['total']
        self.assertEqual(current_stock, 7)

    def test_prescribe_insufficient_stock(self):
        appt_url = '/api/appointments/'
        resp = self.client.post(appt_url, data={'patient': self.patient.id, 'doctor': self.doc.id, 'visit_date': '2023-12-21', 'note': 'For test'})
        appt_id = resp.json()['id']
        pres_url = '/api/prescriptions/'
        res = self.client.post(pres_url, data={'appointment_id': appt_id, 'visit_date': '2023-12-21', 'medicine': self.m.id, 'amount': 20})
        self.assertEqual(res.status_code, 400)

    def test_restock_increases_stock(self):
        # restock via API
        stock_url = '/api/medicine-stock/'
        res = self.client.post(stock_url, data={'medicine': self.m.id, 'add_remove': True, 'amount': 5})
        self.assertEqual(res.status_code, 201)
        current_stock = MedicineStockHistory.objects.filter(medicine=self.m).aggregate(total=models.Sum(models.Case(models.When(add_remove=True, then='amount'), models.When(add_remove=False, then=models.F('amount') * -1), output_field=models.IntegerField())))['total']
        self.assertEqual(current_stock, 15)
