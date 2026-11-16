import React, { useState, useEffect } from 'react';
import { MapContainer, TileLayer, Marker, Popup, useMap, ZoomControl } from 'react-leaflet';
import L from 'leaflet';
import { 
  Maximize2, 
  Eye, 
  MapPin, 
  Clock, 
  AlertTriangle, 
  ThumbsUp,
  Layers,
  Wrench,
  Navigation,
  ExternalLink,
  Satellite,
  Compass
} from 'lucide-react';

// Generar DivIcon personalizado con colores y badges según categoría y severidad
function createCustomPin(categoryColor, isCritical, categorySlug) {
  const isBache = categorySlug === 'bache';
  const isFuga = categorySlug === 'fuga';
  const isLuz = categorySlug === 'luminaria';
  const isSemaforo = categorySlug === 'semaforo';

  let symbol = '●';
  if (isBache) symbol = '🚧';
  else if (isFuga) symbol = '💧';
  else if (isLuz) symbol = '💡';
  else if (isSemaforo) symbol = '🚦';
  else symbol = '🗑️';

  const criticalPulse = isCritical 
    ? `<div style="position: absolute; width: 44px; height: 44px; border-radius: 50%; background: rgba(239, 68, 68, 0.4); animation: pulse-border 1.5s infinite; top: -6px; left: -6px; z-index: -1;"></div>`
    : '';

  return L.divIcon({
    className: 'custom-leaflet-marker',
    html: `
      <div style="position: relative; width: 32px; height: 32px;">
        ${criticalPulse}
        <div style="
          width: 32px; 
          height: 32px; 
          border-radius: 50%; 
          background: ${categoryColor}; 
          border: 2px solid #ffffff; 
          box-shadow: 0 4px 12px rgba(0,0,0,0.6); 
          display: flex; 
          align-items: center; 
          justify-content: center; 
          font-size: 14px;
          cursor: pointer;
          transition: transform 0.2s ease;
        ">
          ${symbol}
        </div>
      </div>
    `,
    iconSize: [32, 32],
    iconAnchor: [16, 16],
    popupAnchor: [0, -20]
  });
}

// Controlador interno de Leaflet para garantizar renderizado de tiles y recentrado
function MapController({ centerTrigger, defaultCenter, focusedIncident }) {
  const map = useMap();

  useEffect(() => {
    // Forzar recalculo de dimensiones para evitar tiles grises en carga inicial
    const t1 = setTimeout(() => map.invalidateSize(), 150);
    const t2 = setTimeout(() => map.invalidateSize(), 500);
    return () => {
      clearTimeout(t1);
      clearTimeout(t2);
    };
  }, [map]);

  useEffect(() => {
    if (focusedIncident && focusedIncident.latitude && focusedIncident.longitude) {
      map.flyTo([focusedIncident.latitude, focusedIncident.longitude], 16, { duration: 1.4 });
    }
  }, [focusedIncident, map]);

  useEffect(() => {
    if (centerTrigger > 0) {
      map.flyTo(defaultCenter, 14, { duration: 1.2 });
    }
  }, [centerTrigger, defaultCenter, map]);

  return null;
}

