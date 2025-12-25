from rest_framework import viewsets, permissions, filters, status
from rest_framework.response import Response
from django.db.models.deletion import ProtectedError
from .models import Patient, PatientCoreMedicalInformation, TypeCoreMedInfo
from .serializers import PatientSerializer, TypeCoreMedInfoSerializer


class PatientViewSet(viewsets.ModelViewSet):
    queryset = Patient.objects.all().order_by('-last_visit_date')
    serializer_class = PatientSerializer
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['first_name', 'last_name', 'phone', 'email']
    ordering_fields = ['last_visit_date', 'first_name', 'last_name']

    def destroy(self, request, *args, **kwargs):
        """Delete patient with custom error message"""
        try:
            return super().destroy(request, *args, **kwargs)
        except ProtectedError:
            return Response(
                {'detail': 'Cannot delete patient with existing appointments.'},
                status=status.HTTP_400_BAD_REQUEST
            )

    def create(self, request, *args, **kwargs):
        """Create patient and associated medical information"""
        # Extract allergies and chronic_conditions from request
        allergies = request.data.pop('allergies', '')
        chronic_conditions = request.data.pop('chronic_conditions', '')

        # Create patient
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        patient = serializer.save()

        # Create allergies records
        if allergies:
            allergy_list = [a.strip() for a in allergies.split(',') if a.strip()]
            for allergy in allergy_list:
                PatientCoreMedicalInformation.objects.create(
                    patient=patient,
                    information_type=1,  # Allergies
                    note=allergy
                )

        # Create chronic conditions records
        if chronic_conditions:
            condition_list = [c.strip() for c in chronic_conditions.split(',') if c.strip()]
            for condition in condition_list:
                PatientCoreMedicalInformation.objects.create(
                    patient=patient,
                    information_type=3,  # Medical Condition
                    note=condition
                )

        headers = self.get_success_headers(serializer.data)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)

class TypeCoreMedViewSet(viewsets.ModelViewSet):
    queryset = TypeCoreMedInfo.objects.all()
    serializer_class = TypeCoreMedInfoSerializer
    permission_classes = [permissions.IsAuthenticated]