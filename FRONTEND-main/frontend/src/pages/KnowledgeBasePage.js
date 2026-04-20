import React, { useState, useRef, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { AnimatedPage } from '../components/AnimatedPage';
import { GlassmorphicCard } from '../components/GlassmorphicCard';
import { Upload, Database, FileText, CheckCircle, Clock, Search, Loader2, AlertTriangle, RefreshCw, Scissors, Cpu, HardDrive } from 'lucide-react';
import { useNotifications } from '../context/NotificationContext';

const API_URL = 'https://web-production-e4321.up.railway.app';
const getToken = () => localStorage.getItem('cortex_token');

export const KnowledgeBasePage = () => {
  const [documents, setDocuments] = useState([]);
  const [dragOver, setDragOver] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [uploading, setUploading] = useState(false);
  const [indexing, setIndexing] = useState(false);
  const [loadingDocs, setLoadingDocs] = useState(true);
  const [message, setMessage] = useState(null);

  // Pipeline animation state: null | 'chunking' | 'embedding' | 'storing' | 'done'
  const [pipelineState, setPipelineState] = useState('idle');

  const fileInputRef = useRef(null);
  const { addNotification } = useNotifications();

  const showMessage = (text, type = 'success') => {
    setMessage({ text, type });
    setTimeout(() => setMessage(null), 4000);
  };

  const loadDocuments = async () => {
    setLoadingDocs(true);
    try {
      const token = getToken();
      const res = await fetch(`${API_URL}/documents`, {
        headers: { 'Authorization': `Bearer ${token}` }
      });
      if (res.ok) {
        const data = await res.json();
        setDocuments(data.documents || []);
      }
    } catch (e) {
      console.error('Failed to load documents:', e);
    } finally {
      setLoadingDocs(false);
    }
  };

  useEffect(() => {
    loadDocuments();
  }, []);

  // Animate pipeline steps one by one
  const animatePipeline = async () => {
    setPipelineState('chunking');
    await new Promise(r => setTimeout(r, 2000));
    setPipelineState('embedding');
    await new Promise(r => setTimeout(r, 3000));
    setPipelineState('storing');
    await new Promise(r => setTimeout(r, 2000));
    setPipelineState('done');
    await new Promise(r => setTimeout(r, 2000));
    setPipelineState('idle');
  };

  const uploadFile = async (file) => {
    if (!file) return;

    const allowedTypes = [
      'application/pdf',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'text/plain'
    ];
    if (!allowedTypes.includes(file.type)) {
      showMessage('Only PDF, DOCX, or TXT files are allowed.', 'error');
      return;
    }

    setUploading(true);
    animatePipeline(); // Start animation immediately

    try {
      const token = getToken();
      const formData = new FormData();
      formData.append('file', file);

      const response = await fetch(`${API_URL}/upload-document`, {
        method: 'POST',
        headers: { 'Authorization': `Bearer ${token}` },
        body: formData,
      });

      const data = await response.json();
      if (!response.ok) throw new Error(data.detail || 'Upload failed');

      showMessage(`✓ ${file.name} uploaded and indexing started!`, 'success');
      addNotification({
        title: 'Document Uploaded',
        message: `${file.name} is being indexed automatically.`,
        type: 'upload'
      });

      await loadDocuments();

    } catch (err) {
      setPipelineState('idle');
      showMessage(err.message || 'Upload failed', 'error');
    } finally {
      setUploading(false);
    }
  };

  const handleDrop = async (e) => {
    e.preventDefault();
    setDragOver(false);
    const file = e.dataTransfer.files?.[0];
    if (file) await uploadFile(file);
  };

  const handleFileSelect = async (e) => {
    const file = e.target.files?.[0];
    if (file) await uploadFile(file);
    e.target.value = '';
  };

  const handleIndexAll = async () => {
    setIndexing(true);
    animatePipeline();
    try {
      const token = getToken();
      const response = await fetch(`${API_URL}/index-documents`, {
        method: 'POST',
        headers: { 'Authorization': `Bearer ${token}` },
      });
      const data = await response.json();
      if (!response.ok) throw new Error(data.detail || 'Indexing failed');
      showMessage('✓ Full re-indexing started!', 'success');
      addNotification({ title: 'Re-indexing Started', message: 'All documents are being re-indexed.', type: 'index' });
    } catch (err) {
      showMessage(err.message || 'Indexing failed', 'error');
    } finally {
      setTimeout(() => setIndexing(false), 7000);
    }
  };

  const filtered = documents.filter(d =>
    d.name.toLowerCase().includes(searchQuery.toLowerCase())
  );

  // Pipeline step config
  const pipelineSteps = [
    {
      icon: Scissors,
      label: 'Document Chunked',
      activeState: 'chunking',
      doneStates: ['embedding', 'storing', 'done'],
    },
    {
      icon: Cpu,
      label: 'Embeddings Generated',
      activeState: 'embedding',
      doneStates: ['storing', 'done'],
    },
    {
      icon: HardDrive,
      label: 'Stored in Vector DB',
      activeState: 'storing',
      doneStates: ['done'],
    },
  ];

  const getStepStatus = (step) => {
    if (step.doneStates.includes(pipelineState)) return 'done';
    if (step.activeState === pipelineState) return 'active';
    return 'idle';
  };

  const statusColor = (s) => {
    if (s === 'Indexed') return 'bg-green-500/20 text-green-400 border-green-500/30';
    if (s === 'Processing') return 'bg-yellow-500/20 text-yellow-400 border-yellow-500/30';
    return 'bg-red-500/20 text-red-400 border-red-500/30';
  };

  return (
    <AnimatedPage className="min-h-screen p-6 md:p-8">
      <div className="max-w-7xl mx-auto" data-testid="knowledge-base-page">
        <h1 className="text-3xl font-medium text-white mb-1">Knowledge Base</h1>
        <p className="text-white/50 mb-8">Upload, index, and manage your documents</p>

        {/* Status Message */}
        <AnimatePresence>
          {message && (
            <motion.div
              initial={{ opacity: 0, y: -10 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -10 }}
              className={`mb-6 px-5 py-3 rounded-xl flex items-center gap-3 text-sm font-medium ${
                message.type === 'success'
                  ? 'bg-green-500/10 border border-green-500/20 text-green-400'
                  : 'bg-red-500/10 border border-red-500/20 text-red-400'
              }`}
            >
              {message.type === 'success' ? <CheckCircle className="w-4 h-4" /> : <AlertTriangle className="w-4 h-4" />}
              {message.text}
            </motion.div>
          )}
        </AnimatePresence>

        {/* Upload Area */}
        <motion.div
          onDragOver={(e) => { e.preventDefault(); setDragOver(true); }}
          onDragLeave={() => setDragOver(false)}
          onDrop={handleDrop}
          onClick={() => !uploading && fileInputRef.current?.click()}
          data-testid="upload-dropzone"
          className={`glass rounded-2xl p-10 mb-8 text-center border-2 border-dashed transition-all duration-300 cursor-pointer ${
            dragOver ? 'border-cyan-400/60 bg-cyan-400/5' : 'border-white/10 hover:border-white/20'
          }`}
        >
          <input
            ref={fileInputRef}
            type="file"
            accept=".pdf,.docx,.txt"
            onChange={handleFileSelect}
            className="hidden"
          />
          {uploading ? (
            <div className="flex flex-col items-center gap-3">
              <Loader2 className="w-10 h-10 text-cyan-400 animate-spin" />
              <p className="text-white/60 text-sm">Uploading and indexing...</p>
            </div>
          ) : (
            <>
              <Upload className="w-10 h-10 text-white/40 mx-auto mb-4" />
              <p className="text-white/60 mb-2">Drag & drop documents here, or click to browse</p>
              <p className="text-xs text-white/30">Supports PDF, DOCX, TXT — Max 50 MB</p>
              <p className="text-xs text-cyan-400/60 mt-2">✦ Auto-indexes after upload — no manual step needed!</p>
            </>
          )}
          <div className="mt-6 flex items-center justify-center space-x-4" onClick={e => e.stopPropagation()}>
            <motion.button
              whileHover={{ scale: 1.04 }}
              whileTap={{ scale: 0.97 }}
              onClick={() => fileInputRef.current?.click()}
              disabled={uploading}
              className="px-6 py-2.5 rounded-xl bg-gradient-to-r from-cyan-500 to-blue-600 text-white text-sm font-medium disabled:opacity-50"
            >
              {uploading ? 'Uploading...' : 'Upload Files'}
            </motion.button>
            <motion.button
              whileHover={{ scale: 1.04 }}
              whileTap={{ scale: 0.97 }}
              onClick={handleIndexAll}
              disabled={indexing || uploading}
              className="px-6 py-2.5 rounded-xl glass border border-white/10 text-white/70 text-sm font-medium hover:text-white hover:border-white/20 disabled:opacity-50 flex items-center gap-2"
            >
              {indexing ? <><Loader2 className="w-4 h-4 animate-spin" /> Re-indexing...</> : 'Re-index All'}
            </motion.button>
          </div>
        </motion.div>

        {/* Processing Pipeline — Animated */}
        <GlassmorphicCard className="p-6 mb-8">
          <div className="flex items-center justify-between mb-6">
            <h2 className="text-lg font-medium text-white">Processing Pipeline</h2>
            {pipelineState !== 'idle' && (
              <span className="text-xs text-cyan-400 animate-pulse flex items-center gap-1">
                <span className="w-2 h-2 rounded-full bg-cyan-400 animate-pulse inline-block" />
                Processing...
              </span>
            )}
            {pipelineState === 'idle' && (
              <span className="text-xs text-white/30">Ready</span>
            )}
          </div>

          <div className="flex items-center justify-between">
            {pipelineSteps.map((step, i) => {
              const status = getStepStatus(step);
              return (
                <React.Fragment key={i}>
                  <div className="flex flex-col items-center flex-1">
                    <motion.div
                      animate={{
                        scale: status === 'active' ? [1, 1.1, 1] : 1,
                      }}
                      transition={{ repeat: status === 'active' ? Infinity : 0, duration: 1 }}
                      className={`w-14 h-14 rounded-full flex items-center justify-center mb-3 border-2 transition-all duration-500 ${
                        status === 'done'
                          ? 'bg-green-500/20 border-green-500 shadow-[0_0_20px_rgba(34,197,94,0.3)]'
                          : status === 'active'
                          ? 'bg-cyan-500/20 border-cyan-400 shadow-[0_0_20px_rgba(0,240,255,0.4)]'
                          : 'bg-white/5 border-white/10'
                      }`}
                    >
                      {status === 'done' ? (
                        <CheckCircle className="w-6 h-6 text-green-400" />
                      ) : status === 'active' ? (
                        <Loader2 className="w-6 h-6 text-cyan-400 animate-spin" />
                      ) : (
                        <step.icon className="w-6 h-6 text-white/30" />
                      )}
                    </motion.div>
                    <span className={`text-sm text-center transition-colors duration-300 ${
                      status === 'done' ? 'text-green-400' :
                      status === 'active' ? 'text-cyan-400' :
                      'text-white/40'
                    }`}>
                      {step.label}
                    </span>
                  </div>

                  {i < pipelineSteps.length - 1 && (
                    <div className="w-16 mx-2 mt-[-28px]">
                      <motion.div
                        className="h-0.5 rounded-full"
                        animate={{
                          background: getStepStatus(pipelineSteps[i+1]) !== 'idle' || status === 'done'
                            ? 'linear-gradient(90deg, #22c55e, #00f0ff)'
                            : 'rgba(255,255,255,0.1)'
                        }}
                        transition={{ duration: 0.5 }}
                      />
                    </div>
                  )}
                </React.Fragment>
              );
            })}
          </div>

          {/* Progress message */}
          <div className="mt-4 text-center text-xs text-white/30 h-4">
            {pipelineState === 'chunking' && '📄 Splitting document into chunks...'}
            {pipelineState === 'embedding' && '🧠 Generating vector embeddings...'}
            {pipelineState === 'storing' && '💾 Storing in FAISS vector database...'}
            {pipelineState === 'done' && '✅ Document ready for queries!'}
          </div>
        </GlassmorphicCard>

        {/* Documents Table */}
        <GlassmorphicCard className="p-6">
          <div className="flex items-center justify-between mb-6">
            <h2 className="text-lg font-medium text-white">
              Documents
              {documents.length > 0 && <span className="ml-2 text-sm text-white/30">({documents.length} files)</span>}
            </h2>
            <div className="flex items-center gap-3">
              <button onClick={loadDocuments} className="text-white/30 hover:text-white transition-colors" title="Refresh">
                <RefreshCw className="w-4 h-4" />
              </button>
              <div className="relative w-64">
                <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-white/30" />
                <input
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  placeholder="Search documents..."
                  className="w-full pl-10 pr-4 py-2 rounded-lg bg-white/[0.04] border border-white/10 text-white text-sm placeholder-white/30 outline-none focus:border-cyan-400/40"
                />
              </div>
            </div>
          </div>

          {loadingDocs ? (
            <div className="text-center py-12">
              <Loader2 className="w-8 h-8 text-cyan-400 animate-spin mx-auto mb-3" />
              <p className="text-white/30 text-sm">Loading documents...</p>
            </div>
          ) : documents.length === 0 ? (
            <div className="text-center py-12">
              <Database className="w-12 h-12 text-white/10 mx-auto mb-3" />
              <p className="text-white/30 text-sm">No documents uploaded yet.</p>
              <p className="text-white/20 text-xs mt-1">Upload a PDF, DOCX, or TXT file above.</p>
            </div>
          ) : (
            <div className="overflow-x-auto">
              <table className="w-full">
                <thead>
                  <tr className="border-b border-white/10">
                    <th className="text-left text-xs text-white/40 uppercase tracking-wider pb-3 pr-4">Document</th>
                    <th className="text-left text-xs text-white/40 uppercase tracking-wider pb-3 pr-4">Status</th>
                    <th className="text-left text-xs text-white/40 uppercase tracking-wider pb-3 pr-4">Size</th>
                    <th className="text-left text-xs text-white/40 uppercase tracking-wider pb-3">Uploaded</th>
                  </tr>
                </thead>
                <tbody>
                  {filtered.map((doc, i) => (
                    <motion.tr
                      key={i}
                      initial={{ opacity: 0 }}
                      animate={{ opacity: 1 }}
                      className="border-b border-white/5 hover:bg-white/[0.02] transition-colors"
                    >
                      <td className="py-3 pr-4">
                        <div className="flex items-center space-x-3">
                          <FileText className="w-5 h-5 text-white/40 flex-shrink-0" />
                          <span className="text-sm text-white">{doc.name}</span>
                        </div>
                      </td>
                      <td className="py-3 pr-4">
                        <span className={`px-2.5 py-1 rounded-full text-xs border ${statusColor(doc.status)}`}>
                          {doc.status}
                        </span>
                      </td>
                      <td className="py-3 pr-4 text-sm text-white/60">{doc.size}</td>
                      <td className="py-3">
                        <div className="flex items-center space-x-1 text-sm text-white/40">
                          <Clock className="w-3.5 h-3.5" />
                          <span>{doc.uploadTime}</span>
                        </div>
                      </td>
                    </motion.tr>
                  ))}
                  {filtered.length === 0 && documents.length > 0 && (
                    <tr>
                      <td colSpan={4} className="py-12 text-center text-white/30 text-sm">No documents found</td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          )}
        </GlassmorphicCard>
      </div>
    </AnimatedPage>
  );
};
