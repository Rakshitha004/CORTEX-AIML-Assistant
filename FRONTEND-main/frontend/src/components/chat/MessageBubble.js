import React from 'react';
import { User, Bot } from 'lucide-react';
import Markdown from 'react-markdown';

export const MessageBubble = ({ message, isUser }) => {
  return (
    <div
      data-testid={isUser ? 'user-message' : 'ai-message'}
      className={`flex items-start space-x-3 mb-6 ${
        isUser ? 'flex-row-reverse space-x-reverse' : ''
      }`}
    >
      <div
        className={`flex-shrink-0 w-10 h-10 rounded-full flex items-center justify-center ${
          isUser
            ? 'bg-gradient-to-br from-cyan-400 to-blue-600'
            : 'bg-gradient-to-br from-purple-500 to-pink-600'
        }`}
      >
        {isUser ? <User className="w-5 h-5 text-white" /> : <Bot className="w-5 h-5 text-white" />}
      </div>
      
      <div
        className={`glass rounded-2xl px-4 py-3 max-w-[70%] ${
          isUser ? 'rounded-tr-sm' : 'rounded-tl-sm'
        }`}
      >
        {isUser ? (
          <p className="text-white text-sm leading-relaxed whitespace-pre-wrap break-words">
            {message}
          </p>
        ) : (
          <Markdown
            components={{
              table: ({ node, ...props }) => (
                <table className="border-collapse w-full my-2 text-sm" {...props} />
              ),
              th: ({ node, ...props }) => (
                <th className="border border-gray-500 px-3 py-2 bg-gray-700 text-white text-left" {...props} />
              ),
              td: ({ node, ...props }) => (
                <td className="border border-gray-600 px-3 py-2 text-gray-200" {...props} />
              ),
              tr: ({ node, ...props }) => (
                <tr className="even:bg-gray-800" {...props} />
              ),
              p: ({ node, ...props }) => (
                <p className="text-white text-sm leading-relaxed mb-1" {...props} />
              ),
            }}
          >
            {message}
          </Markdown>
        )}
      </div>
    </div>
  );
};
