import React, { useState, useRef, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Bell, CheckCheck, Trash2, MessageSquare, FileText, Database } from 'lucide-react';
import { useNotifications } from '../context/NotificationContext';

const typeIcon = (type) => {
  switch (type) {
    case 'chat': return <MessageSquare className="w-4 h-4 text-cyan-400" />;
    case 'upload': return <FileText className="w-4 h-4 text-blue-400" />;
    case 'index': return <Database className="w-4 h-4 text-green-400" />;
    default: return <Bell className="w-4 h-4 text-white/50" />;
  }
};

const timeAgo = (date) => {
  const seconds = Math.floor((Date.now() - date.getTime()) / 1000);
  if (seconds < 60) return 'Just now';
  const minutes = Math.floor(seconds / 60);
  if (minutes < 60) return `${minutes}m ago`;
  const hours = Math.floor(minutes / 60);
  if (hours < 24) return `${hours}h ago`;
  return `${Math.floor(hours / 24)}d ago`;
};

export const NotificationBell = ({ collapsed }) => {
  const { notifications, unreadCount, markAllRead, markRead, clearAll } = useNotifications();
  const [open, setOpen] = useState(false);
  const panelRef = useRef(null);

  // Close on outside click
  useEffect(() => {
    const handler = (e) => {
      if (panelRef.current && !panelRef.current.contains(e.target)) {
        setOpen(false);
      }
    };
    if (open) document.addEventListener('mousedown', handler);
    return () => document.removeEventListener('mousedown', handler);
  }, [open]);

  return (
    <div className="relative" ref={panelRef}>
      <button
        onClick={() => setOpen(!open)}
        data-testid="notification-bell"
        className={`relative flex items-center w-full rounded-xl px-3 py-2.5 text-white/50 hover:text-white hover:bg-white/5 transition-all duration-200 ${collapsed ? 'justify-center' : ''}`}
      >
        <Bell className="w-5 h-5 flex-shrink-0" />
        {!collapsed && <span className="ml-3 text-sm font-medium">Notifications</span>}
        {unreadCount > 0 && (
          <span
            data-testid="notification-badge"
            className="absolute top-1 right-1 w-5 h-5 rounded-full bg-cyan-500 text-white text-[10px] font-bold flex items-center justify-center"
          >
            {unreadCount > 9 ? '9+' : unreadCount}
          </span>
        )}
      </button>

      <AnimatePresence>
        {open && (
          <motion.div
            initial={{ opacity: 0, y: 8, scale: 0.96 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: 8, scale: 0.96 }}
            transition={{ duration: 0.2 }}
            data-testid="notification-panel"
            className="absolute bottom-full left-0 mb-2 w-80 max-h-[420px] glass rounded-2xl border border-white/10 shadow-2xl overflow-hidden z-50"
            style={{ minWidth: collapsed ? 320 : 300 }}
          >
            {/* Header */}
            <div className="flex items-center justify-between px-4 py-3 border-b border-white/10">
              <h3 className="text-sm font-medium text-white">Notifications</h3>
              <div className="flex items-center space-x-2">
                {unreadCount > 0 && (
                  <button
                    onClick={markAllRead}
                    data-testid="mark-all-read-button"
                    className="text-xs text-cyan-400 hover:text-cyan-300 flex items-center space-x-1 transition-colors"
                  >
                    <CheckCheck className="w-3.5 h-3.5" />
                    <span>Mark all read</span>
                  </button>
                )}
                {notifications.length > 0 && (
                  <button
                    onClick={clearAll}
                    data-testid="clear-all-button"
                    className="text-xs text-white/30 hover:text-red-400 transition-colors"
                  >
                    <Trash2 className="w-3.5 h-3.5" />
                  </button>
                )}
              </div>
            </div>

            {/* List */}
            <div className="max-h-[340px] overflow-y-auto">
              {notifications.length === 0 ? (
                <div className="py-12 text-center" data-testid="notification-empty">
                  <Bell className="w-8 h-8 text-white/20 mx-auto mb-3" />
                  <p className="text-sm text-white/30">No notifications yet</p>
                </div>
              ) : (
                notifications.map((n) => (
                  <div
                    key={n.id}
                    onClick={() => markRead(n.id)}
                    data-testid={`notification-item-${n.id}`}
                    className={`flex items-start space-x-3 px-4 py-3 cursor-pointer transition-colors duration-150 border-b border-white/5 ${
                      n.read ? 'opacity-60' : 'bg-white/[0.02] hover:bg-white/[0.04]'
                    }`}
                  >
                    <div className="flex-shrink-0 mt-0.5">{typeIcon(n.type)}</div>
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center justify-between">
                        <span className="text-sm font-medium text-white truncate">{n.title}</span>
                        {!n.read && (
                          <span className="flex-shrink-0 w-2 h-2 rounded-full bg-cyan-400 ml-2" />
                        )}
                      </div>
                      <p className="text-xs text-white/40 mt-0.5 truncate">{n.message}</p>
                      <p className="text-[10px] text-white/25 mt-1">{timeAgo(n.time)}</p>
                    </div>
                  </div>
                ))
              )}
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
};
