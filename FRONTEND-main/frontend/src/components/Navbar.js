import React from 'react';
import { Link, useNavigate } from 'react-router-dom';

export const Navbar = () => {
  const navigate = useNavigate();

  return (
    <nav className="fixed top-0 left-0 right-0 z-50 backdrop-blur-2xl bg-[#05050A]/60 border-b border-white/10">
      <div className="max-w-7xl mx-auto px-6 py-4 flex items-center justify-between">
        <Link to="/" className="flex items-center space-x-2" data-testid="nav-logo">
          <img src="/logo.jpeg" alt="CORTEX" className="w-10 h-10 rounded-lg object-cover" />
          <span className="text-2xl font-light tracking-tight text-white">CORTEX</span>
        </Link>

        <div className="flex items-center space-x-1">
          <Link
            to="/about"
            data-testid="nav-link-about"
            className="px-4 py-2 rounded-lg text-white/60 hover:text-white hover:bg-white/5 text-sm font-medium transition-all duration-200"
          >
            About
          </Link>
          <button
            onClick={() => navigate('/select-role')}
            data-testid="nav-get-started"
            className="ml-2 px-5 py-2 rounded-lg bg-gradient-to-r from-cyan-500 to-blue-600 text-white text-sm font-medium hover:shadow-lg hover:scale-105 transition-all duration-200"
          >
            Get Started
          </button>
        </div>
      </div>
    </nav>
  );
};
