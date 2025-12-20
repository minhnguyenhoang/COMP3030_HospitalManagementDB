from django.db import models


class Patient(models.Model):
    first_name = models.CharField(max_length=50)
    middle_name = models.CharField(max_length=50, blank=True, null=True)
    last_name = models.CharField(max_length=50)
    dob = models.DateField()
    ethnicity = models.CharField(max_length=50, blank=True, null=True)
    preferred_language = models.CharField(max_length=50, blank=True, null=True)
    gender = models.CharField(max_length=20)
    biological_sex = models.CharField(max_length=20)
    phone = models.CharField(max_length=20, blank=True, null=True)
    email = models.EmailField(max_length=100, blank=True, null=True)
    first_visit_date = models.DateField()
    last_visit_date = models.DateField()
    insurance_id = models.CharField(max_length=50, blank=True, null=True)
    insurance_provider = models.CharField(max_length=100, blank=True, null=True)
    blood_type = models.CharField(max_length=10, blank=True, null=True)
    height = models.IntegerField(blank=True, null=True)
    weight = models.IntegerField(blank=True, null=True)
    dnr_status = models.BooleanField(default=False)
    organ_donor_status = models.BooleanField(default=False)

    class Meta:
        db_table = 'Patient'
        ordering = ['last_name', 'first_name']
        indexes = [
            models.Index(fields=['last_name']),
        ]

    def __str__(self):
        return f"{self.first_name} {self.last_name}" 


class PatientPersonalInformation(models.Model):
    patient = models.OneToOneField(Patient, on_delete=models.CASCADE, primary_key=True)
    occupation = models.CharField(max_length=100, blank=True, null=True)
    nat_id = models.CharField(max_length=50, blank=True, null=True)
    passport_no = models.CharField(max_length=50, blank=True, null=True)
    drivers_license_no = models.CharField(max_length=50, blank=True, null=True)
    address = models.CharField(max_length=255, blank=True, null=True)
    city = models.CharField(max_length=100, blank=True, null=True)
    state = models.CharField(max_length=100, blank=True, null=True)
    country = models.CharField(max_length=100, blank=True, null=True)

    class Meta:
        db_table = 'PatientPersonalInformation'

    def __str__(self):
        return f"Personal Info {self.patient_id}"


class PatientCoreMedicalInformation(models.Model):
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE, related_name='core_med_info')
    information_type = models.IntegerField()
    note = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        db_table = 'PatientCoreMedicalInformation'


class PatientEmergencyContact(models.Model):
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE, related_name='emergency_contacts')
    contact_type = models.CharField(max_length=50)
    contact_information = models.CharField(max_length=255)
    relationship = models.CharField(max_length=50)
    last_updated = models.DateField()

    class Meta:
        db_table = 'PatientEmergencyContact'
