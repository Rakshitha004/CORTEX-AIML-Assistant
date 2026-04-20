import React from 'react';
import { motion } from 'framer-motion';

export const AnimatedToggle = ({ checked, onCheckedChange, 'data-testid': testId, ...props }) => {
  return (
    <button
      role="switch"
      aria-checked={checked}
      data-testid={testId}
      onClick={() => onCheckedChange(!checked)}
      className="relative w-14 h-7 rounded-full transition-all duration-300 flex-shrink-0 cursor-pointer focus:outline-none"
      style={{
        background: checked ? 'var(--cx-toggle-on, linear-gradient(135deg, #00F0FF, #0057FF))' : 'rgba(255,255,255,0.08)',
        boxShadow: checked ? '0 0 16px var(--cx-glow-primary, rgba(0,240,255,0.3))' : 'none',
      }}
      {...props}
    >
      <motion.div
        className="absolute top-0.5 w-6 h-6 rounded-full bg-white shadow-lg"
        animate={{ left: checked ? 30 : 2 }}
        transition={{ type: 'spring', stiffness: 500, damping: 30 }}
      />
    </button>
  );
};
