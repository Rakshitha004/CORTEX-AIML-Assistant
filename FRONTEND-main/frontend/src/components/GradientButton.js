import React from 'react';

export const GradientButton = ({ children, onClick, className = '', variant = 'primary', ...props }) => {
  const baseClasses = 'px-6 py-3 rounded-full font-medium text-base transition-all duration-300 cursor-pointer';
  
  const variants = {
    primary: 'btn-gradient text-white',
    secondary: 'glass border-2 border-cyan-400/50 text-cyan-400 hover:bg-cyan-400/10 hover:border-cyan-400',
    outline: 'border-2 border-white/20 text-white hover:bg-white/10 hover:border-white/40'
  };
  
  return (
    <button 
      onClick={onClick}
      className={`${baseClasses} ${variants[variant]} ${className}`}
      {...props}
    >
      {children}
    </button>
  );
};
