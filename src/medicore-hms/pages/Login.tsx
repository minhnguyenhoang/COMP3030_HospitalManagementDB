import React, { useState } from 'react';
import { UserRole } from '../types';
import { Activity, Lock, Mail } from 'lucide-react';

interface LoginProps {
  onLogin: (role: UserRole, UserEmail: string) => void;
}

const Login: React.FC<LoginProps> = ({ onLogin }) => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      setError(null);
      setLoading(true);
      const api = await import('../src/api');
      const response = await api.login(email, password);

      // Get role from backend response
      if (response.role) {
        onLogin(response.role as UserRole, response.email || email);
      } else {
        throw new Error('Role not found in response');
      }
    } catch (err: any) {
      console.error('Login error', err);
      setError(err.message || 'Login failed — check credentials or backend connection');
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