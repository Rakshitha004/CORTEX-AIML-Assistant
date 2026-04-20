import React, { createContext, useContext, useState, useCallback, useEffect } from 'react';

const ThemeContext = createContext(null);

export const useTheme = () => {
  const ctx = useContext(ThemeContext);
  if (!ctx) throw new Error('useTheme must be used within ThemeProvider');
  return ctx;
};

const THEME_KEY = 'cortex_theme';

export const themes = {
  default: {
    id: 'default',
    name: 'Default Dark',
    description: 'Blue/purple futuristic',
    accent: '#00F0FF',
    accentSecondary: '#0057FF',
    accentTertiary: '#9D4CDD',
    surface: 'rgba(255,255,255,0.03)',
    surfaceHover: 'rgba(255,255,255,0.06)',
    border: 'rgba(255,255,255,0.1)',
    bg: '#05050A',
    bgSurface: '#0A0A12',
    glowPrimary: 'rgba(0,240,255,0.25)',
    glowSecondary: 'rgba(0,87,255,0.25)',
    toggleOn: 'linear-gradient(135deg, #00F0FF, #0057FF)',
  },
  calm: {
    id: 'calm',
    name: 'Calm Mode',
    description: 'Soft blue/teal',
    accent: '#5DE5D5',
    accentSecondary: '#2D8B9A',
    accentTertiary: '#1A6B7A',
    surface: 'rgba(93,229,213,0.04)',
    surfaceHover: 'rgba(93,229,213,0.08)',
    border: 'rgba(93,229,213,0.12)',
    bg: '#060D0D',
    bgSurface: '#0A1414',
    glowPrimary: 'rgba(93,229,213,0.2)',
    glowSecondary: 'rgba(45,139,154,0.2)',
    toggleOn: 'linear-gradient(135deg, #5DE5D5, #2D8B9A)',
  },
  focus: {
    id: 'focus',
    name: 'Focus Mode',
    description: 'Minimal dark, low glow',
    accent: '#A0A0B0',
    accentSecondary: '#606070',
    accentTertiary: '#404050',
    surface: 'rgba(255,255,255,0.02)',
    surfaceHover: 'rgba(255,255,255,0.04)',
    border: 'rgba(255,255,255,0.06)',
    bg: '#08080C',
    bgSurface: '#0C0C12',
    glowPrimary: 'rgba(160,160,176,0.1)',
    glowSecondary: 'rgba(96,96,112,0.1)',
    toggleOn: 'linear-gradient(135deg, #A0A0B0, #606070)',
  },
  energetic: {
    id: 'energetic',
    name: 'Energetic Mode',
    description: 'Vibrant purple/pink',
    accent: '#FF00E4',
    accentSecondary: '#9D4CDD',
    accentTertiary: '#6B21D6',
    surface: 'rgba(255,0,228,0.04)',
    surfaceHover: 'rgba(255,0,228,0.08)',
    border: 'rgba(255,0,228,0.12)',
    bg: '#0A050A',
    bgSurface: '#120A14',
    glowPrimary: 'rgba(255,0,228,0.25)',
    glowSecondary: 'rgba(157,76,221,0.25)',
    toggleOn: 'linear-gradient(135deg, #FF00E4, #9D4CDD)',
  },
};

export const ThemeProvider = ({ children }) => {
  const [themeId, setThemeIdState] = useState(() => {
    try { return localStorage.getItem(THEME_KEY) || 'default'; } catch { return 'default'; }
  });

  const theme = themes[themeId] || themes.default;

  const setThemeId = useCallback((id) => {
    setThemeIdState(id);
    try { localStorage.setItem(THEME_KEY, id); } catch {}
  }, []);

  // Apply CSS custom properties
  useEffect(() => {
    const root = document.documentElement;
    root.style.setProperty('--cx-accent', theme.accent);
    root.style.setProperty('--cx-accent-secondary', theme.accentSecondary);
    root.style.setProperty('--cx-accent-tertiary', theme.accentTertiary);
    root.style.setProperty('--cx-surface', theme.surface);
    root.style.setProperty('--cx-surface-hover', theme.surfaceHover);
    root.style.setProperty('--cx-border', theme.border);
    root.style.setProperty('--cx-bg', theme.bg);
    root.style.setProperty('--cx-bg-surface', theme.bgSurface);
    root.style.setProperty('--cx-glow-primary', theme.glowPrimary);
    root.style.setProperty('--cx-glow-secondary', theme.glowSecondary);
    root.style.setProperty('--cx-toggle-on', theme.toggleOn);
    document.body.style.background = theme.bg;
  }, [theme]);

  return (
    <ThemeContext.Provider value={{ themeId, theme, setThemeId, allThemes: themes }}>
      {children}
    </ThemeContext.Provider>
  );
};