import React, { useState, useRef, useEffect } from 'react';
import { motion } from 'framer-motion';
import { Trash2, Menu, X, Loader2, User, Bot, Send, Paperclip, Mic, Square, Plus, FileText, CheckCircle } from 'lucide-react';
import Markdown from 'react-markdown';
import remarkGfm from 'remark-gfm';
import gsap from 'gsap';
import { useNotifications } from '../context/NotificationContext';

const API_URL = 'https://web-production-e4321.up.railway.app';
const getToken = () => localStorage.getItem('cortex_token');

// ── Generate a unique session ID ──────────────────────────────────────────────
const generateSessionId = () => `session_${Date.now()}_${Math.random().toString(36).slice(2, 7)}`;

/* ── Sidebar ── */
const ChatSidebar = ({ isOpen, conversations, activeId, onSelect, onNew, onDelete }) => {
  const ref = useRef(null);
  useEffect(() => {
    if (ref.current) {
      gsap.to(ref.current, { width: isOpen ? 260 : 0, opacity: isOpen ? 1 : 0, duration: 0.3, ease: 'power2.inOut' });
    }
  }, [isOpen]);

  return (
    <div ref={ref} className="h-full overflow-hidden flex-shrink-0" style={{ width: isOpen ? 260 : 0, pointerEvents: isOpen ? 'auto' : 'none' }} data-testid="chat-sidebar">
      <div className="h-full w-[260px] bg-[#070710]/80 backdrop-blur-2xl border-r border-white/10 flex flex-col p-4">
        <button onClick={onNew} data-testid="new-chat-button" className="w-full mb-4 px-4 py-3 rounded-xl bg-gradient-to-r from-cyan-500 to-blue-600 text-white font-medium flex items-center justify-center space-x-2 hover:shadow-lg hover:scale-[1.03] transition-all duration-200">
          <Plus className="w-5 h-5" />
          <span>New Chat</span>
        </button>
        <div className="text-xs uppercase tracking-wider text-white/30 mb-2 px-2">History</div>
        <div className="flex-1 overflow-y-auto space-y-1">
          {conversations.length === 0 ? (
            <p className="text-sm text-white/30 text-center py-8">No conversations</p>
          ) : (
            conversations.map((c) => (
              <div key={c.id} onClick={() => onSelect(c.id)} data-testid={`conversation-${c.id}`}
                className={`group relative px-3 py-2.5 rounded-lg cursor-pointer transition-all duration-200 ${activeId === c.id ? 'bg-white/10 border border-cyan-400/30' : 'hover:bg-white/5 border border-transparent'}`}>
                <div className="flex items-start justify-between">
                  <div className="flex-1 min-w-0">
                    <div className="text-sm text-white font-medium truncate">{c.title}</div>
                    <div className="text-xs text-white/30 truncate mt-0.5">{c.lastMessage}</div>
                  </div>
                  <button onClick={(e) => { e.stopPropagation(); onDelete(c.id); }} data-testid={`delete-conv-${c.id}`} className="opacity-0 group-hover:opacity-100 ml-2 text-white/30 hover:text-red-400 transition-opacity">
                    <Trash2 className="w-4 h-4" />
                  </button>
                </div>
              </div>
            ))
          )}
        </div>
      </div>
    </div>
  );
};

