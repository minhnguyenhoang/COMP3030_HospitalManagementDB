from django.contrib.auth.models import AbstractUser
from django.db import models


class User(AbstractUser):
    """Custom User model with role-based permissions"""

    ROLE_CHOICES = [
        ('ADMIN', 'Administrator'),
        ('DOCTOR', 'Doctor'),
        ('RECEPTIONIST', 'Receptionist'),
    ]

    role = models.CharField(
        max_length=20,
        choices=ROLE_CHOICES,
        default='DOCTOR',
        help_text='User role in the hospital system'
    )

    # Optional: Link to Doctor model if user is a doctor
    # Note: Commented out due to foreign key type incompatibility with SQL-created Doctor table
    # You can link users to doctors manually via doctor.email matching user.email
    # doctor = models.OneToOneField(
    #     'doctors.Doctor',
    #     on_delete=models.SET_NULL,
    #     null=True,
    #     blank=True,
    #     related_name='user_account',
    #     help_text='Linked doctor profile if user is a doctor'
    # )

    class Meta:
        db_table = 'auth_user'
        verbose_name = 'User'
        verbose_name_plural = 'Users'

    def __str__(self):
        return f"{self.username} ({self.get_role_display()})"

    @property
    def is_admin(self):
        return self.role == 'ADMIN'

    @property
    def is_doctor(self):
        return self.role == 'DOCTOR'

    @property
    def is_receptionist(self):
        return self.role == 'RECEPTIONIST'
