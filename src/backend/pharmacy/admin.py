from django.contrib import admin
from .models import Medicine, MedicineStockHistory


@admin.register(Medicine)
class MedicineAdmin(admin.ModelAdmin):
    list_display = ('id', 'medicine_name', 'producer', 'medicine_unit')


@admin.register(MedicineStockHistory)
class MedicineStockHistoryAdmin(admin.ModelAdmin):
    list_display = ('id', 'medicine', 'add_remove', 'amount', 'appointment_id')
