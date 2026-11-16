import React, { useEffect } from 'react';
import { AlertCircle, MapPin, X, ArrowRight, Radio } from 'lucide-react';

export default function LiveToast({ toast, onDismiss, onViewReport }) {
  useEffect(() => {
    if (!toast) return;
    const timer = setTimeout(() => {
      onDismiss();
    }, 9000);
    return () => clearTimeout(timer);
  }, [toast, onDismiss]);

  if (!toast) return null;

  const { report } = toast;

  return (
    <div
      style={{
        position: 'fixed',
        top: '24px',
        right: '24px',
        zIndex: 99999,
        minWidth: '360px',
        maxWidth: '440px',
        background: 'linear-gradient(135deg, rgba(15, 23, 42, 0.98), rgba(24, 32, 54, 0.96))',
        border: '1px solid #38bdf8',
        boxShadow: '0 20px 45px -10px rgba(56, 189, 248, 0.35), 0 0 20px rgba(0,0,0,0.8)',
        borderRadius: '16px',
        padding: '16px 18px',
        backdropFilter: 'blur(16px)',
        animation: 'slideInRight 0.35s cubic-bezier(0.16, 1, 0.3, 1)',
        color: '#f8fafc'
      }}
    >
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '8px' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
          <span
            style={{
              display: 'inline-flex',
              alignItems: 'center',
              gap: '6px',
              padding: '3px 8px',
              borderRadius: '9999px',
              background: 'rgba(56, 189, 248, 0.15)',
              border: '1px solid rgba(56, 189, 248, 0.4)',
              color: '#38bdf8',
              fontSize: '11px',
              fontWeight: 800,
              letterSpacing: '0.5px'
            }}
          >
            <span
              style={{
                width: '7px',
                height: '7px',
                borderRadius: '50%',
                background: '#38bdf8',
                boxShadow: '0 0 8px #38bdf8',
                animation: 'pulse 1.5s infinite'
              }}
            />
            EN VIVO • MORELIA
          </span>
          <span style={{ fontSize: '11px', color: '#94a3b8', fontWeight: 700 }}>
            {report?.ticketNumber}
          </span>
        </div>

        <button
          onClick={onDismiss}
          style={{
            background: 'transparent',
            border: 'none',
            color: '#64748b',
            cursor: 'pointer',
            padding: '2px',
            display: 'flex',
            alignItems: 'center'
          }}
        >
          <X size={16} />
        </button>
      </div>

      <div style={{ marginBottom: '10px' }}>
        <h4 style={{ margin: '0 0 4px 0', fontSize: '14px', fontWeight: 800, color: '#ffffff', lineHeight: 1.3 }}>
          {report?.title}
        </h4>
        <p style={{ margin: 0, fontSize: '12px', color: '#94a3b8', display: 'flex', alignItems: 'center', gap: '4px' }}>
          <MapPin size={13} color="#38bdf8" />
          {report?.address || 'Morelia, Michoacán'}
        </p>
      </div>

      <div style={{ display: 'flex', gap: '8px', marginTop: '12px' }}>
        <button
          onClick={() => {
            onViewReport(report);
            onDismiss();
          }}
          style={{
            flex: 1,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: '6px',
            padding: '8px 12px',
            borderRadius: '8px',
            background: 'linear-gradient(135deg, #0284c7, #0369a1)',
            color: '#ffffff',
            border: 'none',
            fontSize: '12px',
            fontWeight: 700,
            cursor: 'pointer',
            boxShadow: '0 4px 12px rgba(2, 132, 199, 0.4)'
          }}
        >
          <span>Centrar en Mapa</span>
          <ArrowRight size={13} />
        </button>
      </div>
    </div>
  );
}
