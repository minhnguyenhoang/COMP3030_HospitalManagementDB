const API_BASE = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000/api';

function getAuthHeaders() {
  const token = localStorage.getItem('access_token');
  return token ? { Authorization: `Bearer ${token}` } : {};
}

async function refreshToken() {
  const refresh = localStorage.getItem('refresh_token');
  if (!refresh) throw new Error('No refresh token');
  const res = await fetch(`${API_BASE}/auth/token/refresh/`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ refresh }),
  });
  if (!res.ok) throw new Error('Refresh failed');
  const data = await res.json();
  if (data.access) localStorage.setItem('access_token', data.access);
  return data;
}

async function request(path: string, options: RequestInit = {}, auth = true, retry = true) {
  const headers: Record<string, string> = {
    'Content-Type': 'application/json',
    ...(options.headers as Record<string, string> || {}),
  };
  if (auth) Object.assign(headers, getAuthHeaders());

  const res = await fetch(`${API_BASE}${path}`, { ...options, headers });
  if (res.status === 401 && auth && retry) {
    // try refresh
    try {
      await refreshToken();
      return request(path, options, auth, false);
    } catch (e) {
      // force logout
      localStorage.removeItem('access_token');
      localStorage.removeItem('refresh_token');
      throw new Error('Session expired. Please login again.');
    }
  }
  if (!res.ok) {
    const text = await res.text();
    throw new Error(`API ${path} failed: ${res.status} ${text}`);
  }
  const ct = res.headers.get('content-type') || '';
  if (ct.includes('application/json')) return res.json();
  return res.text();
}

export async function login(username: string, password: string) {
  const res = await request('/auth/token/', { method: 'POST', body: JSON.stringify({ username, password }) }, false);
  if (res.access) {
    localStorage.setItem('access_token', res.access);
    if (res.refresh) localStorage.setItem('refresh_token', res.refresh);
  }
  return res;
}

export function logout() {
  localStorage.removeItem('access_token');
  localStorage.removeItem('refresh_token');
}

export async function fetchPatients() {
  return request('/patients/');
}

export async function fetchPatient(patientId: string | number) {
  return request(`/patients/${patientId}/`);
}

export async function searchPatientByPhone(phone: string) {
  return request(`/patients/?search=${encodeURIComponent(phone)}`);
}

export async function createPatient(payload: any) {
  return request('/patients/', { method: 'POST', body: JSON.stringify(payload) });
}

export async function updatePatient(patientId: string | number, payload: any) {
  return request(`/patients/${patientId}/`, { method: 'PUT', body: JSON.stringify(payload) });
}

export async function deletePatient(patientId: string | number) {
  return request(`/patients/${patientId}/`, { method: 'DELETE' });
}

export async function fetchAppointments() {
  return request('/appointments/');
}

export async function createAppointment(payload: any) {
  return request('/appointments/', { method: 'POST', body: JSON.stringify(payload) });
}

export async function updateAppointment(appointmentId: string | number, payload: any) {
  return request(`/appointments/${appointmentId}/`, { method: 'PUT', body: JSON.stringify(payload) });
}

export async function deleteAppointment(appointmentId: string | number) {
  return request(`/appointments/${appointmentId}/`, { method: 'DELETE' });
}

export async function fetchDoctors() {
  return request('/doctors/');
}

export async function createDoctor(payload: any) {
  return request('/doctors/', { method: 'POST', body: JSON.stringify(payload) });
}

export async function updateDoctor(doctorId: string | number, payload: any) {
  return request(`/doctors/${doctorId}/`, { method: 'PUT', body: JSON.stringify(payload) });
}

export async function deleteDoctor(doctorId: string | number) {
  return request(`/doctors/${doctorId}/`, { method: 'DELETE' });
}

export async function fetchDepartments() {
  return request('/departments/');
}

export async function createDepartment(payload: any) {
  return request('/departments/', { method: 'POST', body: JSON.stringify(payload) });
}

export async function fetchDoctorLevels() {
  return request('/doctor-levels/');
}

export async function fetchDoctorStatuses() {
  return request('/doctor-statuses/');
}

export async function fetchMedicines() {
  return request('/medicines/');
}

export async function createMedicine(payload: any) {
  return request('/medicines/', { method: 'POST', body: JSON.stringify(payload) });
}

export async function updateMedicine(medicineId: string | number, payload: any) {
  return request(`/medicines/${medicineId}/`, { method: 'PUT', body: JSON.stringify(payload) });
}

export async function deleteMedicine(medicineId: string | number) {
  return request(`/medicines/${medicineId}/`, { method: 'DELETE' });
}

export async function fetchMedicineTypes() {
  return request('/medicine-types/');
}

export async function fetchMedicineAdminMethods() {
  return request('/medicine-admin-methods/');
}

export async function fetchMedicineStock() {
  return request('/medicine-stock/');
}

export async function createMedicineStock(payload: any) {
  return request('/medicine-stock/', { method: 'POST', body: JSON.stringify(payload) });
}

export async function fetchPrescriptions() {
  return request('/prescriptions/');
}

export async function createPrescription(payload: any) {
  return request('/prescriptions/', { method: 'POST', body: JSON.stringify(payload) });
}

export async function fetchMetrics(lowStockThreshold?: number) {
  const q = lowStockThreshold ? `?low_stock_threshold=${lowStockThreshold}` : '';
  return request(`/metrics/overview/${q}`);
}

export default {
  login,
  logout,
  fetchPatients,
  fetchPatient,
  searchPatientByPhone,
  createPatient,
  updatePatient,
  deletePatient,
  fetchAppointments,
  createAppointment,
  updateAppointment,
  deleteAppointment,
  fetchDoctors,
  createDoctor,
  updateDoctor,
  deleteDoctor,
  fetchDepartments,
  createDepartment,
  fetchDoctorLevels,
  fetchDoctorStatuses,
  fetchMedicines,
  createMedicine,
  updateMedicine,
  deleteMedicine,
  fetchMedicineTypes,
  fetchMedicineAdminMethods,
  fetchMedicineStock,
  createMedicineStock,
  fetchPrescriptions,
  createPrescription,
  fetchMetrics,
};