/* ── Message Bubble ── */
const Bubble = ({ text, isUser, fileName }) => {
  return (
    <motion.div initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.3 }}
      data-testid={isUser ? 'user-message' : 'ai-message'}
      className={`flex items-start space-x-3 mb-5 ${isUser ? 'flex-row-reverse space-x-reverse' : ''}`}>
      <div className={`flex-shrink-0 w-9 h-9 rounded-full flex items-center justify-center ${isUser ? 'bg-gradient-to-br from-cyan-400 to-blue-600' : 'bg-gradient-to-br from-purple-500 to-pink-600'}`}>
        {isUser ? <User className="w-4 h-4 text-white" /> : <Bot className="w-4 h-4 text-white" />}
      </div>
      <div className={`glass rounded-2xl px-4 py-3 max-w-[70%] ${isUser ? 'rounded-tr-sm' : 'rounded-tl-sm'}`}>
        {fileName && (
          <div className="flex items-center gap-2 mb-2 px-2 py-1.5 rounded-lg bg-cyan-500/10 border border-cyan-500/20">
            <FileText className="w-3.5 h-3.5 text-cyan-400 flex-shrink-0" />
            <span className="text-xs text-cyan-400 truncate">{fileName}</span>
          </div>
        )}
        {isUser ? (
          <p className="text-white text-sm leading-relaxed whitespace-pre-wrap break-words">{text}</p>
        ) : (
          <Markdown
            remarkPlugins={[remarkGfm]}
            components={{
              table: ({ node, ...props }) => (
                <table className="border-collapse w-full my-3 text-sm rounded-lg overflow-hidden" {...props} />
              ),
              thead: ({ node, ...props }) => (
                <thead className="bg-purple-900/60" {...props} />
              ),
              tbody: ({ node, ...props }) => (
                <tbody {...props} />
              ),
              th: ({ node, ...props }) => (
                <th className="border border-purple-500/30 px-3 py-2 text-cyan-300 text-left font-semibold text-xs uppercase tracking-wider" {...props} />
              ),
              td: ({ node, ...props }) => (
                <td className="border border-white/10 px-3 py-2 text-gray-200 text-sm" {...props} />
              ),
              tr: ({ node, ...props }) => (
                <tr className="even:bg-white/5 hover:bg-white/10 transition-colors" {...props} />
              ),
              p: ({ node, ...props }) => (
                <p className="text-white text-sm leading-relaxed mb-1" {...props} />
              ),
              strong: ({ node, ...props }) => (
                <strong className="text-cyan-300 font-semibold" {...props} />
              ),
              li: ({ node, ...props }) => (
                <li className="text-white text-sm leading-relaxed ml-4 list-disc" {...props} />
              ),
              ul: ({ node, ...props }) => (
                <ul className="my-2 space-y-1" {...props} />
              ),
              ol: ({ node, ...props }) => (
                <ol className="my-2 space-y-1 list-decimal ml-4" {...props} />
              ),
            }}
          >
            {text}
          </Markdown>
        )}
      </div>
    </motion.div>
  );
};

