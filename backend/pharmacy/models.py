from django.db import models


class TypeCoreMedInfo(models.Model):
    name = models.CharField(max_length=50)

    class Meta:
        db_table = 'Type_CoreMedInfo'
        ordering = ['id']


class TypeMedicineFunction(models.Model):
    name = models.CharField(max_length=50)

    class Meta:
        db_table = 'Type_MedicineFunction'
        ordering = ['id']


class TypeMedicineAdministration(models.Model):
    name = models.CharField(max_length=50)

    class Meta:
        db_table = 'Type_MedicineAdministration'
        ordering = ['id']


class Medicine(models.Model):
    medicine_name = models.CharField(max_length=100)
    producer = models.CharField(max_length=100, blank=True, null=True)
    medicine_type = models.ForeignKey(TypeMedicineFunction, on_delete=models.PROTECT, blank=True, null=True)
    medicine_administration_method = models.ForeignKey(TypeMedicineAdministration, on_delete=models.PROTECT, blank=True, null=True)
    medicine_unit = models.CharField(max_length=20)

    class Meta:
        db_table = 'Medicine'
        ordering = ['medicine_name']

    def __str__(self):
        return self.medicine_name


class MedicineStockHistory(models.Model):
    medicine = models.ForeignKey(Medicine, on_delete=models.CASCADE)
    add_remove = models.BooleanField()  # True means add, False means remove
    amount = models.IntegerField()
    appointment = models.ForeignKey(
        'appointments.Appointment',
        on_delete=models.SET_NULL,
        blank=True,
        null=True,
        related_name='stock_history'
    )
    note = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        db_table = 'MedicineStockHistory'
        ordering = ['id']  # Oldest first (initial stock first)


class PrescriptionHistory(models.Model):
    appointment = models.ForeignKey(
        'appointments.Appointment',
        on_delete=models.CASCADE,
        related_name='prescriptions',
        blank=True,
        null=True
    )
    medicine = models.ForeignKey(Medicine, on_delete=models.PROTECT)
    prescription_date = models.DateField(blank=True, null=True)
    amount = models.IntegerField()

    class Meta:
        db_table = 'PrescriptionHistory'
        ordering = ['-prescription_date', '-id']  # Most recent first
