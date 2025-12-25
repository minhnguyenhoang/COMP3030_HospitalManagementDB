from django.contrib import admin
from .models import Patient, PatientPersonalInformation, PatientCoreMedicalInformation, PatientEmergencyContact, TypeCoreMedInfo


@admin.register(Patient)
class PatientAdmin(admin.ModelAdmin):
    list_display = ('id', 'first_name', 'last_name', 'dob', 'phone', 'last_visit_date')
    search_fields = ('first_name', 'last_name', 'phone')


admin.site.register(PatientPersonalInformation)
admin.site.register(PatientCoreMedicalInformation)
admin.site.register(PatientEmergencyContact)
admin.site.register(TypeCoreMedInfo)