"""
URL configuration for config project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""

from django.contrib import admin
from django.urls import path, include
from django.http import JsonResponse
from rest_framework import routers
from rest_framework_simplejwt.views import TokenRefreshView

from patients.views import PatientViewSet
from doctors.views import DoctorViewSet, DepartmentViewSet, DoctorLevelViewSet, DoctorActiveStatusViewSet
from appointments.views import AppointmentViewSet
from pharmacy.views import (
    MedicineViewSet,
    MedicineStockHistoryViewSet,
    TypeMedicineFunctionViewSet,
    TypeMedicineAdministrationViewSet
)
from metrics.views import OverviewMetrics
from users.views import CustomTokenObtainPairView, UserRegistrationView

router = routers.DefaultRouter()
router.register(r'patients', PatientViewSet)
router.register(r'doctors', DoctorViewSet)
router.register(r'departments', DepartmentViewSet)
router.register(r'doctor-levels', DoctorLevelViewSet)
router.register(r'doctor-statuses', DoctorActiveStatusViewSet)
router.register(r'appointments', AppointmentViewSet)
router.register(r'medicines', MedicineViewSet)
router.register(r'medicine-stock', MedicineStockHistoryViewSet)
router.register(r'medicine-types', TypeMedicineFunctionViewSet)
router.register(r'medicine-admin-methods', TypeMedicineAdministrationViewSet)


def health(request):
    return JsonResponse({'status': 'ok', 'service': 'Hospital Management Backend'})


urlpatterns = [
    path('', health),
    path('admin/', admin.site.urls),
    path('api/', include(router.urls)),
    path('api/metrics/overview/', OverviewMetrics.as_view()),
    path('api/auth/', include('rest_framework.urls')),
    path('api/auth/token/', CustomTokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/auth/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('api/auth/register/', UserRegistrationView.as_view(), name='user_register'),
]
