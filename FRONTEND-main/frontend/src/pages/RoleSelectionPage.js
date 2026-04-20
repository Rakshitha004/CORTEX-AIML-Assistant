import React from 'react';
import { useNavigate } from 'react-router-dom';
import { motion } from 'framer-motion';
import { GraduationCap, BookOpen, ShieldCheck } from 'lucide-react';
import { GlowCard } from '../components/GlowCard';
import { useRole } from '../context/RoleContext';

const roles = [
  {
    id: 'student',
    label: 'Student',
    description: 'Access courses, ask questions, and explore academic knowledge.',
    icon: GraduationCap,
    gradient: 'from-cyan-400 to-blue-600',
    glow: 'rgba(0,240,255,0.4)',
  },
  {
    id: 'teacher',
    label: 'Teacher',
    description: 'Manage content, review analytics, and mentor students.',
    icon: BookOpen,
    gradient: 'from-blue-500 to-purple-600',
    glow: 'rgba(0,87,255,0.4)',
  },
  {
    id: 'admin',
    label: 'Admin',
    description: 'Full system control, audit logs, and user management.',
    icon: ShieldCheck,
    gradient: 'from-purple-500 to-pink-600',
    glow: 'rgba(157,76,221,0.4)',
  },
];

const container = { hidden: {}, show: { transition: { staggerChildren: 0.12 } } };
const item = { hidden: { opacity: 0, y: 40 }, show: { opacity: 1, y: 0, transition: { duration: 0.6, ease: 'easeOut' } } };

export const RoleSelectionPage = () => {
  const navigate = useNavigate();
  const { setRole } = useRole();

  const handleSelect = (roleId) => {
    setRole(roleId);
    navigate('/login', { state: { role: roleId } });
  };

  return (
    <div className="min-h-screen flex flex-col items-center justify-center px-6 relative overflow-hidden" style={{ background: 'var(--cx-bg, #05050A)' }} data-testid="role-selection-page">
      {/* Background glow */}
      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[700px] h-[700px] rounded-full opacity-30 pointer-events-none" style={{ background: `radial-gradient(circle, var(--cx-glow-primary, rgba(0,240,255,0.12)) 0%, var(--cx-glow-secondary, rgba(0,87,255,0.08)) 40%, transparent 70%)` }} />

      <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.6 }} className="text-center mb-12 relative z-10">
        <div className="w-14 h-14 mx-auto mb-6 rounded-xl overflow-hidden">
          <img src="/logo.jpeg" alt="CORTEX" className="w-full h-full object-cover" />
        </div>
        <h1 className="text-4xl sm:text-5xl font-light tracking-tight text-white mb-3">
          Welcome to <span className="gradient-text font-medium">CORTEX</span>
        </h1>
        <p className="text-base text-white/50 max-w-md mx-auto">Select your role to continue</p>
      </motion.div>

      <motion.div variants={container} initial="hidden" animate="show" className="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-4xl relative z-10">
        {roles.map((r) => (
          <motion.div key={r.id} variants={item}>
            <GlowCard
              glowColor={r.glow}
              onClick={() => handleSelect(r.id)}
              data-testid={`role-card-${r.id}`}
              className="text-left"
            >
              <div className={`w-14 h-14 rounded-xl bg-gradient-to-br ${r.gradient} flex items-center justify-center mb-6 group-hover:scale-110 transition-transform duration-300`}>
                <r.icon className="w-7 h-7 text-white" />
              </div>
              <h3 className="text-xl font-medium text-white mb-2">{r.label}</h3>
              <p className="text-sm text-white/50 leading-relaxed">{r.description}</p>
            </GlowCard>
          </motion.div>
        ))}
      </motion.div>
    </div>
  );
};
