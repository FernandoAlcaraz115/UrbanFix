import http from 'http';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const DATA_FILE = path.join(__dirname, 'reports_data.json');

const PORT = process.env.PORT || 3001;

// Dataset inicial de Morelia, Michoacán
const INITIAL_REPORTS = [
  {
    id: 'rep-001',
    ticketNumber: 'UF-MOR-0101',
    title: 'Bache profundo en carril derecho frente a Plaza de Armas',
    description: 'Bache de aproximadamente 45cm de diámetro que causa ponchaduras y frenazos bruscos sobre Av. Madero Poniente.',
    categoryId: 'cat_bache',
    status: 'in_progress',
    priority: 'high',
    latitude: 19.702750,
    longitude: -101.194100,
    address: 'Av. Francisco I. Madero Poniente #250, casi esq. Galeana',
    neighborhood: 'Centro Histórico',
    photoUrl: 'https://images.unsplash.com/photo-1515162816999-a0c47dc192f7?w=800&auto=format&fit=crop&q=80',
    citizenName: 'Alejandro Silva',
    citizenPhone: '443 145 8821',
    assignedCrewId: 'crew-01',
    upvotesCount: 18,
    createdAt: '2026-11-11T10:30:00Z',
    history: [
      { status: 'pending', date: '2026-11-11T10:30:00Z', note: 'Reporte registrado por ciudadano vía App Móvil UrbanFix' },
      { status: 'in_review', date: '2026-11-11T11:15:00Z', note: 'Validado por central de despacho C4 Morelia' },
      { status: 'assigned', date: '2026-11-12T08:00:00Z', note: 'Asignado a Brigada Bacheo Centro Histórico' },
      { status: 'in_progress', date: '2026-11-13T09:15:00Z', note: 'Cuadrilla en sitio aplicando mezcla asfáltica en caliente' }
    ]
  },
  {
    id: 'rep-002',
    ticketNumber: 'UF-MOR-0102',
    title: 'Fuga abundante de agua potable en banqueta rumbo a salida Pátzcuaro',
    description: 'Tubería rota bajo la banqueta. Brote de agua potable a presión inundando carril lateral de Calzada La Huerta.',
    categoryId: 'cat_fuga',
    status: 'assigned',
    priority: 'critical',
    latitude: 19.679200,
    longitude: -101.207800,
    address: 'Calzada La Huerta #840, frente a centro comercial',
    neighborhood: 'Col. Los Pinos',
    photoUrl: 'https://images.unsplash.com/photo-1541888946425-d0fbb18615f3?w=800&auto=format&fit=crop&q=80',
    citizenName: 'Mariana López Tinoco',
    citizenPhone: '443 982 3410',
    assignedCrewId: 'crew-03',
    upvotesCount: 34,
    createdAt: '2026-11-13T06:15:00Z',
    history: [
      { status: 'pending', date: '2026-11-13T06:15:00Z', note: 'Reporte prioritario recibido con coordenadas GPS' },
      { status: 'assigned', date: '2026-11-13T07:10:00Z', note: 'Despachado a cuadrilla de emergencia OOAPAS 24/7' }
    ]
  },
  {
    id: 'rep-003',
    ticketNumber: 'UF-MOR-0103',
    title: 'Luminaria apagada en Calzada San Diego / Las Tarascas',
    description: 'Poste colonial con foco fundido desde hace varios días. El andador peatonal queda a oscuras al caer la noche.',
    categoryId: 'cat_luminaria',
    status: 'pending',
    priority: 'medium',
    latitude: 19.701500,
    longitude: -101.177200,
    address: 'Calzada Fray Antonio de San Miguel esq. Av. Acueducto',
    neighborhood: 'Centro / San Diego',
    photoUrl: 'https://images.unsplash.com/photo-1509114397022-ed747cca3f65?w=800&auto=format&fit=crop&q=80',
    citizenName: 'Esteban Morales Hinojosa',
    citizenPhone: '443 456 7891',
    assignedCrewId: null,
    upvotesCount: 9,
    createdAt: '2026-11-12T19:40:00Z',
    history: [
      { status: 'pending', date: '2026-11-12T19:40:00Z', note: 'En espera de programación de Alumbrado Público' }
    ]
  },
  {
    id: 'rep-004',
    ticketNumber: 'UF-MOR-0104',
    title: 'Semáforo intermitente en cruce de alto flujo Camelinas y Ventura Puente',
    description: 'Luces ámbar y roja parpadeando al mismo tiempo frente a Ceconexpo. Caos vial y peligro inminente de choque.',
    categoryId: 'cat_semaforo',
    status: 'in_review',
    priority: 'critical',
    latitude: 19.684500,
    longitude: -101.183400,
    address: 'Av. Camelinas esq. Av. Ventura Puente',
    neighborhood: 'Col. Félix Ireta / Ceconexpo',
    photoUrl: 'https://images.unsplash.com/photo-1572970725354-93ff912a208c?w=800&auto=format&fit=crop&q=80',
    citizenName: 'Rodrigo Casas Medina',
    citizenPhone: '443 318 9044',
    assignedCrewId: null,
    upvotesCount: 42,
    createdAt: '2026-11-13T08:00:00Z',
    history: [
      { status: 'pending', date: '2026-11-13T08:00:00Z', note: 'Múltiples alertas ciudadanas recibidas en 15 minutos' },
      { status: 'in_review', date: '2026-11-13T08:15:00Z', note: 'C4 Morelia verificando cámaras de videovigilancia vial' }
    ]
  },
  {
    id: 'rep-005',
    ticketNumber: 'UF-MOR-0105',
    title: 'Ramas de poda y cascajo acumulado obstruyendo banqueta',
    description: 'Costales de escombros y ramas secas sobre la acera peatonal impidiendo el libre paso rumbo a Plaza Las Américas.',
    categoryId: 'cat_basura',
    status: 'assigned',
    priority: 'low',
    latitude: 19.688500,
    longitude: -101.162800,
    address: 'Av. Enrique Ramírez Miguel #310',
    neighborhood: 'Col. Chapultepec Oriente / Las Américas',
    photoUrl: 'https://images.unsplash.com/photo-1611288875685-147054941d42?w=800&auto=format&fit=crop&q=80',
    citizenName: 'Lucía Herrera Orozco',
    citizenPhone: '443 667 8899',
    assignedCrewId: 'crew-05',
    upvotesCount: 5,
    createdAt: '2026-11-10T12:00:00Z',
    history: [
      { status: 'pending', date: '2026-11-10T12:00:00Z', note: 'Reporte ingresado' },
      { status: 'assigned', date: '2026-11-12T11:00:00Z', note: 'Asignado a Cuadrilla de Limpia y Parques' }
    ]
  },
  {
    id: 'rep-006',
    ticketNumber: 'UF-MOR-0106',
    title: 'Bache reparado y sellado sobre Av. Acueducto',
    description: 'Trabajo de bacheo profundo completado con asfalto AC-20 y compactación con rodillo mecánico.',
    categoryId: 'cat_bache',
    status: 'resolved',
    priority: 'high',
    latitude: 19.700800,
    longitude: -101.171200,
    address: 'Av. Acueducto #1050, pasando el Bosque Cuauhtémoc',
    neighborhood: 'Col. Chapultepec Norte',
    photoUrl: 'https://images.unsplash.com/photo-1584463699043-4b684cb3501a?w=800&auto=format&fit=crop&q=80',
    resolutionPhotoUrl: 'https://images.unsplash.com/photo-1541888946425-d0fbb18615f3?w=800&auto=format&fit=crop&q=80',
    resolutionNotes: 'Se realizó corte perimetral de 2.5m2, aplicación de liga asfáltica y rodillado.',
    citizenName: 'Patricio Vega Ruiz',
    citizenPhone: '443 443 2211',
    assignedCrewId: 'crew-01',
    upvotesCount: 11,
    createdAt: '2026-11-08T09:00:00Z',
    resolvedAt: '2026-11-11T16:30:00Z',
    history: [
      { status: 'pending', date: '2026-11-08T09:00:00Z', note: 'Reporte ciudadano' },
      { status: 'assigned', date: '2026-11-09T08:30:00Z', note: 'Asignado a Brigada Bacheo Centro' },
      { status: 'in_progress', date: '2026-11-10T10:00:00Z', note: 'Trabajos de fresado y preparación' },
      { status: 'resolved', date: '2026-11-11T16:30:00Z', note: 'Obra concluida y verificada con fotografía posterior' }
    ]
  },
  {
    id: 'rep-007',
    ticketNumber: 'UF-MOR-0107',
    title: 'Fuga de agua en medidor sobre camellón de García de León',
    description: 'Fuga constante con desperdicio de agua hacia el arroyo vehicular sobre el Boulevard.',
    categoryId: 'cat_fuga',
    status: 'pending',
    priority: 'medium',
    latitude: 19.691200,
    longitude: -101.174500,
    address: 'Boulevard García de León #920',
    neighborhood: 'Col. Chapultepec Sur',
    photoUrl: 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=800&auto=format&fit=crop&q=80',
    citizenName: 'Diana Rivas Solórzano',
    citizenPhone: '443 889 0012',
    assignedCrewId: null,
    upvotesCount: 6,
    createdAt: '2026-11-13T09:00:00Z',
    history: [
      { status: 'pending', date: '2026-11-13T09:00:00Z', note: 'Nuevo reporte capturado con GPS' }
    ]
  },
  {
    id: 'rep-008',
    ticketNumber: 'UF-MOR-0108',
    title: 'Dos luminarias LED sin encender en Calzada Juárez frente al Zoológico',
    description: 'Tramo de 60 metros sobre la banqueta del Zoológico queda en penumbra total por la noche.',
    categoryId: 'cat_luminaria',
    status: 'in_progress',
    priority: 'high',
    latitude: 19.682800,
    longitude: -101.196500,
    address: 'Calzada Juárez #340, frente al Zoológico de Morelia',
    neighborhood: 'Col. Villa Universidad',
    photoUrl: 'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?w=800&auto=format&fit=crop&q=80',
    citizenName: 'Gabriel Navarro Soto',
    citizenPhone: '443 112 3344',
    assignedCrewId: 'crew-02',
    upvotesCount: 26,
    createdAt: '2026-11-12T20:00:00Z',
    history: [
      { status: 'pending', date: '2026-11-12T20:00:00Z', note: 'Reporte ingresado' },
      { status: 'assigned', date: '2026-11-13T07:45:00Z', note: 'Asignado a Brigada Alumbrado' },
      { status: 'in_progress', date: '2026-11-13T09:30:00Z', note: 'Grúa de alumbrado en sitio sustituyendo luminarias suburbanas a LED' }
    ]
  },
  {
    id: 'rep-009',
    ticketNumber: 'UF-MOR-0109',
    title: 'Desgaste severo en Periférico Norte cerca de Estadio Morelos',
    description: 'Zanja y bache sobre carril de alta velocidad en Periférico Paseo de la República.',
    categoryId: 'cat_bache',
    status: 'pending',
    priority: 'critical',
    latitude: 19.728500,
    longitude: -101.231000,
    address: 'Periférico Paseo de la República Norte km 14',
    neighborhood: 'Sector Revolución / Estadio Morelos',
    photoUrl: 'https://images.unsplash.com/photo-1515162816999-a0c47dc192f7?w=800&auto=format&fit=crop&q=80',
    citizenName: 'Jorge Bucio Calderón',
    citizenPhone: '443 778 9911',
    assignedCrewId: null,
    upvotesCount: 31,
    createdAt: '2026-11-13T10:10:00Z',
    history: [
      { status: 'pending', date: '2026-11-13T10:10:00Z', note: 'Alerta ciudadana de alta velocidad' }
    ]
  }
];

