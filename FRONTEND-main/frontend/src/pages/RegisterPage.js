import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { motion } from 'framer-motion';
import { Eye, EyeOff, ArrowLeft } from 'lucide-react';
import { useRole } from '../context/RoleContext';

const API_URL = 'https://web-production-e4321.up.railway.app';

export const RegisterPage = () => {
  const navigate = useNavigate();
  const { setRole } = useRole();

  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [role, setRoleState] = useState('Student');
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleRegister = async (e) => {
    e.preventDefault();
    setError('');

    const domain = email.split('@')[1];
    if (!['dsce.edu.in', 'gmail.com','aiml.edu'].includes(domain)) {
      setError('Only @dsce.edu.in or @gmail.com emails are allowed!');
      return;
    }

    if (password !== confirmPassword) {
      setError('Passwords do not match!');
      return;
    }

    if (password.length < 6) {
      setError('Password must be at least 6 characters!');
      return;
    }

    setLoading(true);
    try {
      const response = await fetch(`${API_URL}/register`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, password, role, name }),
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.detail || 'Registration failed');
      }

      // New user - clear previous user's chat data
      localStorage.removeItem('cortex_convos');
      localStorage.removeItem('cortex_active_convo');
      localStorage.removeItem('cortex_convos_email');

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
      setError(err.message || 'Registration failed. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-[#05050A] px-6 relative overflow-hidden">
      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[600px] h-[600px] rounded-full opacity-20 pointer-events-none" style={{ background: 'radial-gradient(circle, rgba(0,87,255,0.18) 0%, transparent 70%)' }} />

      <motion.div initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.6 }} className="w-full max-w-md relative z-10">
        <button onClick={() => navigate('/login')} className="flex items-center space-x-2 text-white/40 hover:text-white mb-8 transition-colors">
          <ArrowLeft className="w-4 h-4" />
          <span className="text-sm">Back to login</span>
        </button>

        <div className="glass rounded-2xl p-8">
          <div className="text-center mb-8">
            <div className="w-12 h-12 mx-auto mb-4 rounded-xl bg-gradient-to-br from-cyan-400 to-blue-600 flex items-center justify-center">
              <span className="text-white font-bold text-xl">C</span>
            </div>
            <h2 className="text-2xl font-medium text-white mb-1">Create Account</h2>
            <p className="text-sm text-white/40">Join CORTEX with your college email</p>
          </div>

          {error && (
            <div className="mb-4 px-4 py-3 rounded-xl bg-red-500/10 border border-red-500/20 text-red-400 text-sm text-center">
              {error}
            </div>
          )}

          <form onSubmit={handleRegister} className="space-y-4">
            <div>
              <label className="block text-sm text-white/60 mb-2">Full Name</label>
              <motion.input whileFocus={{ borderColor: 'rgba(0,240,255,0.5)' }} type="text" value={name} onChange={(e) => setName(e.target.value)} placeholder="Enter your full name" required className="w-full px-4 py-3 rounded-xl bg-white/[0.04] border border-white/10 text-white placeholder-white/30 outline-none transition-colors duration-200 focus:border-cyan-400/50" />
            </div>

            <div>
              <label className="block text-sm text-white/60 mb-2">Email</label>
              <motion.input whileFocus={{ borderColor: 'rgba(0,240,255,0.5)' }} type="email" value={email} onChange={(e) => setEmail(e.target.value)} placeholder="you@dsce.edu.in or @gmail.com" required className="w-full px-4 py-3 rounded-xl bg-white/[0.04] border border-white/10 text-white placeholder-white/30 outline-none transition-colors duration-200 focus:border-cyan-400/50" />
            </div>

            <div>
              <label className="block text-sm text-white/60 mb-2">Role</label>
              <select value={role} onChange={(e) => setRoleState(e.target.value)} className="w-full px-4 py-3 rounded-xl bg-white/[0.04] border border-white/10 text-white outline-none transition-colors duration-200 focus:border-cyan-400/50">
                <option value="Student" className="bg-[#05050A]">Student</option>
                <option value="Teacher" className="bg-[#05050A]">Teacher</option>
                <option value="Admin" className="bg-[#05050A]">Admin</option>
              </select>
            </div>

            <div>
              <label className="block text-sm text-white/60 mb-2">Password</label>
              <div className="relative">
                <motion.input whileFocus={{ borderColor: 'rgba(0,240,255,0.5)' }} type={showPassword ? 'text' : 'password'} value={password} onChange={(e) => setPassword(e.target.value)} placeholder="Min 6 characters" required className="w-full px-4 py-3 rounded-xl bg-white/[0.04] border border-white/10 text-white placeholder-white/30 outline-none transition-colors duration-200 focus:border-cyan-400/50 pr-12" />
                <button type="button" onClick={() => setShowPassword(!showPassword)} className="absolute right-3 top-1/2 -translate-y-1/2 text-white/40 hover:text-white">
                  {showPassword ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
                </button>
              </div>
            </div>

            <div>
              <label className="block text-sm text-white/60 mb-2">Confirm Password</label>
              <motion.input whileFocus={{ borderColor: 'rgba(0,240,255,0.5)' }} type="password" value={confirmPassword} onChange={(e) => setConfirmPassword(e.target.value)} placeholder="Re-enter password" required className="w-full px-4 py-3 rounded-xl bg-white/[0.04] border border-white/10 text-white placeholder-white/30 outline-none transition-colors duration-200 focus:border-cyan-400/50" />
            </div>

            <motion.button type="submit" disabled={loading} whileHover={{ scale: 1.02, boxShadow: '0 0 24px rgba(0,87,255,0.4)' }} whileTap={{ scale: 0.98 }} className="w-full py-3.5 rounded-xl bg-gradient-to-r from-cyan-500 to-blue-600 text-white font-medium text-base transition-all duration-200 disabled:opacity-50">
              {loading ? (
                <div className="flex items-center justify-center space-x-2">
                  <div className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                  <span>Creating account...</span>
                </div>
              ) : 'Create Account'}
            </motion.button>
          </form>

          <p className="text-center text-sm text-white/30 mt-6">
            Already have an account?{' '}
            <span onClick={() => navigate('/login')} className="text-cyan-400 cursor-pointer hover:underline">Sign In</span>
          </p>
        </div>
      </motion.div>
    </div>
  );
};
