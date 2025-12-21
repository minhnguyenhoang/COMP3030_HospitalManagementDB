from django.test import TestCase
from django.contrib.auth import get_user_model
from rest_framework.test import APIClient
from doctors.models import DoctorLevel, DoctorActiveStatus


class DoctorsAPITest(TestCase):
    def setUp(self):
        User = get_user_model()
        self.user = User.objects.create_user(username='test', password='pass')
        self.client = APIClient()
        self.client.force_authenticate(user=self.user)
        DoctorLevel.objects.create(id=1, title='Junior')
        DoctorActiveStatus.objects.create(id=1, status_name='Inactive')

    def test_levels_and_statuses_list(self):
        resp = self.client.get('/api/doctor-levels/')
        self.assertEqual(resp.status_code, 200)
        data = resp.json()
        self.assertTrue(len(data) >= 1)

        resp2 = self.client.get('/api/doctor-statuses/')
        self.assertEqual(resp2.status_code, 200)
        data2 = resp2.json()
        self.assertTrue(len(data2) >= 1)