// Cargar o inicializar reportes en memoria
let reports = [];

function loadReports() {
  try {
    if (fs.existsSync(DATA_FILE)) {
      const raw = fs.readFileSync(DATA_FILE, 'utf-8');
      reports = JSON.parse(raw);
      console.log(`[UrbanFix Server] ${reports.length} reportes cargados desde ${DATA_FILE}`);
      return;
    }
  } catch (err) {
    console.warn('[UrbanFix Server] No se pudo leer archivo de datos existente, usando iniciales:', err.message);
  }
  reports = JSON.parse(JSON.stringify(INITIAL_REPORTS));
  saveReports();
}

function saveReports() {
  try {
    fs.writeFileSync(DATA_FILE, JSON.stringify(reports, null, 2), 'utf-8');
  } catch (err) {
    console.error('[UrbanFix Server] Error al guardar datos:', err.message);
  }
}

// Suscriptores de Server-Sent Events (SSE)
const sseClients = new Set();

function broadcastEvent(eventType, payload) {
  const data = JSON.stringify({ type: eventType, data: payload, timestamp: new Date().toISOString() });
  for (const client of sseClients) {
    client.write(`data: ${data}\n\n`);
  }
}

// Cálculo Haversine de distancia entre coordenadas (metros)
function haversineDistance(lat1, lon1, lat2, lon2) {
  const R = 6371000; // Radio de la Tierra en metros
  const toRad = (x) => (x * Math.PI) / 180;
  const dLat = toRad(lat2 - lat1);
  const dLon = toRad(lon2 - lon1);
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * Math.sin(dLon / 2) * Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}

