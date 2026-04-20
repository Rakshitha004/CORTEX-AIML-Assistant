import React, { createContext, useContext, useState, useCallback, useEffect, useRef } from 'react';
import { useRole } from './RoleContext';

const OnboardingContext = createContext(null);

export const useOnboarding = () => {
  const ctx = useContext(OnboardingContext);
  if (!ctx) throw new Error('useOnboarding must be used within OnboardingProvider');
  return ctx;
};

const tourSteps = {
  student: [
    { target: '[data-testid="sidebar-link-dashboard"]', title: 'Your Dashboard', content: 'View your courses, grades, deadlines, and activity all in one place.', position: 'right' },
    { target: '[data-testid="sidebar-link-chat-assistant"]', title: 'Chat Assistant', content: 'Ask CORTEX any academic question — powered by AI with RAG and SQL.', position: 'right' },
    { target: '[data-testid="notification-bell"]', title: 'Notifications', content: 'Get alerts when your queries are answered or assignments are graded.', position: 'right' },
    { target: '[data-testid="sidebar-link-settings"]', title: 'Settings', content: 'Customize your theme, manage notifications, and update your profile.', position: 'right' },
  ],
  teacher: [
    { target: '[data-testid="sidebar-link-dashboard"]', title: 'Teaching Dashboard', content: 'Monitor student performance, attendance, and submissions at a glance.', position: 'right' },
    { target: '[data-testid="sidebar-link-chat-assistant"]', title: 'Chat Assistant', content: 'Use AI to quickly find information or generate academic content.', position: 'right' },
    { target: '[data-testid="sidebar-link-knowledge-base"]', title: 'Knowledge Base', content: 'Upload and manage documents — they get indexed for AI-powered search.', position: 'right' },
    { target: '[data-testid="notification-bell"]', title: 'Notifications', content: 'Stay updated on student submissions, uploads, and system events.', position: 'right' },
    { target: '[data-testid="sidebar-link-settings"]', title: 'Settings', content: 'Customize your experience with themes and notification preferences.', position: 'right' },
  ],
  admin: [
    { target: '[data-testid="sidebar-link-dashboard"]', title: 'System Overview', content: 'Monitor system health, user activity, and query volume in real-time.', position: 'right' },
    { target: '[data-testid="sidebar-link-chat-assistant"]', title: 'Chat Assistant', content: 'Test the AI assistant and monitor its performance.', position: 'right' },
    { target: '[data-testid="sidebar-link-knowledge-base"]', title: 'Knowledge Base', content: 'Manage the document repository and monitor the indexing pipeline.', position: 'right' },
    { target: '[data-testid="sidebar-link-audit-&-logs"]', title: 'Audit & Logs', content: 'View query logs, system events, and monitor for issues.', position: 'right' },
    { target: '[data-testid="notification-bell"]', title: 'Notifications', content: 'Get alerts for system issues, high latency, and failed operations.', position: 'right' },
    { target: '[data-testid="sidebar-link-settings"]', title: 'Settings', content: 'Configure system-wide settings, themes, and data privacy options.', position: 'right' },
  ],
};

const ONBOARDING_KEY_PREFIX = 'cortex_onboarding_seen_';

export const OnboardingProvider = ({ children }) => {
  const { role } = useRole();
  const key = `${ONBOARDING_KEY_PREFIX}${role || 'none'}`;
  const prevRoleRef = useRef(null);

  const [active, setActive] = useState(false);
  const [step, setStep] = useState(0);

  const steps = tourSteps[role] || [];

  // Auto-trigger tour when role changes and hasn't been seen
  useEffect(() => {
    if (!role) {
      setActive(false);
      return;
    }
    // Only trigger when role actually changes (not on every render)
    if (prevRoleRef.current !== role) {
      prevRoleRef.current = role;
      const seen = localStorage.getItem(key);
      if (!seen) {
        // Delay slightly to ensure sidebar is rendered
        const timer = setTimeout(() => {
          setStep(0);
          setActive(true);
        }, 800);
        return () => clearTimeout(timer);
      }
    }
  }, [role, key]);

  const start = useCallback(() => {
    setStep(0);
    setActive(true);
  }, []);

  const finish = useCallback(() => {
    setActive(false);
    try { localStorage.setItem(key, 'true'); } catch {}
  }, [key]);

  const next = useCallback(() => {
    if (step < steps.length - 1) {
      setStep((s) => s + 1);
    } else {
      finish();
    }
  }, [step, steps.length, finish]);

  const prev = useCallback(() => {
    if (step > 0) setStep((s) => s - 1);
  }, [step]);

  const skip = useCallback(() => {
    finish();
  }, [finish]);

  return (
    <OnboardingContext.Provider value={{ active, step, steps, currentStep: steps[step] || null, start, next, prev, skip, finish, totalSteps: steps.length }}>
      {children}
    </OnboardingContext.Provider>
  );
};
