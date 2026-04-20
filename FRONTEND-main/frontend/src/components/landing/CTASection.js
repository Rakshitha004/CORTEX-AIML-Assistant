import React, { useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { GradientButton } from '../GradientButton';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

gsap.registerPlugin(ScrollTrigger);

export const CTASection = () => {
  const navigate = useNavigate();
  const sectionRef = useRef(null);
  
  useEffect(() => {
    if (sectionRef.current) {
      gsap.fromTo(
        sectionRef.current.children,
        { opacity: 0, scale: 0.9 },
        {
          opacity: 1,
          scale: 1,
          duration: 1,
          ease: 'power3.out',
          scrollTrigger: {
            trigger: sectionRef.current,
            start: 'top 80%',
          }
        }
      );
    }
  }, []);
  
  return (
    <section className="relative py-24 px-6" data-testid="cta-section">
      <div className="max-w-4xl mx-auto">
        <div ref={sectionRef} className="glass rounded-3xl p-12 text-center relative overflow-hidden">
          {/* Glow Effect */}
          <div
            className="absolute inset-0 opacity-20"
            style={{
              background: 'radial-gradient(circle at center, rgba(0, 240, 255, 0.3) 0%, transparent 70%)'
            }}
          />
          
          <div className="relative z-10">
            <h2 className="text-3xl sm:text-4xl font-medium text-white mb-6">
              Start Using CORTEX Today
            </h2>
            <p className="text-lg text-white/60 mb-8 max-w-2xl mx-auto">
              Join the future of academic intelligence. Experience the power of AI-driven assistance.
            </p>
            
            <GradientButton
              onClick={() => navigate('/select-role')}
              data-testid="cta-start-button"
              variant="primary"
              className="px-8 py-4 text-lg"
            >
              Get Started Now
            </GradientButton>
          </div>
        </div>
      </div>
    </section>
  );
};
