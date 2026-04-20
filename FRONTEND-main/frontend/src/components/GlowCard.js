import React, { useRef, useState } from 'react';
import { motion } from 'framer-motion';

export const GlowCard = ({ children, className = '', glowColor = 'rgba(0,240,255,0.4)', onClick, ...props }) => {
  const cardRef = useRef(null);
  const [glowPos, setGlowPos] = useState({ x: 50, y: 50 });
  const [isHovering, setIsHovering] = useState(false);

  const handleMouseMove = (e) => {
    if (!cardRef.current) return;
    const rect = cardRef.current.getBoundingClientRect();
    const x = ((e.clientX - rect.left) / rect.width) * 100;
    const y = ((e.clientY - rect.top) / rect.height) * 100;
    setGlowPos({ x, y });
  };

  return (
    <motion.div
      ref={cardRef}
      onMouseMove={handleMouseMove}
      onMouseEnter={() => setIsHovering(true)}
      onMouseLeave={() => setIsHovering(false)}
      onClick={onClick}
      whileHover={{ scale: 1.04 }}
      whileTap={{ scale: 0.98 }}
      className={`relative rounded-2xl overflow-hidden cursor-pointer ${className}`}
      {...props}
    >
      {/* Animated border glow that follows cursor */}
      <div
        className="absolute inset-0 rounded-2xl pointer-events-none transition-opacity duration-300"
        style={{
          opacity: isHovering ? 1 : 0,
          background: `radial-gradient(circle 120px at ${glowPos.x}% ${glowPos.y}%, ${glowColor}, transparent 70%)`,
        }}
      />

      {/* Glowing border */}
      <div
        className="absolute inset-0 rounded-2xl pointer-events-none transition-opacity duration-300"
        style={{
          opacity: isHovering ? 1 : 0,
          padding: '1px',
          background: `radial-gradient(circle 80px at ${glowPos.x}% ${glowPos.y}%, ${glowColor}, transparent 60%)`,
          mask: 'linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0)',
          maskComposite: 'exclude',
          WebkitMaskComposite: 'xor',
        }}
      />

      {/* Card content */}
      <div className="relative z-10 glass rounded-2xl p-8 h-full border border-white/10 transition-colors duration-300"
        style={{ borderColor: isHovering ? `${glowColor.replace('0.4', '0.3')}` : 'rgba(255,255,255,0.1)' }}
      >
        {children}
      </div>
    </motion.div>
  );
};
