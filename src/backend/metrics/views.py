from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.db.models import Sum, Case, When, IntegerField, F, Count
from django.utils import timezone
from datetime import date, datetime, timedelta

from appointments.models import Appointment
from doctors.models import Doctor
from pharmacy.models import MedicineStockHistory


class OverviewMetrics(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        today = date.today()

        # Create timezone-aware datetime objects
        start_of_day = timezone.make_aware(datetime.combine(today, datetime.min.time()))
        end_of_day = timezone.make_aware(datetime.combine(today, datetime.max.time()))

        total_patients_today = (
            Appointment.objects.filter(
                visit_date__range=(start_of_day, end_of_day)
            )
            .values('patient')
            .distinct()
            .count()
        )

        pending_appointments = Appointment.objects.filter(visit_date__gte=timezone.now()).count()

        # Use status names instead of hardcoded IDs
        doctors_on_duty = Doctor.objects.filter(
            active_status__status_name__in=['Active', 'On-Demand']
        ).count()

        # low stock threshold can be passed as query param (default 10)
        try:
            threshold = int(request.query_params.get('low_stock_threshold', 10))
        except Exception:
            threshold = 10

        stock_qs = (
            MedicineStockHistory.objects.values('medicine')
            .annotate(
                current_stock=Sum(
                    Case(
                        When(add_remove=True, then=F('amount')),
                        When(add_remove=False, then=F('amount') * -1),
                        output_field=IntegerField(),
                    )
                )
            )
        )
        low_stock_alerts = sum(1 for s in stock_qs if (s['current_stock'] or 0) <= threshold)

        # last 7 days patient counts
        weekly = []
        for i in range(6, -1, -1):
            d = today - timedelta(days=i)
            # Use timezone-aware datetime for date range
            start_dt = timezone.make_aware(datetime.combine(d, datetime.min.time()))
            end_dt = timezone.make_aware(datetime.combine(d, datetime.max.time()))
            cnt = (
                Appointment.objects.filter(visit_date__range=(start_dt, end_dt))
                .values('patient')
                .distinct()
                .count()
            )
            weekly.append({'name': d.strftime('%a'), 'date': d.isoformat(), 'patients': cnt})

        # top conditions (diagnosis)
        top_conditions = (
            Appointment.objects
            .exclude(diagnosis__isnull=True)
            .exclude(diagnosis__exact='')
            .values('diagnosis')
            .annotate(count=Count('id'))
            .order_by('-count')[:5]
        )
        conditions = [{'name': t['diagnosis'], 'count': t['count']} for t in top_conditions]

        return Response({
            'total_patients_today': total_patients_today,
            'pending_appointments': pending_appointments,
            'doctors_on_duty': doctors_on_duty,
            'low_stock_alerts': low_stock_alerts,
            'weekly_patient_counts': weekly,
            'top_conditions': conditions,
        })