/* ── Chat Input ── */
const ChatInput = ({ onSend, disabled }) => {
  const [msg, setMsg] = useState('');
  const [recording, setRecording] = useState(false);
  const [recTime, setRecTime] = useState(0);
  const [attachedFile, setAttachedFile] = useState(null);
  const [uploading, setUploading] = useState(false);
  const [uploadDone, setUploadDone] = useState(false);
  const taRef = useRef(null);
  const recRef = useRef(null);
  const mediaRef = useRef(null);
  const chunksRef = useRef([]);
  const fileInputRef = useRef(null);

  useEffect(() => {
    if (taRef.current) {
      taRef.current.style.height = 'auto';
      taRef.current.style.height = Math.min(taRef.current.scrollHeight, 120) + 'px';
    }
  }, [msg]);

  useEffect(() => {
    if (recording) {
      recRef.current = setInterval(() => setRecTime((p) => p + 1), 1000);
    } else {
      clearInterval(recRef.current);
      setRecTime(0);
    }
    return () => clearInterval(recRef.current);
  }, [recording]);

  const handleFileChange = async (e) => {
    const file = e.target.files[0];
    if (!file) return;
    const allowed = ['application/pdf', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'application/msword'];
    if (!allowed.includes(file.type)) { alert('Only PDF and Word (.docx, .doc) files are supported.'); return; }
    setAttachedFile(file);
    setUploadDone(false);
    setUploading(true);
    try {
      const token = getToken();
      const formData = new FormData();
      formData.append('file', file);
      const res = await fetch(`${API_URL}/upload-and-index`, {
        method: 'POST',
        headers: { 'Authorization': `Bearer ${token}` },
        body: formData,
      });
      if (!res.ok) { const err = await res.json(); throw new Error(err.detail || 'Upload failed'); }
      setUploadDone(true);
    } catch (err) {
      alert('Upload failed: ' + err.message);
      setAttachedFile(null);
    } finally {
      setUploading(false);
      if (fileInputRef.current) fileInputRef.current.value = '';
    }
  };

  const removeFile = () => { setAttachedFile(null); setUploadDone(false); if (fileInputRef.current) fileInputRef.current.value = ''; };

  const send = () => {
    if (msg.trim() && !disabled && !uploading) {
      onSend(msg.trim(), attachedFile?.name || null);
      setMsg('');
      setAttachedFile(null);
      setUploadDone(false);
      if (taRef.current) taRef.current.style.height = 'auto';
    }
  };

  const startRec = async () => {
    try {
      const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
      if (SpeechRecognition) {
        const recognition = new SpeechRecognition();
        recognition.continuous = false;
        recognition.interimResults = false;
        recognition.lang = 'en-US';
        recognition.onresult = (event) => { setMsg(event.results[0][0].transcript); setRecording(false); };
        recognition.onerror = () => setRecording(false);
        recognition.onend = () => setRecording(false);
        recognition.start();
        setRecording(true);
      } else {
        const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
        mediaRef.current = new MediaRecorder(stream);
        chunksRef.current = [];
        mediaRef.current.ondataavailable = (e) => chunksRef.current.push(e.data);
        mediaRef.current.onstop = () => { onSend('[Voice message recorded]', null); stream.getTracks().forEach((t) => t.stop()); };
        mediaRef.current.start();
        setRecording(true);
      }
    } catch { alert('Microphone access is required.'); }
  };

  const stopRec = () => { if (mediaRef.current && recording) { mediaRef.current.stop(); setRecording(false); } };
  const fmt = (s) => `${Math.floor(s / 60)}:${String(s % 60).padStart(2, '0')}`;

  if (recording) {
    return (
      <div className="glass border-t border-white/10 p-4" data-testid="chat-input-container">
        <div className="max-w-4xl mx-auto flex items-center justify-between glass rounded-2xl border border-red-500/40 px-6 py-4" data-testid="recording-ui">
          <div className="flex items-center space-x-4">
            <div className="relative">
              <div className="w-3 h-3 rounded-full bg-red-500 animate-pulse" />
              <div className="absolute inset-0 w-3 h-3 rounded-full bg-red-500 animate-ping" />
            </div>
            <span className="text-white text-sm">Listening... {fmt(recTime)}</span>
          </div>
          <button onClick={stopRec} data-testid="stop-recording-button" className="w-10 h-10 rounded-full bg-red-500 flex items-center justify-center text-white hover:bg-red-600 transition-colors">
            <Square className="w-4 h-4" fill="currentColor" />
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="glass border-t border-white/10 p-4" data-testid="chat-input-container">
      {attachedFile && (
        <div className="max-w-4xl mx-auto mb-3">
          <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-lg bg-cyan-500/10 border border-cyan-500/30">
            {uploading ? <Loader2 className="w-3.5 h-3.5 text-cyan-400 animate-spin" />
              : uploadDone ? <CheckCircle className="w-3.5 h-3.5 text-green-400" />
              : <FileText className="w-3.5 h-3.5 text-cyan-400" />}
            <span className="text-xs text-cyan-400 max-w-[200px] truncate">{attachedFile.name}</span>
            {uploadDone && <span className="text-[10px] text-green-400">✓ Indexed</span>}
            {uploading && <span className="text-[10px] text-cyan-400/70">Uploading...</span>}
            <button onClick={removeFile} className="text-white/30 hover:text-red-400 transition-colors ml-1"><X className="w-3 h-3" /></button>
          </div>
        </div>
      )}
      <div className="max-w-4xl mx-auto flex items-end space-x-3">
        <input ref={fileInputRef} type="file" accept=".pdf,.doc,.docx" className="hidden" onChange={handleFileChange} data-testid="file-input" />
        <button onClick={() => fileInputRef.current?.click()} data-testid="attach-button" disabled={uploading}
          className={`flex-shrink-0 w-10 h-10 rounded-full glass border flex items-center justify-center transition-all duration-200 ${attachedFile ? 'border-cyan-400/60 text-cyan-400' : 'border-white/10 text-white/50 hover:text-cyan-400 hover:border-cyan-400/40'} disabled:opacity-50`}>
          <Paperclip className="w-5 h-5" />
        </button>
        <div className="flex-1 glass rounded-2xl border border-white/10 px-4 py-2 flex items-center">
          <textarea ref={taRef} data-testid="chat-input" value={msg} onChange={(e) => setMsg(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); send(); } }}
            placeholder={attachedFile ? `Ask about ${attachedFile.name}...` : 'Ask CORTEX anything...'}
            disabled={disabled || uploading} rows={1}
            className="flex-1 bg-transparent text-white placeholder-white/30 outline-none resize-none max-h-[120px] text-sm" style={{ minHeight: '24px' }} />
        </div>
        <button onClick={startRec} data-testid="voice-button" className="flex-shrink-0 w-10 h-10 rounded-full glass border border-white/10 flex items-center justify-center text-white/50 hover:text-purple-400 hover:border-purple-400/40 transition-all duration-200">
          <Mic className="w-5 h-5" />
        </button>
        <button onClick={send} data-testid="send-button" disabled={!msg.trim() || disabled || uploading}
          className="flex-shrink-0 w-10 h-10 rounded-full bg-gradient-to-r from-cyan-500 to-blue-600 flex items-center justify-center text-white hover:shadow-lg hover:scale-105 transition-all duration-200 disabled:opacity-40 disabled:cursor-not-allowed disabled:hover:scale-100">
          <Send className="w-5 h-5" />
        </button>
      </div>
      <div className="max-w-4xl mx-auto flex gap-2 mt-3 flex-wrap">
        {['List all faculty members', 'What is the vision of AIML department', 'Show research areas'].map((chip) => (
          <button key={chip} onClick={() => onSend(chip, null)}
            className="px-3 py-1.5 rounded-full bg-white/5 border border-white/10 text-xs text-white/50 hover:text-white hover:border-cyan-400/40 transition-all">
            {chip}
          </button>
        ))}
      </div>
    </div>
  );
};

