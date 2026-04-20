import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { AnimatedPage } from '../components/AnimatedPage';
import { GlassmorphicCard } from '../components/GlassmorphicCard';
import { AnimatedToggle } from '../components/AnimatedToggle';
import { User, Shield, Bell, Palette, Database, Save, Check, Navigation } from 'lucide-react';
import { useTheme, themes } from '../context/ThemeContext';
import { useRole } from '../context/RoleContext';
import { useOnboarding } from '../context/OnboardingContext';

const API_URL = 'https://web-production-e4321.up.railway.app';

const tabs = [
  { id: 'profile', label: 'Profile', icon: User },
  { id: 'security', label: 'Security', icon: Shield },
  { id: 'notifications', label: 'Notifications', icon: Bell },
  { id: 'appearance', label: 'Appearance', icon: Palette },
  { id: 'data', label: 'Data & Privacy', icon: Database },
];

const panelVariants = {
  initial: { opacity: 0, x: 16 },
  animate: { opacity: 1, x: 0 },
  exit: { opacity: 0, x: -16 },
};

export const SettingsPage = () => {
  const [active, setActive] = useState('profile');
  const { themeId, setThemeId } = useTheme();
  const { role } = useRole();
  const { start: startTour } = useOnboarding();

  // Get real user data from localStorage
  const [currentUser, setCurrentUser] = useState({
    name: '',
    email: '',
    role: '',
  });

  useEffect(() => {
    const name = localStorage.getItem('cortex_user_name') || '';
    const role = localStorage.getItem('cortex_user_role') || '';
    const userStr = localStorage.getItem('user');
    let email = '';
    if (userStr) {
      try {
        const user = JSON.parse(userStr);
        email = user.email || '';
      } catch (e) {}
    }
    setCurrentUser({ name, email, role });
  }, []);

  const initials = currentUser.name
    ? currentUser.name.split(' ').map(n => n[0]).join('').toUpperCase().slice(0, 2)
    : 'U';

  const [settings, setSettings] = useState({
    twoFactorAuth: false,
    emailNotifications: true,
    pushNotifications: false,
    weeklyDigest: true,
    darkMode: true,
    reducedMotion: false,
    dataCollection: true,
    shareAnalytics: false,
  });

  const toggle = (key) => setSettings((p) => ({ ...p, [key]: !p[key] }));

  const roleTitles = { student: 'Student', teacher: 'Teacher', admin: 'Administrator' };

  const panels = {
    profile: (
      <div>
        <h2 className="text-2xl font-medium text-white mb-6">Profile</h2>
        <div className="flex items-center space-x-5 mb-8">
          <div className="w-20 h-20 rounded-full flex items-center justify-center text-white text-2xl font-bold" style={{ background: 'var(--cx-toggle-on, linear-gradient(135deg, #00F0FF, #0057FF))' }}>
            {initials}
          </div>
          <div>
            <div className="text-white font-medium text-lg">{currentUser.name || 'User'}</div>
            <div className="text-sm text-white/40">{roleTitles[currentUser.role] || roleTitles[role] || 'Student'} &middot; AIML Department</div>
          </div>
        </div>
        <div className="space-y-4">
          <Field label="Full Name" testId="profile-name-input" defaultValue={currentUser.name} />
          <Field label="Email" testId="profile-email-input" defaultValue={currentUser.email} type="email" />
          <Field label="Role" testId="profile-role-input" defaultValue={roleTitles[currentUser.role] || roleTitles[role] || 'Student'} disabled />
          <Field label="Department" testId="profile-dept-input" defaultValue="AIML" disabled />
        </div>
        <SaveButton />
      </div>
    ),
    security: (
      <div>
        <h2 className="text-2xl font-medium text-white mb-6">Security</h2>
        <Toggle label="Two-Factor Authentication" desc="Add an extra layer of security to your account" checked={settings.twoFactorAuth} onChange={() => toggle('twoFactorAuth')} testId="toggle-2fa" />
        <div className="mt-6">
          <Field label="Change Password" testId="password-input" placeholder="Enter new password" type="password" />
        </div>
        <SaveButton />
      </div>
    ),
    notifications: (
      <div>
        <h2 className="text-2xl font-medium text-white mb-6">Notifications</h2>
        <Toggle label="Email Notifications" desc="Receive important updates via email" checked={settings.emailNotifications} onChange={() => toggle('emailNotifications')} testId="toggle-email-notifications" />
        <Toggle label="Push Notifications" desc="Receive real-time browser notifications" checked={settings.pushNotifications} onChange={() => toggle('pushNotifications')} testId="toggle-push-notifications" />
        <Toggle label="Weekly Digest" desc="Get a weekly summary of your activity" checked={settings.weeklyDigest} onChange={() => toggle('weeklyDigest')} testId="toggle-weekly-digest" />
        <SaveButton />
      </div>
    ),
    appearance: (
      <div>
        <h2 className="text-2xl font-medium text-white mb-6">Appearance</h2>
        <div className="mb-8">
          <h3 className="text-sm text-white/50 uppercase tracking-wider mb-4">Theme</h3>
          <div className="grid grid-cols-2 gap-3">
            {Object.values(themes).map((t) => (
              <motion.button
                key={t.id}
                whileHover={{ scale: 1.02 }}
                whileTap={{ scale: 0.98 }}
                onClick={() => setThemeId(t.id)}
                data-testid={`theme-${t.id}`}
                className={`relative p-4 rounded-xl text-left transition-all duration-300 ${
                  themeId === t.id ? 'border-2' : 'border border-white/10 hover:border-white/20'
                }`}
                style={{
                  background: t.surface,
                  borderColor: themeId === t.id ? t.accent : undefined,
                  boxShadow: themeId === t.id ? `0 0 20px ${t.glowPrimary}` : 'none',
                }}
              >
                {themeId === t.id && (
                  <div className="absolute top-2 right-2 w-5 h-5 rounded-full flex items-center justify-center" style={{ background: t.accent }}>
                    <Check className="w-3 h-3 text-black" />
                  </div>
                )}
                <div className="flex items-center space-x-2 mb-2">
                  <div className="w-4 h-4 rounded-full" style={{ background: t.accent }} />
                  <div className="w-4 h-4 rounded-full" style={{ background: t.accentSecondary }} />
                  <div className="w-4 h-4 rounded-full" style={{ background: t.accentTertiary }} />
                </div>
                <div className="text-sm font-medium text-white">{t.name}</div>
                <div className="text-xs text-white/40">{t.description}</div>
              </motion.button>
            ))}
          </div>
        </div>
        <Toggle label="Reduced Motion" desc="Minimize animations for accessibility" checked={settings.reducedMotion} onChange={() => toggle('reducedMotion')} testId="toggle-reduced-motion" />
        <div className="mt-6 pt-6 border-t border-white/[0.06]">
          <div className="flex items-center justify-between">
            <div>
              <div className="text-white font-medium mb-0.5">Guided Tour</div>
              <div className="text-sm text-white/40">Replay the onboarding walkthrough</div>
            </div>
            <motion.button
              whileHover={{ scale: 1.03 }}
              whileTap={{ scale: 0.97 }}
              onClick={startTour}
              data-testid="take-tour-button"
              className="px-4 py-2 rounded-xl text-sm font-medium flex items-center space-x-2"
              style={{ background: 'var(--cx-surface)', border: '1px solid var(--cx-border)', color: 'var(--cx-accent)' }}
            >
              <Navigation className="w-4 h-4" />
              <span>Take Tour Again</span>
            </motion.button>
          </div>
        </div>
        <SaveButton />
      </div>
    ),
    data: (
      <div>
        <h2 className="text-2xl font-medium text-white mb-6">Data & Privacy</h2>
        <Toggle label="Usage Data Collection" desc="Help us improve CORTEX by sharing anonymous usage data" checked={settings.dataCollection} onChange={() => toggle('dataCollection')} testId="toggle-data-collection" />
        <Toggle label="Share Analytics" desc="Share analytics with your institution" checked={settings.shareAnalytics} onChange={() => toggle('shareAnalytics')} testId="toggle-share-analytics" />
        <div className="mt-8 flex space-x-4">
          <motion.button whileHover={{ scale: 1.03 }} whileTap={{ scale: 0.97 }} data-testid="export-data-button" className="px-5 py-2.5 rounded-xl glass border border-white/10 text-white/70 text-sm hover:text-white hover:border-white/20 transition-all">
            Export My Data
          </motion.button>
          <motion.button whileHover={{ scale: 1.03 }} whileTap={{ scale: 0.97 }} data-testid="delete-data-button" className="px-5 py-2.5 rounded-xl glass border border-red-500/20 text-red-400/70 text-sm hover:text-red-400 hover:border-red-500/40 transition-all">
            Delete All Data
          </motion.button>
        </div>
      </div>
    ),
  };

  return (
    <AnimatedPage className="min-h-screen p-6 md:p-8 overflow-auto">
      <div className="max-w-7xl mx-auto" data-testid="settings-page">
        <h1 className="text-3xl font-medium text-white mb-1">Settings</h1>
        <p className="text-white/50 mb-8">Manage your CORTEX preferences</p>
        <div className="grid md:grid-cols-4 gap-6">
          <div className="md:col-span-1">
            <GlassmorphicCard className="p-3">
              <nav className="space-y-1">
                {tabs.map((t) => (
                  <button
                    key={t.id}
                    onClick={() => setActive(t.id)}
                    data-testid={`settings-nav-${t.id}`}
                    className={`w-full flex items-center space-x-3 px-3 py-2.5 rounded-xl text-left transition-all duration-200 ${
                      active === t.id ? 'bg-white/10 border border-white/20' : 'text-white/50 hover:text-white hover:bg-white/5 border border-transparent'
                    }`}
                    style={{ color: active === t.id ? 'var(--cx-accent, #00F0FF)' : undefined, borderColor: active === t.id ? `color-mix(in srgb, var(--cx-accent, #00F0FF) 30%, transparent)` : undefined }}
                  >
                    <t.icon className="w-5 h-5 flex-shrink-0" />
                    <span className="text-sm font-medium">{t.label}</span>
                  </button>
                ))}
              </nav>
            </GlassmorphicCard>
          </div>
          <div className="md:col-span-3">
            <GlassmorphicCard className="p-8">
              <AnimatePresence mode="wait">
                <motion.div key={active} variants={panelVariants} initial="initial" animate="animate" exit="exit" transition={{ duration: 0.25 }}>
                  {panels[active]}
                </motion.div>
              </AnimatePresence>
            </GlassmorphicCard>
          </div>
        </div>
      </div>
    </AnimatedPage>
  );
};

