import React, { useState } from 'react';
import { Search, Filter, Plus, ChevronRight, Eye, Pencil, Trash2 } from 'lucide-react';
import { Patient } from '../types';
import { useNavigate } from 'react-router-dom';
import { showSuccess, showError } from '../src/utils/toast';

const Patients: React.FC = () => {
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState('');
  const [filterGender, setFilterGender] = useState('All');
  const [patients, setPatients] = useState<Patient[]>([]);
  const [loading, setLoading] = useState(false);
  const [showAdd, setShowAdd] = useState(false);
  const [showEdit, setShowEdit] = useState(false);
  const [editingPatient, setEditingPatient] = useState<any>(null);
  const [form, setForm] = useState({
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

  React.useEffect(() => {
    let mounted = true;
    setLoading(true);
    import('../src/api').then(api => {
      api.fetchPatients().then((payload) => {
        if (!mounted) return;
        // payload is paginated by DRF: {results: [...]}
        const items = payload.results || payload;
        const normalized: Patient[] = items.map((p: any) => ({
          id: p.id.toString(),
          name: `${p.first_name} ${p.last_name}`,
          dob: p.dob,
          gender: p.gender,
          phone: p.phone || '',
          address: p.personal_info?.address || '',
          bloodGroup: p.blood_type || '',
          lastVisit: p.last_visit_date || '',
          dnrStatus: p.dnr_status || false,
          allergies: [],
          chronicConditions: [],
        }));
        setPatients(normalized);
        setLoading(false);
      }).catch((err) => {
        console.error('Failed to fetch patients:', err);
        setLoading(false);
      });
    });
    return () => { mounted = false; }
  }, []);

  const handleOpenAdd = () => setShowAdd(true);
  const handleCloseAdd = () => {
    setShowAdd(false);
    setForm({
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
  };

  const handleCreate = async (ev: React.FormEvent) => {
    ev.preventDefault();

    // Validation
    if (!form.first_name || !form.last_name) {
      return showError('First name and last name are required');
    }
    if (!form.dob) {
      return showError('Date of birth is required');
    }
    if (!form.phone) {
      return showError('Phone number is required');
    }
    if (form.phone && !/^\+?[\d\s-()]+$/.test(form.phone)) {
      return showError('Please enter a valid phone number');
    }
    if (form.email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.email)) {
      return showError('Please enter a valid email address');
    }

    setLoading(true);
    try {
      const api = await import('../src/api');
      const payload = { ...form, first_visit_date: form.dob, last_visit_date: form.dob };
      const res = await api.createPatient(payload);
      setPatients(prev => [{ id: res.id.toString(), name: `${res.first_name} ${res.last_name}`, dob: res.dob, gender: res.gender || '', phone: res.phone || '', address: '', bloodGroup: res.blood_type || '', lastVisit: res.last_visit_date || '', dnrStatus: res.dnr_status || false, allergies: [], chronicConditions: [] }, ...prev]);
      handleCloseAdd();
      showSuccess('Patient created successfully');
    } catch (err:any) {
      showError('Failed to create patient: ' + err.message);
    } finally {
      setLoading(false);
    }
  }

  const handleOpenEdit = (patient: any) => {
    setEditingPatient(patient);
    // Fetch full patient data
    import('../src/api').then(async (api) => {
      try {
        const fullData = await api.fetchPatient(patient.id);
        setForm({
          first_name: fullData.first_name || '',
          last_name: fullData.last_name || '',
          dob: fullData.dob || '',
          gender: fullData.gender || 'Male',
          biological_sex: fullData.biological_sex || 'Male',
          phone: fullData.phone || '',
          email: fullData.email || '',
          blood_type: fullData.blood_type || '',
          allergies: fullData.allergies || '',
          chronic_conditions: fullData.chronic_conditions || ''
        });
        setShowEdit(true);
      } catch (err: any) {
        showError('Failed to load patient data: ' + err.message);
      }
    });
  };

  const handleCloseEdit = () => {
    setShowEdit(false);
    setEditingPatient(null);
    setForm({
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
  };

  const handleUpdate = async (ev: React.FormEvent) => {
    ev.preventDefault();

    if (!editingPatient) return;

    // Validation
    if (!form.first_name || !form.last_name) {
      return showError('First name and last name are required');
    }
    if (!form.dob) {
      return showError('Date of birth is required');
    }
    if (!form.phone) {
      return showError('Phone number is required');
    }

    setLoading(true);
    try {
      const api = await import('../src/api');
      const payload = { ...form, first_visit_date: form.dob, last_visit_date: form.dob };
      const res = await api.updatePatient(editingPatient.id, payload);

      // Update local state
      setPatients(prev => prev.map(p =>
        p.id === editingPatient.id
          ? {
              ...p,
              name: `${res.first_name} ${res.last_name}`,
              dob: res.dob,
              gender: res.gender || '',
              phone: res.phone || '',
              bloodGroup: res.blood_type || ''
            }
          : p
      ));

      handleCloseEdit();
      showSuccess('Patient updated successfully');
    } catch (err: any) {
      showError('Failed to update patient: ' + err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (patientId: string) => {
    if (!confirm('Are you sure you want to delete this patient? This action cannot be undone.')) {
      return;
    }

    setLoading(true);
    try {
      const api = await import('../src/api');
      await api.deletePatient(patientId);
      setPatients(prev => prev.filter(p => p.id !== patientId));
      showSuccess('Patient deleted successfully');
    } catch (err: any) {
      showError('Failed to delete patient: ' + err.message);
    } finally {
      setLoading(false);
    }
  };

  const filteredPatients = patients.filter(p => {
    const matchesSearch = p.name.toLowerCase().includes(searchTerm.toLowerCase()) || 
                          p.id.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          p.phone.includes(searchTerm);
    const matchesFilter = filterGender === 'All' || p.gender === filterGender;
    return matchesSearch && matchesFilter;
  });

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h2 className="text-2xl font-bold text-slate-800">Patient Directory</h2>
          <p className="text-slate-500 text-sm">Manage and search patient records</p>
        </div>
        <div className="flex items-center gap-2">
          <button onClick={handleOpenAdd} className="flex items-center gap-2 bg-blue-600 hover:bg-blue-700 text-white px-4 py-2.5 rounded-lg shadow-md transition-all">
            <Plus className="w-4 h-4" />
            <span>Add New Patient</span>
          </button>
        </div>
      </div>

      {/* Add Patient Modal */}
      {showAdd && (
        <div className="fixed inset-0 bg-black/40 flex items-center justify-center z-50 p-4">
          <form onSubmit={handleCreate} className="bg-white p-6 rounded-xl w-full max-w-2xl max-h-[90vh] overflow-y-auto">
            <h3 className="text-lg font-bold mb-4">Add New Patient</h3>

            {/* Basic Information */}
            <div className="mb-4">
              <h4 className="text-sm font-semibold text-slate-700 mb-2">Basic Information</h4>
              <div className="grid grid-cols-2 gap-3">
                <input
                  value={form.first_name}
                  onChange={(e)=>setForm({...form, first_name: e.target.value})}
                  placeholder="First name *"
                  className="p-2 border rounded"
                  required
                />
                <input
                  value={form.last_name}
                  onChange={(e)=>setForm({...form, last_name: e.target.value})}
                  placeholder="Last name *"
                  className="p-2 border rounded"
                  required
                />
                <input
                  value={form.dob}
                  onChange={(e)=>setForm({...form, dob: e.target.value})}
                  type="date"
                  max={new Date().toISOString().split('T')[0]}
                  className="p-2 border rounded"
                  required
                />
                <select
                  value={form.gender}
                  onChange={(e)=>setForm({...form, gender: e.target.value, biological_sex: e.target.value})}
                  className="p-2 border rounded"
                  required
                >
                  <option value="Male">Male</option>
                  <option value="Female">Female</option>
                  <option value="Other">Other</option>
                </select>
              </div>
            </div>

            {/* Contact Information */}
            <div className="mb-4">
              <h4 className="text-sm font-semibold text-slate-700 mb-2">Contact Information</h4>
              <div className="grid grid-cols-2 gap-3">
                <input
                  value={form.phone}
                  onChange={(e)=>setForm({...form, phone: e.target.value})}
                  placeholder="Phone *"
                  className="p-2 border rounded"
                  required
                />
                <input
                  value={form.email}
                  onChange={(e)=>setForm({...form, email: e.target.value})}
                  placeholder="Email (optional)"
                  className="p-2 border rounded"
                />
              </div>
            </div>

            {/* Medical Information */}
            <div className="mb-4">
              <h4 className="text-sm font-semibold text-slate-700 mb-2">Medical Information</h4>
              <div className="grid grid-cols-2 gap-3">
                <select
                  value={form.blood_type}
                  onChange={(e)=>setForm({...form, blood_type: e.target.value})}
                  className="p-2 border rounded"
                >
                  <option value="">Blood Type (optional)</option>
                  <option value="A+">A+</option>
                  <option value="A-">A-</option>
                  <option value="B+">B+</option>
                  <option value="B-">B-</option>
                  <option value="AB+">AB+</option>
                  <option value="AB-">AB-</option>
                  <option value="O+">O+</option>
                  <option value="O-">O-</option>
                </select>
                <div></div>
                <textarea
                  value={form.allergies}
                  onChange={(e)=>setForm({...form, allergies: e.target.value})}
                  placeholder="Allergies (optional, comma-separated)"
                  className="p-2 border rounded col-span-2"
                  rows={2}
                />
                <textarea
                  value={form.chronic_conditions}
                  onChange={(e)=>setForm({...form, chronic_conditions: e.target.value})}
                  placeholder="Chronic Conditions (optional, comma-separated)"
                  className="p-2 border rounded col-span-2"
                  rows={2}
                />
              </div>
            </div>

            <div className="flex justify-end gap-2 mt-4">
              <button type="button" onClick={handleCloseAdd} className="px-4 py-2 rounded border">Cancel</button>
              <button type="submit" disabled={loading} className="px-4 py-2 rounded bg-blue-600 text-white disabled:opacity-50">{loading ? 'Creating...' : 'Create Patient'}</button>
            </div>
          </form>
        </div>
      )}

      {/* Edit Patient Modal */}
      {showEdit && editingPatient && (
        <div className="fixed inset-0 bg-black/40 flex items-center justify-center z-50 p-4">
          <form onSubmit={handleUpdate} className="bg-white p-6 rounded-xl w-full max-w-2xl max-h-[90vh] overflow-y-auto">
            <h3 className="text-lg font-bold mb-4">Edit Patient</h3>

            {/* Basic Information */}
            <div className="mb-4">
              <h4 className="text-sm font-semibold text-slate-700 mb-2">Basic Information</h4>
              <div className="grid grid-cols-2 gap-3">
                <input
                  value={form.first_name}
                  onChange={(e)=>setForm({...form, first_name: e.target.value})}
                  placeholder="First name *"
                  className="p-2 border rounded"
                  required
                />
                <input
                  value={form.last_name}
                  onChange={(e)=>setForm({...form, last_name: e.target.value})}
                  placeholder="Last name *"
                  className="p-2 border rounded"
                  required
                />
                <input
                  type="date"
                  value={form.dob}
                  onChange={(e)=>setForm({...form, dob: e.target.value})}
                  className="p-2 border rounded"
                  required
                />
                <select
                  value={form.gender}
                  onChange={(e)=>setForm({...form, gender: e.target.value})}
                  className="p-2 border rounded"
                >
                  <option value="Male">Male</option>
                  <option value="Female">Female</option>
                  <option value="Other">Other</option>
                </select>
                <select
                  value={form.biological_sex}
                  onChange={(e)=>setForm({...form, biological_sex: e.target.value})}
                  className="p-2 border rounded"
                >
                  <option value="Male">Biological Sex: Male</option>
                  <option value="Female">Biological Sex: Female</option>
                </select>
              </div>
            </div>

            {/* Contact Information */}
            <div className="mb-4">
              <h4 className="text-sm font-semibold text-slate-700 mb-2">Contact Information</h4>
              <div className="grid grid-cols-2 gap-3">
                <input
                  type="tel"
                  value={form.phone}
                  onChange={(e)=>setForm({...form, phone: e.target.value})}
                  placeholder="Phone *"
                  className="p-2 border rounded"
                  required
                />
                <input
                  type="email"
                  value={form.email}
                  onChange={(e)=>setForm({...form, email: e.target.value})}
                  placeholder="Email (optional)"
                  className="p-2 border rounded"
                />
              </div>
            </div>

            {/* Medical Information */}
            <div className="mb-4">
              <h4 className="text-sm font-semibold text-slate-700 mb-2">Medical Information</h4>
              <div className="grid grid-cols-2 gap-3">
                <select
                  value={form.blood_type}
                  onChange={(e)=>setForm({...form, blood_type: e.target.value})}
                  className="p-2 border rounded"
                >
                  <option value="">Blood Type (optional)</option>
                  <option value="A+">A+</option>
                  <option value="A-">A-</option>
                  <option value="B+">B+</option>
                  <option value="B-">B-</option>
                  <option value="AB+">AB+</option>
                  <option value="AB-">AB-</option>
                  <option value="O+">O+</option>
                  <option value="O-">O-</option>
                </select>
                <div></div>
                <textarea
                  value={form.allergies}
                  onChange={(e)=>setForm({...form, allergies: e.target.value})}
                  placeholder="Allergies (optional, comma-separated)"
                  className="p-2 border rounded col-span-2"
                  rows={2}
                />
                <textarea
                  value={form.chronic_conditions}
                  onChange={(e)=>setForm({...form, chronic_conditions: e.target.value})}
                  placeholder="Chronic Conditions (optional, comma-separated)"
                  className="p-2 border rounded col-span-2"
                  rows={2}
                />
              </div>
            </div>

            <div className="flex justify-end gap-2 mt-4">
              <button type="button" onClick={handleCloseEdit} className="px-4 py-2 rounded border">Cancel</button>
              <button type="submit" disabled={loading} className="px-4 py-2 rounded bg-blue-600 text-white disabled:opacity-50">{loading ? 'Updating...' : 'Update Patient'}</button>
            </div>
          </form>
        </div>
      )}

      <div className="bg-white p-4 rounded-xl shadow-sm border border-slate-200 flex flex-col md:flex-row gap-4">
        <div className="flex-1 relative">
          <Search className="absolute left-3 top-3 w-5 h-5 text-slate-400" />
          <input
            type="text"
            placeholder="Search by Name, ID, or Phone..."
            className="w-full pl-10 pr-4 py-2.5 bg-slate-50 border border-slate-200 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>
        <div className="flex gap-4">
          <div className="relative">
            <Filter className="absolute left-3 top-3 w-4 h-4 text-slate-400" />
            <select 
              className="pl-9 pr-8 py-2.5 bg-slate-50 border border-slate-200 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none appearance-none cursor-pointer"
              value={filterGender}
              onChange={(e) => setFilterGender(e.target.value)}
            >
              <option value="All">All Genders</option>
              <option value="Male">Male</option>
              <option value="Female">Female</option>
            </select>
          </div>
        </div>
      </div>

      <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left">
            <thead className="bg-slate-50 text-slate-500 text-xs uppercase font-semibold border-b border-slate-100">
              <tr>
                <th className="px-6 py-4">ID</th>
                <th className="px-6 py-4">Name</th>
                <th className="px-6 py-4">Age/Gender</th>
                <th className="px-6 py-4">Blood Group</th>
                <th className="px-6 py-4">Last Visit</th>
                <th className="px-6 py-4">Contact</th>
                <th className="px-6 py-4 text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {filteredPatients.map((patient) => {
                const age = new Date().getFullYear() - new Date(patient.dob).getFullYear();
                return (
                  <tr key={patient.id} className="hover:bg-slate-50 transition-colors group">
                    <td className="px-6 py-4 font-mono text-sm text-slate-500">{patient.id}</td>
                    <td className="px-6 py-4">
                      <div className="font-medium text-slate-900">{patient.name}</div>
                      {patient.dnrStatus && <span className="text-[10px] font-bold bg-red-100 text-red-600 px-1.5 py-0.5 rounded">DNR</span>}
                    </td>
                    <td className="px-6 py-4 text-slate-600">{age} yrs / {patient.gender}</td>
                    <td className="px-6 py-4">
                      <span className="bg-red-50 text-red-700 px-2 py-1 rounded-md text-xs font-bold border border-red-100">
                        {patient.bloodGroup}
                      </span>
                    </td>
                    <td className="px-6 py-4 text-slate-600 text-sm">{patient.lastVisit}</td>
                    <td className="px-6 py-4 text-slate-600 text-sm">{patient.phone}</td>
                    <td className="px-6 py-4 text-right">
                      <div className="flex items-center justify-end gap-2">
                        <button
                          onClick={() => navigate(`/patients/${patient.id}`)}
                          className="text-blue-600 hover:bg-blue-50 p-2 rounded-lg transition-colors"
                          title="View Profile"
                        >
                          <Eye className="w-4 h-4" />
                        </button>
                        <button
                          onClick={() => handleOpenEdit(patient)}
                          className="text-green-600 hover:bg-green-50 p-2 rounded-lg transition-colors"
                          title="Edit Patient"
                        >
                          <Pencil className="w-4 h-4" />
                        </button>
                        <button
                          onClick={() => handleDelete(patient.id)}
                          className="text-red-600 hover:bg-red-50 p-2 rounded-lg transition-colors"
                          title="Delete Patient"
                          disabled={loading}
                        >
                          <Trash2 className="w-4 h-4" />
                        </button>
                      </div>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
        {filteredPatients.length === 0 && (
          <div className="p-12 text-center text-slate-500">
            No patients found matching your search.
          </div>
        )}
      </div>
    </div>
  );
};

export default Patients;