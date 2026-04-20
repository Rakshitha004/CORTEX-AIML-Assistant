import React from 'react';
import { HeroSection } from '../components/landing/HeroSection';
import { FeaturesSection } from '../components/landing/FeaturesSection';
import { DemoPreview } from '../components/landing/DemoPreview';
import { BenefitsSection } from '../components/landing/BenefitsSection';
import { CTASection } from '../components/landing/CTASection';

export const LandingPage = () => {
  return (
    <div className="bg-[#05050A]" data-testid="landing-page">
      <div className="bg-gradient-overlay" />
      <HeroSection />
      <FeaturesSection />
      <DemoPreview />
      <BenefitsSection />
      <CTASection />
    </div>
  );
};