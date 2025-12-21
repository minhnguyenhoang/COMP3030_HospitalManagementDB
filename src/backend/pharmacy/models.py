from django.db import models


class TypeCoreMedInfo(models.Model):
    name = models.CharField(max_length=50)

    class Meta:
        db_table = 'Type_CoreMedInfo'
        ordering = ['id']
        verbose_name = 'Core Medical Information'
        verbose_name_plural = 'Core Medical Information'


class TypeMedicineFunction(models.Model):
    name = models.CharField(max_length=50)

    class Meta:
        db_table = 'Type_MedicineFunction'
        ordering = ['id']
        verbose_name = 'Medicine Function'
        verbose_name_plural = 'Medicine Functions'


class TypeMedicineAdministration(models.Model):
    name = models.CharField(max_length=50)

    class Meta:
        db_table = 'Type_MedicineAdministration'
        ordering = ['id']
        verbose_name = 'Medicine Administration Method'
        verbose_name_plural = 'Medicine Administration Methods'


class Medicine(models.Model):
    medicine_name = models.CharField(max_length=100)
    producer = models.CharField(max_length=100, blank=True, null=True)
    medicine_type = models.ForeignKey(TypeMedicineFunction, on_delete=models.PROTECT, blank=True, null=True)
    medicine_administration_method = models.ForeignKey(TypeMedicineAdministration, on_delete=models.PROTECT, blank=True, null=True)
    medicine_unit = models.CharField(max_length=20)

    class Meta:
        db_table = 'Medicine'
        ordering = ['medicine_name']
        verbose_name = 'Medicine'
        verbose_name_plural = 'Medicine'

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
        ordering = ['-id']  # Newest first (latest stock first)
        verbose_name = 'Medicine Stock History'
        verbose_name_plural = 'Medicine Stock History'
