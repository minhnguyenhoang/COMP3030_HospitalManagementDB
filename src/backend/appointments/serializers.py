from rest_framework import serializers
from .models import Appointment
from doctors.serializers import DoctorSerializer
from doctors.models import Doctor


class AppointmentSerializer(serializers.ModelSerializer):
    doctor = DoctorSerializer(read_only=True)
    # Allow setting doctor by id when creating/updating
    doctor_id = serializers.PrimaryKeyRelatedField(queryset=Doctor.objects.all(), source='doctor', write_only=True, required=True)

    class Meta:
        model = Appointment
        fields = '__all__'