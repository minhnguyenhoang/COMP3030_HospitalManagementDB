from rest_framework import viewsets, permissions, status
from rest_framework.response import Response
from django.db import transaction
from django.db import models
from .models import Medicine, PrescriptionHistory, MedicineStockHistory, TypeMedicineFunction, TypeMedicineAdministration
from .serializers import (
    MedicineSerializer,
    PrescriptionSerializer,
    MedicineStockHistorySerializer,
    TypeMedicineFunctionSerializer,
    TypeMedicineAdministrationSerializer
)


class MedicineViewSet(viewsets.ModelViewSet):
    queryset = Medicine.objects.all()
    serializer_class = MedicineSerializer
    permission_classes = [permissions.IsAuthenticated]


class PrescriptionViewSet(viewsets.ModelViewSet):
    queryset = PrescriptionHistory.objects.select_related('medicine').all()
    serializer_class = PrescriptionSerializer
    permission_classes = [permissions.IsAuthenticated]

    def create(self, request, *args, **kwargs):
        """Create prescription and deduct stock atomically"""
        medicine_id = request.data.get('medicine')
        amount = int(request.data.get('amount', 0))
        appointment_id = request.data.get('appointment_id')

        if not medicine_id or amount <= 0:
            return Response({'detail': 'medicine and positive amount are required.'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            med = Medicine.objects.get(id=medicine_id)
        except Medicine.DoesNotExist:
            return Response({'detail': 'Medicine not found.'}, status=status.HTTP_404_NOT_FOUND)

        # Check current stock
        current_stock = MedicineStockHistory.objects.filter(medicine=med).aggregate(
            total=models.Sum(models.Case(
                models.When(add_remove=True, then='amount'),
                models.When(add_remove=False, then=models.F('amount') * -1),
                output_field=models.IntegerField()
            ))
        )['total'] or 0

        if current_stock < amount:
            return Response({'detail': 'Insufficient stock.'}, status=status.HTTP_400_BAD_REQUEST)

        with transaction.atomic():
            # Normalize input keys for serializer (accept 'medicine' field from clients)
            data = request.data.copy()
            if 'medicine' in data and 'medicine_id' not in data:
                data['medicine_id'] = data.get('medicine')

            # Create Prescription
            serializer = self.get_serializer(data=data)
            serializer.is_valid(raise_exception=True)
            pres = serializer.save()

            # Insert stock removal record
            MedicineStockHistory.objects.create(
                medicine=med,
                add_remove=False,
                amount=amount,
                appointment_id=appointment_id,
                note='Prescription deduction'
            )

            return Response(PrescriptionSerializer(pres).data, status=status.HTTP_201_CREATED)


class MedicineStockHistoryViewSet(viewsets.ModelViewSet):
    queryset = MedicineStockHistory.objects.select_related('medicine').all()
    serializer_class = MedicineStockHistorySerializer
    permission_classes = [permissions.IsAuthenticated]


class TypeMedicineFunctionViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = TypeMedicineFunction.objects.all()
    serializer_class = TypeMedicineFunctionSerializer
    permission_classes = [permissions.IsAuthenticated]


class TypeMedicineAdministrationViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = TypeMedicineAdministration.objects.all()
    serializer_class = TypeMedicineAdministrationSerializer
    permission_classes = [permissions.IsAuthenticated]
