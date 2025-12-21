from django.db import models


class DoctorLevel(models.Model):
    """Lookup table for doctor levels/titles"""
    title = models.CharField(max_length=50)
    
    class Meta:
        db_table = 'Type_DoctorLevel'
        ordering = ['id']
        verbose_name = 'Doctor Level'
        verbose_name_plural = 'Doctor Levels'

    def __str__(self):
        return self.title


class DoctorActiveStatus(models.Model):
    """Lookup table for doctor active status"""
    status_name = models.CharField(max_length=50)
    
    class Meta:
        db_table = 'Type_DoctorActiveStatus'
        ordering = ['id']
        verbose_name = 'Doctor Active Status'
        verbose_name_plural = 'Doctor Active Statuses'

    def __str__(self):
        return self.status_name


class Department(models.Model):
    """Hospital departments"""
    department_name = models.CharField(max_length=100)
    description = models.CharField(max_length=255, blank=True, null=True)
    head_of_department = models.ForeignKey(
        'Doctor',
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='headed_department'
    )
    
    class Meta:
        db_table = 'Department'
        ordering = ['department_name']
        verbose_name = 'Department'
        verbose_name_plural = 'Departments'

    def __str__(self):
        return self.department_name


class Doctor(models.Model):
    """Doctor information"""
    department = models.ForeignKey(
        Department,
        on_delete=models.PROTECT,
        related_name='doctors'
    )
    medical_license_id = models.CharField(max_length=50, blank=True, null=True, db_index=True)
    dob = models.DateField()
    first_name = models.CharField(max_length=50)
    middle_name = models.CharField(max_length=50, blank=True, null=True)
    last_name = models.CharField(max_length=50, blank=True, null=True)
    gender = models.CharField(max_length=20)
    national_id = models.CharField(max_length=20, unique=True)
    phone = models.CharField(max_length=20, blank=True, null=True)
    email = models.EmailField(max_length=100, blank=True, null=True)
    address = models.CharField(max_length=255, blank=True, null=True)
    expertise = models.CharField(max_length=100)
    doctor_level = models.ForeignKey(
        DoctorLevel,
        on_delete=models.PROTECT
    )
    active_status = models.ForeignKey(
        DoctorActiveStatus,
        on_delete=models.PROTECT
    )
    
    class Meta:
        db_table = 'Doctor'
        ordering = ['first_name', 'last_name']
        indexes = [models.Index(fields=['medical_license_id'])]
        verbose_name = 'Doctor'
        verbose_name_plural = 'Doctors'
        
    def __str__(self):
        return f"Dr. {self.first_name} {self.last_name or ''}"
    
    @property
    def full_name(self):
        parts = [self.first_name]
        if self.middle_name:
            parts.append(self.middle_name)
        if self.last_name:
            parts.append(self.last_name)
        return ' '.join(parts)
    
    @property
    def is_available(self):
        """Check if doctor is available (Active or On-Demand status). Use status_name to avoid id ordering assumptions."""
        try:
            return self.active_status.status_name in ('On-Demand', 'Active')
        except Exception:
            return False

