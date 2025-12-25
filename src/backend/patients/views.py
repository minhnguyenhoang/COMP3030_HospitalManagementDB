from rest_framework import viewsets, permissions, filters, status
from rest_framework.response import Response
from django.db.models.deletion import ProtectedError
from .models import Patient, PatientCoreMedicalInformation, PatientPersonalInformation, TypeCoreMedInfo
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

        print(f"DEBUG CREATE - Allergies: '{allergies}'")
        print(f"DEBUG CREATE - Chronic Conditions: '{chronic_conditions}'")

        # Extract personal information fields
        personal_info_fields = {
            'nat_id': request.data.pop('nat_id', ''),
            'passport_no': request.data.pop('passport_no', ''),
            'drivers_license_no': request.data.pop('drivers_license_no', ''),
            'address': request.data.pop('address', ''),
            'city': request.data.pop('city', ''),
            'state': request.data.pop('state', ''),
            'country': request.data.pop('country', '')
        }

        # Create patient
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        patient = serializer.save()

        # Create PatientPersonalInformation if any field is provided
        if any(personal_info_fields.values()):
            PatientPersonalInformation.objects.create(
                patient=patient,
                **personal_info_fields
            )

        # Create allergies records
        if allergies:
            allergy_list = [a.strip() for a in allergies.split(',') if a.strip()]
            print(f"DEBUG - Creating {len(allergy_list)} allergy records: {allergy_list}")
            for allergy in allergy_list:
                try:
                    PatientCoreMedicalInformation.objects.create(
                        patient=patient,
                        information_type_id=1,  # Allergies
                        note=allergy
                    )
                    print(f"  ✓ Created allergy: {allergy}")
                except Exception as e:
                    print(f"  ✗ Failed to create allergy '{allergy}': {e}")

        # Create chronic conditions records
        if chronic_conditions:
            condition_list = [c.strip() for c in chronic_conditions.split(',') if c.strip()]
            print(f"DEBUG - Creating {len(condition_list)} chronic condition records: {condition_list}")
            for condition in condition_list:
                try:
                    PatientCoreMedicalInformation.objects.create(
                        patient=patient,
                        information_type_id=3,  # Medical Condition
                        note=condition
                    )
                    print(f"  ✓ Created condition: {condition}")
                except Exception as e:
                    print(f"  ✗ Failed to create condition '{condition}': {e}")

        # Refresh serializer to include newly created medical info
        patient.refresh_from_db()
        refreshed_serializer = self.get_serializer(patient)
        headers = self.get_success_headers(refreshed_serializer.data)
        return Response(refreshed_serializer.data, status=status.HTTP_201_CREATED, headers=headers)

    def update(self, request, *args, **kwargs):
        """Update patient and associated medical information"""
        # Extract allergies and chronic_conditions from request
        allergies = request.data.pop('allergies', '')
        chronic_conditions = request.data.pop('chronic_conditions', '')

        print(f"DEBUG UPDATE - Allergies: '{allergies}'")
        print(f"DEBUG UPDATE - Chronic Conditions: '{chronic_conditions}'")

        # Extract personal information fields
        personal_info_fields = {
            'nat_id': request.data.pop('nat_id', ''),
            'passport_no': request.data.pop('passport_no', ''),
            'drivers_license_no': request.data.pop('drivers_license_no', ''),
            'address': request.data.pop('address', ''),
            'city': request.data.pop('city', ''),
            'state': request.data.pop('state', ''),
            'country': request.data.pop('country', '')
        }

        # Update the Patient instance
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=kwargs.get('partial', False))
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)

        # Update or create PatientPersonalInformation
        if any(personal_info_fields.values()):
            PatientPersonalInformation.objects.update_or_create(
                patient=instance,
                defaults=personal_info_fields
            )

        # Delete all existing PatientCoreMedicalInformation records for this patient
        PatientCoreMedicalInformation.objects.filter(patient=instance).delete()

        # Recreate allergies (type=1)
        if allergies:
            allergy_list = [a.strip() for a in allergies.split(',') if a.strip()]
            print(f"DEBUG UPDATE - Creating {len(allergy_list)} allergy records: {allergy_list}")
            for allergy in allergy_list:
                try:
                    PatientCoreMedicalInformation.objects.create(
                        patient=instance,
                        information_type_id=1,
                        note=allergy
                    )
                    print(f"  ✓ Created allergy: {allergy}")
                except Exception as e:
                    print(f"  ✗ Failed to create allergy '{allergy}': {e}")

        # Recreate chronic conditions (type=3)
        if chronic_conditions:
            condition_list = [c.strip() for c in chronic_conditions.split(',') if c.strip()]
            print(f"DEBUG UPDATE - Creating {len(condition_list)} chronic condition records: {condition_list}")
            for condition in condition_list:
                try:
                    PatientCoreMedicalInformation.objects.create(
                        patient=instance,
                        information_type_id=3,
                        note=condition
                    )
                    print(f"  ✓ Created condition: {condition}")
                except Exception as e:
                    print(f"  ✗ Failed to create condition '{condition}': {e}")

        # Refresh instance to include newly created medical info
        instance.refresh_from_db()
        refreshed_serializer = self.get_serializer(instance)
        print(f"DEBUG UPDATE - Response data: {refreshed_serializer.data}")
        print(f"DEBUG UPDATE - Allergies in response: {refreshed_serializer.data.get('allergies')}")
        print(f"DEBUG UPDATE - Chronic conditions in response: {refreshed_serializer.data.get('chronic_conditions')}")
        return Response(refreshed_serializer.data)

    def partial_update(self, request, *args, **kwargs):
        """Partial update patient and associated medical information"""
        kwargs['partial'] = True
        return self.update(request, *args, **kwargs)

class TypeCoreMedViewSet(viewsets.ModelViewSet):
    queryset = TypeCoreMedInfo.objects.all()
    serializer_class = TypeCoreMedInfoSerializer
    permission_classes = [permissions.IsAuthenticated]