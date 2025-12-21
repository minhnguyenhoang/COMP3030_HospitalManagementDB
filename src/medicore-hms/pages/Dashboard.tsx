import React from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Users,
  CalendarClock,
  Stethoscope,
  AlertTriangle,
  TrendingUp
} from 'lucide-react';
import { 
  BarChart, 
  Bar, 
  XAxis, 
  YAxis, 
  CartesianGrid, 
  Tooltip, 
  ResponsiveContainer,
  AreaChart,
  Area
} from 'recharts';

const Dashboard: React.FC = () => {
  const navigate = useNavigate();
  const [totalPatientsToday, setTotalPatientsToday] = React.useState<number | null>(null);
  const [pendingAppointments, setPendingAppointments] = React.useState<number | null>(null);
  const [doctorsOnDuty, setDoctorsOnDuty] = React.useState<number | null>(null);
  const [lowStockAlerts, setLowStockAlerts] = React.useState<number | null>(null);
  const [dataPatientTrend, setDataPatientTrend] = React.useState<any[]>([]);
  const [dataDiseases, setDataDiseases] = React.useState<any[]>([]);
  const [recentAppointments, setRecentAppointments] = React.useState<any[]>([]);
  const [loading, setLoading] = React.useState(false);

  React.useEffect(() => {
    let mounted = true;
    setLoading(true);
    import('../src/api').then(async (api) => {
      try {
        const metrics = await api.fetchMetrics();
        const appts = await api.fetchAppointments();
        if (!mounted) return;

        console.log('Dashboard metrics:', metrics);
        console.log('Appointments:', appts);

        setTotalPatientsToday(metrics.total_patients_today ?? 0);
        setPendingAppointments(metrics.pending_appointments ?? 0);
        setDoctorsOnDuty(metrics.doctors_on_duty ?? 0);
        setLowStockAlerts(metrics.low_stock_alerts ?? 0);
        setDataPatientTrend(metrics.weekly_patient_counts || []);
        setDataDiseases(metrics.top_conditions || []);

        const apptsList = appts.results || appts;
        const sorted = apptsList.sort((a:any,b:any) => (new Date(b.visit_date)).getTime() - (new Date(a.visit_date)).getTime());
        setRecentAppointments(sorted.slice(0,3));
        setLoading(false);
      } catch (err: any) {
        console.error('Failed to fetch dashboard metrics:', err);
        console.error('Error details:', err.message);
        setLoading(false);
      }
    });
    return () => { mounted = false; };
  }, []);


  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h2 className="text-2xl font-bold text-slate-800">Hospital Overview</h2>
        <p className="text-slate-500 text-sm">{new Date().toLocaleDateString('en-US', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' })}</p>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <div className="bg-white p-6 rounded-xl shadow-sm border border-slate-200">
          <div className="flex items-center justify-between mb-4">
            <div className="p-3 bg-blue-100 rounded-lg">
              <Users className="w-6 h-6 text-blue-600" />
            </div>
          </div>
          <h3 className="text-3xl font-bold text-slate-800">{totalPatientsToday ?? '—'}</h3>
          <p className="text-sm text-slate-500">Total Patients Today</p>
        </div>

        <div className="bg-white p-6 rounded-xl shadow-sm border border-slate-200">
          <div className="flex items-center justify-between mb-4">
            <div className="p-3 bg-indigo-100 rounded-lg">
              <CalendarClock className="w-6 h-6 text-indigo-600" />
            </div>
          </div>
          <h3 className="text-3xl font-bold text-slate-800">{pendingAppointments ?? '—'}</h3>
          <p className="text-sm text-slate-500">Pending Appointments</p>
        </div>

        <div className="bg-white p-6 rounded-xl shadow-sm border border-slate-200">
          <div className="flex items-center justify-between mb-4">
            <div className="p-3 bg-emerald-100 rounded-lg">
              <Stethoscope className="w-6 h-6 text-emerald-600" />
            </div>
          </div>
          <h3 className="text-3xl font-bold text-slate-800">{doctorsOnDuty ?? '—'}</h3>
          <p className="text-sm text-slate-500">Doctors on Duty</p>
        </div>

        <div className={`bg-white p-6 rounded-xl shadow-sm border border-slate-200 ${lowStockAlerts !== 0 ? "ring-2 ring-red-100" : ""}`}>
          <div className="flex items-center justify-between mb-4">
            <div className="p-3 bg-red-100 rounded-lg">
              <AlertTriangle className="w-6 h-6 text-red-600" />
            </div>
            {lowStockAlerts !== 0 && (<span className="text-xs font-bold text-red-600">Action Needed</span>)}
          </div>
          <h3 className="text-3xl font-bold text-slate-800">{lowStockAlerts ?? '—'}</h3>
          <p className="text-sm text-slate-500">Low Stock Alerts</p>
        </div>
      </div>

      {/* Charts Section */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2 bg-white p-6 rounded-xl shadow-sm border border-slate-200">
          <h3 className="text-lg font-bold text-slate-800 mb-4">Patient Trends (Weekly)</h3>
          <div className="h-64 w-full">
            {dataPatientTrend.length > 0 && dataPatientTrend.some((d: any) => d.patients > 0) ? (
              <ResponsiveContainer width="100%" height="100%">
                <AreaChart data={dataPatientTrend}>
                  <defs>
                    <linearGradient id="colorPatients" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="5%" stopColor="#3b82f6" stopOpacity={0.8}/>
                      <stop offset="95%" stopColor="#3b82f6" stopOpacity={0}/>
                    </linearGradient>
                  </defs>
                  <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#e2e8f0" />
                  <XAxis dataKey="name" axisLine={false} tickLine={false} tick={{fill: '#64748b'}} />
                  <YAxis axisLine={false} tickLine={false} tick={{fill: '#64748b'}} />
                  <Tooltip
                    contentStyle={{backgroundColor: '#fff', borderRadius: '8px', border: 'none', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)'}}
                  />
                  <Area type="monotone" dataKey="patients" stroke="#3b82f6" fillOpacity={1} fill="url(#colorPatients)" strokeWidth={2} />
                </AreaChart>
              </ResponsiveContainer>
            ) : (
              <div className="flex items-center justify-center h-full text-slate-400">
                <p className="text-sm">No patient visits recorded this week</p>
              </div>
            )}
          </div>
        </div>

        <div className="bg-white p-6 rounded-xl shadow-sm border border-slate-200">
          <h3 className="text-lg font-bold text-slate-800 mb-4">Common Conditions</h3>
          <div className="h-64 w-full">
            {dataDiseases.length > 0 ? (
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={dataDiseases} layout="vertical" margin={{ left: 0 }}>
                  <CartesianGrid strokeDasharray="3 3" horizontal={true} vertical={false} />
                  <XAxis type="number" hide />
                  <YAxis dataKey="name" type="category" width={100} tick={{fill: '#64748b', fontSize: 12}} />
                  <Tooltip cursor={{fill: 'transparent'}} />
                  <Bar dataKey="count" fill="#6366f1" radius={[0, 4, 4, 0]} barSize={20} />
                </BarChart>
              </ResponsiveContainer>
            ) : (
              <div className="flex items-center justify-center h-full text-slate-400">
                <p className="text-sm">No diagnosis data available</p>
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Recent Activity */}
      <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
        <div className="p-6 border-b border-slate-100 flex justify-between items-center">
          <h3 className="text-lg font-bold text-slate-800">Recent Appointments</h3>
          <button onClick={() => navigate('/appointments')} className="text-blue-600 text-sm font-medium hover:text-blue-700">View All</button>
        </div>
        <div className="overflow-x-auto">
          <table className="w-full text-left">
            <thead className="bg-slate-50 text-slate-500 text-xs uppercase font-semibold">
              <tr>
                <th className="px-6 py-4">Patient</th>
                <th className="px-6 py-4">Doctor</th>
                <th className="px-6 py-4">Time</th>
                <th className="px-6 py-4">Type</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {recentAppointments.length > 0 ? (
                recentAppointments.map((row:any, i:number) => (
                  <tr key={i} className="hover:bg-slate-50 transition-colors">
                    <td className="px-6 py-4 text-slate-800 font-medium">{row.patient?.first_name ? `${row.patient.first_name} ${row.patient.last_name || ''}` : `P-${row.patient}`}</td>
                    <td className="px-6 py-4 text-slate-600">{row.doctor?.first_name ? `Dr. ${row.doctor.first_name}` : `Dr.`}</td>
                    <td className="px-6 py-4 text-slate-600">{new Date(row.visit_date).toLocaleTimeString([], {hour: '2-digit', minute: '2-digit'})}</td>
                    <td className="px-6 py-4 text-slate-600">{row.category || 'Consultation'}</td>
                  </tr>
                ))
              ) : (
                <tr>
                  <td colSpan={5} className="px-6 py-12 text-center text-slate-400">
                    No recent appointments
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;