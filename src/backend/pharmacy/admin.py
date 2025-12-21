from django.contrib import admin
from .models import Medicine, PrescriptionHistory, MedicineStockHistory


@admin.register(Medicine)
class MedicineAdmin(admin.ModelAdmin):
    list_display = ('id', 'medicine_name', 'producer', 'medicine_unit')


@admin.register(PrescriptionHistory)
class PrescriptionAdmin(admin.ModelAdmin):
    list_display = ('id', 'appointment_id', 'medicine', 'prescription_date', 'amount')


@admin.register(MedicineStockHistory)
class MedicineStockHistoryAdmin(admin.ModelAdmin):
    list_display = ('id', 'medicine', 'add_remove', 'amount', 'appointment_id')
