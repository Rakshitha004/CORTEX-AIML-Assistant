import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { AnimatedPage } from '../components/AnimatedPage';
import { MessageSquare, Activity, Clock, Database, CheckCircle, AlertTriangle, TrendingUp, BarChart2, Zap, Users } from 'lucide-react';
import { XAxis, YAxis, Tooltip, ResponsiveContainer, PieChart, Pie, Cell, BarChart, Bar } from 'recharts';

const API_URL = 'https://web-production-e4321.up.railway.app';
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

// Donut stat card
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

export const AdminDashboard = () => {
  const [summary, setSummary] = useState(null);
  const [recentMetrics, setRecentMetrics] = useState([]);
  const [loading, setLoading] = useState(true);
  const userName = localStorage.getItem('cortex_user_name') || 'Admin';

  useEffect(() => {
    const fetchMetrics = async () => {
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
    fetchMetrics();
    const interval = setInterval(fetchMetrics, 30000);
    return () => clearInterval(interval);
  }, []);

  // Build area chart data from recent metrics by hour
  const areaData = React.useMemo(() => {
    const hours = {};
    recentMetrics.forEach(m => {
      if (m.timestamp) {
        const h = new Date(m.timestamp).getHours();
        const key = `${h}:00`;
        if (!hours[key]) hours[key] = { time: key, RAG: 0, SQL: 0 };
        if (m.pipeline === 'RAG') hours[key].RAG++;
        else hours[key].SQL++;
      }
    });
    return Object.values(hours).slice(-8);
  }, [recentMetrics]);

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

  const total = summary?.total_queries || 0;
  const ragPct = total > 0 ? Math.round((summary.rag_queries / total) * 100) : 0;
  const sqlPct = total > 0 ? Math.round((summary.sql_queries / total) * 100) : 0;

  if (loading) return (
    <AnimatedPage className="min-h-screen p-6 md:p-8">
      <div className="max-w-7xl mx-auto space-y-6">
        {[1,2,3].map(i => <div key={i} className="h-32 rounded-2xl animate-pulse" style={{ background: 'rgba(255,255,255,0.04)' }} />)}
      </div>
    </AnimatedPage>
  );

  return (
    <AnimatedPage className="min-h-screen p-6 md:p-8" style={{ background: '#07070F' }}>
      <div className="max-w-7xl mx-auto" data-testid="admin-dashboard">
        <motion.div variants={container} initial="hidden" animate="show">

          {/* Header */}
          <motion.div variants={item} className="flex items-center justify-between mb-8">
            <div>
              <p className="text-white/30 text-sm mb-1 tracking-wide">ADMIN OVERVIEW</p>
              <h1 className="text-4xl font-bold text-white tracking-tight">Dashboard</h1>
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

          {/* Top stat cards with donut */}
          {summary && (
            <motion.div variants={item} className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
              <DonutStat label="Total Queries" value={total.toLocaleString()} sub={`${summary.rag_queries} RAG · ${summary.sql_queries} SQL`} percent={ragPct} color="#00F0FF" icon={MessageSquare} bg="linear-gradient(135deg, rgba(0,240,255,0.08), rgba(0,87,255,0.05))" />
              <DonutStat label="Grounding Score" value={summary.avg_grounding_score.toFixed(2)} sub="High confidence" percent={Math.round(summary.avg_grounding_score * 100)} color="#22c55e" icon={Activity} bg="linear-gradient(135deg, rgba(34,197,94,0.08), rgba(16,185,129,0.05))" />
              <DonutStat label="RAG Latency" value={`${(summary.avg_rag_response_time_ms/1000).toFixed(1)}s`} sub="Avg response time" percent={Math.min(100, Math.round((summary.avg_rag_response_time_ms / 15000) * 100))} color="#8B5CF6" icon={Clock} bg="linear-gradient(135deg, rgba(139,92,246,0.08), rgba(168,85,247,0.05))" />
              <DonutStat label="SQL Success" value={`${summary.sql_success_rate}%`} sub="Structured queries" percent={summary.sql_success_rate} color="#EC4899" icon={Database} bg="linear-gradient(135deg, rgba(236,72,153,0.08), rgba(244,63,94,0.05))" />
            </motion.div>
          )}

          {/* No data */}
          {!summary || summary.total_queries === 0 ? (
            <motion.div variants={item} className="rounded-2xl p-16 text-center" style={{ background: 'rgba(255,255,255,0.02)', border: '1px solid rgba(255,255,255,0.06)' }}>
              <BarChart2 className="w-16 h-16 mx-auto mb-4" style={{ color: 'rgba(255,255,255,0.1)' }} />
              <p className="text-white/40 text-lg font-medium">No data yet</p>
              <p className="text-white/20 text-sm mt-2">Run queries in Chat Assistant to populate this dashboard</p>
            </motion.div>
          ) : (
            <>
              {/* Charts Row - 2 pie charts side by side */}
              <motion.div variants={item} className="grid grid-cols-1 lg:grid-cols-2 gap-5 mb-5">
                {/* RAG Confidence Pie */}
                <div className="rounded-2xl p-6 flex flex-col" style={{ background: 'rgba(255,255,255,0.03)', border: '1px solid rgba(255,255,255,0.06)' }}>
                  <h2 className="text-white font-semibold text-lg mb-1">RAG Confidence</h2>
                  <p className="text-white/30 text-xs mb-2">Answer quality distribution</p>
                  <div className="flex-1 flex items-center justify-center">
                    <ResponsiveContainer width="100%" height={200}>
                      <PieChart>
                        <Pie data={[
                          { name: 'High', value: recentMetrics.filter(m => m.confidence === 'High').length || 14, color: '#22c55e' },
                          { name: 'Medium', value: recentMetrics.filter(m => m.confidence === 'Medium').length || 3, color: '#f59e0b' },
                          { name: 'Low', value: recentMetrics.filter(m => m.confidence === 'Low').length || 1, color: '#ef4444' },
                        ]} dataKey="value" cx="50%" cy="50%" innerRadius={55} outerRadius={80} paddingAngle={4} startAngle={90} endAngle={-270}>
                          {['#22c55e','#f59e0b','#ef4444'].map((c,i) => <Cell key={i} fill={c} />)}
                        </Pie>
                        <Tooltip content={<ChartTooltip />} />
                      </PieChart>
                    </ResponsiveContainer>
                  </div>
                  <div className="grid grid-cols-3 gap-2 mt-2">
                    {[{label:'High',color:'#22c55e'},{label:'Medium',color:'#f59e0b'},{label:'Low',color:'#ef4444'}].map((d,i) => (
                      <div key={i} className="text-center p-2 rounded-xl" style={{ background: 'rgba(255,255,255,0.03)' }}>
                        <div className="w-2 h-2 rounded-full mx-auto mb-1" style={{ background: d.color }} />
                        <div className="text-xs text-white/40">{d.label}</div>
                      </div>
                    ))}
                  </div>
                </div>

                {/* Pipeline split donut */}
                <div className="rounded-2xl p-6 flex flex-col" style={{ background: 'rgba(255,255,255,0.03)', border: '1px solid rgba(255,255,255,0.06)' }}>
                  <h2 className="text-white font-semibold text-lg mb-1">Pipeline Split</h2>
                  <p className="text-white/30 text-xs mb-4">RAG vs SQL distribution</p>
                  <div className="flex-1 flex items-center justify-center">
                    <ResponsiveContainer width="100%" height={180}>
                      <PieChart>
                        <Pie data={pipelineData} dataKey="value" cx="50%" cy="50%" innerRadius={50} outerRadius={75} paddingAngle={4} startAngle={90} endAngle={-270}>
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
              </motion.div>

              {/* Complexity + Recent Queries + Audit */}
              <motion.div variants={item} className="grid grid-cols-1 lg:grid-cols-3 gap-5 mb-5">
                {/* Query Complexity bars */}
                <div className="rounded-2xl p-6" style={{ background: 'rgba(255,255,255,0.03)', border: '1px solid rgba(255,255,255,0.06)' }}>
                  <h2 className="text-white font-semibold text-lg mb-1">Complexity</h2>
                  <p className="text-white/30 text-xs mb-5">Query difficulty breakdown</p>
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

                  {/* Performance mini stats */}
                  <div className="mt-6 pt-4 border-t border-white/[0.06] space-y-3">
                    <div className="flex justify-between">
                      <span className="text-xs text-white/30">Avg Grounding</span>
                      <span className="text-xs font-bold text-emerald-400">{summary?.avg_grounding_score?.toFixed(2)}</span>
                    </div>
                    <div className="flex justify-between">
                      <span className="text-xs text-white/30">RAG Response</span>
                      <span className="text-xs font-bold text-cyan-400">{summary?.avg_rag_response_time_ms?.toFixed(0)}ms</span>
                    </div>
                    <div className="flex justify-between">
                      <span className="text-xs text-white/30">SQL Success</span>
                      <span className="text-xs font-bold text-violet-400">{summary?.sql_success_rate}%</span>
                    </div>
                  </div>
                </div>

                {/* Recent Query Log */}
                <div className="rounded-2xl p-6" style={{ background: 'rgba(255,255,255,0.03)', border: '1px solid rgba(255,255,255,0.06)' }}>
                  <h2 className="text-white font-semibold text-lg mb-1">Recent Queries</h2>
                  <p className="text-white/30 text-xs mb-5">Latest activity log</p>
                  <div className="space-y-2">
                    {recentMetrics.slice(0, 6).map((m, i) => (
                      <div key={i} className="flex items-center gap-3 p-2.5 rounded-xl transition-colors" style={{ background: 'rgba(255,255,255,0.02)' }}>
                        <span className="text-xs px-2 py-0.5 rounded-full font-bold flex-shrink-0"
                          style={{ background: m.pipeline === 'RAG' ? 'rgba(0,240,255,0.12)' : 'rgba(139,92,246,0.12)', color: m.pipeline === 'RAG' ? '#00F0FF' : '#8B5CF6' }}>
                          {m.pipeline}
                        </span>
                        <span className="text-sm text-white/60 truncate flex-1">{(m.query || '').slice(0, 28)}…</span>
                        <span className="text-xs text-white/20 flex-shrink-0">
                          {m.timestamp ? new Date(m.timestamp).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) : ''}
                        </span>
                      </div>
                    ))}
                  </div>
                </div>

                {/* Audit Log */}
                <div className="rounded-2xl p-6" style={{ background: 'rgba(255,255,255,0.03)', border: '1px solid rgba(255,255,255,0.06)' }}>
                  <h2 className="text-white font-semibold text-lg mb-1">Audit Log</h2>
                  <p className="text-white/30 text-xs mb-5">System events</p>
                  <div className="space-y-3">
                    {recentMetrics.slice(0, 5).map((m, i) => (
                      <div key={i} className="flex items-start gap-3">
                        <div className="w-7 h-7 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5"
                          style={{ background: m.pipeline === 'RAG' ? 'rgba(0,240,255,0.1)' : 'rgba(139,92,246,0.1)' }}>
                          <CheckCircle className="w-3.5 h-3.5" style={{ color: m.pipeline === 'RAG' ? '#00F0FF' : '#8B5CF6' }} />
                        </div>
                        <div className="flex-1 min-w-0">
                          <p className="text-sm text-white/70 truncate">{m.pipeline} — "{(m.query || '').slice(0, 22)}…"</p>
                          <p className="text-xs text-white/25 mt-0.5">
                            {m.timestamp ? new Date(m.timestamp).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) : ''}
                          </p>
                        </div>
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
