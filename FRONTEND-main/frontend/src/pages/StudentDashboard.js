import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { AnimatedPage } from '../components/AnimatedPage';
import { MessageSquare, Activity, Clock, Database, CheckCircle, TrendingUp, BarChart2 } from 'lucide-react';
import { PieChart, Pie, Cell, Tooltip, ResponsiveContainer, BarChart, Bar, XAxis, YAxis } from 'recharts';

const API_URL = 'http://localhost:8000';
const getToken = () => localStorage.getItem('cortex_token');

const container = { hidden: {}, show: { transition: { staggerChildren: 0.08 } } };
const item = { hidden: { opacity: 0, y: 24 }, show: { opacity: 1, y: 0, transition: { duration: 0.5, ease: 'easeOut' } } };

const ChartTooltip = ({ active, payload, label }) => {
  if (active && payload?.length) return (
    <div style={{ background: 'rgba(15,15,30,0.95)', border: '1px solid rgba(255,255,255,0.1)', borderRadius: 10, padding: '8px 14px' }}>
      <p style={{ color: 'rgba(255,255,255,0.5)', fontSize: 11 }}>{label}</p>
      <p style={{ color: '#fff', fontSize: 13, fontWeight: 700 }}>{payload[0].value}</p>
    </div>
  );
  return null;
};

const DonutStat = ({ label, value, sub, percent, color, icon: Icon, bg }) => {
  const r = 28, circ = 2 * Math.PI * r;
  const dash = (percent / 100) * circ;
  return (
    <motion.div whileHover={{ y: -4 }} transition={{ duration: 0.2 }}
      className="rounded-2xl p-5 flex items-center gap-4 relative overflow-hidden"
      style={{ background: bg, border: '1px solid rgba(255,255,255,0.06)' }}>
      <div className="relative flex-shrink-0">
        <svg width={70} height={70}>
          <circle cx={35} cy={35} r={r} fill="none" stroke="rgba(255,255,255,0.08)" strokeWidth={5} />
          <circle cx={35} cy={35} r={r} fill="none" stroke={color} strokeWidth={5}
            strokeDasharray={`${dash} ${circ}`} strokeLinecap="round"
            transform="rotate(-90 35 35)" />
        </svg>
        <div className="absolute inset-0 flex items-center justify-center">
          <Icon className="w-5 h-5" style={{ color }} />
        </div>
      </div>
      <div>
        <div className="text-xs text-white/40 mb-1">{label}</div>
        <div className="text-2xl font-bold text-white">{value}</div>
        <div className="text-xs mt-0.5" style={{ color }}>{sub}</div>
      </div>
      <div className="absolute top-4 right-4 text-xs font-bold" style={{ color }}>{percent}%</div>
    </motion.div>
  );
};

// Filter out background system queries
const isSystemQuery = (query) => {
  if (!query) return true;
  const systemPrefixes = [
    'what is the cgpa of student with email',
    'show all semester sgpa for student with usn',
    'show all grades of student with usn',
    'what is cgpa of student with usn',
    'show all students with their cgpa',
  ];
  return systemPrefixes.some(prefix => query.toLowerCase().startsWith(prefix.toLowerCase()));
};