// Servidor HTTP
const server = http.createServer((req, res) => {
  // Configuración CORS completa
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PATCH, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    res.writeHead(204);
    res.end();
    return;
  }

  const parsedUrl = new URL(req.url, `http://${req.headers.host || 'localhost'}`);
  const pathname = parsedUrl.pathname;

  // 1. Verificación de salud
  if (req.method === 'GET' && (pathname === '/' || pathname === '/health')) {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({
      status: 'online',
      service: 'UrbanFix Live Sync Server (Morelia)',
      connectedClients: sseClients.size,
      totalReports: reports.length,
      time: new Date().toISOString()
    }));
    return;
  }

  // 2. Canal de eventos en vivo SSE (Server-Sent Events)
  if (req.method === 'GET' && pathname === '/api/events') {
    res.writeHead(200, {
      'Content-Type': 'text/event-stream',
      'Cache-Control': 'no-cache',
      'Connection': 'keep-alive',
      'Access-Control-Allow-Origin': '*'
    });
    res.write(`data: ${JSON.stringify({ type: 'CONNECTED', message: 'Conectado a UrbanFix Live Dispatch C4 Morelia' })}\n\n`);

    sseClients.add(res);

    req.on('close', () => {
      sseClients.delete(res);
    });
    return;
  }

  // 3. Obtener lista de reportes
  if (req.method === 'GET' && pathname === '/api/reports') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify(reports));
    return;
  }

  // 4. Crear nuevo reporte (desde la App Móvil o Web)
  if (req.method === 'POST' && pathname === '/api/reports') {
    let body = '';
    req.on('data', chunk => { body += chunk; });
    req.on('end', () => {
      try {
        const payload = JSON.parse(body);

        // Generar folio consecutivo
        const num = reports.length + 101;
        const ticketNumber = payload.ticketNumber || `UF-MOR-0${num}`;
        const newId = payload.id || `rep-${Date.now()}`;

        const newReport = {
          id: newId,
          ticketNumber: ticketNumber,
          title: payload.title || 'Falla urbana reportada por ciudadano',
          description: payload.description || '',
          categoryId: payload.categoryId || 'cat_bache',
          status: 'pending',
          priority: payload.priority || 'medium',
          latitude: Number(payload.latitude) || 19.7024,
          longitude: Number(payload.longitude) || -101.1923,
          address: payload.address || 'Ubicación en Morelia, Mich.',
          neighborhood: payload.neighborhood || 'Centro',
          photoUrl: payload.photoUrl || 'https://images.unsplash.com/photo-1515162816999-a0c47dc192f7?w=800&auto=format&fit=crop&q=80',
          citizenName: payload.citizenName || 'Tú (Ciudadano)',
          citizenPhone: payload.citizenPhone || '443 555 0199',
          assignedCrewId: null,
          upvotesCount: 1,
          createdAt: new Date().toISOString(),
          history: [
            {
              status: 'pending',
              date: new Date().toISOString(),
              note: 'Reporte ingresado por ciudadano vía App Móvil UrbanFix'
            }
          ]
        };

        // Agregar al inicio
        reports.unshift(newReport);
        saveReports();

        // Notificar en tiempo real al panel admin y a todas las apps
        broadcastEvent('REPORT_CREATED', newReport);

        res.writeHead(201, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify(newReport));
      } catch (err) {
        res.writeHead(400, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Payload JSON inválido', details: err.message }));
      }
    });
    return;
  }

  // 5. Apoyar reporte (+1 Voto Ciudadano)
  const upvoteMatch = pathname.match(/^\/api\/reports\/([^/]+)\/upvote$/);
  if (req.method === 'POST' && upvoteMatch) {
    const reportId = upvoteMatch[1];
    const report = reports.find(r => r.id === reportId || r.ticketNumber === reportId);

    if (!report) {
      res.writeHead(404, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ error: 'Reporte no encontrado' }));
      return;
    }

    report.upvotesCount = (report.upvotesCount || 0) + 1;
    if (!report.history) report.history = [];
    report.history.push({
      status: report.status,
      date: new Date().toISOString(),
      note: 'Apoyo ciudadano (+1) sumado por vecino en la misma zona'
    });

    saveReports();
    broadcastEvent('REPORT_UPVOTED', report);

    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify(report));
    return;
  }

  // 6. Cambiar estado o cuadrilla asignada (desde el Panel C4)
  const statusMatch = pathname.match(/^\/api\/reports\/([^/]+)\/status$/);
  if (req.method === 'PATCH' && statusMatch) {
    const reportId = statusMatch[1];
    let body = '';
    req.on('data', chunk => { body += chunk; });
    req.on('end', () => {
      try {
        const { status, assignedCrewId, note, resolutionPhotoUrl } = JSON.parse(body);
        const report = reports.find(r => r.id === reportId || r.ticketNumber === reportId);

        if (!report) {
          res.writeHead(404, { 'Content-Type': 'application/json' });
          res.end(JSON.stringify({ error: 'Reporte no encontrado' }));
          return;
        }

        if (status) report.status = status;
        if (assignedCrewId !== undefined) report.assignedCrewId = assignedCrewId;
        if (resolutionPhotoUrl) report.resolutionPhotoUrl = resolutionPhotoUrl;
        if (status === 'resolved') report.resolvedAt = new Date().toISOString();

        if (!report.history) report.history = [];
        report.history.push({
          status: report.status,
          date: new Date().toISOString(),
          note: note || `Estado actualizado a ${report.status} por C4 Morelia`
        });

        saveReports();
        broadcastEvent('REPORT_STATUS_CHANGED', report);

        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify(report));
      } catch (err) {
        res.writeHead(400, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Payload JSON inválido' }));
      }
    });
    return;
  }

  // 7. Endpoint detector de duplicados (RPC espacial rápido)
  if (req.method === 'POST' && pathname === '/api/reports/check-duplicate') {
    let body = '';
    req.on('data', chunk => { body += chunk; });
    req.on('end', () => {
      try {
        const { latitude, longitude, categoryId, radius = 35 } = JSON.parse(body);
        const lat = Number(latitude);
        const lon = Number(longitude);

        const candidates = reports.filter(r => {
          if (r.status === 'resolved') return false;
          if (categoryId && r.categoryId !== categoryId) return false;
          const dist = haversineDistance(lat, lon, r.latitude, r.longitude);
          return dist <= radius;
        });

        if (candidates.length > 0) {
          const nearest = candidates.reduce((prev, curr) => {
            const dPrev = haversineDistance(lat, lon, prev.latitude, prev.longitude);
            const dCurr = haversineDistance(lat, lon, curr.latitude, curr.longitude);
            return dCurr < dPrev ? curr : prev;
          });
          const dist = Math.round(haversineDistance(lat, lon, nearest.latitude, nearest.longitude));

          res.writeHead(200, { 'Content-Type': 'application/json' });
          res.end(JSON.stringify({
            isDuplicate: true,
            distanceMeters: dist,
            existingReport: nearest,
            message: `Ya existe un reporte similar a ${dist}m de tu ubicación.`
          }));
        } else {
          res.writeHead(200, { 'Content-Type': 'application/json' });
          res.end(JSON.stringify({ isDuplicate: false }));
        }
      } catch (err) {
        res.writeHead(400, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Error al procesar coordenadas' }));
      }
    });
    return;
  }

  // Ruta no encontrada
  res.writeHead(404, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify({ error: 'Endpoint no encontrado' }));
});

// Inicializar y escuchar
loadReports();

server.listen(PORT, '0.0.0.0', () => {
  console.log('========================================================');
  console.log(`🚨 UrbanFix Live Server (C4 Morelia) activo en puerto ${PORT}`);
  console.log(`👉 API REST: http://localhost:${PORT}/api/reports`);
  console.log(`👉 Eventos en vivo (SSE): http://localhost:${PORT}/api/events`);
  console.log('========================================================');
});
