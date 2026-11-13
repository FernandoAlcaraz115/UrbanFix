# UrbanFix — Especificación Técnica: Entregable 1

## 1. Visión General
El **Entregable 1** consiste en el centro de comando para supervisores y directores de obras públicas del municipio. Permite centralizar reportes de fallas urbanas (baches, luminarias, fugas, semáforos, basura), visualizarlos en tiempo real en un mapa interactivo con estética nocturna/técnica, despacharlos mediante un tablero Kanban y auditar métricas de SLA.

---

## 2. Módulos Implementados

### Módulo A: Dashboard Operativo & KPIs
- Indicadores en tiempo real:
  - Total de reportes ingresados.
  - Incidencias con cuadrilla en campo.
  - Incidencias resueltas con porcentaje de efectividad.
  - Alertas críticas en tiempo real (con animación de pulso).
  - Votos acumulados (+1 de apoyo ciudadano).

### Módulo B: Mapa Geoespacial Interactivo
- Integración con Leaflet y CartoDB Dark Matter tiles.
- Pines personalizados por categoría de infraestructura:
  - 🚧 Baches / Asfalto Dañado
  - 💡 Luminarias Fundidas
  - 💧 Fugas de Agua Potable
  - 🚦 Semáforos Averiados
  - 🗑️ Basura Acumulada
- Anillo de pulso rojo animado para reportes de urgencia crítica.
- Popups informativos con miniatura fotográfica, dirección, ticket y botón de inspección.

### Módulo C: Tablero Kanban de Despacho
- Columnas de estado operativo:
  1. `Recibidos`: Reportes entrantes sin asignar.
  2. `En Revisión`: Verificación de cámaras C5 o llamada.
  3. `Asignados`: Vinculados a una brigada técnica específica.
  4. `En Obra`: Cuadrilla laborando en sitio.
  5. `Resueltos`: Reparación concluida y verificada con evidencia.
- Tarjetas con fotografía, nivel de severidad y botón de avance rápido de fase.

### Módulo D: Modal de Inspección & Despacho
- Vista fotográfica ampliada de la evidencia ciudadana con coordenadas GPS exactas.
- Asignador de cuadrillas municipales disponibles en tiempo real.
- Selector de cambio de fase de estado.
- Datos del ciudadano y número de teléfono de contacto.

### Módulo E: Directorio de Cuadrillas Municipales
- Brigadas de campo divididas por área técnica (Obras Públicas, Alumbrado, Agua, Movilidad).
- Estado operativo (`Disponible` o `En Obra`), jefe de cuadrilla y tareas en curso.

### Módulo F: Métricas de Desempeño
- Cumplimiento de SLA (porcentaje antes del tiempo límite legal).
- Tiempo medio de atención (horas).
- Contador de tickets duplicados prevenidos mediante geocercas.
- Distribución de fallas por colonia y sector de la ciudad.

---

## 3. Base de Datos y Modelo PostGIS (Supabase)
- **Extensión PostGIS:** Uso de `GEOGRAPHY(Point, 4326)` para cálculos esféricos en metros.
- **Trigger `update_report_geom`:** Actualiza automáticamente el punto espacial al recibir `latitude` y `longitude`.
- **Índice GiST:** Para búsquedas espaciales en milisegundos (`idx_reports_location`).
- **Función RPC `find_nearby_reports`:** Algoritmo para detectar incidencias dentro de un radio de $X$ metros (evita reportes duplicados en la app móvil).

