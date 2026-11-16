import { INITIAL_REPORTS } from '../data/mockData';

const API_BASE = 'http://localhost:3001/api';

// Generador de audio nativo con Web Audio API (sin archivos externos)
export function playChime() {
  try {
    const AudioContext = window.AudioContext || window.webkitAudioContext;
    if (!AudioContext) return;
    const ctx = new AudioContext();
    
    // Tono 1
    const osc1 = ctx.createOscillator();
    const gain1 = ctx.createGain();
    osc1.type = 'sine';
    osc1.frequency.setValueAtTime(587.33, ctx.currentTime); // D5
    gain1.gain.setValueAtTime(0.15, ctx.currentTime);
    gain1.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.35);
    osc1.connect(gain1);
    gain1.connect(ctx.destination);
    osc1.start();
    osc1.stop(ctx.currentTime + 0.35);

    // Tono 2 (acorde ascendente agradable)
    const osc2 = ctx.createOscillator();
    const gain2 = ctx.createGain();
    osc2.type = 'triangle';
    osc2.frequency.setValueAtTime(880.00, ctx.currentTime + 0.12); // A5
    gain2.gain.setValueAtTime(0.12, ctx.currentTime + 0.12);
    gain2.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.5);
    osc2.connect(gain2);
    gain2.connect(ctx.destination);
    osc2.start(ctx.currentTime + 0.12);
    osc2.stop(ctx.currentTime + 0.5);
  } catch (e) {
    // Silencio si el usuario no ha interactuado aún con el DOM
  }
}

// Cargar reportes iniciales desde la API o fallback local
export async function fetchLiveReports() {
  try {
    const res = await fetch(`${API_BASE}/reports`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const data = await res.json();
    return Array.isArray(data) && data.length > 0 ? data : INITIAL_REPORTS;
  } catch (err) {
    console.warn('[UrbanFix Live] Servidor local no disponible, operando en modo local/mock:', err.message);
    return INITIAL_REPORTS;
  }
}

// Suscripción al stream Server-Sent Events (SSE)
export function subscribeToLiveEvents(onEvent) {
  try {
    const eventSource = new EventSource(`${API_BASE}/events`);

    eventSource.onmessage = (event) => {
      try {
        const payload = JSON.parse(event.data);
        onEvent(payload);
      } catch (err) {
        console.error('[UrbanFix SSE] Error parseando evento:', err);
      }
    };

    eventSource.onerror = () => {
      // Reconexión automática de SSE
    };

    return () => {
      eventSource.close();
    };
  } catch (err) {
    console.warn('[UrbanFix SSE] No se pudo inicializar EventSource:', err);
    return () => {};
  }
}

// Actualizar estado o cuadrilla en el servidor
export async function updateReportOnServer(reportId, updateData) {
  try {
    const res = await fetch(`${API_BASE}/reports/${reportId}/status`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(updateData)
    });
    return await res.json();
  } catch (err) {
    console.warn('[UrbanFix Live] No se pudo sincronizar estado con el servidor:', err.message);
  }
}
