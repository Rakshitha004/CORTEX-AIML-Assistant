import React, { useState, useRef, useEffect } from 'react';
import { Send, Paperclip, Mic, Square } from 'lucide-react';

export const ChatInput = ({ onSendMessage, disabled = false }) => {
  const [message, setMessage] = useState('');
  const [isRecording, setIsRecording] = useState(false);
  const [recordingTime, setRecordingTime] = useState(0);
  const textareaRef = useRef(null);
  const recordingIntervalRef = useRef(null);
  const mediaRecorderRef = useRef(null);
  const audioChunksRef = useRef([]);
  
  useEffect(() => {
    if (textareaRef.current) {
      textareaRef.current.style.height = 'auto';
      textareaRef.current.style.height = Math.min(textareaRef.current.scrollHeight, 120) + 'px';
    }
  }, [message]);
  
  useEffect(() => {
    if (isRecording) {
      recordingIntervalRef.current = setInterval(() => {
        setRecordingTime(prev => prev + 1);
      }, 1000);
    } else {
      if (recordingIntervalRef.current) {
        clearInterval(recordingIntervalRef.current);
      }
      setRecordingTime(0);
    }
    
    return () => {
      if (recordingIntervalRef.current) {
        clearInterval(recordingIntervalRef.current);
      }
    };
  }, [isRecording]);
  
  const handleSend = () => {
    if (message.trim() && !disabled) {
      onSendMessage(message.trim());
      setMessage('');
      if (textareaRef.current) {
        textareaRef.current.style.height = 'auto';
      }
    }
  };
  
  const handleKeyDown = (e) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleSend();
    }
  };
  
  const startRecording = async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      mediaRecorderRef.current = new MediaRecorder(stream);
      audioChunksRef.current = [];
      
      mediaRecorderRef.current.ondataavailable = (event) => {
        audioChunksRef.current.push(event.data);
      };
      
      mediaRecorderRef.current.onstop = () => {
        const audioBlob = new Blob(audioChunksRef.current, { type: 'audio/wav' });
        // Here you would typically send the audio to your backend
        console.log('Audio recorded:', audioBlob);
        onSendMessage('[Voice message recorded]');
        
        // Stop all tracks
        stream.getTracks().forEach(track => track.stop());
      };
      
      mediaRecorderRef.current.start();
      setIsRecording(true);
    } catch (error) {
      console.error('Error accessing microphone:', error);
      // Fallback if mic access denied
      alert('Microphone access is required for voice recording.');
    }
  };
  
  const stopRecording = () => {
    if (mediaRecorderRef.current && isRecording) {
      mediaRecorderRef.current.stop();
      setIsRecording(false);
    }
  };
  
  const formatTime = (seconds) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };
  
  return (
    <div className="glass border-t border-white/10 p-4" data-testid="chat-input-container">
      <div className="max-w-4xl mx-auto">
        {isRecording ? (
          // Recording UI
          <div className="flex items-center justify-between glass rounded-2xl border border-red-500/50 px-6 py-4" data-testid="recording-ui">
            <div className="flex items-center space-x-4">
              <div className="relative">
                <div className="w-4 h-4 rounded-full bg-red-500 animate-pulse" />
                <div className="absolute inset-0 w-4 h-4 rounded-full bg-red-500 animate-ping" />
              </div>
              <div>
                <div className="text-white font-medium">Recording...</div>
                <div className="text-white/60 text-sm">{formatTime(recordingTime)}</div>
              </div>
            </div>
            
            {/* Waveform Animation */}
            <div className="flex items-center space-x-1" data-testid="recording-waveform">
              {[...Array(20)].map((_, i) => (
                <div
                  key={i}
                  className="w-1 bg-gradient-to-t from-red-500 to-pink-500 rounded-full"
                  style={{
                    height: `${Math.random() * 20 + 10}px`,
                    animation: `pulse ${Math.random() * 0.5 + 0.5}s ease-in-out infinite`,
                    animationDelay: `${i * 0.05}s`
                  }}
                />
              ))}
            </div>
            
            <button
              onClick={stopRecording}
              data-testid="stop-recording-button"
              className="flex-shrink-0 w-12 h-12 rounded-full bg-red-500 flex items-center justify-center text-white hover:bg-red-600 transition-all duration-200"
            >
              <Square className="w-5 h-5" fill="currentColor" />
            </button>
          </div>
        ) : (
          // Normal input UI
          <div className="flex items-end space-x-3">
            <button
              data-testid="attach-button"
              className="flex-shrink-0 w-10 h-10 rounded-full glass border border-white/10 flex items-center justify-center text-white/60 hover:text-cyan-400 hover:border-cyan-400/50 transition-all duration-200"
            >
              <Paperclip className="w-5 h-5" />
            </button>
            
            <div className="flex-1 glass rounded-2xl border border-white/10 px-4 py-2 flex items-center space-x-3">
              <textarea
                ref={textareaRef}
                data-testid="chat-input"
                value={message}
                onChange={(e) => setMessage(e.target.value)}
                onKeyDown={handleKeyDown}
                placeholder="Ask CORTEX anything..."
                disabled={disabled}
                rows={1}
                className="flex-1 bg-transparent text-white placeholder-white/40 outline-none resize-none max-h-[120px] text-sm"
                style={{ minHeight: '24px' }}
              />
            </div>
            
            <button
              onClick={startRecording}
              data-testid="voice-button"
              className="flex-shrink-0 w-10 h-10 rounded-full glass border border-white/10 flex items-center justify-center text-white/60 hover:text-purple-400 hover:border-purple-400/50 transition-all duration-200 hover:scale-105"
            >
              <Mic className="w-5 h-5" />
            </button>
            
            <button
              onClick={handleSend}
              data-testid="send-button"
              disabled={!message.trim() || disabled}
              className="flex-shrink-0 w-10 h-10 rounded-full bg-gradient-to-r from-cyan-500 to-blue-600 flex items-center justify-center text-white hover:shadow-lg hover:scale-105 transition-all duration-200 disabled:opacity-40 disabled:cursor-not-allowed disabled:hover:scale-100"
            >
              <Send className="w-5 h-5" />
            </button>
          </div>
        )}
      </div>
    </div>
  );
};