from django.contrib import admin
from .models import Doctor, Department, DoctorLevel, DoctorActiveStatus


@admin.register(Doctor)
class DoctorAdmin(admin.ModelAdmin):
    list_display = ('id', 'first_name', 'last_name', 'medical_license_id', 'department', 'doctor_level', 'active_status')
    search_fields = ('first_name', 'last_name', 'medical_license_id')


@admin.register(Department)
class DepartmentAdmin(admin.ModelAdmin):
    list_display = ('id', 'department_name', 'head_of_department')


admin.site.register(DoctorLevel)
admin.site.register(DoctorActiveStatus)
