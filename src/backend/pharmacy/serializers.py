from rest_framework import serializers
from .models import Medicine, MedicineStockHistory, TypeMedicineFunction, TypeMedicineAdministration


class TypeMedicineFunctionSerializer(serializers.ModelSerializer):
    class Meta:
        model = TypeMedicineFunction
        fields = ['id', 'name']


class TypeMedicineAdministrationSerializer(serializers.ModelSerializer):
    class Meta:
        model = TypeMedicineAdministration
        fields = ['id', 'name']


class MedicineSerializer(serializers.ModelSerializer):
    class Meta:
        model = Medicine
        fields = '__all__'


class MedicineStockHistorySerializer(serializers.ModelSerializer):
    # Return medicine as ID for frontend stock calculation
    medicine = serializers.IntegerField(source='medicine.id', read_only=True)
    medicine_name = serializers.CharField(source='medicine.medicine_name', read_only=True)

    # Write field for creation/update
    medicine_id = serializers.PrimaryKeyRelatedField(
        queryset=Medicine.objects.all(),
        source='medicine',
        write_only=True,
        required=True
    )

    class Meta:
        model = MedicineStockHistory
        fields = [
            'id', 'medicine', 'medicine_name', 'medicine_id',
            'add_remove', 'amount', 'appointment', 'note'
        ]