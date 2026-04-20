import React, { createContext, useContext, useState, useCallback, useEffect } from 'react';

const RoleContext = createContext(null);

export const useRole = () => {
  const ctx = useContext(RoleContext);
  if (!ctx) throw new Error('useRole must be used within RoleProvider');
  return ctx;
};

const ROLE_KEY = 'cortex_user_role';

export const RoleProvider = ({ children }) => {
  const [role, setRoleState] = useState(() => {
    try { return localStorage.getItem(ROLE_KEY) || null; } catch { return null; }
  });

  const setRole = useCallback((r) => {
    setRoleState(r);
    try { if (r) localStorage.setItem(ROLE_KEY, r); else localStorage.removeItem(ROLE_KEY); } catch {}
  }, []);

  const clearRole = useCallback(() => {
    setRoleState(null);
    try { localStorage.removeItem(ROLE_KEY); } catch {}
  }, []);

  const hasAccess = useCallback((page) => {
    if (!role) return false;
    const access = {
      student: ['dashboard', 'chat', 'settings'],
      teacher: ['dashboard', 'chat', 'audit-logs', 'settings'],
      admin: ['dashboard', 'chat', 'knowledge-base', 'audit-logs', 'settings'],
    };
    return (access[role] || []).includes(page);
  }, [role]);

  return (
    <RoleContext.Provider value={{ role, setRole, clearRole, hasAccess }}>
      {children}
    </RoleContext.Provider>
  );
};
