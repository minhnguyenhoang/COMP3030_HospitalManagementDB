import React, { useState } from 'react';
import { Search, Calendar, User, FileText, CheckCircle } from 'lucide-react';
import { UserRole } from '../types';
import { showSuccess, showError, showWarning } from '../src/utils/toast';

interface AppointmentsProps {
  role: UserRole;
}

const Appointments: React.FC<AppointmentsProps> = ({ role }) => {
  const [activeStep, setActiveStep] = useState(1);
  const [selectedPatient, setSelectedPatient] = useState<number | null>(null);
  const [appointments, setAppointments] = useState<any[]>([]);
  const [doctors, setDoctors] = useState<any[]>([]);
  const [patients, setPatients] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);

  // Receptionist booking states
  const [selectedDoctor, setSelectedDoctor] = useState<string>('');
  const [appointmentDate, setAppointmentDate] = useState('');
  const [reason, setReason] = useState('');
  const [patientSearch, setPatientSearch] = useState('');

  // New patient search and form states
  const [phoneSearch, setPhoneSearch] = useState('');
  const [foundPatient, setFoundPatient] = useState<any>(null);
  const [isNewPatient, setIsNewPatient] = useState(false);
  const [patientForm, setPatientForm] = useState({
    first_name: '',
    last_name: '',
    dob: '',
    gender: 'Male',
    biological_sex: 'Male',
    phone: '',
    email: '',
    blood_type: '',
    allergies: '',
    chronic_conditions: ''
  });

  // Doctor form state
  const [diagnosis, setDiagnosis] = useState('');
  const [notes, setNotes] = useState('');
  const [medicationSearch, setMedicationSearch] = useState('');
  const [medicationQty, setMedicationQty] = useState(1);
  const [medications, setMedications] = useState<{medicineId:number, amount:number, name:string}[]>([]);
  const [medicineList, setMedicineList] = useState<any[]>([]);
  const [filteredMedicines, setFilteredMedicines] = useState<any[]>([]);
  const [showMedicineDropdown, setShowMedicineDropdown] = useState(false);

  const isReceptionist = role === UserRole.RECEPTIONIST;

  React.useEffect(() => {
    let mounted = true;
    setLoading(true);
    import('../src/api').then(async (api) => {
      try {
        const [apptsResp, docsResp, patsResp, medsResp] = await Promise.all([
          api.fetchAppointments(),
          api.fetchDoctors(),
          api.fetchPatients(),
          api.fetchMedicines()
        ]);
        if (!mounted) return;
        setAppointments(apptsResp.results || apptsResp);
        const doctorsList = docsResp.results || docsResp;
        setDoctors(doctorsList);
        if (doctorsList.length > 0) setSelectedDoctor(doctorsList[0].id.toString());
        setPatients(patsResp.results || patsResp);
        setMedicineList(medsResp.results || medsResp);
        setLoading(false);
      } catch (err) {
        console.error('Failed to fetch appointments data:', err);
        setLoading(false);
      }
    });
    return () => { mounted = false; };
  }, []);

  const handleSearchPatient = async () => {
    if (!phoneSearch || phoneSearch.length < 8) {
      return showWarning('Enter valid phone number (at least 8 digits)');
    }

    try {
      const api = await import('../src/api');
      const result = await api.searchPatientByPhone(phoneSearch);
      const patientList = result.results || result;

      if (patientList && patientList.length > 0) {
        // Patient found - auto-fill form
        const patient = patientList[0];
        setFoundPatient(patient);
        setIsNewPatient(false);
        setPatientForm({
          first_name: patient.first_name || '',
          last_name: patient.last_name || '',
          dob: patient.dob || '',
          gender: patient.gender || 'Male',
          biological_sex: patient.biological_sex || 'Male',
          phone: patient.phone || '',
          email: patient.email || '',
          blood_type: patient.blood_type || '',
          allergies: (patient.allergies || []).join(', '),
          chronic_conditions: (patient.chronic_conditions || []).join(', ')
        });
        showSuccess('Patient found! Information loaded.');
      } else {
        // New patient
        setFoundPatient(null);
        setIsNewPatient(true);
        setPatientForm(prev => ({ ...prev, phone: phoneSearch }));
        showWarning('Patient not found. Please fill in new patient information.');
      }
    } catch (err: any) {
      showError('Search failed: ' + err.message);
    }
  };

  const handleMedicineSearch = (value: string) => {
    setMedicationSearch(value);
    if (value.trim().length > 0) {
      const filtered = medicineList.filter((m: any) =>
        m.medicine_name.toLowerCase().includes(value.toLowerCase())
      );
      setFilteredMedicines(filtered);
      setShowMedicineDropdown(true);
    } else {
      setFilteredMedicines([]);
      setShowMedicineDropdown(false);
    }
  };

  const handleSelectMedicine = (medicine: any) => {
    setMedicationSearch(medicine.medicine_name);
    setShowMedicineDropdown(false);
  };

  const handleBook = async (ev: React.FormEvent) => {
    ev.preventDefault();
    if (!selectedDoctor) return showError('Select a doctor');
    if (!appointmentDate) return showError('Select date and time');
    if (!phoneSearch) return showError('Enter patient phone number');

    try {
      const api = await import('../src/api');
      let patientId = foundPatient?.id;

      // If new patient, create patient first
      if (isNewPatient || !patientId) {
        if (!patientForm.first_name || !patientForm.last_name || !patientForm.dob) {
          return showError('Please fill in patient name and date of birth');
        }
        const newPatient = await api.createPatient(patientForm);
        patientId = newPatient.id;
        showSuccess('New patient created successfully');
      }

      // Create appointment
      const payload = {
        patient: patientId,
        doctor: parseInt(selectedDoctor),
        visit_date: appointmentDate,
        note: reason || 'Booked from receptionist'
      };
      await api.createAppointment(payload);
      showSuccess('Appointment created successfully');

      // Refresh appointments and reset form
      const appts = await api.fetchAppointments();
      setAppointments(appts.results || appts);
      setPhoneSearch('');
      setFoundPatient(null);
      setIsNewPatient(false);
      setPatientForm({
        first_name: '',
        last_name: '',
        dob: '',
        gender: 'Male',
        biological_sex: 'Male',
        phone: '',
        email: '',
        blood_type: '',
        allergies: '',
        chronic_conditions: ''
      });
      setReason('');
      setAppointmentDate('');
    } catch (err: any) {
      showError('Create failed: ' + err.message);
    }
  }

  // Filter appointments for today
  const todayAppointments = appointments.filter(appt => {
    const apptDate = new Date(appt.visit_date);
    const today = new Date();
    return apptDate.toDateString() === today.toDateString();
  });

  // Filter by search term
  const filteredAppointments = todayAppointments.filter(appt => {
    if (!patientSearch) return true;
    const patient = appt.patient;
    if (!patient) return false;
    const name = `${patient.first_name || ''} ${patient.last_name || ''}`.toLowerCase();
    return name.includes(patientSearch.toLowerCase());
  });

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h2 className="text-2xl font-bold text-slate-800">
            {isReceptionist ? 'Book Appointment' : 'Consultation Room'}
          </h2>
          <p className="text-slate-500 text-sm">
            {isReceptionist ? 'Schedule new visits for patients' : 'Record diagnosis and prescriptions'}
          </p>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Left Column: For Doctor role only - Patient Queue */}
        {!isReceptionist && (
          <div className="lg:col-span-1 bg-white rounded-xl shadow-sm border border-slate-200 p-4 h-fit">
            <h3 className="font-bold text-slate-800 mb-4 flex items-center gap-2">
              <User className="w-5 h-5 text-blue-600" />
              Today's Appointments
            </h3>

            <div className="relative mb-4">
              <Search className="absolute left-3 top-3 w-4 h-4 text-slate-400" />
              <input
                type="text"
                placeholder="Search patient..."
                value={patientSearch}
                onChange={(e) => setPatientSearch(e.target.value)}
                className="w-full pl-9 pr-3 py-2 bg-slate-50 border border-slate-200 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none"
              />
            </div>

            <div className="space-y-2">
              {filteredAppointments.length > 0 ? (
                filteredAppointments.map((appt:any, i:number) => {
                  const patient = appt.patient;
                  const patientName = patient?.first_name
                    ? `${patient.first_name} ${patient.last_name || ''}`
                    : `Patient #${patient}`;

                  // Format appointment time
                  let displayTime = 'No time';
                  try {
                    const date = new Date(appt.visit_date);
                    displayTime = date.toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit', hour12: true });
                  } catch {
                    displayTime = 'Invalid time';
                  }

                  return (
                    <button
                      key={appt.id || i}
                      onClick={() => setSelectedPatient(patient?.id || patient || null)}
                      className={`w-full text-left p-3 rounded-lg text-sm transition-colors border ${
                        selectedPatient === (patient?.id || patient)
                          ? 'bg-blue-50 border-blue-200 text-blue-700'
                          : 'bg-white border-transparent hover:bg-slate-50 text-slate-600'
                      }`}
                    >
                      <div className="font-medium">{patientName}</div>
                      <div className="text-xs opacity-70 flex justify-between mt-1">
                        <span>ID: {patient?.id || patient}</span>
                        <span>{displayTime}</span>
                      </div>
                    </button>
                  );
                })
              ) : (
                <div className="text-center py-8 text-slate-400">
                  <p className="text-sm">No appointments today</p>
                </div>
              )}
            </div>
          </div>
        )}

        {/* Right Column: Interaction Area */}
        <div className={`${isReceptionist ? 'lg:col-span-3' : 'lg:col-span-2'} bg-white rounded-xl shadow-sm border border-slate-200 p-6`}>
          {isReceptionist ? (
            /* Receptionist View: Booking Form with Patient Search */
            <form onSubmit={handleBook} className="space-y-6">
              <h3 className="text-lg font-bold text-slate-800 pb-2 border-b border-slate-100">Book New Appointment</h3>

              {/* Step 1: Search Patient by Phone */}
              <div className="bg-blue-50 p-4 rounded-lg border border-blue-100">
                <label className="block text-xs font-bold text-slate-700 mb-2 uppercase">Step 1: Search Patient</label>
                <div className="flex gap-2">
                  <input
                    type="text"
                    placeholder="Enter phone number..."
                    value={phoneSearch}
                    onChange={(e) => setPhoneSearch(e.target.value)}
                    className="flex-1 p-2.5 bg-white border border-slate-200 rounded-lg text-sm"
                  />
                  <button
                    type="button"
                    onClick={handleSearchPatient}
                    className="bg-blue-600 text-white px-6 py-2 rounded-lg text-sm font-bold hover:bg-blue-700 transition-colors flex items-center gap-2"
                  >
                    <Search className="w-4 h-4" />
                    Search
                  </button>
                </div>
              </div>

              {/* Step 2: Patient Information (auto-filled or manual entry) */}
              {(foundPatient || isNewPatient) && (
                <div className="space-y-4">
                  <div className="flex items-center justify-between pb-2 border-b border-slate-100">
                    <label className="block text-xs font-bold text-slate-700 uppercase">
                      Step 2: Patient Information {foundPatient && <span className="text-green-600">(Found in Database)</span>}
                      {isNewPatient && <span className="text-orange-600">(New Patient)</span>}
                    </label>
                  </div>

                  {/* Show medical history if patient found */}
                  {foundPatient && (
                    <div className="bg-green-50 p-4 rounded-lg border border-green-100">
                      <div className="grid grid-cols-3 gap-x-6 gap-y-3 text-sm">
                        <div>
                          <span className="font-bold text-green-800">Patient ID:</span> {foundPatient.id}
                        </div>
                        <div>
                          <span className="font-bold text-green-800">Blood Type:</span> {foundPatient.blood_type || 'N/A'}
                        </div>
                        <div>
                          <span className="font-bold text-green-800">Last Visit:</span> {foundPatient.last_visit_date ? new Date(foundPatient.last_visit_date).toLocaleDateString() : 'First visit'}
                        </div>
                        <div className="col-span-3 flex gap-8">
                          <div className="flex-1">
                            <span className="font-bold text-green-800">Allergies: </span>
                            {foundPatient.allergies && foundPatient.allergies.length > 0 ? (
                              <span className="text-red-600">{foundPatient.allergies.join(', ')}</span>
                            ) : <span className="text-slate-500">None</span>}
                          </div>
                          <div className="flex-1">
                            <span className="font-bold text-green-800">Chronic Conditions: </span>
                            {foundPatient.chronic_conditions && foundPatient.chronic_conditions.length > 0 ? (
                              <span className="text-orange-600">{foundPatient.chronic_conditions.join(', ')}</span>
                            ) : <span className="text-slate-500">None</span>}
                          </div>
                        </div>
                      </div>
                    </div>
                  )}

                  {/* Patient form - editable for new patients, read-only for existing */}
                  <div className="grid grid-cols-2 gap-4">
                    <div>
                      <label className="block text-xs font-bold text-slate-700 mb-1">First Name *</label>
                      <input
                        type="text"
                        value={patientForm.first_name}
                        onChange={(e) => setPatientForm(prev => ({ ...prev, first_name: e.target.value }))}
                        disabled={!!foundPatient}
                        className="w-full p-2.5 bg-slate-50 border border-slate-200 rounded-lg text-sm disabled:opacity-60"
                        required={isNewPatient}
                      />
                    </div>
                    <div>
                      <label className="block text-xs font-bold text-slate-700 mb-1">Last Name *</label>
                      <input
                        type="text"
                        value={patientForm.last_name}
                        onChange={(e) => setPatientForm(prev => ({ ...prev, last_name: e.target.value }))}
                        disabled={!!foundPatient}
                        className="w-full p-2.5 bg-slate-50 border border-slate-200 rounded-lg text-sm disabled:opacity-60"
                        required={isNewPatient}
                      />
                    </div>
                    <div>
                      <label className="block text-xs font-bold text-slate-700 mb-1">Date of Birth *</label>
                      <input
                        type="date"
                        value={patientForm.dob}
                        onChange={(e) => setPatientForm(prev => ({ ...prev, dob: e.target.value }))}
                        disabled={!!foundPatient}
                        className="w-full p-2.5 bg-slate-50 border border-slate-200 rounded-lg text-sm disabled:opacity-60"
                        required={isNewPatient}
                      />
                    </div>
                    <div>
                      <label className="block text-xs font-bold text-slate-700 mb-1">Gender</label>
                      <select
                        value={patientForm.gender}
                        onChange={(e) => setPatientForm(prev => ({ ...prev, gender: e.target.value }))}
                        disabled={!!foundPatient}
                        className="w-full p-2.5 bg-slate-50 border border-slate-200 rounded-lg text-sm disabled:opacity-60"
                      >
                        <option>Male</option>
                        <option>Female</option>
                        <option>Other</option>
                      </select>
                    </div>
                    <div>
                      <label className="block text-xs font-bold text-slate-700 mb-1">Phone</label>
                      <input
                        type="text"
                        value={patientForm.phone}
                        onChange={(e) => setPatientForm(prev => ({ ...prev, phone: e.target.value }))}
                        disabled={!!foundPatient}
                        className="w-full p-2.5 bg-slate-50 border border-slate-200 rounded-lg text-sm disabled:opacity-60"
                      />
                    </div>
                    <div>
                      <label className="block text-xs font-bold text-slate-700 mb-1">Email</label>
                      <input
                        type="email"
                        value={patientForm.email}
                        onChange={(e) => setPatientForm(prev => ({ ...prev, email: e.target.value }))}
                        disabled={!!foundPatient}
                        className="w-full p-2.5 bg-slate-50 border border-slate-200 rounded-lg text-sm disabled:opacity-60"
                      />
                    </div>
                  </div>
                </div>
              )}

              {/* Step 3: Appointment Details */}
              {(foundPatient || isNewPatient) && (
                <div className="space-y-4">
                  <label className="block text-xs font-bold text-slate-700 pb-2 border-b border-slate-100 uppercase">Step 3: Appointment Details</label>
                  <div className="grid grid-cols-2 gap-4">
                    <div>
                      <label className="block text-xs font-bold text-slate-700 mb-1">Assign Doctor *</label>
                      <select
                        className="w-full p-2.5 bg-slate-50 border border-slate-200 rounded-lg text-sm"
                        value={selectedDoctor}
                        onChange={(e) => setSelectedDoctor(e.target.value)}
                        required
                      >
                        {doctors.map((d:any) => (
                          <option key={d.id} value={d.id}>
                            {`Dr. ${d.first_name} ${d.last_name || ''}${d.department?.department_name ? ` (${d.department.department_name})` : ''}`}
                          </option>
                        ))}
                      </select>
                    </div>
                    <div>
                      <label className="block text-xs font-bold text-slate-700 mb-1">Date & Time *</label>
                      <input
                        type="datetime-local"
                        value={appointmentDate}
                        onChange={(e) => setAppointmentDate(e.target.value)}
                        min={new Date().toISOString().slice(0, 16)}
                        className="w-full p-2.5 bg-slate-50 border border-slate-200 rounded-lg text-sm"
                        required
                      />
                    </div>
                  </div>
                  <div>
                    <label className="block text-xs font-bold text-slate-700 mb-1">Reason for Visit</label>
                    <textarea
                      className="w-full p-3 bg-slate-50 border border-slate-200 rounded-lg text-sm h-24 resize-none"
                      placeholder="Enter patient complaints or reason for visit..."
                      value={reason}
                      onChange={(e) => setReason(e.target.value)}
                    ></textarea>
                  </div>
                  <div className="pt-2">
                    <button
                      type="submit"
                      disabled={loading}
                      className="bg-blue-600 text-white px-8 py-3 rounded-lg text-sm font-bold hover:bg-blue-700 transition-colors w-full disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                      {loading ? 'Processing...' : 'Confirm Appointment'}
                    </button>
                  </div>
                </div>
              )}
            </form>
          ) : (
            /* Doctor View */
            !selectedPatient ? (
              <div className="h-64 flex flex-col items-center justify-center text-slate-400">
                <User className="w-12 h-12 mb-2 opacity-20" />
                <p>Select a patient to begin</p>
              </div>
            ) : (
              <div className="space-y-6">
                <div className="flex justify-between items-center pb-4 border-b border-slate-100">
                  <div>
                    <h3 className="text-lg font-bold text-slate-800">Patient ID: {selectedPatient}</h3>
                    <p className="text-sm text-slate-500">Consultation Session</p>
                  </div>
                  <span className="bg-green-100 text-green-700 px-3 py-1 rounded-full text-xs font-bold">
                    Active
                  </span>
                </div>

                <div className="space-y-5">
                  <div>
                    <label className="block text-xs font-bold text-slate-700 mb-1 uppercase">Clinical Diagnosis</label>
                    <input
                      type="text"
                      value={diagnosis}
                      onChange={(e) => setDiagnosis(e.target.value)}
                      className="w-full p-3 bg-slate-50 border border-slate-200 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none transition-all"
                      placeholder="e.g. Acute Viral Bronchitis"
                    />
                  </div>

                  <div>
                    <label className="block text-xs font-bold text-slate-700 mb-1 uppercase">Doctor's Notes</label>
                    <textarea
                      value={notes}
                      onChange={(e) => setNotes(e.target.value)}
                      className="w-full p-3 bg-slate-50 border border-slate-200 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none h-32 resize-none"
                      placeholder="Patient observations, vitals, and recommendations..."
                    ></textarea>
                  </div>

                  <div className="bg-blue-50 p-4 rounded-lg border border-blue-100">
                    <label className="block text-xs font-bold text-blue-800 mb-2 uppercase flex items-center gap-2">
                      <FileText className="w-4 h-4" /> e-Prescription
                    </label>
                    <div className="flex gap-2 mb-3">
                      <div className="flex-1 relative">
                        <input
                          type="text"
                          value={medicationSearch}
                          onChange={(e) => handleMedicineSearch(e.target.value)}
                          onFocus={() => {
                            if (medicationSearch.trim()) {
                              // Show filtered medicines if already searching
                              setShowMedicineDropdown(true);
                            } else {
                              // Show all medicines when clicked without search
                              setFilteredMedicines(medicineList);
                              setShowMedicineDropdown(true);
                            }
                          }}
                          placeholder="Search medication (e.g. Amoxicillin)..."
                          className="w-full p-2 text-sm border border-blue-200 rounded-md focus:outline-none focus:border-blue-500"
                        />
                        {showMedicineDropdown && filteredMedicines.length > 0 && (
                          <div className="absolute z-10 w-full mt-1 bg-white border border-slate-200 rounded-md shadow-lg max-h-60 overflow-y-auto">
                            {filteredMedicines.map((med: any) => (
                              <button
                                key={med.id}
                                type="button"
                                onClick={() => handleSelectMedicine(med)}
                                className="w-full text-left px-3 py-2 hover:bg-blue-50 text-sm border-b border-slate-100 last:border-0"
                              >
                                <div className="font-medium text-slate-800">{med.medicine_name}</div>
                                {med.producer && <div className="text-xs text-slate-500">{med.producer}</div>}
                              </button>
                            ))}
                          </div>
                        )}
                      </div>
                      <input
                        value={medicationQty}
                        onChange={(e) => setMedicationQty(Math.max(1, parseInt(e.target.value) || 1))}
                        type="number"
                        min={1}
                        placeholder="Qty"
                        className="w-24 p-2 text-sm border border-blue-200 rounded-md"
                      />
                      <button onClick={async () => {
                        if (!medicationSearch) return showError('Enter medication name');
                        if (!medicationQty || medicationQty < 1) return showError('Enter valid quantity');

                        const found = medicineList.find((m:any) => m.medicine_name.toLowerCase() === medicationSearch.toLowerCase());
                        if (!found) return showWarning('Medicine not found');

                        setMedications(prev => [...prev, { medicineId: found.id, amount: medicationQty, name: found.medicine_name }]);
                        setMedicationQty(1);
                        setMedicationSearch('');
                        setShowMedicineDropdown(false);
                      }} type="button" className="bg-blue-600 text-white px-3 py-2 rounded-md text-sm font-medium hover:bg-blue-700">Add</button>
                    </div>
                    <div className="space-y-2">
                      {medications.map((m, idx) => (
                        <div key={idx} className="flex justify-between items-center bg-white p-2 rounded border border-blue-100 text-sm">
                          <span>{m.name} × {m.amount}</span>
                          <button onClick={() => setMedications(prev => prev.filter((_,i) => i !== idx))} className="text-red-600 text-xs">Remove</button>
                        </div>
                      ))}
                    </div>

                    <div className="flex justify-end gap-3 pt-4">
                      <button onClick={async () => {
                        if (!selectedPatient) return showError('Select patient first');
                        try {
                          const api = await import('../src/api');
                          const appt = await api.createAppointment({ patient: selectedPatient, doctor: doctors[0]?.id, visit_date: new Date().toISOString().slice(0,10), note: notes, diagnosis: diagnosis });
                          for (const med of medications) {
                            await api.createPrescription({ appointment_id: appt.id, visit_date: appt.visit_date, medicine: med.medicineId, amount: med.amount });
                          }
                          showSuccess('Consultation finalized');
                          setMedications([]);
                          setDiagnosis('');
                          setNotes('');
                        } catch (err:any) { showError('Error: ' + err.message); }
                      }} className="bg-blue-600 text-white px-6 py-2 rounded-lg text-sm font-bold hover:bg-blue-700 transition-colors flex items-center gap-2">
                        <CheckCircle className="w-4 h-4" /> Finalize Consultation
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            )
          )}
        </div>
      </div>
    </div>
  );
};

export default Appointments;