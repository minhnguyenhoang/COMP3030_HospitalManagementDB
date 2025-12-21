from rest_framework import viewsets, permissions, status
from rest_framework.response import Response
# from django.db import transaction
# from django.db import models
from django.db.models.deletion import ProtectedError
from .models import Medicine, MedicineStockHistory, TypeMedicineFunction, TypeMedicineAdministration
from .serializers import (
    MedicineSerializer,
    MedicineStockHistorySerializer,
    TypeMedicineFunctionSerializer,
    TypeMedicineAdministrationSerializer
)


class MedicineViewSet(viewsets.ModelViewSet):
    queryset = Medicine.objects.all()
    serializer_class = MedicineSerializer
    permission_classes = [permissions.IsAuthenticated]

    def destroy(self, request, *args, **kwargs):
        """Delete medicine with custom error message"""
        try:
            return super().destroy(request, *args, **kwargs)
        except ProtectedError:
            return Response(
                {'detail': 'Cannot delete medicine with prescription history.'},
                status=status.HTTP_400_BAD_REQUEST
            )


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
