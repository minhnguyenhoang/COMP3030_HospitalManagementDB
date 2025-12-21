from rest_framework import serializers
from .models import Doctor, Department, DoctorLevel, DoctorActiveStatus


class DepartmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Department
        fields = ['id', 'department_name', 'description', 'head_of_department']
        extra_kwargs = {
            'head_of_department': {'required': False, 'allow_null': True}
        }


class DoctorLevelSerializer(serializers.ModelSerializer):
    class Meta:
        model = DoctorLevel
        fields = ['id', 'title']


class DoctorActiveStatusSerializer(serializers.ModelSerializer):
    class Meta:
        model = DoctorActiveStatus
        fields = ['id', 'status_name']


class DoctorSerializer(serializers.ModelSerializer):
    # Read fields for display - return string values
    department_name = serializers.CharField(source='department.department_name', read_only=True)
    doctor_level_title = serializers.CharField(source='doctor_level.title', read_only=True)
    active_status_name = serializers.CharField(source='active_status.status_name', read_only=True)

    # Write fields for creation/update
    department_id = serializers.PrimaryKeyRelatedField(
        queryset=Department.objects.all(),
        source='department',
        write_only=True,
        required=False
    )
    doctor_level_id = serializers.PrimaryKeyRelatedField(
        queryset=DoctorLevel.objects.all(),
        source='doctor_level',
        write_only=True,
        required=False
    )
    active_status_id = serializers.PrimaryKeyRelatedField(
        queryset=DoctorActiveStatus.objects.all(),
        source='active_status',
        write_only=True,
        required=False
    )

    class Meta:
        model = Doctor
        fields = [
            'id', 'first_name', 'middle_name', 'last_name',
            'medical_license_id', 'dob', 'gender', 'national_id',
            'phone', 'email', 'address', 'expertise',
            'department_name', 'department_id',
            'doctor_level_title', 'doctor_level_id',
            'active_status_name', 'active_status_id'
        ]
