import React, { useState } from 'react';
import { HashRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { Toaster } from 'react-hot-toast';
import Sidebar from './components/Sidebar';
import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import Patients from './pages/Patients';
import PatientProfile from './pages/PatientProfile';
import Appointments from './pages/Appointments';
import StaffPage from './pages/Staff';
import Inventory from './pages/Inventory';
import { UserRole } from './types';
import { Bell } from 'lucide-react';

const App: React.FC = () => {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [role, setRole] = useState<UserRole>(UserRole.DOCTOR);
  const [showNotifications, setShowNotifications] = useState(false);
  const [notifications, setNotifications] = useState<any[]>([]);
  const [email, setEmail] = useState('');

  // Fetch notifications on login
  React.useEffect(() => {
    if (isAuthenticated) {
      import('./src/api').then(async (api) => {
        try {
          const metrics = await api.fetchMetrics();
          const lowStock = await api.fetchMedicineStock();

          // Create notifications from low stock items
          const stockList = lowStock.results || lowStock;
          const lowStockNotifs = stockList
            .filter((item: any) => item.current_stock <= 10)
            .map((item: any) => ({
              id: item.medicine_id,
              type: 'alert',
              title: 'Low Stock Alert',
              message: `${item.medicine_name} is low (${item.current_stock} ${item.medicine_unit} remaining)`,
              time: 'Now'
            }));

          setNotifications(lowStockNotifs);
        } catch (err) {
          console.error('Failed to fetch notifications:', err);
        }
      });
    }
  }, [isAuthenticated]);

  // Close notification dropdown when clicking outside
  React.useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      const target = event.target as HTMLElement;
      if (showNotifications && !target.closest('.notification-dropdown')) {
        setShowNotifications(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, [showNotifications]);

  const handleLogin = (selectedRole: UserRole, UserEmail) => {
    setRole(selectedRole);
    setIsAuthenticated(true);
    setEmail(UserEmail);
  };

  const handleLogout = async () => {
    // clear tokens and state
    try {
      const api = await import('./src/api');
      api.logout();
    } catch (e) {
      localStorage.removeItem('access_token');
      localStorage.removeItem('refresh_token');
    }
    setIsAuthenticated(false);
  };

  if (!isAuthenticated) {
    return <Login onLogin={handleLogin} />;
  }

  return (
    <>
      <Toaster />
      <Router>
        <div className="flex min-h-screen bg-slate-50">
          <Sidebar role={role} onLogout={handleLogout} />
        
        <div className="flex-1 flex flex-col">
          {/* Top Header */}
          <header className="bg-white border-b border-slate-200 h-16 px-8 flex items-center justify-between sticky top-0 z-10 shadow-sm">
            <div className="flex items-center gap-6 ml-auto">
              <div className="relative notification-dropdown">
                <button
                  onClick={() => setShowNotifications(!showNotifications)}
                  className="relative text-slate-500 hover:text-blue-600 transition-colors"
                >
                  <Bell className="w-5 h-5" />
                  {notifications.length > 0 && (
                    <span className="absolute -top-1 -right-1 w-2.5 h-2.5 bg-red-500 rounded-full border-2 border-white"></span>
                  )}
                </button>

                {/* Notification Dropdown */}
                {showNotifications && (
                  <div className="absolute right-0 mt-2 w-80 bg-white rounded-lg shadow-xl border border-slate-200 z-50">
                    <div className="p-4 border-b border-slate-100">
                      <h3 className="font-bold text-slate-800">Notifications</h3>
                      <p className="text-xs text-slate-500">{notifications.length} new alerts</p>
                    </div>
                    <div className="max-h-96 overflow-y-auto">
                      {notifications.length > 0 ? (
                        notifications.map((notif) => (
                          <div
                            key={notif.id}
                            className="p-4 border-b border-slate-50 hover:bg-slate-50 cursor-pointer transition-colors"
                          >
                            <div className="flex items-start gap-3">
                              <div className="w-8 h-8 bg-red-100 rounded-full flex items-center justify-center flex-shrink-0">
                                <Bell className="w-4 h-4 text-red-600" />
                              </div>
                              <div className="flex-1">
                                <p className="text-sm font-bold text-slate-800">{notif.title}</p>
                                <p className="text-xs text-slate-600 mt-1">{notif.message}</p>
                                <p className="text-xs text-slate-400 mt-1">{notif.time}</p>
                              </div>
                            </div>
                          </div>
                        ))
                      ) : (
                        <div className="p-8 text-center text-slate-400">
                          <Bell className="w-8 h-8 mx-auto mb-2 opacity-30" />
                          <p className="text-sm">No new notifications</p>
                        </div>
                      )}
                    </div>
                  </div>
                )}
              </div>
              
              <div className="flex items-center gap-3 pl-6 border-l border-slate-200">
                <div className="text-right hidden sm:block">
                  <p className="text-sm font-bold text-slate-800">{email}</p>
                  <p className="text-xs text-slate-500 font-medium">{role}</p>
                </div>
                <div className="w-9 h-9 bg-blue-600 rounded-full flex items-center justify-center text-white font-bold text-sm shadow-md ring-2 ring-blue-100">
                  DS
                </div>
              </div>
            </div>
          </header>

          {/* Main Content Area */}
          <main className="p-8 flex-1 overflow-x-hidden">
            <Routes>
              <Route path="/" element={<Dashboard />} />
              <Route path="/patients" element={<Patients />} />
              <Route path="/patients/:id" element={<PatientProfile role={role} />} />
              <Route path="/appointments" element={<Appointments role={role} />} />
              <Route path="/staff" element={<StaffPage />} />
              <Route path="/inventory" element={<Inventory role={role} />} />
              <Route path="*" element={<Navigate to="/" />} />
            </Routes>
          </main>
        </div>
      </div>
    </Router>
    </>
  );
};

export default App;