from django.core.management.base import BaseCommand
from doctors.models import DoctorLevel, DoctorActiveStatus
from pharmacy.models import TypeMedicineFunction, TypeMedicineAdministration, TypeCoreMedInfo

class Command(BaseCommand):
    help = 'Seed lookup data'

    def handle(self, *args, **options):
        # Doctor levels
        levels = ['Junior', 'Associate', 'Senior', 'Head']
        for i, l in enumerate(levels, start=1):
            DoctorLevel.objects.get_or_create(id=i, defaults={'title': l})

        # Doctor active statuses
        statuses = ['Inactive', 'On-Demand', 'Active']
        for i, s in enumerate(statuses, start=1):
            DoctorActiveStatus.objects.get_or_create(id=i, defaults={'status_name': s})

        # Medicine function types (example)
        meds = ['Analgesic', 'Antibiotic', 'Antipyretic']
        for i, m in enumerate(meds, start=1):
            TypeMedicineFunction.objects.get_or_create(id=i, defaults={'name': m})

        admins = ['Oral', 'Injection', 'Topical']
        for i, a in enumerate(admins, start=1):
            TypeMedicineAdministration.objects.get_or_create(id=i, defaults={'name': a})

        core = ['Allergies', 'Chronic Conditions']
        for i, c in enumerate(core, start=1):
            TypeCoreMedInfo.objects.get_or_create(id=i, defaults={'name': c})

        self.stdout.write(self.style.SUCCESS('Seeded lookup data.'))
