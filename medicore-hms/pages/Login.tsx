import React, { useState } from 'react';
import { UserRole } from '../types';
import { Activity, Lock, Mail, ChevronDown } from 'lucide-react';

interface LoginProps {
  onLogin: (role: UserRole, UserEmail) => void;
}

const Login: React.FC<LoginProps> = ({ onLogin }) => {
  const [role, setRole] = useState<UserRole>(UserRole.DOCTOR);
  const [email, setEmail] = useState('admin');
  const [password, setPassword] = useState('admin123');
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      setError(null);
      setLoading(true);
      const api = await import('../src/api');
      await api.login(email, password);
      onLogin(role, email);
    } catch (err: any) {
      console.error('Login error', err);
      setError(err.message || 'Login failed — check network or backend CORS');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-slate-50 flex flex-col justify-center items-center p-4">
      <div className="mb-8 text-center">
        <div className="bg-blue-600 p-3 rounded-xl inline-block mb-4 shadow-lg shadow-blue-200">
          <Activity className="text-white w-10 h-10" />
        </div>
        <h1 className="text-3xl font-bold text-slate-900 tracking-tight">MediCore HMS</h1>
        <p className="text-slate-500 mt-2">Secure access for medical professionals</p>
      </div>

      <div className="bg-white p-8 rounded-2xl shadow-xl border border-slate-100 w-full max-w-md">
        <form onSubmit={handleSubmit} className="space-y-5">
          <div>
            <label className="block text-sm font-medium text-slate-700 mb-1">Select Role (Demo)</label>
            <div className="relative">
              <select 
                value={role}
                onChange={(e) => setRole(e.target.value as UserRole)}
                className="w-full pl-4 pr-10 py-3 bg-slate-50 border border-slate-200 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent appearance-none outline-none transition-all"
              >
                <option value={UserRole.ADMIN}>Administrator</option>
                <option value={UserRole.DOCTOR}>Doctor</option>
                <option value={UserRole.RECEPTIONIST}>Receptionist</option>
              </select>
              <ChevronDown className="absolute right-3 top-3.5 w-5 h-5 text-slate-400 pointer-events-none" />
            </div>
          </div>

          <div>
            <label className="block text-sm font-medium text-slate-700 mb-1">Email or Username</label>
            <div className="relative">
              <Mail className="absolute left-3 top-3.5 w-5 h-5 text-slate-400" />
              <input 
                type="text" 
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="w-full pl-10 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none transition-all"
                placeholder="doctor@hospital.com"
              />
            </div>
          </div>

          <div>
            <label className="block text-sm font-medium text-slate-700 mb-1">Password</label>
            <div className="relative">
              <Lock className="absolute left-3 top-3.5 w-5 h-5 text-slate-400" />
              <input 
                type="password" 
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="w-full pl-10 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none transition-all"
                placeholder="••••••••"
              />
            </div>
          </div>

          <div className="flex items-center justify-between text-sm">
            <label className="flex items-center text-slate-600 cursor-pointer">
              <input type="checkbox" className="mr-2 rounded text-blue-600 focus:ring-blue-500" />
              Remember me
            </label>
            <button type="button" className="text-blue-600 hover:text-blue-700 font-medium">Forgot Password?</button>
          </div>

          <button 
            type="submit" 
            disabled={loading}
            className={`w-full ${loading ? 'bg-blue-400' : 'bg-blue-600 hover:bg-blue-700'} text-white font-bold py-3 rounded-lg shadow-lg shadow-blue-200 transition-all transform ${loading ? '' : 'hover:-translate-y-0.5'}`}
          >
            {loading ? 'Signing in...' : 'Sign In'}
          </button>

          {error && (
            <div className="mt-3 text-center text-sm text-red-600">
              {error}
            </div>
          )}
        </form>
      </div>
      
      <p className="mt-6 text-sm text-slate-400">
        © 2024 MediCore Systems. All rights reserved.
      </p>
    </div>
  );
};

export default Login;