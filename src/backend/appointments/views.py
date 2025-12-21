from rest_framework import viewsets, permissions, status
from rest_framework.response import Response
from django.db import transaction
from .models import Appointment
from .serializers import AppointmentSerializer


class AppointmentViewSet(viewsets.ModelViewSet):
    queryset = Appointment.objects.select_related('patient', 'doctor').all().order_by('-visit_date')
    serializer_class = AppointmentSerializer
    permission_classes = [permissions.IsAuthenticated]

    def create(self, request, *args, **kwargs):
        # Validate doctor availability (ActiveStatus >= 2)
        # Accept either 'doctor' or 'doctor_id' from client
        doctor_id = request.data.get('doctor') or request.data.get('doctor_id')
        patient_id = request.data.get('patient') or request.data.get('patient_id')
        visit_date = request.data.get('visit_date')

        if not doctor_id or not patient_id or not visit_date:
            return Response({'detail': 'doctor, patient and visit_date are required.'}, status=status.HTTP_400_BAD_REQUEST)

        from doctors.models import Doctor
        try:
            doctor = Doctor.objects.get(id=doctor_id)
        except Doctor.DoesNotExist:
            return Response({'detail': 'Doctor not found.'}, status=status.HTTP_404_NOT_FOUND)

        if not doctor.is_available:
            return Response({'detail': 'Doctor is not available.'}, status=status.HTTP_400_BAD_REQUEST)

        with transaction.atomic():
            # copy data so we can normalize key names for serializer
            data = request.data.copy()
            if 'doctor' in data and 'doctor_id' not in data:
                data['doctor_id'] = data.get('doctor')
            # ensure patient field is present (serializer expects 'patient') - already provided
            serializer = self.get_serializer(data=data)
            serializer.is_valid(raise_exception=True)
            self.perform_create(serializer)
            headers = self.get_success_headers(serializer.data)
            return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)
