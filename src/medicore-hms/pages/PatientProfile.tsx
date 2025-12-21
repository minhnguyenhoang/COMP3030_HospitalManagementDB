import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Patient, MedicalRecord, Prescription } from '../types';
import {
  User,
  Calendar,
  AlertCircle,
  FileText,
  Activity,
  Pill,
  Clock,
  Sparkles,
  ArrowLeft
} from 'lucide-react';
import { summarizePatientHistory } from '../services/geminiService';
import { showSuccess, showError, showWarning } from '../src/utils/toast';

function safePatient(p:any) {
  if (!p) return null;
  return {
    id: p.id || '',
    name: `${p.first_name || ''} ${p.last_name || ''}`.trim() || 'Unknown',
    dob: p.dob || '',
    gender: p.gender || '',
    phone: p.phone || '',
    address: p.personal_info?.address || '',
    bloodGroup: p.blood_type || '',
    lastVisit: p.last_visit_date || '',
    dnrStatus: p.dnr_status || false,
    allergies: p.allergies || [],
    chronicConditions: p.chronic_conditions || [],
  };
}

const PatientProfile: React.FC = () => {
  const { id } = useParams(); // In a real app, fetch by ID
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState<'info' | 'history' | 'prescriptions'>('info');
  const [aiSummary, setAiSummary] = useState<string | null>(null);
  const [loadingAi, setLoadingAi] = useState(false);

  const [patient, setPatient] = React.useState<any | null>(null);
  const [appointments, setAppointments] = React.useState<any[]>([]);
  const [prescriptions, setPrescriptions] = React.useState<any[]>([]);
  const [loading, setLoading] = React.useState(false);

  // prescription modal
  const [showPrescModal, setShowPrescModal] = useState(false);
  const [medicinesList, setMedicinesList] = useState<any[]>([]);
  const [prescForm, setPrescForm] = useState({ medicine: '', amount: 1 });
  const [prescLoading, setPrescLoading] = useState(false);

  const handleCreatePrescription = async (ev: React.FormEvent) => {
    ev.preventDefault();

    // Validation
    if (!prescForm.medicine) {
      return showError('Please select a medication');
    }
    if (!prescForm.amount || prescForm.amount <= 0) {
      return showError('Please enter a valid amount (greater than 0)');
    }

    setPrescLoading(true);
    try {
      const api = await import('../src/api');
      // pick newest appointment for this patient as reference
      const appt = appointments[0];
      if (!appt) {
        showWarning('No appointments found for this patient');
        return;
      }
      const payload = { appointment_id: appt.id, visit_date: appt.visit_date || new Date().toISOString().slice(0,10), medicine: prescForm.medicine, amount: prescForm.amount };
      await api.createPrescription(payload);
      const pres = await api.fetchPrescriptions();
      setPrescriptions((pres.results || pres).filter((pr:any) => appt && pr.appointment_id === appt.id));
      setShowPrescModal(false);
      setPrescForm({medicine:'', amount:1});
      showSuccess('Prescription created successfully');
    } catch (err:any) {
      showError('Create prescription failed: ' + err.message);
    } finally {
      setPrescLoading(false);
    }
  }
  React.useEffect(() => {
    let mounted = true;
    setLoading(true);
    import('../src/api').then(async (api) => {
      try {
        if (id) {
          const p = await api.fetchPatient(id);
          const appts = await api.fetchAppointments();
          const pres = await api.fetchPrescriptions?.();

          if (!mounted) return;
          setPatient(p);

          const apptList = (appts.results || appts).filter((a: any) => String(a.patient) === String(id));
          setAppointments(apptList);

          if (pres) {
            const presList = (pres.results || pres).filter((pr: any) => apptList.some((a: any) => a.id === pr.appointment_id));
            setPrescriptions(presList);
          }
        }
      } catch (err) {
        // ignore
      } finally { setLoading(false); }
    });

    return () => { mounted = false; };
  }, [id]);

  // Generate AI Summary
  const handleGenerateSummary = async () => {
    setLoadingAi(true);
    try {
      const patientData = safePatient(patient);
      if (!patientData) {
        setAiSummary("No patient data available.");
        setLoadingAi(false);
        return;
      }
      const records = appointments.map(a => ({ id: a.id, date: a.visit_date, doctorName: a.doctor?.first_name || 'Dr', diagnosis: a.diagnosis || '', notes: a.note || '', type: 'Consultation' }));
      const summary = await summarizePatientHistory(patientData, records);
      setAiSummary(summary);
    } catch (e) {
      setAiSummary("Failed to generate summary.");
    } finally {
      setLoadingAi(false);
    }
  };

  const displayPatient = safePatient(patient);

  if (!displayPatient) {
    return (
      <div className="space-y-6">
        <button
          onClick={() => navigate('/patients')}
          className="flex items-center text-slate-500 hover:text-blue-600 transition-colors text-sm"
        >
          <ArrowLeft className="w-4 h-4 mr-1" /> Back to Directory
        </button>
        <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-12 text-center text-slate-500">
          <User className="w-12 h-12 mx-auto mb-4 opacity-20" />
          <p>Patient not found or loading...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <button
        onClick={() => navigate('/patients')}
        className="flex items-center text-slate-500 hover:text-blue-600 transition-colors text-sm"
      >
        <ArrowLeft className="w-4 h-4 mr-1" /> Back to Directory
      </button>

      {/* Profile Header */}
      <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-6">
        <div className="flex flex-col md:flex-row gap-6 items-start">
          <div className="w-24 h-24 bg-blue-100 rounded-full flex items-center justify-center text-blue-600 text-3xl font-bold border-4 border-blue-50">
            {displayPatient.name.charAt(0) || '?'}
          </div>
          <div className="flex-1">
            <div className="flex justify-between items-start">
              <div>
                <h1 className="text-2xl font-bold text-slate-900">{displayPatient.name}</h1>
                <div className="flex items-center gap-3 text-slate-500 text-sm mt-1">
                  <span className="flex items-center gap-1"><User className="w-4 h-4" /> {displayPatient.dob ? new Date().getFullYear() - new Date(displayPatient.dob).getFullYear() : '?'} yrs, {displayPatient.gender}</span>
                  <span className="flex items-center gap-1"><Activity className="w-4 h-4" /> Blood: {displayPatient.bloodGroup}</span>
                </div>
              </div>
              <div className="flex flex-col items-end gap-2">
                 {displayPatient.dnrStatus && (
                  <span className="px-3 py-1 bg-red-100 text-red-700 text-xs font-bold rounded-full border border-red-200">
                    DNR - Do Not Resuscitate
                  </span>
                 )}
                 <button
                  onClick={handleGenerateSummary}
                  disabled={loadingAi}
                  className="flex items-center gap-2 bg-purple-100 text-purple-700 px-3 py-1.5 rounded-lg text-sm font-medium hover:bg-purple-200 transition-colors disabled:opacity-50"
                 >
                   <Sparkles className="w-4 h-4" />
                   {loadingAi ? 'Analyzing...' : 'AI Summary'}
                 </button>
              </div>
            </div>
            
            {/* AI Summary Box */}
            {aiSummary && (
              <div className="mt-4 p-4 bg-purple-50 border border-purple-100 rounded-lg text-sm text-slate-700 animate-in fade-in duration-500">
                <h4 className="font-semibold text-purple-800 mb-1 flex items-center gap-2">
                  <Sparkles className="w-3 h-3" /> AI Medical Summary
                </h4>
                <p>{aiSummary}</p>
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Tabs */}
      <div className="bg-white rounded-xl shadow-sm border border-slate-200 min-h-[500px]">
        <div className="border-b border-slate-200">
          <nav className="flex gap-6 px-6">
            {(['info', 'history', 'prescriptions'] as const).map((tab) => (
              <button
                key={tab}
                onClick={() => setActiveTab(tab)}
                className={`py-4 text-sm font-medium border-b-2 transition-colors capitalize ${
                  activeTab === tab 
                    ? 'border-blue-600 text-blue-600' 
                    : 'border-transparent text-slate-500 hover:text-slate-700'
                }`}
              >
                {tab === 'info' ? 'Personal Info' : tab === 'history' ? 'Medical History' : 'Prescriptions'}
              </button>
            ))}
          </nav>
        </div>

        <div className="p-6">
          {activeTab === 'info' && (
            <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
              <div className="space-y-4">
                <h3 className="text-lg font-bold text-slate-800 flex items-center gap-2">
                  <User className="w-5 h-5 text-blue-500" /> General Details
                </h3>
                <div className="grid grid-cols-2 gap-y-4 text-sm">
                  <div className="text-slate-500">Date of Birth</div>
                  <div className="font-medium">{displayPatient.dob}</div>
                  <div className="text-slate-500">Phone</div>
                  <div className="font-medium">{displayPatient.phone}</div>
                  <div className="text-slate-500">Address</div>
                  <div className="font-medium">{displayPatient.address}</div>
                </div>
              </div>

              <div className="space-y-4">
                <h3 className="text-lg font-bold text-slate-800 flex items-center gap-2">
                  <AlertCircle className="w-5 h-5 text-red-500" /> Alerts & Conditions
                </h3>
                <div>
                  <div className="text-sm text-slate-500 mb-2">Allergies</div>
                  <div className="flex flex-wrap gap-2">
                    {displayPatient.allergies.length > 0 ? displayPatient.allergies.map(a => (
                      <span key={a} className="px-3 py-1 bg-red-50 text-red-700 rounded-full text-xs font-medium border border-red-100">{a}</span>
                    )) : <span className="text-slate-400 text-sm">No allergies recorded</span>}
                  </div>
                </div>
                <div>
                  <div className="text-sm text-slate-500 mb-2">Chronic Conditions</div>
                  <div className="flex flex-wrap gap-2">
                    {displayPatient.chronicConditions.length > 0 ? displayPatient.chronicConditions.map(c => (
                      <span key={c} className="px-3 py-1 bg-amber-50 text-amber-700 rounded-full text-xs font-medium border border-amber-100">{c}</span>
                    )) : <span className="text-slate-400 text-sm">No chronic conditions recorded</span>}
                  </div>
                </div>
              </div>
            </div>
          )}

          {activeTab === 'history' && (
            <div className="relative border-l-2 border-slate-200 ml-3 space-y-8 pl-8 py-2">
              {appointments.length > 0 ? appointments.map((rec:any) => (
                <div key={rec.id} className="relative">
                  <span className="absolute -left-[41px] top-1 w-5 h-5 rounded-full bg-blue-600 border-4 border-white shadow-sm"></span>
                  <div className="bg-slate-50 p-4 rounded-lg border border-slate-100 hover:shadow-md transition-shadow">
                    <div className="flex justify-between items-start mb-2">
                      <h4 className="font-bold text-slate-800">{rec.diagnosis || 'Consultation'}</h4>
                      <span className="text-xs text-slate-500 font-mono">{rec.visit_date || rec.date}</span>
                    </div>
                    <p className="text-sm text-slate-600 mb-3">{rec.note || rec.notes}</p>
                    <div className="flex items-center gap-2 text-xs text-slate-500">
                      <StethoscopeIcon className="w-3 h-3" />
                      <span>{rec.doctor?.first_name ? `Dr. ${rec.doctor.first_name}` : 'Dr.'}</span>
                      <span className="w-1 h-1 rounded-full bg-slate-300"></span>
                      <span>{rec.type || 'Consultation'}</span>
                    </div>
                  </div>
                </div>
              )) : (
                <div className="text-center text-slate-400 py-8">
                  <FileText className="w-12 h-12 mx-auto mb-2 opacity-20" />
                  <p>No medical history records found</p>
                </div>
              )}
            </div>
          )}

          {activeTab === 'prescriptions' && (
            <div>
              <div className="flex justify-between items-center mb-3">
                <h4 className="text-sm text-slate-600">Prescriptions</h4>
                <div className="flex gap-2">
                  <button onClick={async ()=>{
                    // prepare modal data
                    setShowPrescModal(true);
                    const api = await import('../src/api');
                    const meds = await api.fetchMedicines();
                    setMedicinesList(meds.results || meds);
                  }} className="px-3 py-1 rounded bg-blue-600 text-white text-sm">New Prescription</button>
                </div>
              </div>
              <div className="overflow-x-auto">
                <table className="w-full text-left">
                  <thead className="bg-slate-50 text-slate-500 text-xs uppercase font-semibold">
                    <tr>
                      <th className="px-4 py-3">Medication</th>
                      <th className="px-4 py-3">Amount</th>
                      <th className="px-4 py-3">Prescribed By</th>
                      <th className="px-4 py-3">Date</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-100 text-sm">
                    {prescriptions.length > 0 ? prescriptions.map((p:any) => (
                      <tr key={p.id || `${p.medicine}-${p.appointment_id}`}>
                        <td className="px-4 py-3 font-medium text-blue-600 flex items-center gap-2">
                          <Pill className="w-4 h-4" /> {p.medicine?.medicine_name || p.medicine_name || p.medication || p.medicine}
                        </td>
                        <td className="px-4 py-3">{p.amount || p.dosage}</td>
                        <td className="px-4 py-3">{p.doctor?.first_name ? `Dr. ${p.doctor.first_name}` : p.doctorName || 'Dr.'}</td>
                        <td className="px-4 py-3 text-slate-500">{p.prescription_date || p.date || p.visit_date}</td>
                      </tr>
                    )) : (
                      <tr>
                        <td colSpan={4} className="px-4 py-8 text-center text-slate-400">
                          <Pill className="w-12 h-12 mx-auto mb-2 opacity-20" />
                          <p>No prescriptions found</p>
                        </td>
                      </tr>
                    )}
                  </tbody>
                </table>
              </div>

              {showPrescModal && (
                <div className="fixed inset-0 bg-black/40 flex items-center justify-center z-50">
                  <form onSubmit={handleCreatePrescription} className="bg-white p-6 rounded-xl w-full max-w-md">
                    <h3 className="text-lg font-bold mb-4">New Prescription</h3>
                    <select value={prescForm.medicine} onChange={(e)=>setPrescForm({...prescForm, medicine: e.target.value})} className="w-full p-2 border rounded mb-3" required>
                      <option value="">Select medication *</option>
                      {medicinesList.map((m:any)=> <option key={m.id} value={m.id}>{m.medicine_name}</option>)}
                    </select>
                    <input type="number" min={1} value={prescForm.amount || ''} onChange={(e)=>setPrescForm({...prescForm, amount: parseInt(e.target.value||'0',10)})} className="w-full p-2 border rounded mb-3" placeholder="Amount *" required />
                    <div className="flex justify-end gap-2 mt-4">
                      <button type="button" onClick={()=>setShowPrescModal(false)} className="px-4 py-2 rounded border" disabled={prescLoading}>Cancel</button>
                      <button type="submit" disabled={prescLoading} className="px-4 py-2 rounded bg-blue-600 text-white disabled:opacity-50">{prescLoading ? 'Creating...' : 'Create'}</button>
                    </div>
                  </form>
                </div>
              )}
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

// Helper component for icon to avoid repetitive imports
const StethoscopeIcon = ({ className }: { className: string }) => (
  <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className={className}><path d="M4.8 2.3A.3.3 0 1 0 5 2H4a2 2 0 0 0-2 2v5a6 6 0 0 0 6 6v0a6 6 0 0 0 6-6V4a2 2 0 0 0-2-2h-1a.2.2 0 1 0 .3.3"/><path d="M8 15v1a6 6 0 0 0 6 6v0a6 6 0 0 0 6-6v-4"/><circle cx="20" cy="10" r="2"/></svg>
);

export default PatientProfile;