/* ── Main Layout ── */
const INIT_MSGS = [{ id: '1', text: "Hi! I'm CORTEX 🤖 — powered by AI, trained for AIML.\n\nAsk me anything — I'm always online.", isUser: false }];

const makeConvo = (id, title) => ({ id, title, lastMessage: '', messages: [...INIT_MSGS] });

export const ChatLayout = () => {
  const [sidebarOpen, setSidebarOpen] = useState(true);
  const [convos, setConvos] = useState(() => {
    try {
      const saved = localStorage.getItem('cortex_convos');
      const savedEmail = localStorage.getItem('cortex_convos_email');
      const currentEmail = JSON.parse(localStorage.getItem('user') || '{}').email || '';
      if (saved && savedEmail === currentEmail) return JSON.parse(saved);
    } catch {}
    // Generate a proper session ID for the default conversation
    return [makeConvo(generateSessionId(), 'New Conversation')];
  });

  const [activeId, setActiveId] = useState(() => {
    // On load, use the first convo's id (which is now a proper session ID)
    try {
      const saved = localStorage.getItem('cortex_convos');
      const savedEmail = localStorage.getItem('cortex_convos_email');
      const currentEmail = JSON.parse(localStorage.getItem('user') || '{}').email || '';
      if (saved && savedEmail === currentEmail) {
        const parsed = JSON.parse(saved);
        const savedActive = localStorage.getItem('cortex_active_convo');
        if (savedActive && parsed.find(c => c.id === savedActive)) return savedActive;
        return parsed[0]?.id || generateSessionId();
      }
    } catch {}
    return generateSessionId();
  });

  const [loading, setLoading] = useState(false);
  const [historyLoaded, setHistoryLoaded] = useState(false);
  const containerRef = useRef(null);
  const { addNotification } = useNotifications();

  // Save to localStorage on every change
  useEffect(() => {
    try {
      const currentEmail = JSON.parse(localStorage.getItem('user') || '{}').email || '';
      localStorage.setItem('cortex_convos', JSON.stringify(convos));
      localStorage.setItem('cortex_convos_email', currentEmail);
    } catch {}
  }, [convos]);

  useEffect(() => {
    try {
      localStorage.setItem('cortex_active_convo', activeId);
    } catch {}
  }, [activeId]);

  // Load chat history from MongoDB on startup
  // eslint-disable-next-line react-hooks/exhaustive-deps
  useEffect(() => {
    const token = getToken();
    if (!token || historyLoaded) return;
    fetch(`${API_URL}/chat/sessions`, {
      headers: { 'Authorization': `Bearer ${token}` }
    })
      .then(res => res.json())
      .then(data => {
        if (data.sessions && data.sessions.length > 0) {
          const validSessions = data.sessions.filter(s =>
            s.title && s.title !== 'New Conversation' && s.title.length > 3
          );
          if (validSessions.length > 0) {
            const loaded = validSessions.map(s => ({
              id: s.id,
              title: s.title || 'Conversation',
              lastMessage: s.messages[s.messages.length - 1]?.text?.slice(0, 50) || '',
              messages: [
                INIT_MSGS[0],
                ...s.messages.map((m, idx) => ({
                  id: `history-${s.id}-${idx}`,
                  text: m.text || '',
                  isUser: m.isUser || false,
                  fileName: m.fileName || null
                }))
              ]
            }));
            setConvos(prev => {
              const localWithMessages = prev.filter(c => c.messages.length > 1);
              const mongoIds = loaded.map(l => l.id);
              const newLocal = localWithMessages.filter(c => !mongoIds.includes(c.id));
              // Don't add a fresh convo here — the one from init state is already there
              return [...loaded, ...newLocal];
            });
          }
        }
        setHistoryLoaded(true);
      })
      .catch(() => setHistoryLoaded(true));
  }, []);

  const activeConvo = convos.find(c => c.id === activeId) || convos[0];
  const messages = activeConvo?.messages || INIT_MSGS;

  // Auto-scroll
  useEffect(() => {
    if (containerRef.current) {
      gsap.to(containerRef.current, { scrollTop: containerRef.current.scrollHeight, duration: 0.4, ease: 'power2.out' });
    }
  }, [messages]);

  const handleSend = async (text, fileName) => {
    const userMsg = { id: Date.now().toString(), text, isUser: true, fileName };

    // Use activeId as session_id — it's now always a proper unique session ID
    const currentSessionId = activeId;

    setConvos(prev => prev.map(c => {
      if (c.id !== activeId) return c;
      const newTitle = c.title === 'New Conversation' ? text.slice(0, 40) : c.title;
      return { ...c, title: newTitle, messages: [...c.messages, userMsg] };
    }));

    setLoading(true);
    try {
      const token = getToken();
      if (!token) throw new Error('Not authenticated. Please login again.');
      const response = await fetch(`${API_URL}/query`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${token}` },
        body: JSON.stringify({ query: text, session_id: currentSessionId }),
      });
      const data = await response.json();
      if (!response.ok) throw new Error(data.detail || 'Query failed');
      const answer = data.answer || 'No response received.';
      const aiMsg = { id: (Date.now() + 1).toString(), text: answer, isUser: false };

      setConvos(prev => prev.map(c => {
        if (c.id !== activeId) return c;
        return { ...c, lastMessage: answer.slice(0, 50), messages: [...c.messages, aiMsg] };
      }));

      addNotification({ title: 'Query Complete', message: `Response ready for: "${text.slice(0, 40)}${text.length > 40 ? '...' : ''}"`, type: 'chat' });
    } catch (error) {
      const errMsg = { id: (Date.now() + 1).toString(), text: `⚠️ ${error.message}`, isUser: false };
      setConvos(prev => prev.map(c => c.id !== activeId ? c : { ...c, messages: [...c.messages, errMsg] }));
    } finally {
      setLoading(false);
    }
  };

  const handleNew = () => {
    // Don't create new if current is already empty
    const current = convos.find(c => c.id === activeId);
    if (current && current.messages.length <= 1) {
      return; // Already on an empty conversation
    }
    // Always generate a unique session ID for new conversations
    const newSessionId = generateSessionId();
    setConvos(prev => [makeConvo(newSessionId, 'New Conversation'), ...prev]);
    setActiveId(newSessionId);
  };

  const handleSelect = (id) => setActiveId(id);

  const handleDelete = (id) => {
    setConvos(prev => {
      const remaining = prev.filter(c => c.id !== id);
      if (remaining.length === 0) {
        // Last convo deleted — create a fresh one
        const newSessionId = generateSessionId();
        setActiveId(newSessionId);
        return [makeConvo(newSessionId, 'New Conversation')];
      }
      if (activeId === id) setActiveId(remaining[0].id);
      return remaining;
    });
  };

  const sidebarConvos = convos.map(c => ({ id: c.id, title: c.title, lastMessage: c.lastMessage }));

  return (
    <div className="h-full flex flex-col overflow-hidden bg-[#05050A]" data-testid="chat-layout">
      <div className="flex-shrink-0 backdrop-blur-2xl bg-[#05050A]/60 border-b border-white/10 px-4 py-3 flex items-center space-x-3">
        <button onClick={() => setSidebarOpen(!sidebarOpen)} data-testid="toggle-sidebar-button" className="w-9 h-9 rounded-lg glass border border-white/10 flex items-center justify-center text-white/50 hover:text-white hover:border-cyan-400/40 transition-all duration-200">
          {sidebarOpen ? <X className="w-5 h-5" /> : <Menu className="w-5 h-5" />}
        </button>
        <div>
          <h1 className="text-lg font-medium text-white">CORTEX Assistant</h1>
          <p className="text-xs text-white/30">RAG + SQL Pipeline Active</p>
        </div>
        <div className="ml-auto flex items-center space-x-2">
          <div className="w-2 h-2 rounded-full bg-green-400 animate-pulse" />
          <span className="text-xs text-green-400">Online</span>
        </div>
      </div>

      <div className="flex-1 flex overflow-hidden">
        <ChatSidebar isOpen={sidebarOpen} conversations={sidebarConvos} activeId={activeId} onSelect={handleSelect} onNew={handleNew} onDelete={handleDelete} />
        <div className="flex-1 flex flex-col overflow-hidden">
          <div ref={containerRef} data-testid="messages-container" className="flex-1 overflow-y-auto px-6 py-6">
            <div className="max-w-4xl mx-auto">
              {messages.map((m) => <Bubble key={m.id} text={m.text} isUser={m.isUser} fileName={m.fileName} />)}
              {loading && (
                <div className="flex items-start space-x-3 mb-5" data-testid="typing-indicator">
                  <div className="flex-shrink-0 w-9 h-9 rounded-full bg-gradient-to-br from-purple-500 to-pink-600 flex items-center justify-center">
                    <Loader2 className="w-4 h-4 text-white animate-spin" />
                  </div>
                  <div className="glass rounded-2xl rounded-tl-sm px-4 py-3">
                    <div className="flex space-x-1.5">
                      <div className="w-2 h-2 rounded-full bg-white/50 animate-bounce" style={{ animationDelay: '0ms' }} />
                      <div className="w-2 h-2 rounded-full bg-white/50 animate-bounce" style={{ animationDelay: '150ms' }} />
                      <div className="w-2 h-2 rounded-full bg-white/50 animate-bounce" style={{ animationDelay: '300ms' }} />
                    </div>
                  </div>
                </div>
              )}
            </div>
          </div>
          <ChatInput onSend={handleSend} disabled={loading} />
        </div>
      </div>
    </div>
  );
};
