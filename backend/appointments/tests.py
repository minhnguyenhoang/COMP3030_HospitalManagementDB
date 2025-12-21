from django.test import TestCase
from django.urls import reverse
from rest_framework.test import APIClient
from django.contrib.auth import get_user_model
from doctors.models import Doctor, DoctorLevel, DoctorActiveStatus, Department
from patients.models import Patient

class AppointmentTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        # create and authenticate user
        User = get_user_model()
        self.user = User.objects.create_user(username='apptuser', password='pass')
        self.client.force_authenticate(user=self.user)

        lvl = DoctorLevel.objects.create(title='Senior')
        status_active = DoctorActiveStatus.objects.create(status_name='Active')
        dept = Department.objects.create(department_name='General')
        self.doc = Doctor.objects.create(department=dept, dob='1980-01-01', first_name='John', last_name='Doe', gender='Male', national_id='D123', expertise='General', doctor_level=lvl, active_status=status_active)
        self.patient = Patient.objects.create(first_name='Alice', last_name='Smith', dob='1990-05-05', gender='Female', biological_sex='F', first_visit_date='2023-01-01', last_visit_date='2023-01-01')

    def test_create_appointment_success(self):
        url = reverse('appointment-list')
        res = self.client.post(url, data={'patient': self.patient.id, 'doctor': self.doc.id, 'visit_date': '2023-12-20', 'note': 'Test'})
        self.assertEqual(res.status_code, 201)

    def test_create_appointment_doctor_inactive(self):
        # set doctor inactive
        inactive = DoctorActiveStatus.objects.create(status_name='Inactive')
        self.doc.active_status = inactive
        self.doc.save()
        url = reverse('appointment-list')
        res = self.client.post(url, data={'patient': self.patient.id, 'doctor': self.doc.id, 'visit_date': '2023-12-20', 'note': 'Test'})
        self.assertEqual(res.status_code, 400)
