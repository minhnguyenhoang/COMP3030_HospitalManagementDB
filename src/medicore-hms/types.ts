export enum UserRole {
  ADMIN = 'ADMIN',
  DOCTOR = 'DOCTOR',
  RECEPTIONIST = 'RECEPTIONIST'
}

export interface User {
  id: string;
  name: string;
  role: UserRole;
  avatar: string;
  email: string;
}

export interface Patient {
  id: string;
  name: string;
  dob: string; // YYYY-MM-DD
  gender: 'Male' | 'Female' | 'Other';
  phone: string;
  address: string;
  bloodGroup: string;
  lastVisit: string;
  dnrStatus: boolean;
  allergies: string[];
  chronicConditions: string[];
}

export interface MedicalRecord {
  id: string;
  date: string;
  doctorName: string;
  diagnosis: string;
  notes: string;
  type: 'Consultation' | 'Emergency' | 'Checkup';
}

export interface Prescription {
  id: string;
  medication: string;
  dosage: string;
  frequency: string;
  duration: string;
  date: string;
  doctorName: string;
}

export interface Staff {
  id: string;
  name: string;
  role: string;
  department: string;
  status: 'Active' | 'On Leave' | 'Off Duty';
  avatar: string;
}

export interface InventoryItem {
  id: string;
  name: string;
  category: string;
  stock: number;
  unit: string;
  minLevel: number;
  lastUpdated: string;
}

export interface Appointment {
  id: string;
  patientName: string;
  doctorName: string;
  time: string;
  status: 'Pending' | 'Confirmed' | 'Completed' | 'Cancelled';
  type: string;
}
