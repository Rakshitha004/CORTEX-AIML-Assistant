import React from 'react';
import { BrowserRouter, Routes, Route, useLocation } from 'react-router-dom';
import { AnimatePresence } from 'framer-motion';
import { Toaster } from 'sonner';
import { NotificationProvider } from './context/NotificationContext';
import { RoleProvider } from './context/RoleContext';
import { ThemeProvider } from './context/ThemeContext';
import { OnboardingProvider } from './context/OnboardingContext';
import { RouteGuard } from './components/RouteGuard';
import { OnboardingTour } from './components/OnboardingTour';
import { Navbar } from './components/Navbar';
import { AppLayout } from './components/AppLayout';
import { LandingPage } from './pages/LandingPage';
import { AboutPage } from './pages/AboutPage';
import { RoleSelectionPage } from './pages/RoleSelectionPage';
import { LoginPage } from './pages/LoginPage';
import { DashboardPage } from './pages/DashboardPage';
import { ChatLayout } from './pages/ChatPage';
import { KnowledgeBasePage } from './pages/KnowledgeBasePage';
import { AuditLogsPage } from './pages/AuditLogsPage';
import { SettingsPage } from './pages/SettingsPage';
import { RegisterPage } from './pages/RegisterPage';
import '@/App.css';

const AppContent = () => {
  const location = useLocation();
  const publicPaths = ['/', '/about'];
  const showNavbar = publicPaths.includes(location.pathname);

  return (
    <div className="App">
      {showNavbar && <Navbar />}
      <AnimatePresence mode="wait">
        <Routes location={location} key={location.pathname}>
          {/* Public routes */}
          <Route path="/" element={<LandingPage />} />
          <Route path="/about" element={<AboutPage />} />
          <Route path="/select-role" element={<RoleSelectionPage />} />
          <Route path="/login" element={<LoginPage />} />
          <Route path="/register" element={<RegisterPage />} />

          {/* App routes — sidebar layout with role guards */}
          <Route path="/app" element={<AppLayout />}>
            <Route path="dashboard" element={<RouteGuard page="dashboard"><DashboardPage /></RouteGuard>} />
            <Route path="chat" element={<RouteGuard page="chat"><ChatLayout /></RouteGuard>} />
            <Route path="knowledge-base" element={<RouteGuard page="knowledge-base"><KnowledgeBasePage /></RouteGuard>} />
            <Route path="audit-logs" element={<RouteGuard page="audit-logs"><AuditLogsPage /></RouteGuard>} />
            <Route path="settings" element={<RouteGuard page="settings"><SettingsPage /></RouteGuard>} />
          </Route>
        </Routes>
      </AnimatePresence>
    </div>
  );
};

function App() {
  return (
    <BrowserRouter>
      <RoleProvider>
        <ThemeProvider>
          <NotificationProvider>
            <OnboardingProvider>
              <Toaster
              position="bottom-right"
              toastOptions={{
                style: {
                  background: 'rgba(10, 10, 18, 0.95)',
                  border: '1px solid rgba(255,255,255,0.1)',
                  color: '#fff',
                  backdropFilter: 'blur(24px)',
                  borderRadius: '12px',
                },
              }}
            />
            <OnboardingTour />
            <AppContent />
            </OnboardingProvider>
          </NotificationProvider>
        </ThemeProvider>
      </RoleProvider>
    </BrowserRouter>
  );
}

export default App;