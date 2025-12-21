from django.db import models


class Appointment(models.Model):
    patient = models.ForeignKey('patients.Patient', on_delete=models.PROTECT)
    doctor = models.ForeignKey('doctors.Doctor', on_delete=models.PROTECT)
    visit_date = models.DateTimeField()
    diagnosis = models.CharField(max_length=255, blank=True, null=True)
    category = models.CharField(max_length=50, blank=True, null=True)
    note = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        db_table = 'Appointments'
        ordering = ['-visit_date']  # Most recent first
        indexes = [
            models.Index(fields=['patient']),
            models.Index(fields=['doctor']),
        ]

    def __str__(self):
        return f"Appt {self.id} - {self.patient} with Dr. {self.doctor}"
