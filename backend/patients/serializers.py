from rest_framework import serializers
from .models import Patient, PatientPersonalInformation, PatientCoreMedicalInformation, PatientEmergencyContact


class PatientPersonalInformationSerializer(serializers.ModelSerializer):
    class Meta:
        model = PatientPersonalInformation
        fields = '__all__'


class PatientCoreMedicalInformationSerializer(serializers.ModelSerializer):
    class Meta:
        model = PatientCoreMedicalInformation
        fields = '__all__'


class PatientEmergencyContactSerializer(serializers.ModelSerializer):
    class Meta:
        model = PatientEmergencyContact
        fields = '__all__'


class PatientSerializer(serializers.ModelSerializer):
    personal_info = PatientPersonalInformationSerializer(read_only=True, source='patientpersonalinformation')
    core_med_info = PatientCoreMedicalInformationSerializer(many=True, read_only=True)
    emergency_contacts = PatientEmergencyContactSerializer(many=True, read_only=True)

    # Computed fields for easier frontend access
    allergies = serializers.SerializerMethodField()
    chronic_conditions = serializers.SerializerMethodField()

    class Meta:
        model = Patient
        fields = [
            'id', 'first_name', 'middle_name', 'last_name', 'dob',
            'ethnicity', 'preferred_language', 'gender', 'biological_sex',
            'phone', 'email',
            'first_visit_date', 'last_visit_date',
            'insurance_id', 'insurance_provider',
            'blood_type', 'height', 'weight',
            'dnr_status', 'organ_donor_status',
            'personal_info', 'core_med_info', 'emergency_contacts',
            'allergies', 'chronic_conditions'
        ]

    def get_allergies(self, obj):
        """Return list of allergy notes"""
        return [
            info.note for info in obj.core_med_info.all()
            if info.information_type == 1 and info.note
        ]

    def get_chronic_conditions(self, obj):
        """Return list of chronic condition notes"""
        return [
            info.note for info in obj.core_med_info.all()
            if info.information_type == 3 and info.note
        ]
