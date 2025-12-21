from rest_framework import viewsets, permissions
from .models import DoctorLevel, DoctorActiveStatus
from rest_framework import serializers


class DoctorLevelSerializer(serializers.ModelSerializer):
    class Meta:
        model = DoctorLevel
        fields = ['id', 'title']


class DoctorActiveStatusSerializer(serializers.ModelSerializer):
    class Meta:
        model = DoctorActiveStatus
        fields = ['id', 'status_name']


class DoctorLevelViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = DoctorLevel.objects.all()
    serializer_class = DoctorLevelSerializer
    permission_classes = [permissions.IsAuthenticated]


class DoctorActiveStatusViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = DoctorActiveStatus.objects.all()
    serializer_class = DoctorActiveStatusSerializer
    permission_classes = [permissions.IsAuthenticated]
