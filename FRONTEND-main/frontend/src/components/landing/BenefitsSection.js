import React, { useEffect, useRef } from 'react';
import { GlassmorphicCard } from '../GlassmorphicCard';
import { Users, GraduationCap, UserCog } from 'lucide-react';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

gsap.registerPlugin(ScrollTrigger);

const benefits = [
  {
    icon: GraduationCap,
    title: 'For Students',
    description: 'Get instant answers to course-related questions. No more digging through PDFs or waiting for office hours.',
    image: 'https://images.unsplash.com/photo-1764016888054-d8d3b8d66945?crop=entropy&cs=srgb&fm=jpg&ixid=M3w3NTY2NzF8MHwxfHNlYXJjaHwzfHx1bml2ZXJzaXR5JTIwc3R1ZGVudCUyMHBvcnRyYWl0JTIwZGFya3xlbnwwfHx8fDE3NzYzNDg3MTN8MA&ixlib=rb-4.1.0&q=85'
  },
  {
    icon: Users,
    title: 'For Teachers',
    description: 'Automate routine queries and spend more time on what matters—teaching and mentoring students.',
    image: 'https://images.unsplash.com/photo-1612914073562-9f2e8272fea2?crop=entropy&cs=srgb&fm=jpg&ixid=M3w3NTY2NzF8MHwxfHNlYXJjaHwxfHx1bml2ZXJzaXR5JTIwc3R1ZGVudCUyMHBvcnRyYWl0JTIwZGFya3xlbnwwfHx8fDE3NzYzNDg3MTN8MA&ixlib=rb-4.1.0&q=85'
  },
  {
    icon: UserCog,
    title: 'For Administrators',
    description: 'Track usage patterns, identify bottlenecks, and make data-driven decisions to improve efficiency.',
    image: 'https://images.unsplash.com/photo-1485014749802-1dba3a03984c?crop=entropy&cs=srgb&fm=jpg&ixid=M3w3NTY2NzF8MHwxfHNlYXJjaHwyfHx1bml2ZXJzaXR5JTIwc3R1ZGVudCUyMHBvcnRyYWl0JTIwZGFya3xlbnwwfHx8fDE3NzYzNDg3MTN8MA&ixlib=rb-4.1.0&q=85'
  },
];

export const BenefitsSection = () => {
  const sectionRef = useRef(null);
  
  useEffect(() => {
    const cards = sectionRef.current?.querySelectorAll('.benefit-card');
    
    if (cards) {
      gsap.fromTo(
        cards,
        { opacity: 0, x: -50 },
        {
          opacity: 1,
          x: 0,
          duration: 0.8,
          stagger: 0.2,
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
    <section ref={sectionRef} className="relative py-24 px-6" data-testid="benefits-section">
      <div className="max-w-7xl mx-auto">
        <div className="text-center mb-16">
          <h2 className="text-3xl sm:text-4xl font-medium text-white mb-4">
            Built for Everyone
          </h2>
          <p className="text-lg text-white/60 max-w-2xl mx-auto">
            Whether you're a student, teacher, or administrator, CORTEX adapts to your needs.
          </p>
        </div>
        
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {benefits.map((benefit, index) => (
            <GlassmorphicCard
              key={index}
              hover
              data-testid={`benefit-card-${index}`}
              className="benefit-card overflow-hidden p-0 cursor-pointer"
            >
              <div className="h-48 overflow-hidden">
                <img
                  src={benefit.image}
                  alt={benefit.title}
                  className="w-full h-full object-cover"
                />
              </div>
              <div className="p-6">
                <div className="w-12 h-12 rounded-lg bg-gradient-to-br from-cyan-400 to-blue-600 flex items-center justify-center mb-4">
                  <benefit.icon className="w-6 h-6 text-white" />
                </div>
                <h3 className="text-xl font-medium text-white mb-3">{benefit.title}</h3>
                <p className="text-white/60 leading-relaxed">{benefit.description}</p>
              </div>
            </GlassmorphicCard>
          ))}
        </div>
      </div>
    </section>
  );
};