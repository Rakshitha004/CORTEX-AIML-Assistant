import React, { useEffect, useRef } from 'react';
import { MessageCircle, Trash2 } from 'lucide-react';
import gsap from 'gsap';

export const Sidebar = ({ isOpen, conversations, activeConversation, onSelectConversation, onNewChat, onDeleteConversation }) => {
  const sidebarRef = useRef(null);
  
  useEffect(() => {
    if (sidebarRef.current) {
      gsap.to(sidebarRef.current, {
        width: isOpen ? '260px' : '0px',
        opacity: isOpen ? 1 : 0,
        duration: 0.3,
        ease: 'power2.inOut'
      });
    }
  }, [isOpen]);
  
  return (
    <div
      ref={sidebarRef}
      className="h-full overflow-hidden flex-shrink-0"
      style={{ width: isOpen ? '260px' : '0px' }}
      data-testid="chat-sidebar"
    >
      <div className="h-full w-[260px] glass border-r border-white/10 flex flex-col p-4">
        <button
          onClick={onNewChat}
          data-testid="new-chat-button"
          className="w-full mb-4 px-4 py-3 rounded-lg bg-gradient-to-r from-cyan-500 to-blue-600 text-white font-medium flex items-center justify-center space-x-2 hover:shadow-lg hover:scale-105 transition-all duration-200"
        >
          <MessageCircle className="w-5 h-5" />
          <span>New Chat</span>
        </button>
        
        <div className="flex-1 overflow-y-auto space-y-2">
          <div className="text-xs uppercase tracking-wider text-white/40 mb-2 px-2">Conversations</div>
          {conversations.length === 0 ? (
            <div className="text-sm text-white/40 text-center py-8">No conversations yet</div>
          ) : (
            conversations.map((conv) => (
              <div
                key={conv.id}
                data-testid={`conversation-${conv.id}`}
                onClick={() => onSelectConversation(conv.id)}
                className={`group relative px-3 py-2.5 rounded-lg cursor-pointer transition-all duration-200 ${
                  activeConversation === conv.id
                    ? 'bg-white/10 border border-cyan-400/30'
                    : 'hover:bg-white/5 border border-transparent'
                }`}
              >
                <div className="flex items-start justify-between">
                  <div className="flex-1 min-w-0">
                    <div className="text-sm text-white font-medium truncate">
                      {conv.title || 'New Conversation'}
                    </div>
                    <div className="text-xs text-white/40 truncate mt-0.5">
                      {conv.lastMessage || 'Start chatting...'}
                    </div>
                  </div>
                  <button
                    onClick={(e) => {
                      e.stopPropagation();
                      onDeleteConversation(conv.id);
                    }}
                    data-testid={`delete-conversation-${conv.id}`}
                    className="opacity-0 group-hover:opacity-100 transition-opacity ml-2 text-white/40 hover:text-red-400"
                  >
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
