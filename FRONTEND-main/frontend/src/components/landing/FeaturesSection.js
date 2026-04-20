import React, { useEffect, useRef } from 'react';
import { GlassmorphicCard } from '../GlassmorphicCard';
import { MessageSquare, Database, BarChart3, Zap, Brain, GitMerge, Table2, Search, Globe, Shield } from 'lucide-react';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

gsap.registerPlugin(ScrollTrigger);

const features = [
  {
    icon: MessageSquare,
    category: 'CORE FEATURE',
    title: 'Chat Assistant',
    description:'Together AI\'s Llama 3.3 70B powers natural language understanding, reasoning, and generation for all conversational features.',
    color: 'from-cyan-400 to-blue-600',
  },
  {
    icon: Database,
    category: 'RAG-POWERED',
    title: 'Knowledge Base',
    description: 'A structured, searchable repository of department documents, lecture notes, research papers, and FAQs — continuously updated and indexed for instant retrieval.',
    color: 'from-blue-600 to-purple-600',
  },
  {
    icon: BarChart3,
    category: 'LIVE DATA',
    title: 'Analytics',
    description: 'Real-time dashboards showing query volume, resolution rates, popular topics, and user engagement — giving faculty and admins actionable insights.',
    color: 'from-purple-500 to-pink-600',
  },
  {
    icon: Zap,
    category: 'WORKFLOW',
    title: 'Automation',
    description: 'Automate repetitive tasks — schedule reminders, generate report summaries, send notifications, and integrate with department systems via SQL and APIs.',
    color: 'from-orange-400 to-cyan-400',
  },
];

const techStack = [
  {
    icon: Brain,
    category: 'LANGUAGE MODEL',
    title: 'Llama 3.3 70B',
    description: 'Meta\'s Llama 3.3 70B via Groq powers natural language understanding, reasoning, and generation for all conversational features.',
    color: 'from-blue-500 to-cyan-400',
  },
  {
    icon: GitMerge,
    category: 'RETRIEVAL SYSTEM',
    title: 'RAG Pipeline',
    description: 'Retrieval-Augmented Generation ensures every answer is grounded in verified department documents, not hallucinated.',
    color: 'from-purple-500 to-pink-500',
  },
  {
    icon: Table2,
    category: 'DATA LAYER',
    title: 'SQL Integration',
    description: 'Direct integration with department databases for real-time student records, course data, and administrative queries.',
    color: 'from-pink-500 to-purple-600',
  },
  {
    icon: Search,
    category: 'EMBEDDINGS',
    title: 'Vector Search',
    description: 'Semantic similarity search across thousands of documents in milliseconds using dense vector embeddings via FAISS + BM25.',
    color: 'from-orange-500 to-pink-500',
  },
  {
    icon: Globe,
    category: 'INTEGRATION',
    title: 'REST APIs',
    description: 'Open API endpoints for integration with LMS platforms, student portals, and third-party academic tools.',
    color: 'from-cyan-400 to-blue-500',
  },
  {
    icon: Shield,
    category: 'SECURITY',
    title: 'Role-Based Auth',
    description: 'Granular permission system ensuring students, faculty, and admins see only what they are authorized to access.',
    color: 'from-emerald-400 to-cyan-500',
  },
];

export const FeaturesSection = () => {
  const sectionRef = useRef(null);
  const techRef = useRef(null);

  useEffect(() => {
    const cards = sectionRef.current?.querySelectorAll('.feature-card');
    if (cards) {
      gsap.fromTo(cards,
        { opacity: 0, y: 50 },
        { opacity: 1, y: 0, duration: 0.8, stagger: 0.15, ease: 'power3.out', scrollTrigger: { trigger: sectionRef.current, start: 'top 80%' } }
      );
    }

    const techCards = techRef.current?.querySelectorAll('.tech-card');
    if (techCards) {
      gsap.fromTo(techCards,
        { opacity: 0, y: 50 },
        { opacity: 1, y: 0, duration: 0.8, stagger: 0.1, ease: 'power3.out', scrollTrigger: { trigger: techRef.current, start: 'top 80%' } }
      );
    }
  }, []);

  return (
    <>
      {/* ── Capabilities Section ── */}
      <section ref={sectionRef} className="relative py-24 px-6" data-testid="features-section">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-16">
            <div className="inline-flex items-center px-4 py-1.5 rounded-full border border-white/10 bg-white/5 text-xs font-semibold text-white/60 uppercase tracking-widest mb-6">
              Capabilities
            </div>
            <h2 className="text-4xl sm:text-5xl font-bold text-white mb-4">
              Everything your department needs,{' '}
              <span className="bg-gradient-to-r from-cyan-400 to-purple-500 bg-clip-text text-transparent">
                in one place
              </span>
            </h2>
            <p className="text-lg text-white/50 max-w-2xl mx-auto">
              Four interconnected systems working together to make academic life smarter.
            </p>
          </div>

          {/* 4 cards in one row */}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
            {features.map((feature, index) => (
              <GlassmorphicCard
                key={index}
                hover
                data-testid={`feature-card-${index}`}
                className="feature-card p-6 cursor-pointer flex flex-col gap-4"
              >
                <div className={`w-12 h-12 rounded-xl bg-gradient-to-br ${feature.color} flex items-center justify-center flex-shrink-0`}>
                  <feature.icon className="w-6 h-6 text-white" />
                </div>
                <div>
                  <p className="text-[10px] font-bold text-white/30 uppercase tracking-widest mb-1">{feature.category}</p>
                  <h3 className="text-lg font-semibold text-white mb-2">{feature.title}</h3>
                  <p className="text-sm text-white/50 leading-relaxed">{feature.description}</p>
                </div>
              </GlassmorphicCard>
            ))}
          </div>
        </div>
      </section>

      {/* ── Under the Hood Section ── */}
      <section ref={techRef} className="relative py-24 px-6">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-16">
            <div className="inline-flex items-center px-4 py-1.5 rounded-full border border-white/10 bg-white/5 text-xs font-semibold text-white/60 uppercase tracking-widest mb-6">
              Under the Hood
            </div>
            <h2 className="text-4xl sm:text-5xl font-bold text-white mb-4">
              Built on production-grade{' '}
              <span className="bg-gradient-to-r from-cyan-400 to-purple-500 bg-clip-text text-transparent">
                AI infrastructure
              </span>
            </h2>
            <p className="text-lg text-white/50 max-w-2xl mx-auto">
              Enterprise-ready stack designed for reliability, accuracy, and scale.
            </p>
          </div>

          {/* 3x2 grid */}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
            {techStack.map((tech, index) => (
              <GlassmorphicCard
                key={index}
                hover
                className="tech-card p-6 cursor-pointer flex items-start gap-4"
              >
                <div className={`w-12 h-12 rounded-xl bg-gradient-to-br ${tech.color} flex items-center justify-center flex-shrink-0`}>
                  <tech.icon className="w-6 h-6 text-white" />
                </div>
                <div>
                  <p className="text-[10px] font-bold text-white/30 uppercase tracking-widest mb-1">{tech.category}</p>
                  <h3 className="text-base font-semibold text-white mb-1.5">{tech.title}</h3>
                  <p className="text-sm text-white/50 leading-relaxed">{tech.description}</p>
                </div>
              </GlassmorphicCard>
            ))}
          </div>
        </div>
      </section>
    </>
  );
};