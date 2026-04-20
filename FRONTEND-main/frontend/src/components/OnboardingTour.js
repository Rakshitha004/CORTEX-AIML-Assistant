import React, { useEffect, useState, useRef } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { X, ChevronRight, ChevronLeft } from 'lucide-react';
import { useOnboarding } from '../context/OnboardingContext';
import { useLocation } from 'react-router-dom';

export const OnboardingTour = () => {
  const { active, step, currentStep, next, prev, skip, totalSteps } = useOnboarding();
  const location = useLocation();
  const [pos, setPos] = useState({ top: 0, left: 0, width: 0, height: 0 });
  const [tooltipStyle, setTooltipStyle] = useState({});
  const rafRef = useRef(null);

  useEffect(() => {
    if (!active || !currentStep) return;

    const updatePosition = () => {
      const el = document.querySelector(currentStep.target);
      if (el) {
        const rect = el.getBoundingClientRect();
        setPos({ top: rect.top, left: rect.left, width: rect.width, height: rect.height });

        // Position tooltip to the right of the target
        const tooltipW = 300;
        const tooltipH = 160;
        let tTop = rect.top + rect.height / 2 - tooltipH / 2;
        let tLeft = rect.right + 16;

        // Fallback: if tooltip goes off-screen right, place it below
        if (tLeft + tooltipW > window.innerWidth) {
          tLeft = rect.left + rect.width / 2 - tooltipW / 2;
          tTop = rect.bottom + 12;
        }
        // Keep in viewport
        tTop = Math.max(12, Math.min(tTop, window.innerHeight - tooltipH - 12));
        tLeft = Math.max(12, Math.min(tLeft, window.innerWidth - tooltipW - 12));

        setTooltipStyle({ top: tTop, left: tLeft, width: tooltipW });
      }
    };

    updatePosition();
    // Re-calc on resize
    window.addEventListener('resize', updatePosition);
    return () => window.removeEventListener('resize', updatePosition);
  }, [active, currentStep, step]);

  if (!active || !currentStep || !location.pathname.startsWith('/app')) return null;

  return (
    <AnimatePresence>
      <div className="fixed inset-0 z-[999]" data-testid="onboarding-overlay">
        {/* Backdrop with cutout */}
        <div className="absolute inset-0" style={{ background: 'rgba(0,0,0,0.6)' }} onClick={skip} />

        {/* Spotlight on target */}
        <motion.div
          key={`spotlight-${step}`}
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          className="absolute rounded-xl pointer-events-none"
          style={{
            top: pos.top - 6,
            left: pos.left - 6,
            width: pos.width + 12,
            height: pos.height + 12,
            boxShadow: '0 0 0 9999px rgba(0,0,0,0.6), 0 0 20px var(--cx-glow-primary, rgba(0,240,255,0.4))',
            border: '2px solid var(--cx-accent, #00F0FF)',
            zIndex: 1000,
          }}
        />

        {/* Tooltip */}
        <motion.div
          key={`tooltip-${step}`}
          initial={{ opacity: 0, y: 8 }}
          animate={{ opacity: 1, y: 0 }}
          exit={{ opacity: 0, y: 8 }}
          transition={{ duration: 0.25 }}
          className="absolute z-[1001] glass rounded-2xl p-5 shadow-2xl"
          style={tooltipStyle}
          data-testid="onboarding-tooltip"
        >
          {/* Close */}
          <button
            onClick={skip}
            data-testid="onboarding-skip"
            className="absolute top-3 right-3 text-white/30 hover:text-white transition-colors"
          >
            <X className="w-4 h-4" />
          </button>

          {/* Content */}
          <div className="mb-4">
            <h3 className="text-base font-medium text-white mb-1">{currentStep.title}</h3>
            <p className="text-sm text-white/50 leading-relaxed">{currentStep.content}</p>
          </div>

          {/* Footer */}
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-1.5">
              {Array.from({ length: totalSteps }).map((_, i) => (
                <div
                  key={i}
                  className="w-2 h-2 rounded-full transition-all duration-200"
                  style={{
                    background: i === step ? 'var(--cx-accent, #00F0FF)' : 'rgba(255,255,255,0.15)',
                    width: i === step ? 16 : 8,
                  }}
                />
              ))}
            </div>

            <div className="flex items-center space-x-2">
              {step > 0 && (
                <button
                  onClick={prev}
                  data-testid="onboarding-prev"
                  className="px-3 py-1.5 rounded-lg text-xs text-white/50 hover:text-white hover:bg-white/5 transition-colors flex items-center space-x-1"
                >
                  <ChevronLeft className="w-3.5 h-3.5" />
                  <span>Back</span>
                </button>
              )}
              <button
                onClick={next}
                data-testid="onboarding-next"
                className="px-4 py-1.5 rounded-lg text-xs font-medium text-white flex items-center space-x-1"
                style={{ background: 'var(--cx-toggle-on, linear-gradient(135deg, #00F0FF, #0057FF))' }}
              >
                <span>{step === totalSteps - 1 ? 'Finish' : 'Next'}</span>
                {step < totalSteps - 1 && <ChevronRight className="w-3.5 h-3.5" />}
              </button>
            </div>
          </div>

          {/* Step counter */}
          <div className="mt-3 text-center">
            <span className="text-[10px] text-white/25">{step + 1} of {totalSteps}</span>
          </div>
        </motion.div>
      </div>
    </AnimatePresence>
  );
};
