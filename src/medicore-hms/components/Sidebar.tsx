import React from 'react';
import { NavLink } from 'react-router-dom';
import { 
  LayoutDashboard, 
  Users, 
  Calendar, 
  Stethoscope, 
  Pill, 
  LogOut, 
  Activity 
} from 'lucide-react';
import { UserRole } from '../types';

interface SidebarProps {
  role: UserRole;
  onLogout: () => void;
}

const Sidebar: React.FC<SidebarProps> = ({ role, onLogout }) => {
  const linkClass = ({ isActive }: { isActive: boolean }) => 
    `flex items-center gap-3 px-4 py-3 text-sm font-medium rounded-lg transition-colors ${
      isActive 
        ? 'bg-blue-600 text-white shadow-md' 
        : 'text-slate-500 hover:bg-blue-50 hover:text-blue-600'
    }`;

  return (
    <aside className="w-64 bg-white border-r border-slate-200 flex flex-col h-screen sticky top-0">
      <div className="p-6 border-b border-slate-100 flex items-center gap-2">
        <div className="bg-blue-600 p-2 rounded-lg">
          <Activity className="text-white w-6 h-6" />
        </div>
        <div>
          <h1 className="text-xl font-bold text-slate-800 tracking-tight">MediCore</h1>
          <p className="text-xs text-slate-500 font-medium">Hospital System</p>
        </div>
      </div>

      <nav className="flex-1 p-4 space-y-1 overflow-y-auto">
        <NavLink to="/" className={linkClass}>
          <LayoutDashboard className="w-5 h-5" />
          Dashboard
        </NavLink>

        <NavLink to="/patients" className={linkClass}>
          <Users className="w-5 h-5" />
          Patient Directory
        </NavLink>

        <NavLink to="/appointments" className={linkClass}>
          <Calendar className="w-5 h-5" />
          Appointments
        </NavLink>

        <NavLink to="/staff" className={linkClass}>
          <Stethoscope className="w-5 h-5" />
          Staff & Departments
        </NavLink>

        <NavLink to="/inventory" className={linkClass}>
          <Pill className="w-5 h-5" />
          Pharmacy & Inventory
        </NavLink>
      </nav>

      <div className="p-4 border-t border-slate-100">
        <button 
          onClick={onLogout}
          className="flex items-center gap-3 px-4 py-3 w-full text-sm font-medium text-red-600 hover:bg-red-50 rounded-lg transition-colors"
        >
          <LogOut className="w-5 h-5" />
          Sign Out
        </button>
      </div>
    </aside>
  );
};

export default Sidebar;