import React, { useEffect, useRef, useState } from 'react';
import { GlassmorphicCard } from '../GlassmorphicCard';
import { User, Bot } from 'lucide-react';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

gsap.registerPlugin(ScrollTrigger);

const demoMessages = [
  { text: 'What are the office hours for Prof. Smith?', isUser: true },
  { text: 'Prof. Smith\'s office hours are Monday and Wednesday, 2-4 PM in Room 305.', isUser: false },
  { text: 'Can you summarize the syllabus for CS101?', isUser: true },
  { text: 'CS101 covers programming fundamentals, data structures, algorithms, and includes 3 projects and a final exam.', isUser: false },
];

export const DemoPreview = () => {
  const sectionRef = useRef(null);
  const [displayedMessages, setDisplayedMessages] = useState([]);
  const [currentIndex, setCurrentIndex] = useState(0);
  const [typingText, setTypingText] = useState('');
  const [isTyping, setIsTyping] = useState(false);
  const typingTimeoutRef = useRef(null);
  
  useEffect(() => {
    if (sectionRef.current) {
      gsap.fromTo(
        sectionRef.current,
        { opacity: 0, y: 50 },
        {
          opacity: 1,
          y: 0,
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
  
  useEffect(() => {
    if (currentIndex < demoMessages.length) {
      const message = demoMessages[currentIndex];
      
      if (message.isUser) {
        // User messages appear instantly
        setDisplayedMessages(prev => [...prev, { ...message, fullText: message.text }]);
        setCurrentIndex(prev => prev + 1);
      } else {
        // AI messages type out
        setIsTyping(true);
        let charIndex = 0;
        const typeChar = () => {
          if (charIndex < message.text.length) {
            setTypingText(message.text.substring(0, charIndex + 1));
            charIndex++;
            typingTimeoutRef.current = setTimeout(typeChar, 30);
          } else {
            setDisplayedMessages(prev => [...prev, { ...message, fullText: message.text }]);
            setTypingText('');
            setIsTyping(false);
            setCurrentIndex(prev => prev + 1);
          }
        };
        
        setTimeout(() => {
          typeChar();
        }, 800);
      }
    } else {
      // Reset after all messages
      const resetTimer = setTimeout(() => {
        setDisplayedMessages([]);
        setCurrentIndex(0);
        setTypingText('');
        setIsTyping(false);
      }, 4000);
      
      return () => clearTimeout(resetTimer);
    }
    
    return () => {
      if (typingTimeoutRef.current) {
        clearTimeout(typingTimeoutRef.current);
      }
    };
  }, [currentIndex]);
  
  return (
    <section ref={sectionRef} className="relative py-24 px-6" data-testid="demo-preview-section">
      <div className="max-w-4xl mx-auto">
        <div className="text-center mb-12">
          <h2 className="text-3xl sm:text-4xl font-medium text-white mb-4">
            See CORTEX in Action
          </h2>
          <p className="text-lg text-white/60">
            Watch how CORTEX understands and responds to natural language queries.
          </p>
        </div>
        
        <GlassmorphicCard className="p-8 relative overflow-hidden">
          {/* Animated gradient background */}
          <div className="absolute inset-0 opacity-10 pointer-events-none">
            <div className="absolute top-0 right-0 w-64 h-64 bg-cyan-400 rounded-full blur-3xl animate-glow" />
            <div className="absolute bottom-0 left-0 w-64 h-64 bg-purple-600 rounded-full blur-3xl animate-glow" style={{ animationDelay: '1.5s' }} />
          </div>
          
          <div className="space-y-4 min-h-[300px] relative z-10">
            {displayedMessages.map((msg, index) => (
              <div
                key={index}
                data-testid={`demo-message-${index}`}
                className={`flex items-start space-x-3 animate-in fade-in slide-in-from-bottom-4 duration-500 ${
                  msg.isUser ? 'flex-row-reverse space-x-reverse' : ''
                }`}
              >
                <div
                  className={`flex-shrink-0 w-10 h-10 rounded-full flex items-center justify-center ${
                    msg.isUser
                      ? 'bg-gradient-to-br from-cyan-400 to-blue-600'
                      : 'bg-gradient-to-br from-purple-500 to-pink-600'
                  }`}
                >
                  {msg.isUser ? <User className="w-5 h-5 text-white" /> : <Bot className="w-5 h-5 text-white" />}
                </div>
                
                <div
                  className={`glass rounded-2xl px-4 py-3 max-w-[80%] ${
                    msg.isUser ? 'rounded-tr-sm' : 'rounded-tl-sm'
                  }`}
                >
                  <p className="text-white text-sm leading-relaxed">
                    {msg.fullText}
                  </p>
                </div>
              </div>
            ))}
            
            {isTyping && typingText && (
              <div className="flex items-start space-x-3">
                <div className="flex-shrink-0 w-10 h-10 rounded-full bg-gradient-to-br from-purple-500 to-pink-600 flex items-center justify-center">
                  <Bot className="w-5 h-5 text-white" />
                </div>
                <div className="glass rounded-2xl rounded-tl-sm px-4 py-3 max-w-[80%]">
                  <p className="text-white text-sm leading-relaxed">
                    {typingText}
                    <span className="inline-block w-0.5 h-4 bg-cyan-400 ml-0.5 animate-pulse" />
                  </p>
                </div>
              </div>
            )}
            
            {currentIndex < demoMessages.length && !isTyping && displayedMessages.length > 0 && !demoMessages[currentIndex].isUser && (
              <div className="flex items-start space-x-3" data-testid="typing-indicator">
                <div className="flex-shrink-0 w-10 h-10 rounded-full bg-gradient-to-br from-purple-500 to-pink-600 flex items-center justify-center">
                  <Bot className="w-5 h-5 text-white" />
                </div>
                <div className="glass rounded-2xl rounded-tl-sm px-4 py-3">
                  <div className="flex space-x-2">
                    <div className="w-2 h-2 rounded-full bg-white/60 animate-bounce" style={{ animationDelay: '0ms' }} />
                    <div className="w-2 h-2 rounded-full bg-white/60 animate-bounce" style={{ animationDelay: '150ms' }} />
                    <div className="w-2 h-2 rounded-full bg-white/60 animate-bounce" style={{ animationDelay: '300ms' }} />
                  </div>
                </div>
              </div>
            )}
          </div>
        </GlassmorphicCard>
      </div>
    </section>
  );
};
