import React from 'react';
import { Staff } from '../types';
import { Mail, Phone, MoreHorizontal } from 'lucide-react';
import { showSuccess, showError } from '../src/utils/toast';

const StaffPage: React.FC = () => {
  const [staff, setStaff] = React.useState<any[]>([]);
  const [loading, setLoading] = React.useState(false);
  const [showAdd, setShowAdd] = React.useState(false);
  const [showAddDept, setShowAddDept] = React.useState(false);
  const [departments, setDepartments] = React.useState<any[]>([]);
  const [levels, setLevels] = React.useState<any[]>([]);
  const [statuses, setStatuses] = React.useState<any[]>([]);
  const [form, setForm] = React.useState({
    first_name: '',
    last_name: '',
    expertise: '',
    department_id: '',
    doctor_level: '',
    active_status: '',
    dob: '',
    gender: '',
    national_id: ''
  });
  const [deptForm, setDeptForm] = React.useState({ department_name: '', description: '' });

  React.useEffect(() => {
    let mounted = true;
    setLoading(true);
    import('../src/api').then(async (api) => {
      try {
        const [docs, deps, lvls, stats] = await Promise.all([api.fetchDoctors(), api.fetchDepartments(), api.fetchDoctorLevels(), api.fetchDoctorStatuses()]);
        const list = docs.results || docs;
        if (!mounted) return;
        setStaff(list.map((d: any) => ({ id: d.id, name: `${d.first_name} ${d.last_name}`.trim(), role: d.doctor_level || 'Doctor', department: d.department?.department_name || '', status: d.active_status || 'Active', avatar: (d.first_name && d.last_name) ? d.first_name[0] + d.last_name[0] : d.first_name?.[0] || 'Dr' })));
        setDepartments(deps.results || deps);
        setLevels(lvls.results || lvls);
        setStatuses(stats.results || stats);
        setLoading(false);
      } catch (err) {
        console.error('Failed to fetch staff data:', err);
        setLoading(false);
      }
    });
    return () => { mounted = false; };
  }, []);

  const handleOpenAdd = () => setShowAdd(true);
  const handleCloseAdd = () => {
    setShowAdd(false);
    setForm({
      first_name: '',
      last_name: '',
      expertise: '',
      department_id: '',
      doctor_level: '',
      active_status: '',
      dob: '',
      gender: '',
      national_id: ''
    });
  };

  const handleOpenAddDept = () => setShowAddDept(true);
  const handleCloseAddDept = () => { setShowAddDept(false); setDeptForm({ department_name: '', description: '' }); };

  const handleCreateDept = async (ev: React.FormEvent) => {
    ev.preventDefault();

    if (!deptForm.department_name) {
      return showError('Department name is required');
    }

    setLoading(true);
    try {
      const api = await import('../src/api');
      await api.createDepartment(deptForm);
      // refresh departments
      const deps = await api.fetchDepartments();
      setDepartments(deps.results || deps);
      handleCloseAddDept();
      showSuccess('Department created successfully');
    } catch (err: any) {
      showError('Create department failed: ' + err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleCreate = async (ev: React.FormEvent) => {
    ev.preventDefault();

    // Validation
    if (!form.first_name || !form.last_name) {
      return showError('First name and last name are required');
    }
    if (!form.expertise) {
      return showError('Role/Expertise is required');
    }
    if (!form.department_id) {
      return showError('Please select a department');
    }
    if (!form.doctor_level) {
      return showError('Please select a doctor level');
    }
    if (!form.active_status) {
      return showError('Please select an active status');
    }
    if (!form.dob) {
      return showError('Date of birth is required');
    }
    if (!form.gender) {
      return showError('Gender is required');
    }
    if (!form.national_id) {
      return showError('National ID is required');
    }

    setLoading(true);
    try {
      const api = await import('../src/api');
      const payload = { ...form };
      await api.createDoctor(payload);
      // refresh
      const docs = await api.fetchDoctors();
      const list = docs.results || docs;
      setStaff(list.map((d: any) => ({ id: d.id, name: `${d.first_name} ${d.last_name}`.trim(), role: d.doctor_level || 'Doctor', department: d.department?.department_name || '', status: d.active_status || 'Active', avatar: (d.first_name && d.last_name) ? d.first_name[0] + d.last_name[0] : d.first_name?.[0] || 'Dr' })));
      handleCloseAdd();
      showSuccess('Staff member created successfully');
    } catch (err:any) {
      showError('Create doctor failed: ' + err.message);
    } finally {
      setLoading(false);
    }
  }
  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h2 className="text-2xl font-bold text-slate-800">Staff Management</h2>
          <p className="text-slate-500 text-sm">Doctors, Nurses, and Support Staff</p>
        </div>
        <div className="flex gap-2">
          <button onClick={handleOpenAddDept} className="bg-slate-600 hover:bg-slate-700 text-white px-4 py-2 rounded-lg text-sm font-medium shadow-sm">
            Add Department
          </button>
          <button onClick={handleOpenAdd} className="bg-slate-800 hover:bg-slate-900 text-white px-4 py-2 rounded-lg text-sm font-medium shadow-sm">
            Add Employee
          </button>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
        {staff.map((person) => (
          <div key={person.id} className="bg-white rounded-xl shadow-sm border border-slate-200 p-6 flex flex-col items-center text-center relative hover:shadow-md transition-shadow">
            <button className="absolute top-4 right-4 text-slate-400 hover:text-slate-600">
              <MoreHorizontal className="w-5 h-5" />
            </button>
            
            <div className="w-20 h-20 rounded-full bg-slate-100 text-slate-600 flex items-center justify-center text-xl font-bold mb-4 border border-slate-200">
              {person.avatar}
            </div>
            
            <h3 className="text-lg font-bold text-slate-800">{person.name}</h3>
            <p className="text-blue-600 text-sm font-medium mb-1">{person.role}</p>
            <p className="text-slate-400 text-xs mb-4">{person.department}</p>
            
            <div className={`px-3 py-1 rounded-full text-xs font-bold mb-6
              ${person.status === 'Active' ? 'bg-green-100 text-green-700' : 
                person.status === 'On Leave' ? 'bg-yellow-100 text-yellow-700' : 'bg-slate-100 text-slate-600'}`}>
              {person.status}
            </div>

            <div className="flex gap-2 w-full mt-auto">
              <button className="flex-1 flex items-center justify-center gap-2 py-2 border border-slate-200 rounded-lg text-slate-600 hover:bg-slate-50 text-sm transition-colors">
                <Mail className="w-4 h-4" /> Message
              </button>
              <button className="flex-1 flex items-center justify-center gap-2 py-2 border border-slate-200 rounded-lg text-slate-600 hover:bg-slate-50 text-sm transition-colors">
                <Phone className="w-4 h-4" /> Call
              </button>
            </div>
          </div>
        ))}
      </div>

      {showAdd && (
        <div className="fixed inset-0 bg-black/40 flex items-center justify-center z-50 overflow-y-auto">
          <form onSubmit={handleCreate} className="bg-white p-6 rounded-xl w-full max-w-md my-8">
            <h3 className="text-lg font-bold mb-4">Add New Staff</h3>
            <div className="grid grid-cols-1 gap-3 max-h-[70vh] overflow-y-auto px-1">
              <div className="grid grid-cols-2 gap-3">
                <input value={form.first_name} onChange={(e)=>setForm({...form, first_name: e.target.value})} placeholder="First name *" className="p-2 border rounded" required />
                <input value={form.last_name} onChange={(e)=>setForm({...form, last_name: e.target.value})} placeholder="Last name *" className="p-2 border rounded" required />
              </div>
              <input value={form.national_id} onChange={(e)=>setForm({...form, national_id: e.target.value})} placeholder="National ID *" className="p-2 border rounded" required />
              <div className="grid grid-cols-2 gap-3">
                <input type="date" value={form.dob} onChange={(e)=>setForm({...form, dob: e.target.value})} placeholder="Date of Birth *" className="p-2 border rounded" required />
                <select value={form.gender} onChange={(e)=>setForm({...form, gender: e.target.value})} className="p-2 border rounded" required>
                  <option value="">Gender *</option>
                  <option value="Male">Male</option>
                  <option value="Female">Female</option>
                  <option value="Other">Other</option>
                </select>
              </div>
              <input value={form.expertise} onChange={(e)=>setForm({...form, expertise: e.target.value})} placeholder="Role / Expertise *" className="p-2 border rounded" required />
              <select value={form.department_id} onChange={(e)=>setForm({...form, department_id: e.target.value})} className="p-2 border rounded" required>
                <option value="">Select Department *</option>
                {departments.map((d:any)=> <option key={d.id} value={d.id}>{d.department_name}</option>)}
              </select>
              <div className="grid grid-cols-2 gap-3">
                <select value={form.doctor_level} onChange={(e)=>setForm({...form, doctor_level: e.target.value})} className="p-2 border rounded" required>
                  <option value="">Level *</option>
                  {levels.map((l:any)=> <option key={l.id} value={l.id}>{l.title}</option>)}
                </select>
                <select value={form.active_status} onChange={(e)=>setForm({...form, active_status: e.target.value})} className="p-2 border rounded" required>
                  <option value="">Status *</option>
                  {statuses.map((s:any)=> <option key={s.id} value={s.id}>{s.status_name}</option>)}
                </select>
              </div>

              <div className="flex justify-end gap-2 mt-4">
                <button type="button" onClick={handleCloseAdd} className="px-4 py-2 rounded border">Cancel</button>
                <button type="submit" disabled={loading} className="px-4 py-2 rounded bg-blue-600 text-white disabled:opacity-50">{loading ? 'Creating...' : 'Create'}</button>
              </div>
            </div>
          </form>
        </div>
      )}

      {showAddDept && (
        <div className="fixed inset-0 bg-black/40 flex items-center justify-center z-50">
          <form onSubmit={handleCreateDept} className="bg-white p-6 rounded-xl w-full max-w-md">
            <h3 className="text-lg font-bold mb-4">Add New Department</h3>
            <div className="grid grid-cols-1 gap-3">
              <input value={deptForm.department_name} onChange={(e)=>setDeptForm({...deptForm, department_name: e.target.value})} placeholder="Department Name *" className="p-2 border rounded" required />
              <textarea value={deptForm.description} onChange={(e)=>setDeptForm({...deptForm, description: e.target.value})} placeholder="Description (optional)" className="p-2 border rounded h-24 resize-none" />

              <div className="flex justify-end gap-2 mt-4">
                <button type="button" onClick={handleCloseAddDept} className="px-4 py-2 rounded border" disabled={loading}>Cancel</button>
                <button type="submit" disabled={loading} className="px-4 py-2 rounded bg-blue-600 text-white disabled:opacity-50">{loading ? 'Creating...' : 'Create'}</button>
              </div>
            </div>
          </form>
        </div>
      )}
    </div>
  );
};

export default StaffPage;