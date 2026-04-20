import React from 'react';

export const GlassmorphicCard = ({ children, className = '', hover = false, ...props }) => {
  const hoverClass = hover ? 'card-hover' : '';
  
  return (
    <div 
      className={`glass rounded-2xl p-6 ${hoverClass} ${className}`}
      {...props}
    >
      {children}
    </div>
  );
};