export const StudentDashboard = () => {
  const [summary, setSummary] = useState(null);
  const [recentMetrics, setRecentMetrics] = useState([]);
  const [loading, setLoading] = useState(true);
  const userName = localStorage.getItem('cortex_user_name') || 'Student';

  useEffect(() => {
    const fetchData = async () => {
      try {
        const token = getToken();
        const headers = { Authorization: `Bearer ${token}` };
        const [summaryRes, recentRes] = await Promise.all([
          fetch(`${API_URL}/metrics/summary`, { headers }),
          fetch(`${API_URL}/metrics/recent`, { headers }),
        ]);
        if (summaryRes.ok) setSummary(await summaryRes.json());
        if (recentRes.ok) { const d = await recentRes.json(); setRecentMetrics(d.metrics || []); }
      } catch (e) { console.error(e); } finally { setLoading(false); }
    };
    fetchData();
  }, []);

  const total = summary?.total_queries || 0;
  const ragPct = total > 0 ? Math.round((summary.rag_queries / total) * 100) : 0;
  const sqlPct = total > 0 ? Math.round((summary.sql_queries / total) * 100) : 0;

  const pipelineData = summary ? [
    { name: 'RAG', value: summary.rag_queries, color: '#00F0FF' },
    { name: 'SQL', value: summary.sql_queries, color: '#8B5CF6' },
  ] : [];

  const complexityCounts = { Simple: 0, Medium: 0, Complex: 0 };
  recentMetrics.forEach(m => { if (m.query_complexity) complexityCounts[m.query_complexity]++; });
  const complexityData = [
    { name: 'Simple', v: complexityCounts.Simple, color: '#00F0FF' },
    { name: 'Medium', v: complexityCounts.Medium, color: '#8B5CF6' },
    { name: 'Complex', v: complexityCounts.Complex, color: '#EC4899' },
  ];

  // Filter out system queries for display
  const userQueries = recentMetrics.filter(m => !isSystemQuery(m.query));

  if (loading) return (
    <AnimatedPage className="min-h-screen p-6 md:p-8">
      <div className="max-w-7xl mx-auto space-y-6">
        {[1,2,3].map(i => <div key={i} className="h-32 rounded-2xl animate-pulse" style={{ background: 'rgba(255,255,255,0.04)' }} />)}
      </div>
    </AnimatedPage>
  );

  return (
    <AnimatedPage className="min-h-screen p-6 md:p-8" style={{ background: '#07070F' }}>
      <div className="max-w-7xl mx-auto" data-testid="student-dashboard">
        <motion.div variants={container} initial="hidden" animate="show">

          {/* Header */}
          <motion.div variants={item} className="flex items-center justify-between mb-8">
            <div>
              <p className="text-white/30 text-sm mb-1 tracking-wide">STUDENT OVERVIEW</p>
              <h1 className="text-4xl font-bold text-white tracking-tight">Hi, {userName}! 👋</h1>
              <p className="text-white/30 text-sm mt-1">Your activity dashboard</p>
            </div>
            <div className="flex items-center gap-3">
              <div className="flex items-center gap-2 px-3 py-1.5 rounded-full" style={{ background: 'rgba(34,197,94,0.1)', border: '1px solid rgba(34,197,94,0.2)' }}>
                <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse" />
                <span className="text-xs text-emerald-400 font-medium">Live</span>
              </div>
              <div className="w-10 h-10 rounded-xl flex items-center justify-center text-white font-bold text-sm" style={{ background: 'linear-gradient(135deg, #00F0FF, #0057FF)' }}>
                {userName.charAt(0).toUpperCase()}
              </div>
            </div>
          </motion.div>

          {/* Stat Cards */}
          {summary && (
            <motion.div variants={item} className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
              <DonutStat label="Total Queries" value={userQueries.length} sub={`Your questions to CORTEX`} percent={ragPct || 0} color="#00F0FF" icon={MessageSquare} bg="linear-gradient(135deg, rgba(0,240,255,0.08), rgba(0,87,255,0.05))" />
              <DonutStat label="Grounding Score" value={summary.avg_grounding_score?.toFixed(2)} sub="Answer quality" percent={Math.round((summary.avg_grounding_score || 0) * 100)} color="#22c55e" icon={Activity} bg="linear-gradient(135deg, rgba(34,197,94,0.08), rgba(16,185,129,0.05))" />
              <DonutStat label="RAG Queries" value={summary.rag_queries} sub="Knowledge queries" percent={ragPct || 0} color="#8B5CF6" icon={Clock} bg="linear-gradient(135deg, rgba(139,92,246,0.08), rgba(168,85,247,0.05))" />
              <DonutStat label="SQL Queries" value={summary.sql_queries} sub="Data queries" percent={sqlPct || 0} color="#EC4899" icon={Database} bg="linear-gradient(135deg, rgba(236,72,153,0.08), rgba(244,63,94,0.05))" />
            </motion.div>
          )}

          {/* No data state */}
          {!summary || userQueries.length === 0 ? (
            <motion.div variants={item} className="rounded-2xl p-16 text-center" style={{ background: 'rgba(255,255,255,0.02)', border: '1px solid rgba(255,255,255,0.06)' }}>
              <BarChart2 className="w-16 h-16 mx-auto mb-4" style={{ color: 'rgba(255,255,255,0.1)' }} />
              <p className="text-white/40 text-lg font-medium">No activity yet</p>
              <p className="text-white/20 text-sm mt-2">Start asking questions in Chat Assistant!</p>
            </motion.div>
          ) : (
            <>
              {/* Pipeline Split + Complexity */}
              <motion.div variants={item} className="grid grid-cols-1 lg:grid-cols-2 gap-5 mb-5">
                {/* Pipeline Donut */}
                <div className="rounded-2xl p-6" style={{ background: 'rgba(255,255,255,0.03)', border: '1px solid rgba(255,255,255,0.06)' }}>
                  <h2 className="text-white font-semibold text-lg mb-1">Query Pipeline Split</h2>
                  <p className="text-white/30 text-xs mb-4">RAG vs SQL distribution</p>
                  <div className="flex items-center justify-center">
                    <ResponsiveContainer width="100%" height={180}>
                      <PieChart>
                        <Pie data={pipelineData} dataKey="value" cx="50%" cy="50%" innerRadius={50} outerRadius={75} paddingAngle={4}>
                          {pipelineData.map((e, i) => <Cell key={i} fill={e.color} />)}
                        </Pie>
                        <Tooltip content={<ChartTooltip />} />
                      </PieChart>
                    </ResponsiveContainer>
                  </div>
                  <div className="space-y-3 mt-2">
                    {pipelineData.map((d, i) => (
                      <div key={i} className="flex items-center justify-between">
                        <div className="flex items-center gap-2">
                          <div className="w-2.5 h-2.5 rounded-full" style={{ background: d.color }} />
                          <span className="text-sm text-white/60">{d.name} Queries</span>
                        </div>
                        <span className="text-sm font-bold text-white">{d.value}</span>
                      </div>
                    ))}
                    <div className="pt-2 border-t border-white/[0.06] flex items-center justify-between">
                      <span className="text-xs text-white/30">Total</span>
                      <span className="text-sm font-bold text-white">{total}</span>
                    </div>
                  </div>
                </div>

                {/* Query Complexity */}
                <div className="rounded-2xl p-6" style={{ background: 'rgba(255,255,255,0.03)', border: '1px solid rgba(255,255,255,0.06)' }}>
                  <h2 className="text-white font-semibold text-lg mb-1">Query Complexity</h2>
                  <p className="text-white/30 text-xs mb-5">Breakdown of your questions</p>
                  <div className="space-y-4">
                    {complexityData.map((c, i) => {
                      const max = Math.max(...complexityData.map(x => x.v)) || 1;
                      const pct = Math.round((c.v / max) * 100);
                      return (
                        <div key={i}>
                          <div className="flex justify-between mb-1.5">
                            <span className="text-sm text-white/60">{c.name}</span>
                            <span className="text-sm font-bold text-white">{c.v}</span>
                          </div>
                          <div className="h-2 rounded-full" style={{ background: 'rgba(255,255,255,0.06)' }}>
                            <motion.div initial={{ width: 0 }} animate={{ width: `${pct}%` }} transition={{ duration: 1, delay: i * 0.1 }}
                              className="h-full rounded-full" style={{ background: c.color }} />
                          </div>
                        </div>
                      );
                    })}
                  </div>
                </div>
              </motion.div>

              {/* Recent Queries */}
              <motion.div variants={item}>
                <div className="rounded-2xl p-6" style={{ background: 'rgba(255,255,255,0.03)', border: '1px solid rgba(255,255,255,0.06)' }}>
                  <h2 className="text-white font-semibold text-lg mb-1">Recent Queries</h2>
                  <p className="text-white/30 text-xs mb-5">Your latest activity</p>
                  <div className="space-y-2">
                    {userQueries.slice(0, 8).map((m, i) => (
                      <div key={i} className="flex items-center gap-3 p-2.5 rounded-xl" style={{ background: 'rgba(255,255,255,0.02)' }}>
                        <span className="text-xs px-2 py-0.5 rounded-full font-bold flex-shrink-0"
                          style={{ background: m.pipeline === 'RAG' ? 'rgba(0,240,255,0.12)' : 'rgba(139,92,246,0.12)', color: m.pipeline === 'RAG' ? '#00F0FF' : '#8B5CF6' }}>
                          {m.pipeline}
                        </span>
                        <span className="text-sm text-white/60 truncate flex-1">{(m.query || '').slice(0, 50)}</span>
                        <span className="text-xs text-white/20 flex-shrink-0">
                          {m.timestamp ? new Date(m.timestamp).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) : ''}
                        </span>
                      </div>
                    ))}
                  </div>
                </div>
              </motion.div>
            </>
          )}
        </motion.div>
      </div>
    </AnimatedPage>
  );
};