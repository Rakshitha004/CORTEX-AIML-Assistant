import React, { useMemo } from 'react';
import { NavLink, useLocation, useNavigate } from 'react-router-dom';
import { motion } from 'framer-motion';
import { LayoutDashboard, MessageSquare, Database, FileText, Settings, LogOut, ChevronLeft, ChevronRight, Radio } from 'lucide-react';
import { NotificationBell } from './NotificationBell';
import { useRole } from '../context/RoleContext';

const allNavItems = [
  { path: '/app/dashboard', label: 'Dashboard', icon: LayoutDashboard, page: 'dashboard' },
  { path: '/app/chat', label: 'Chat Assistant', icon: MessageSquare, page: 'chat' },
  { path: '/app/knowledge-base', label: 'Knowledge Base', icon: Database, page: 'knowledge-base' },
  { path: '/app/audit-logs', label: 'Audit & Logs', icon: FileText, page: 'audit-logs' },
  { path: '/app/settings', label: 'Settings', icon: Settings, page: 'settings' },
];

export const AppSidebar = ({ collapsed, onToggle }) => {
  const location = useLocation();
  const navigate = useNavigate();
  const { role, hasAccess, clearRole } = useRole();

  const navItems = useMemo(() =>
    allNavItems.filter((item) => hasAccess(item.page)),
    [hasAccess]
  );

  const handleLogout = () => {
    localStorage.removeItem('cortex_token');
    localStorage.removeItem('cortex_user_name');
    localStorage.removeItem('cortex_user_role');
    clearRole();
    navigate('/');
  };

  const userName = localStorage.getItem('cortex_user_name') || role || 'User';

  return (
    <motion.aside
      data-testid="app-sidebar"
      initial={false}
      animate={{ width: collapsed ? 72 : 260 }}
      transition={{ duration: 0.25, ease: 'easeInOut' }}
      className="h-screen flex-shrink-0 flex flex-col border-r border-white/10 bg-[#070710]/80 backdrop-blur-2xl"
    >
      <div className="flex items-center px-4 h-16 border-b border-white/10">
        <div className="w-9 h-9 rounded-lg bg-gradient-to-br from-cyan-400 to-blue-600 flex items-center justify-center flex-shrink-0">
          <span className="text-white font-bold text-lg">C</span>
        </div>
        {!collapsed && (
          <motion.span initial={{ opacity: 0 }} animate={{ opacity: 1 }} className="ml-3 text-xl font-light tracking-tight text-white">
            CORTEX
          </motion.span>
        )}
      </div>

      <div className="px-4 pt-4 pb-2">
        <div data-testid="live-indicator" className={`flex items-center space-x-2 rounded-lg py-2 ${collapsed ? 'justify-center' : 'px-3'} bg-green-500/10 border border-green-500/20`}>
          <Radio className="w-4 h-4 text-green-400 animate-pulse" />
          {!collapsed && <span className="text-xs font-medium text-green-400 uppercase tracking-wider">Live</span>}
        </div>
      </div>

      {role && (
        <div className="px-4 pb-2">
          <div data-testid="role-badge" className={`flex items-center rounded-lg py-1.5 ${collapsed ? 'justify-center' : 'px-3 space-x-2'} bg-white/[0.04] border border-white/[0.06]`}>
            {!collapsed ? (
              <>
                <div className="w-6 h-6 rounded-md bg-gradient-to-br from-cyan-400 to-blue-600 flex items-center justify-center text-white text-xs font-bold flex-shrink-0">
                  {userName[0]?.toUpperCase()}
                </div>
                <div className="min-w-0">
                  <div className="text-xs font-medium text-white/70 truncate">{userName}</div>
                  <div className="text-[10px] text-white/30 capitalize">{role}</div>
                </div>
              </>
            ) : (
              <span className="text-[10px] font-bold text-white/40 uppercase">{role[0]}</span>
            )}
          </div>
        </div>
      )}

      <nav className="flex-1 px-3 py-2 space-y-1 overflow-y-auto">
        {navItems.map(({ path, label, icon: Icon }) => {
          const isActive = location.pathname === path;
          return (
            <NavLink key={path} to={path} data-testid={`sidebar-link-${label.toLowerCase().replace(/\s+/g, '-')}`}
              className={`group flex items-center rounded-xl px-3 py-2.5 transition-all duration-200 ${isActive ? 'bg-white/10 text-cyan-400 border border-cyan-400/30' : 'text-white/50 hover:text-white hover:bg-white/5 border border-transparent'}`}
            >
              <Icon className={`w-5 h-5 flex-shrink-0 ${isActive ? 'text-cyan-400' : ''}`} />
              {!collapsed && <span className="ml-3 text-sm font-medium truncate">{label}</span>}
            </NavLink>
          );
        })}
      </nav>

      <div className="px-3 py-4 border-t border-white/10 space-y-2">
        <NotificationBell collapsed={collapsed} />
        <button onClick={handleLogout} data-testid="sidebar-logout" className={`flex items-center w-full rounded-xl px-3 py-2.5 text-white/50 hover:text-red-400 hover:bg-red-500/10 transition-all duration-200 ${collapsed ? 'justify-center' : ''}`}>
          <LogOut className="w-5 h-5 flex-shrink-0" />
          {!collapsed && <span className="ml-3 text-sm font-medium">Logout</span>}
        </button>
        <button onClick={onToggle} data-testid="sidebar-toggle" className={`flex items-center w-full rounded-xl px-3 py-2.5 text-white/30 hover:text-white hover:bg-white/5 transition-all duration-200 ${collapsed ? 'justify-center' : ''}`}>
          {collapsed ? <ChevronRight className="w-5 h-5" /> : <><ChevronLeft className="w-5 h-5 flex-shrink-0" /><span className="ml-3 text-sm">Collapse</span></>}
        </button>
      </div>
    </motion.aside>
  );
};