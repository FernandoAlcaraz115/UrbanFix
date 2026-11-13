# 🏙️ UrbanFix — Reporte Ciudadano Inteligente de Infraestructura Urbana

<p align="center">
  <strong>Plataforma integral GovTech para reporte, geolocalización, despacho y seguimiento en tiempo real de fallas en infraestructura urbana.</strong><br>
  <em>Diseñada e implementada para el H. Ayuntamiento de Morelia, Michoacán, México.</em>
</p>

---

## 📌 El Problema
En las ciudades modernas, los ciudadanos frecuentemente reportan baches, luminarias descompuestas, fugas de agua potable, semáforos averiados o acumulación de basura en redes sociales (Twitter/X, Facebook, grupos de WhatsApp). Esto ocasiona:
- **Pérdida de trazabilidad:** Las denuncias quedan dispersas y sin folio oficial.
- **Falta de coordenadas precisas:** Los ayuntamientos no pueden localizar el punto exacto de la falla.
- **Reportes duplicados:** Decenas de personas reportan el mismo bache sin que el municipio pueda agruparlos eficientemente.
- **Desconfianza ciudadana:** El ciudadano nunca se entera si su reporte fue canalizado o reparado.

## 💡 La Solución UrbanFix
**UrbanFix** conecta directamente al ciudadano de a pie con las cuadrillas de servicios públicos y el centro de comando municipal (C5 / Obras Públicas):

1. **App Móvil Ciudadana (Flutter):** Captura fotográfica con georreferenciación GPS automática y detector inteligente de duplicados por radio de proximidad.
2. **Panel Web de Comando y Despacho (React + Vite):** Mapa interactivo de calor/pines con Leaflet, tablero Kanban de flujo de obra, asignación de cuadrillas y métricas de cumplimiento de SLA.
3. **Backend Geoespacial (Supabase + PostgreSQL + PostGIS):** Consultas espaciales de alta velocidad con tipo `GEOGRAPHY(Point, 4326)` y funciones RPC para prevención de duplicados en 30 metros.

---

## 🏗️ Arquitectura del Sistema

```
[ App Móvil (Flutter) ]              [ Panel Admin Web (React + Vite) ]
   • Cámara + GPS                       • Mapa CartoDB Dark + Leaflet
   • Folio de seguimiento               • Tablero Kanban de Despacho
   • Detector duplicados (<30m)         • Asignación de Cuadrillas
             │                                    │
             └─────────────────┬──────────────────┘
                               │
                               ▼
               [ Supabase (PostgreSQL + PostGIS) ]
                  • Tabla `reports` (Geom Point)
                  • Tabla `crews` (Brigadas de obra)
                  • Tabla `categories` & `report_history`
                  • RPC `find_nearby_reports()`
```

---

## 📂 Estructura del Repositorio

```text
UrbanFix/
├── admin/                     # Panel Web de Gestión Municipal (React + Vite)
│   ├── src/
│   │   ├── components/        # Mapa, Kanban, Tabla, KPIs, Cuadrillas, Métricas
│   │   ├── data/              # Dataset de prueba y simulación reactiva
│   │   ├── services/          # Cliente Supabase con detección automática
│   │   ├── styles/            # Sistema de diseño GovTech oscuro (theme.css)
│   │   ├── App.jsx
│   │   └── main.jsx
│   ├── index.html
│   ├── package.json
│   └── vite.config.js
├── supabase/                  # Base de Datos y Lógica Geoespacial
│   ├── schema.sql             # Esquema DDL con extensiones PostGIS e índices GiST
│   └── seed.sql               # Datos iniciales (categorías, cuadrillas, reportes reales)
└── docs/                      # Diagramas, requerimientos y especificaciones
```

---

## 🚀 Puesta en Marcha

### Opción Rápida (Windows):
Simplemente haz doble clic en el archivo **`iniciar.bat`** en la raíz de la carpeta `UrbanFix/`. El script verificará Node.js, instalará dependencias si es necesario y abrirá automáticamente el panel web en tu navegador.

### Opción Manual desde Terminal:
```bash
# Entrar al directorio del panel admin
cd admin

# Instalar dependencias
npm install

# Iniciar servidor de desarrollo y abrir navegador
npm run dev -- --open
```
La aplicación estará disponible en `http://localhost:5173/` (o el puerto indicado por Vite).

#### Conexión a Supabase (Opcional):
Por defecto, la aplicación incluye un adaptador de datos simulados reactivo para pruebas inmediatas sin configuración. Para conectar tu propia instancia de Supabase:
1. Crea un archivo `.env` en la carpeta `admin/`:
   ```env
   VITE_SUPABASE_URL=https://tu-proyecto.supabase.co
   VITE_SUPABASE_ANON_KEY=tu-anon-key
   ```
2. Ejecuta el script `supabase/schema.sql` y `supabase/seed.sql` en el SQL Editor de tu consola de Supabase.

---

## 🛠️ Stack Tecnológico

| Capa | Tecnología | Propósito |
| :--- | :--- | :--- |
| **Panel Web Admin** | React 18, Vite | Dashboard rápido, reactivo y modular para supervisores. |
| **Cartografía** | Leaflet, React-Leaflet, CartoDB | Renderizado de pines personalizados, popups y clusters. |
| **Diseño & UI** | CSS3 Glassmorphism, Lucide Icons | Interfaz moderna oscura con indicadores de pulso para reportes críticos. |
| **Base de Datos** | PostgreSQL 15+ & PostGIS (Supabase) | Cálculos de proximidad espacial y soporte geoespacial nativo. |
| **App Móvil (Fase 2)** | Flutter (Dart) | Aplicación multiplataforma para ciudadanos y brigadas de campo. |

---

## 📋 Estado del Proyecto

- [x] **Entregable 1:** Panel Web Administrativo Municipal (React + Vite + Leaflet)
- [x] **Entregable 1:** Esquema SQL con soporte PostGIS y función RPC de duplicados
- [ ] **Entregable 2:** App Móvil Ciudadana en Flutter (Cámara, GPS y seguimiento de tickets)
- [ ] **Entregable 3:** App Móvil modo Técnico (Evidencia de reparación con foto Antes/Después)

---

## 📄 Licencia
Este proyecto está bajo la Licencia MIT.

