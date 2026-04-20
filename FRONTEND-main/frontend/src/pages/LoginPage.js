import React, { useState } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { motion } from 'framer-motion';
import { Eye, EyeOff, ArrowLeft } from 'lucide-react';
import { useRole } from '../context/RoleContext';

const API_URL = 'http://localhost:8000';

export const LoginPage = () => {
  const navigate = useNavigate();
  const location = useLocation();
  const { role: storedRole, setRole } = useRole();
  const role = location.state?.role || storedRole || 'student';

  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleLogin = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      const response = await fetch(`${API_URL}/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          email,
          password,
          role: role.charAt(0).toUpperCase() + role.slice(1),
        }),
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.detail || 'Login failed');
      }

      // Check if different user is logging in
      const previousEmail = JSON.parse(localStorage.getItem('user') || '{}').email || '';
      if (previousEmail !== email) {
        // Different user - clear their chat data
        localStorage.removeItem('cortex_convos');
        localStorage.removeItem('cortex_active_convo');
        localStorage.removeItem('cortex_convos_email');
      }

      // Set new user data
      localStorage.setItem('cortex_token', data.access_token);
      localStorage.setItem('token', data.access_token);
      localStorage.setItem('cortex_user_name', data.name);
      localStorage.setItem('cortex_user_role', data.role.toLowerCase());
      localStorage.setItem('user', JSON.stringify({
        name: data.name,
        email: email,
        role: data.role,
      }));

      setRole(data.role.toLowerCase());
      navigate('/app/dashboard');

    } catch (err) {
      setError(err.message || 'Login failed. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-[#05050A] px-6 relative overflow-hidden" data-testid="login-page">
      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[600px] h-[600px] rounded-full opacity-20 pointer-events-none" style={{ background: 'radial-gradient(circle, rgba(0,87,255,0.18) 0%, transparent 70%)' }} />

      <motion.div initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.6 }} className="w-full max-w-md relative z-10">
        <button onClick={() => navigate('/select-role')} data-testid="login-back-button" className="flex items-center space-x-2 text-white/40 hover:text-white mb-8 transition-colors">
          <ArrowLeft className="w-4 h-4" />
          <span className="text-sm">Back to role selection</span>
        </button>

        <div className="glass rounded-2xl p-8">
          <div className="text-center mb-8">
            <div className="w-12 h-12 mx-auto mb-4 rounded-xl bg-gradient-to-br from-cyan-400 to-blue-600 flex items-center justify-center">
              <span className="text-white font-bold text-xl">C</span>
            </div>
            <h2 className="text-2xl font-medium text-white mb-1">Sign in to CORTEX</h2>
            <p className="text-sm text-white/40 capitalize">Logging in as {role}</p>
          </div>

          {error && (
            <div className="mb-4 px-4 py-3 rounded-xl bg-red-500/10 border border-red-500/20 text-red-400 text-sm text-center">
              {error}
            </div>
          )}

          <form onSubmit={handleLogin} className="space-y-5">
            <div>
              <label className="block text-sm text-white/60 mb-2">Email</label>
              <motion.input whileFocus={{ borderColor: 'rgba(0,240,255,0.5)' }} type="email" data-testid="login-email-input" value={email} onChange={(e) => setEmail(e.target.value)} placeholder="you@university.edu" required className="w-full px-4 py-3 rounded-xl bg-white/[0.04] border border-white/10 text-white placeholder-white/30 outline-none transition-colors duration-200 focus:border-cyan-400/50" />
            </div>

            <div>
              <label className="block text-sm text-white/60 mb-2">Password</label>
              <div className="relative">
                <motion.input whileFocus={{ borderColor: 'rgba(0,240,255,0.5)' }} type={showPassword ? 'text' : 'password'} data-testid="login-password-input" value={password} onChange={(e) => setPassword(e.target.value)} placeholder="Enter password" required className="w-full px-4 py-3 rounded-xl bg-white/[0.04] border border-white/10 text-white placeholder-white/30 outline-none transition-colors duration-200 focus:border-cyan-400/50 pr-12" />
                <button type="button" onClick={() => setShowPassword(!showPassword)} data-testid="toggle-password-visibility" className="absolute right-3 top-1/2 -translate-y-1/2 text-white/40 hover:text-white">
                  {showPassword ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
                </button>
              </div>
            </div>

            <motion.button type="submit" data-testid="login-submit-button" disabled={loading} whileHover={{ scale: 1.02, boxShadow: '0 0 24px rgba(0,87,255,0.4)' }} whileTap={{ scale: 0.98 }} className="w-full py-3.5 rounded-xl bg-gradient-to-r from-cyan-500 to-blue-600 text-white font-medium text-base transition-all duration-200 disabled:opacity-50">
              {loading ? (
                <div className="flex items-center justify-center space-x-2">
                  <div className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                  <span>Signing in...</span>
                </div>
              ) : 'Sign In'}
            </motion.button>
          </form>

          <p className="text-center text-sm text-white/30 mt-6">
            Don't have an account?{' '}
            <span onClick={() => navigate('/register')} className="text-cyan-400 cursor-pointer hover:underline">Register here</span>
          </p>
        </div>
      </motion.div>
    </div>
  );
};