export default function IncidentsMap({ 
  reports = [], 
  categories = [],
  onSelectIncident,
  statusFilter,
  setStatusFilter,
  focusedIncident
}) {
  // 'dark' (Esri Dark Canvas), 'streets' (OpenStreetMap), 'satellite' (Esri Satellite)
  const [mapStyle, setMapStyle] = useState('dark');
  const [centerTrigger, setCenterTrigger] = useState(0);

  // Coordenadas de Morelia, Michoacán (Centro Histórico / Catedral de Morelia)
  const moreliaCenter = [19.7024, -101.1923];

  const getCategory = (catId) => categories.find(c => c.id === catId) || { color: '#3b82f6', name: 'General', slug: 'general' };

  return (
    <div className="glass-panel" style={{
      position: 'relative',
      borderRadius: 'var(--radius-md)',
      overflow: 'hidden',
      height: 'calc(100vh - 240px)',
      minHeight: '520px',
      border: '1px solid var(--border-subtle)'
    }}>
      {/* Top Floating Map Toolbar */}
      <div style={{
        position: 'absolute',
        top: '16px',
        left: '16px',
        right: '16px',
        zIndex: 1000,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        pointerEvents: 'none',
        flexWrap: 'wrap',
        gap: '10px'
      }}>
        {/* Status Filter Badges */}
        <div style={{
          display: 'flex',
          gap: '8px',
          background: 'rgba(15, 23, 42, 0.90)',
          backdropFilter: 'blur(12px)',
          padding: '6px 12px',
          borderRadius: 'var(--radius-full)',
          border: '1px solid var(--border-subtle)',
          pointerEvents: 'auto',
          boxShadow: '0 8px 20px rgba(0,0,0,0.5)'
        }}>
          {[
            { id: 'all', label: 'Todos' },
            { id: 'pending', label: 'Pendientes' },
            { id: 'assigned', label: 'Asignados' },
            { id: 'in_progress', label: 'En Obra' },
            { id: 'resolved', label: 'Resueltos' }
          ].map((st) => (
            <button
              key={st.id}
              onClick={() => setStatusFilter(st.id)}
              style={{
                background: statusFilter === st.id ? 'var(--primary)' : 'transparent',
                color: statusFilter === st.id ? '#ffffff' : 'var(--text-muted)',
                border: 'none',
                padding: '4px 10px',
                borderRadius: 'var(--radius-full)',
                fontSize: '0.75rem',
                fontWeight: statusFilter === st.id ? 700 : 500,
                cursor: 'pointer',
                transition: 'all 0.15s ease'
              }}
            >
              {st.label}
            </button>
          ))}
        </div>

        {/* Controls: Recentering & Map View Toggle */}
        <div style={{
          display: 'flex',
          gap: '8px',
          pointerEvents: 'auto'
        }}>
          {/* Centrar en Morelia */}
          <button
            onClick={() => setCenterTrigger(prev => prev + 1)}
            className="btn btn-secondary btn-sm"
            style={{
              background: 'rgba(15, 23, 42, 0.90)',
              backdropFilter: 'blur(12px)',
              fontSize: '0.75rem',
              padding: '6px 12px',
              border: '1px solid var(--border-subtle)',
              boxShadow: '0 8px 20px rgba(0,0,0,0.4)',
              color: '#38bdf8'
            }}
            title="Centrar mapa en la Catedral de Morelia"
          >
            <Navigation size={14} />
            <span>Centrar en Morelia</span>
          </button>

          {/* Selector de Capas */}
          <div style={{
            display: 'flex',
            gap: '4px',
            background: 'rgba(15, 23, 42, 0.90)',
            backdropFilter: 'blur(12px)',
            padding: '3px',
            borderRadius: 'var(--radius-sm)',
            border: '1px solid var(--border-subtle)',
            boxShadow: '0 8px 20px rgba(0,0,0,0.4)'
          }}>
            <button
              onClick={() => setMapStyle('dark')}
              style={{
                background: mapStyle === 'dark' ? 'var(--primary)' : 'transparent',
                color: mapStyle === 'dark' ? '#ffffff' : 'var(--text-muted)',
                border: 'none',
                borderRadius: '6px',
                padding: '4px 8px',
                fontSize: '0.73rem',
                fontWeight: mapStyle === 'dark' ? 700 : 500,
                cursor: 'pointer',
                display: 'flex',
                alignItems: 'center',
                gap: '4px'
              }}
            >
              <Layers size={13} />
              <span>Oscuro</span>
            </button>

            <button
              onClick={() => setMapStyle('streets')}
              style={{
                background: mapStyle === 'streets' ? 'var(--primary)' : 'transparent',
                color: mapStyle === 'streets' ? '#ffffff' : 'var(--text-muted)',
                border: 'none',
                borderRadius: '6px',
                padding: '4px 8px',
                fontSize: '0.73rem',
                fontWeight: mapStyle === 'streets' ? 700 : 500,
                cursor: 'pointer',
                display: 'flex',
                alignItems: 'center',
                gap: '4px'
              }}
            >
              <Compass size={13} />
              <span>Calles</span>
            </button>

            <button
              onClick={() => setMapStyle('satellite')}
              style={{
                background: mapStyle === 'satellite' ? 'var(--primary)' : 'transparent',
                color: mapStyle === 'satellite' ? '#ffffff' : 'var(--text-muted)',
                border: 'none',
                borderRadius: '6px',
                padding: '4px 8px',
                fontSize: '0.73rem',
                fontWeight: mapStyle === 'satellite' ? 700 : 500,
                cursor: 'pointer',
                display: 'flex',
                alignItems: 'center',
                gap: '4px'
              }}
            >
              <Satellite size={13} />
              <span>Satélite</span>
            </button>
          </div>
        </div>
      </div>

      {/* Floating Category Legend */}
      <div style={{
        position: 'absolute',
        bottom: '16px',
        left: '16px',
        zIndex: 1000,
        background: 'rgba(15, 23, 42, 0.90)',
        backdropFilter: 'blur(12px)',
        padding: '12px 16px',
        borderRadius: '12px',
        border: '1px solid var(--border-subtle)',
        fontSize: '0.74rem',
        boxShadow: '0 8px 24px rgba(0,0,0,0.5)',
        maxWidth: '260px'
      }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '8px' }}>
          <div style={{ fontWeight: 700, color: '#f1f5f9' }}>
            Mapa de Morelia, Mich.
          </div>
          <span style={{ fontSize: '0.68rem', color: '#38bdf8', fontWeight: 600 }}>C4 Municipal</span>
        </div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: '5px' }}>
          {categories.map((c) => (
            <div key={c.id} style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
              <span style={{
                width: '10px',
                height: '10px',
                borderRadius: '50%',
                backgroundColor: c.color,
                boxShadow: `0 0 6px ${c.color}`
              }} />
              <span style={{ color: 'var(--text-muted)' }}>{c.name.split('/')[0].trim()}</span>
            </div>
          ))}
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginTop: '4px', borderTop: '1px solid rgba(255,255,255,0.08)', paddingTop: '4px' }}>
            <span style={{
              width: '10px',
              height: '10px',
              borderRadius: '50%',
              backgroundColor: '#ef4444',
              boxShadow: '0 0 8px #ef4444'
            }} />
            <span style={{ color: '#f87171', fontWeight: 600 }}>Alerta Crítica / Emergencia</span>
          </div>
        </div>
      </div>

      {/* Actual Leaflet Map */}
      <MapContainer
        center={moreliaCenter}
        zoom={13}
        maxZoom={18}
        minZoom={10}
        style={{ width: '100%', height: '100%', background: '#0a0e17' }}
        zoomControl={false}
      >
        <ZoomControl position="bottomright" />
        <MapController centerTrigger={centerTrigger} defaultCenter={moreliaCenter} focusedIncident={focusedIncident} />

        {/* 1. MODO OSCURO (Esri World Dark Gray Canvas: 100% Gratuito y sin API Key) */}
        {mapStyle === 'dark' && (
          <>
            <TileLayer
              key="esri-dark-base"
              attribution='&copy; <a href="https://www.esri.com/">Esri</a>'
              url="https://server.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Dark_Gray_Base/MapServer/tile/{z}/{y}/{x}"
              maxZoom={16}
            />
            <TileLayer
              key="esri-dark-ref"
              url="https://server.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Dark_Gray_Reference/MapServer/tile/{z}/{y}/{x}"
              maxZoom={16}
            />
          </>
        )}

        {/* 2. MODO CALLES (OpenStreetMap: 100% Gratuito, detalle calle por calle de Morelia) */}
        {mapStyle === 'streets' && (
          <TileLayer
            key="osm-streets"
            attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
            url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
            maxZoom={19}
          />
        )}

        {/* 3. MODO SATÉLITE HD (Esri World Imagery + Capa de Calles) */}
        {mapStyle === 'satellite' && (
          <>
            <TileLayer
              key="esri-satellite"
              attribution='&copy; <a href="https://www.esri.com/">Esri</a>, Maxar'
              url="https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}"
              maxZoom={18}
            />
            <TileLayer
              key="esri-sat-labels"
              url="https://server.arcgisonline.com/ArcGIS/rest/services/Reference/World_Boundaries_and_Places/MapServer/tile/{z}/{y}/{x}"
              maxZoom={18}
            />
          </>
        )}

        {reports.map((report) => {
          const category = getCategory(report.categoryId);
          const isCritical = report.priority === 'critical';
          const pin = createCustomPin(category.color, isCritical, category.slug);

          return (
            <Marker
              key={report.id}
              position={[report.latitude, report.longitude]}
              icon={pin}
            >
              <Popup>
                <div style={{ padding: '6px', maxWidth: '280px' }}>
                  {/* Image Preview */}
                  {report.photoUrl && (
                    <div style={{
                      width: '100%',
                      height: '120px',
                      borderRadius: '8px',
                      overflow: 'hidden',
                      marginBottom: '10px',
                      position: 'relative'
                    }}>
                      <img 
                        src={report.photoUrl} 
                        alt={report.title} 
                        style={{ width: '100%', height: '100%', objectFit: 'cover' }}
                      />
                      <span className={`badge badge-${report.status}`} style={{
                        position: 'absolute',
                        top: '8px',
                        right: '8px',
                        boxShadow: '0 2px 6px rgba(0,0,0,0.6)'
                      }}>
                        {report.status.replace('_', ' ')}
                      </span>
                    </div>
                  )}

                  {/* Header info */}
                  <div style={{ display: 'flex', alignItems: 'center', gap: '6px', marginBottom: '4px' }}>
                    <span style={{
                      fontSize: '0.7rem',
                      fontWeight: 700,
                      color: category.color,
                      textTransform: 'uppercase'
                    }}>
                      {category.name.split('/')[0]}
                    </span>
                    <span style={{ color: 'var(--text-dim)', fontSize: '0.7rem' }}>•</span>
                    <span style={{ fontSize: '0.7rem', color: '#94a3b8' }}>
                      {report.ticketNumber}
                    </span>
                  </div>

                  <h4 style={{ 
                    fontSize: '0.88rem', 
                    fontWeight: 700, 
                    color: '#f8fafc', 
                    marginBottom: '6px',
                    lineHeight: '1.25' 
                  }}>
                    {report.title}
                  </h4>

                  <p style={{ 
                    fontSize: '0.75rem', 
                    color: 'var(--text-muted)', 
                    marginBottom: '10px',
                    lineHeight: '1.4' 
                  }}>
                    {report.description.length > 90 ? `${report.description.slice(0, 90)}...` : report.description}
                  </p>

                  <div style={{ 
                    display: 'flex', 
                    alignItems: 'center', 
                    gap: '6px', 
                    fontSize: '0.72rem', 
                    color: 'var(--text-dim)', 
                    marginBottom: '12px' 
                  }}>
                    <MapPin size={13} color="#94a3b8" />
                    <span style={{ whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
                      {report.address}
                    </span>
                  </div>

                  <button
                    onClick={() => onSelectIncident(report)}
                    className="btn btn-primary"
                    style={{ width: '100%', fontSize: '0.78rem', padding: '6px 12px' }}
                  >
                    <Eye size={14} />
                    <span>Inspeccionar & Despachar</span>
                  </button>
                </div>
              </Popup>
            </Marker>
          );
        })}
      </MapContainer>
    </div>
  );
}
