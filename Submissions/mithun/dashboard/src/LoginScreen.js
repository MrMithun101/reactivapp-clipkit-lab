import React from 'react';
import { useAuth0 } from '@auth0/auth0-react';

const styles = {
  page: {
    minHeight: '100vh',
    background: '#1a1a1a',
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    justifyContent: 'center',
    fontFamily: "'Inter', -apple-system, BlinkMacSystemFont, sans-serif",
    WebkitFontSmoothing: 'antialiased',
    padding: '24px',
  },
  brand: {
    textAlign: 'center',
    marginBottom: '36px',
  },
  logo: {
    fontSize: '32px',
    fontWeight: '700',
    color: '#ffffff',
    letterSpacing: '-0.5px',
    marginBottom: '8px',
  },
  logoAccent: {
    color: '#2E7D32',
  },
  tagline: {
    fontSize: '14px',
    color: '#888',
    letterSpacing: '0.2px',
  },
  card: {
    background: '#212121',
    border: '1px solid #2a2a2a',
    borderRadius: '16px',
    padding: '40px 36px',
    width: '100%',
    maxWidth: '400px',
  },
  cardTitle: {
    fontSize: '20px',
    fontWeight: '600',
    color: '#ffffff',
    marginBottom: '6px',
  },
  cardSub: {
    fontSize: '13px',
    color: '#666',
    marginBottom: '28px',
  },
  fieldGroup: {
    display: 'flex',
    flexDirection: 'column',
    gap: '14px',
    marginBottom: '24px',
  },
  label: {
    display: 'block',
    fontSize: '12px',
    fontWeight: '500',
    color: '#999',
    marginBottom: '6px',
    letterSpacing: '0.4px',
    textTransform: 'uppercase',
  },
  input: {
    width: '100%',
    background: '#2a2a2a',
    border: '1px solid #333',
    borderRadius: '8px',
    padding: '11px 14px',
    fontSize: '14px',
    color: '#e8e8e8',
    outline: 'none',
    transition: 'border-color 0.15s',
    boxSizing: 'border-box',
  },
  signInBtn: {
    width: '100%',
    background: '#2E7D32',
    color: '#ffffff',
    border: 'none',
    borderRadius: '8px',
    padding: '13px',
    fontSize: '15px',
    fontWeight: '600',
    cursor: 'pointer',
    letterSpacing: '0.2px',
    transition: 'background 0.15s, transform 0.1s',
  },
  divider: {
    borderTop: '1px solid #2a2a2a',
    margin: '28px 0 0',
  },
  footer: {
    marginTop: '40px',
    textAlign: 'center',
    fontSize: '12px',
    color: '#444',
    letterSpacing: '0.3px',
  },
  footerAccent: {
    color: '#2E7D32',
    fontWeight: '500',
  },
};

export default function LoginScreen() {
  const { loginWithRedirect } = useAuth0();

  return (
    <div style={styles.page}>
      <div style={styles.brand}>
        <div style={styles.logo}>
          Flour<span style={styles.logoAccent}>ish</span>
        </div>
        <p style={styles.tagline}>Charity analytics for the modern fundraiser</p>
      </div>

      <div style={styles.card}>
        <h1 style={styles.cardTitle}>Sign in</h1>
        <p style={styles.cardSub}>Access your charity dashboard</p>

        <div style={styles.fieldGroup}>
          <div>
            <label style={styles.label}>Email</label>
            <input
              style={styles.input}
              type="email"
              placeholder="you@charity.org"
              readOnly
              tabIndex={-1}
            />
          </div>
          <div>
            <label style={styles.label}>Password</label>
            <input
              style={styles.input}
              type="password"
              placeholder="••••••••"
              readOnly
              tabIndex={-1}
            />
          </div>
        </div>

        <button
          style={styles.signInBtn}
          onClick={() => loginWithRedirect()}
          onMouseOver={(e) => { e.currentTarget.style.background = '#388E3C'; }}
          onMouseOut={(e) => { e.currentTarget.style.background = '#2E7D32'; }}
          onMouseDown={(e) => { e.currentTarget.style.transform = 'scale(0.98)'; }}
          onMouseUp={(e) => { e.currentTarget.style.transform = 'scale(1)'; }}
        >
          Sign In
        </button>

        <div style={styles.divider} />
      </div>

      <footer style={styles.footer}>
        Powered by <span style={styles.footerAccent}>Flourish</span>
      </footer>
    </div>
  );
}
