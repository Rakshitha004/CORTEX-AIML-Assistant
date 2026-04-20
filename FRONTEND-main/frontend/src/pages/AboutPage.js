import React, { useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { motion } from 'framer-motion';
import { GlassmorphicCard } from '../components/GlassmorphicCard';
import { GradientButton } from '../components/GradientButton';
import { MessageSquare, Database, BarChart3, Brain, Users, Code, GraduationCap, BookOpen, ShieldCheck } from 'lucide-react';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

gsap.registerPlugin(ScrollTrigger);

const features = [
  { icon: MessageSquare, title: 'Chat Assistant', description: 'RAG + SQL powered conversational AI for instant academic answers' },
  { icon: Database, title: 'Knowledge Base', description: 'Centralized document repository with vector search' },
  { icon: BarChart3, title: 'Analytics Dashboard', description: 'Real-time insights, audit logs, and performance metrics' },
];

const techStack = [
  { icon: Brain, name: 'Gemini AI / LLM', description: 'Advanced natural language processing' },
  { icon: Database, name: 'RAG Pipeline', description: 'Retrieval augmented generation for accuracy' },
  { icon: Code, name: 'SQL Integration', description: 'Direct database query automation' },
];

const personas = [
  { icon: GraduationCap, name: 'Students', desc: 'Instant answers, no more digging through PDFs', color: 'text-cyan-400' },
  { icon: BookOpen, name: 'Teachers', desc: 'Automate routine queries, focus on mentoring', color: 'text-blue-400' },
  { icon: ShieldCheck, name: 'Admins', desc: 'Data-driven decisions, full system oversight', color: 'text-purple-400' },
];

const container = { hidden: {}, show: { transition: { staggerChildren: 0.1 } } };
const item = { hidden: { opacity: 0, y: 30 }, show: { opacity: 1, y: 0, transition: { duration: 0.6 } } };

export const AboutPage = () => {
  const navigate = useNavigate();
  const heroRef = useRef(null);

  useEffect(() => {
    if (heroRef.current) {
      gsap.fromTo(heroRef.current.children, { opacity: 0, y: 30 }, { opacity: 1, y: 0, duration: 0.8, stagger: 0.15, ease: 'power3.out' });
    }
  }, []);

  return (
    <div className="min-h-screen bg-[#05050A] pt-20" data-testid="about-page">
      <div className="bg-gradient-overlay" />

      {/* Hero */}
      <section className="relative py-24 px-6">
        <div ref={heroRef} className="max-w-5xl mx-auto text-center relative z-10">
          <h1 className="text-5xl sm:text-6xl font-light text-white mb-4">
            About <span className="gradient-text font-medium">CORTEX</span>
          </h1>
          <p className="text-lg text-white/50 max-w-3xl mx-auto leading-relaxed">
            Empowering academic institutions with AI-driven intelligence, automation, and centralized knowledge management.
          </p>
        </div>
      </section>

      {/* Vision + Image */}
      <section className="relative py-16 px-6">
        <div className="max-w-6xl mx-auto grid md:grid-cols-2 gap-10 items-center">
          <motion.div initial={{ opacity: 0, x: -30 }} whileInView={{ opacity: 1, x: 0 }} viewport={{ once: true }} transition={{ duration: 0.7 }}>
            <h2 className="text-3xl sm:text-4xl font-medium text-white mb-6">Our Vision</h2>
            <p className="text-base text-white/50 leading-relaxed mb-4">
              CORTEX is an AI-powered academic assistant designed to transform how institutions operate. We make knowledge instantly accessible and automate repetitive tasks so educators and students can focus on what matters.
            </p>
            <p className="text-base text-white/50 leading-relaxed">
              By leveraging cutting-edge AI, we're building the future of smart, efficient, data-driven education.
            </p>
          </motion.div>
          <motion.div initial={{ opacity: 0, x: 30 }} whileInView={{ opacity: 1, x: 0 }} viewport={{ once: true }} transition={{ duration: 0.7 }} className="h-[360px] rounded-2xl overflow-hidden">
            <img src="https://static.prod-images.emergentagent.com/jobs/1296eb21-1271-4f60-9e68-2964495a4be3/images/5f8f5e7fba21b3611fb3f683934b97a20ec3aa603fe0c1e87da16e2ee7a79caf.png" alt="Academic Vision" className="w-full h-full object-cover opacity-60" />
          </motion.div>
        </div>
      </section>

      {/* Problem / Solution */}
      <section className="relative py-16 px-6">
        <div className="max-w-6xl mx-auto grid md:grid-cols-2 gap-6">
          <motion.div initial={{ opacity: 0, y: 30 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }}>
            <GlassmorphicCard className="p-8 h-full">
              <h3 className="text-2xl font-medium text-white mb-5">The Problem</h3>
              <ul className="space-y-3 text-white/50">
                {['Students waste hours searching through scattered PDFs', 'Academic data lives across disconnected systems', 'Teachers spend too much time on repetitive queries', 'No centralized knowledge management system'].map((t, i) => (
                  <li key={i} className="flex items-start"><span className="text-red-400 mr-2 mt-1">&bull;</span>{t}</li>
                ))}
              </ul>
            </GlassmorphicCard>
          </motion.div>
          <motion.div initial={{ opacity: 0, y: 30 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} transition={{ delay: 0.1 }}>
            <GlassmorphicCard className="p-8 h-full">
              <h3 className="text-2xl font-medium text-white mb-5">Our Solution</h3>
              <ul className="space-y-3 text-white/50">
                {['Instant answers through natural language chat', 'Centralized knowledge base with RAG technology', 'Automated query handling and workflow automation', 'Real-time analytics and performance tracking'].map((t, i) => (
                  <li key={i} className="flex items-start"><span className="text-green-400 mr-2 mt-1">&bull;</span>{t}</li>
                ))}
              </ul>
            </GlassmorphicCard>
          </motion.div>
        </div>
      </section>

      {/* Features */}
      <section className="relative py-16 px-6">
        <div className="max-w-6xl mx-auto">
          <h2 className="text-3xl font-medium text-white text-center mb-10">Key Features</h2>
          <motion.div variants={container} initial="hidden" whileInView="show" viewport={{ once: true }} className="grid md:grid-cols-3 gap-6">
            {features.map((f, i) => (
              <motion.div key={i} variants={item} whileHover={{ scale: 1.03 }}>
                <GlassmorphicCard className="p-6 text-center h-full">
                  <div className="w-14 h-14 mx-auto mb-4 rounded-xl bg-gradient-to-br from-cyan-400 to-blue-600 flex items-center justify-center">
                    <f.icon className="w-7 h-7 text-white" />
                  </div>
                  <h3 className="text-lg font-medium text-white mb-2">{f.title}</h3>
                  <p className="text-sm text-white/50">{f.description}</p>
                </GlassmorphicCard>
              </motion.div>
            ))}
          </motion.div>
        </div>
      </section>

      {/* Who It's For */}
      <section className="relative py-16 px-6">
        <div className="max-w-4xl mx-auto text-center">
          <h2 className="text-3xl font-medium text-white mb-10">Built For</h2>
          <motion.div variants={container} initial="hidden" whileInView="show" viewport={{ once: true }} className="grid md:grid-cols-3 gap-6">
            {personas.map((p, i) => (
              <motion.div key={i} variants={item} whileHover={{ scale: 1.04 }}>
                <div className="glass rounded-2xl p-6">
                  <p.icon className={`w-10 h-10 ${p.color} mx-auto mb-4`} />
                  <h3 className="text-lg font-medium text-white mb-1">{p.name}</h3>
                  <p className="text-sm text-white/50">{p.desc}</p>
                </div>
              </motion.div>
            ))}
          </motion.div>
        </div>
      </section>

      {/* Tech Stack */}
      <section className="relative py-16 px-6">
        <div className="max-w-6xl mx-auto text-center">
          <h2 className="text-3xl font-medium text-white mb-10">Powered By</h2>
          <motion.div variants={container} initial="hidden" whileInView="show" viewport={{ once: true }} className="grid md:grid-cols-3 gap-6">
            {techStack.map((t, i) => (
              <motion.div key={i} variants={item} whileHover={{ scale: 1.04 }}>
                <GlassmorphicCard className="p-8 text-center h-full">
                  <t.icon className="w-12 h-12 text-cyan-400 mx-auto mb-4" />
                  <h3 className="text-lg font-medium text-white mb-1">{t.name}</h3>
                  <p className="text-sm text-white/50">{t.description}</p>
                </GlassmorphicCard>
              </motion.div>
            ))}
          </motion.div>
        </div>
      </section>

      {/* CTA */}
      <section className="relative py-24 px-6">
        <div className="max-w-4xl mx-auto text-center">
          <h2 className="text-3xl font-medium text-white mb-6">Ready to Transform Your Institution?</h2>
          <GradientButton onClick={() => navigate('/select-role')} data-testid="about-cta-button" variant="primary" className="px-8 py-4 text-lg">
            Get Started with CORTEX
          </GradientButton>
        </div>
      </section>
    </div>
  );
};
