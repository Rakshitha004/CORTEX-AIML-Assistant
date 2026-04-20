import React from 'react';
import { Navigate } from 'react-router-dom';
import { useRole } from '../context/RoleContext';

export const RouteGuard = ({ page, children }) => {
  const { role, hasAccess } = useRole();
  const token = localStorage.getItem('cortex_token');

  // Not logged in
  if (!token || !role) {
    return <Navigate to="/select-role" replace />;
  }

  // No access to this page
  if (!hasAccess(page)) {
    return <Navigate to="/app/dashboard" replace />;
  }

  return children;
};
