import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { AnimatedPage } from '../components/AnimatedPage';
import { GlassmorphicCard } from '../components/GlassmorphicCard';
import { MessageSquare, Clock, CheckCircle, AlertTriangle, Info, Search, RefreshCw, Loader2, Database, Activity } from 'lucide-react';

const API_URL = 'https://web-production-e4321.up.railway.app';
const getToken = () => localStorage.getItem('cortex_token');

const SYSTEM_PREFIXES = [
  'what is the cgpa of student with email',
  'show all semester sgpa for student with usn',
  'show all grades of student with usn',
  'what is cgpa of student with usn',
  'show all students with their cgpa',
];

const isSystemQuery = (query) => {
  if (!query) return true;
  return SYSTEM_PREFIXES.some(p => query.toLowerCase().startsWith(p.toLowerCase()));
};

const statusIcon = (s) => {
  if (s === 'success' || s === true) return <CheckCircle className="w-4 h-4 text-green-400" />;
  if (s === 'warning') return <AlertTriangle className="w-4 h-4 text-yellow-400" />;
  return <AlertTriangle className="w-4 h-4 text-red-400" />;
};

export const AuditLogsPage = () => {
  const [searchQuery, setSearchQuery] = useState('');
  const [chats, setChats] = useState([]);
  const [metrics, setMetrics] = useState([]);
  const [summary, setSummary] = useState(null);
  const [loading, setLoading] = useState(true);
  const [activeTab, setActiveTab] = useState('queries');

  const loadData = async () => {
    setLoading(true);
    try {
      const token = getToken();
      const headers = { 'Authorization': `Bearer ${token}` };

      const [chatsRes, metricsRes, summaryRes] = await Promise.all([
        fetch(`${API_URL}/chat/history`, { headers }),
        fetch(`${API_URL}/metrics/recent`, { headers }),
        fetch(`${API_URL}/metrics/summary`, { headers }),
      ]);

      if (chatsRes.ok) {
        const data = await chatsRes.json();
        setChats(data.history || []);
      }
      if (metricsRes.ok) {
        const data = await metricsRes.json();
        setMetrics(data.metrics || []);
      }
      if (summaryRes.ok) {
        const data = await summaryRes.json();
        setSummary(data);
      }
    } catch (e) {
      console.error('Failed to load audit data:', e);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadData();
  }, []);

  const filteredChats = chats
    .filter(c => !isSystemQuery(c.query))
    .filter(c =>
      (c.query || '').toLowerCase().includes(searchQuery.toLowerCase()) ||
      (c.email || '').toLowerCase().includes(searchQuery.toLowerCase())
    );

  const filteredMetrics = metrics
    .filter(m => !isSystemQuery(m.query))
    .filter(m =>
      (m.query || '').toLowerCase().includes(searchQuery.toLowerCase())
    );

  const formatTime = (timestamp) => {
    if (!timestamp) return '—';
    try {
      return new Date(timestamp).toLocaleString();
    } catch { return '—'; }
  };

  const statCards = summary ? [
    { icon: MessageSquare, label: 'Total Queries', value: summary.total_queries.toLocaleString(), color: 'from-cyan-400 to-blue-600' },
    { icon: Activity, label: 'RAG Queries', value: summary.rag_queries.toLocaleString(), color: 'from-blue-500 to-purple-600' },
    { icon: Database, label: 'SQL Queries', value: summary.sql_queries.toLocaleString(), color: 'from-purple-500 to-pink-600' },
    { icon: Clock, label: 'Avg Response', value: `${(summary.avg_rag_response_time_ms / 1000).toFixed(1)}s`, color: 'from-pink-500 to-cyan-400' },
  ] : [];

  return (
    <AnimatedPage className="min-h-screen p-6 md:p-8">
      <div className="max-w-7xl mx-auto" data-testid="audit-logs-page">
        <div className="flex items-center justify-between mb-1">
          <h1 className="text-3xl font-medium text-white">Audit & Logs</h1>
          <button onClick={loadData} className="text-white/30 hover:text-white transition-colors flex items-center gap-2 text-sm">
            <RefreshCw className="w-4 h-4" /> Refresh
          </button>
        </div>
        <p className="text-white/50 mb-8">Monitor real queries, metrics, and system activity</p>

        {/* Real Metrics */}
        {summary && (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            {statCards.map((m, i) => (
              <motion.div key={i} initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: i * 0.08 }} whileHover={{ scale: 1.03 }}>
                <GlassmorphicCard className="p-5">
                  <div className={`w-11 h-11 rounded-xl bg-gradient-to-br ${m.color} flex items-center justify-center mb-3`}>
                    <m.icon className="w-5 h-5 text-white" />
                  </div>
                  <div className="text-2xl font-light text-white mb-0.5">{m.value}</div>
                  <span className="text-sm text-white/50">{m.label}</span>
                </GlassmorphicCard>
              </motion.div>
            ))}
          </div>
        )}

        {/* Tabs */}
        <div className="flex gap-2 mb-6">
          {['queries', 'metrics'].map(tab => (
            <button
              key={tab}
              onClick={() => setActiveTab(tab)}
              className={`px-4 py-2 rounded-lg text-sm font-medium transition-all ${
                activeTab === tab
                  ? 'bg-white/10 text-white border border-white/20'
                  : 'text-white/40 hover:text-white'
              }`}
            >
              {tab === 'queries' ? '💬 Chat History' : '📊 Pipeline Metrics'}
            </button>
          ))}
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <div className="lg:col-span-2">
            <GlassmorphicCard className="p-6">
              <div className="flex items-center justify-between mb-6">
                <h2 className="text-lg font-medium text-white">
                  {activeTab === 'queries' ? 'Chat Query Log' : 'Pipeline Metrics Log'}
                </h2>
                <div className="relative w-56">
                  <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-white/30" />
                  <input
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                    placeholder="Search..."
                    className="w-full pl-10 pr-4 py-2 rounded-lg bg-white/[0.04] border border-white/10 text-white text-sm placeholder-white/30 outline-none focus:border-cyan-400/40"
                  />
                </div>
              </div>

              {loading ? (
                <div className="text-center py-12">
                  <Loader2 className="w-8 h-8 text-cyan-400 animate-spin mx-auto mb-3" />
                  <p className="text-white/30 text-sm">Loading logs...</p>
                </div>
              ) : activeTab === 'queries' ? (
                <div className="overflow-x-auto">
                  <table className="w-full">
                    <thead>
                      <tr className="border-b border-white/10">
                        <th className="text-left text-xs text-white/40 uppercase tracking-wider pb-3 pr-3">Pipeline</th>
                        <th className="text-left text-xs text-white/40 uppercase tracking-wider pb-3 pr-3">Query</th>
                        <th className="text-left text-xs text-white/40 uppercase tracking-wider pb-3 pr-3">User</th>
                        <th className="text-left text-xs text-white/40 uppercase tracking-wider pb-3">Time</th>
                      </tr>
                    </thead>
                    <tbody>
                      {filteredChats.length === 0 ? (
                        <tr><td colSpan={4} className="py-8 text-center text-white/30 text-sm">No queries yet</td></tr>
                      ) : filteredChats.map((log, i) => (
                        <tr key={i} className="border-b border-white/5 hover:bg-white/[0.02] transition-colors">
                          <td className="py-3 pr-3">
                            <span className={`text-xs px-2 py-1 rounded-full font-medium ${
                              log.intent === 'knowledge_query'
                                ? 'bg-cyan-500/15 text-cyan-400'
                                : log.intent === 'student_query'
                                ? 'bg-blue-500/15 text-blue-400'
                                : 'bg-white/10 text-white/40'
                            }`}>
                              {log.intent === 'knowledge_query' ? 'RAG' : log.intent === 'student_query' ? 'SQL' : log.intent || '—'}
                            </span>
                          </td>
                          <td className="py-3 pr-3 text-sm text-white max-w-xs truncate">{log.query}</td>
                          <td className="py-3 pr-3 text-sm text-white/50">{log.email?.split('@')[0] || '—'}</td>
                          <td className="py-3 text-sm text-white/40">{formatTime(log.timestamp)}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              ) : (
                <div className="overflow-x-auto">
                  <table className="w-full">
                    <thead>
                      <tr className="border-b border-white/10">
                        <th className="text-left text-xs text-white/40 uppercase tracking-wider pb-3 pr-3">Status</th>
                        <th className="text-left text-xs text-white/40 uppercase tracking-wider pb-3 pr-3">Pipeline</th>
                        <th className="text-left text-xs text-white/40 uppercase tracking-wider pb-3 pr-3">Query</th>
                        <th className="text-left text-xs text-white/40 uppercase tracking-wider pb-3 pr-3">Score</th>
                        <th className="text-left text-xs text-white/40 uppercase tracking-wider pb-3">Time</th>
                      </tr>
                    </thead>
                    <tbody>
                      {filteredMetrics.length === 0 ? (
                        <tr><td colSpan={5} className="py-8 text-center text-white/30 text-sm">No metrics yet</td></tr>
                      ) : filteredMetrics.map((m, i) => (
                        <tr key={i} className="border-b border-white/5 hover:bg-white/[0.02] transition-colors">
                          <td className="py-3 pr-3">{statusIcon(m.success)}</td>
                          <td className="py-3 pr-3">
                            <span className={`text-xs px-2 py-1 rounded-full font-medium ${
                              m.pipeline === 'RAG' ? 'bg-cyan-500/15 text-cyan-400' : 'bg-blue-500/15 text-blue-400'
                            }`}>{m.pipeline}</span>
                          </td>
                          <td className="py-3 pr-3 text-sm text-white/70 max-w-xs truncate">{(m.query || '').slice(0, 40)}</td>
                          <td className="py-3 pr-3 text-sm text-white/50">
                            {m.grounding_score !== undefined ? m.grounding_score.toFixed(2) : m.rows_returned !== undefined ? `${m.rows_returned} rows` : '—'}
                          </td>
                          <td className="py-3 text-sm text-white/40">{m.execution_time_ms ? `${m.execution_time_ms}ms` : '—'}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              )}
            </GlassmorphicCard>
          </div>

          {/* Recent Activity */}
          <div>
            <GlassmorphicCard className="p-6 h-full">
              <h2 className="text-lg font-medium text-white mb-4">Recent Activity</h2>
              <div className="space-y-3 max-h-[500px] overflow-y-auto">
                {loading ? (
                  <div className="text-center py-8">
                    <Loader2 className="w-6 h-6 text-cyan-400 animate-spin mx-auto" />
                  </div>
                ) : chats.filter(c => !isSystemQuery(c.query)).length === 0 ? (
                  <p className="text-white/30 text-sm text-center py-8">No activity yet</p>
                ) : chats.filter(c => !isSystemQuery(c.query)).slice(0, 15).map((chat, i) => (
                  <div key={i} className="flex items-start space-x-3 text-sm p-2 rounded-lg hover:bg-white/[0.02]">
                    <Info className={`w-4 h-4 flex-shrink-0 mt-0.5 ${
                      chat.intent === 'knowledge_query' ? 'text-cyan-400' :
                      chat.intent === 'student_query' ? 'text-blue-400' : 'text-white/30'
                    }`} />
                    <div className="flex-1 min-w-0">
                      <p className="text-white/60 leading-relaxed truncate">{chat.query}</p>
                      <p className="text-white/30 text-xs mt-0.5">{chat.email?.split('@')[0]} · {formatTime(chat.timestamp)}</p>
                    </div>
                  </div>
                ))}
              </div>
            </GlassmorphicCard>
          </div>
        </div>
      </div>
    </AnimatedPage>
  );
};