const Field = ({ label, testId, defaultValue, placeholder, type = 'text', disabled = false }) => (
  <div>
    <label className="block text-sm text-white/50 mb-2">{label}</label>
    <input type={type} data-testid={testId} defaultValue={defaultValue} placeholder={placeholder} disabled={disabled} className="w-full px-4 py-3 rounded-xl bg-white/[0.04] border border-white/10 text-white placeholder-white/25 outline-none focus:border-cyan-400/50 transition-colors disabled:opacity-50 disabled:cursor-not-allowed" />
  </div>
);

const Toggle = ({ label, desc, checked, onChange, testId }) => (
  <div className="flex items-center justify-between py-4 border-b border-white/[0.06]">
    <div>
      <div className="text-white font-medium mb-0.5">{label}</div>
      <div className="text-sm text-white/40">{desc}</div>
    </div>
    <AnimatedToggle checked={checked} onCheckedChange={onChange} data-testid={testId} />
  </div>
);

const SaveButton = () => (
  <div className="mt-8">
    <motion.button whileHover={{ scale: 1.03, boxShadow: '0 0 20px var(--cx-glow-primary, rgba(0,87,255,0.3))' }} whileTap={{ scale: 0.97 }} data-testid="save-settings-button" className="px-6 py-2.5 rounded-xl text-white text-sm font-medium flex items-center space-x-2" style={{ background: 'var(--cx-toggle-on, linear-gradient(135deg, #00F0FF, #0057FF))' }}>
      <Save className="w-4 h-4" />
      <span>Save Changes</span>
    </motion.button>
  </div>
);
