from rest_framework import viewsets, permissions, filters
from .models import Doctor, Department, DoctorLevel, DoctorActiveStatus
from .serializers import DoctorSerializer, DepartmentSerializer, DoctorLevelSerializer, DoctorActiveStatusSerializer


class DoctorViewSet(viewsets.ModelViewSet):
    queryset = Doctor.objects.select_related('department', 'doctor_level', 'active_status').all()
    serializer_class = DoctorSerializer
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['first_name', 'last_name', 'expertise', 'department__department_name']
    ordering_fields = ['first_name', 'last_name']


class DepartmentViewSet(viewsets.ModelViewSet):
    queryset = Department.objects.all()
    serializer_class = DepartmentSerializer
    permission_classes = [permissions.IsAuthenticated]


class DoctorLevelViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = DoctorLevel.objects.all()
    serializer_class = DoctorLevelSerializer
    permission_classes = [permissions.IsAuthenticated]


class DoctorActiveStatusViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = DoctorActiveStatus.objects.all()
    serializer_class = DoctorActiveStatusSerializer
    permission_classes = [permissions.IsAuthenticated]
