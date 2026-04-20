import React, { useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { GradientButton } from '../GradientButton';
import gsap from 'gsap';

export const HeroSection = () => {
  const navigate = useNavigate();
  const orbRef = useRef(null);
  const ring1Ref = useRef(null);
  const ring2Ref = useRef(null);
  const contentRef = useRef(null);
  const glowRef = useRef(null);

  useEffect(() => {
    // Orb pulse
    if (orbRef.current) {
      gsap.to(orbRef.current, {
        scale: 1.04,
        duration: 3,
        repeat: -1,
        yoyo: true,
        ease: 'sine.inOut',
      });
    }

    // Ring 1 rotate
    if (ring1Ref.current) {
      gsap.to(ring1Ref.current, {
        rotation: 360,
        duration: 18,
        repeat: -1,
        ease: 'none',
        transformOrigin: 'center center',
      });
    }

    // Ring 2 rotate opposite
    if (ring2Ref.current) {
      gsap.to(ring2Ref.current, {
        rotation: -360,
        duration: 12,
        repeat: -1,
        ease: 'none',
        transformOrigin: 'center center',
      });
    }

    // Glow pulse
    if (glowRef.current) {
      gsap.to(glowRef.current, {
        opacity: 0.6,
        scale: 1.15,
        duration: 4,
        repeat: -1,
        yoyo: true,
        ease: 'sine.inOut',
      });
    }

    // Content fade in
    if (contentRef.current) {
      gsap.fromTo(
        contentRef.current.children,
        { opacity: 0, y: 30 },
        { opacity: 1, y: 0, duration: 1, stagger: 0.15, ease: 'power3.out', delay: 0.3 }
      );
    }
  }, []);

  return (
    <section
      className="relative min-h-screen flex flex-col items-center justify-center overflow-hidden"
      data-testid="hero-section"
      style={{ background: '#05050A' }}
    >
      {/* Background radial glow */}
      <div
        ref={glowRef}
        className="absolute top-1/4 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[700px] h-[700px] rounded-full pointer-events-none opacity-40"
        style={{
          background: 'radial-gradient(circle, rgba(120,60,255,0.35) 0%, rgba(0,200,255,0.15) 50%, transparent 75%)',
          filter: 'blur(60px)',
        }}
      />

      {/* ── 3D Orb ── */}
      <div className="relative flex items-center justify-center mt-16 mb-0" style={{ width: 520, height: 400 }}>

        {/* Outer ring 1 */}
        <div
          ref={ring1Ref}
          className="absolute"
          style={{
            width: 480,
            height: 200,
            borderRadius: '50%',
            border: '1.5px solid rgba(180,120,255,0.35)',
            transform: 'rotateX(70deg) rotateZ(20deg)',
            boxShadow: '0 0 30px rgba(160,80,255,0.2)',
          }}
        />

        {/* Outer ring 2 */}
        <div
          ref={ring2Ref}
          className="absolute"
          style={{
            width: 420,
            height: 175,
            borderRadius: '50%',
            border: '1.5px solid rgba(80,200,255,0.3)',
            transform: 'rotateX(70deg) rotateZ(-30deg)',
            boxShadow: '0 0 25px rgba(0,200,255,0.15)',
          }}
        />

        {/* Core orb */}
        <div
          ref={orbRef}
          className="relative rounded-full flex items-center justify-center"
          style={{
            width: 280,
            height: 280,
            background: 'radial-gradient(circle at 35% 35%, rgba(255,180,255,0.9), rgba(160,80,255,0.85) 40%, rgba(80,60,200,0.9) 70%, rgba(30,20,80,1) 100%)',
            boxShadow: '0 0 80px rgba(160,80,255,0.5), 0 0 140px rgba(80,60,200,0.3), inset 0 0 60px rgba(255,200,255,0.15)',
          }}
        >
          {/* Inner highlight */}
          <div
            className="absolute rounded-full"
            style={{
              width: 90,
              height: 60,
              top: 40,
              left: 50,
              background: 'radial-gradient(ellipse, rgba(255,255,255,0.35) 0%, transparent 80%)',
              filter: 'blur(8px)',
              transform: 'rotate(-20deg)',
            }}
          />

          {/* Eye-like glows */}
          <div className="absolute flex gap-6" style={{ top: '38%' }}>
            <div
              style={{
                width: 28,
                height: 32,
                borderRadius: '50% 50% 50% 50% / 60% 60% 40% 40%',
                background: 'rgba(255,255,255,0.9)',
                boxShadow: '0 0 20px rgba(255,255,255,0.8)',
              }}
            />
            <div
              style={{
                width: 28,
                height: 32,
                borderRadius: '50% 50% 50% 50% / 60% 60% 40% 40%',
                background: 'rgba(255,255,255,0.9)',
                boxShadow: '0 0 20px rgba(255,255,255,0.8)',
              }}
            />
          </div>

          {/* Orange/warm bottom glow */}
          <div
            className="absolute bottom-8 left-8 rounded-full"
            style={{
              width: 80,
              height: 80,
              background: 'radial-gradient(circle, rgba(255,140,60,0.6), transparent 70%)',
              filter: 'blur(12px)',
            }}
          />
        </div>

        {/* Hello speech bubble */}
        <div
          className="absolute"
          style={{ top: 20, right: 60 }}
        >
          <div
            className="px-4 py-2 rounded-2xl text-sm font-semibold text-gray-800 relative"
            style={{
              background: 'rgba(255,255,255,0.95)',
              boxShadow: '0 4px 20px rgba(0,0,0,0.15)',
            }}
          >
            Hello!
            <div
              className="absolute"
              style={{
                bottom: -8,
                left: 20,
                width: 0,
                height: 0,
                borderLeft: '8px solid transparent',
                borderRight: '8px solid transparent',
                borderTop: '8px solid rgba(255,255,255,0.95)',
              }}
            />
          </div>
        </div>
      </div>

      {/* ── Text Content Below Orb ── */}
      <div ref={contentRef} className="relative z-10 max-w-4xl mx-auto px-6 text-center mt-4">
        <div className="inline-block px-4 py-2 rounded-full glass border border-cyan-400/30 mb-6">
          <span className="text-sm text-cyan-400 uppercase tracking-wider">AI-Powered Academic Intelligence</span>
        </div>

        <h1 className="text-5xl sm:text-6xl lg:text-7xl font-light tracking-tight text-white mb-6 leading-tight">
          Your AI Assistant for
          <br />
          <span className="gradient-text font-medium">Academic Intelligence</span>
        </h1>

        <p className="text-lg sm:text-xl text-white/60 mb-10 max-w-3xl mx-auto leading-relaxed">
          CORTEX transforms how students, teachers, and administrators interact with academic data. Get instant answers, automate workflows, and unlock insights with cutting-edge AI.
        </p>

        <div className="flex flex-col sm:flex-row items-center justify-center space-y-4 sm:space-y-0 sm:space-x-4">
          <GradientButton
            onClick={() => navigate('/select-role')}
            data-testid="hero-try-now-button"
            variant="primary"
            className="px-8 py-4 text-lg"
          >
            Try Now
          </GradientButton>

          <GradientButton
            onClick={() => navigate('/about')}
            data-testid="hero-explore-button"
            variant="secondary"
            className="px-8 py-4 text-lg"
          >
            Explore Features
          </GradientButton>
        </div>
      </div>
    </section>
  );
};
