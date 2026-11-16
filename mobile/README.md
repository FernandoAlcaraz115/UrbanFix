# 📱 UrbanFix Mobile — App Ciudadana de Morelia, Michoacán

Aplicación móvil multiplataforma desarrollada en **Flutter** para el reporte y seguimiento ciudadano de infraestructura urbana (baches, luminarias fundidas, fugas de agua potable, semáforos y basura) en el **H. Ayuntamiento de Morelia**.

---

## 🌟 Funcionalidades Implementadas

1. **Captura Fotográfica Rápida:** Foto directa de la falla urbana como evidencia inmutable.
2. **Geolocalización GPS Automática:** Detección de coordenadas exactas y geocodificación de calles de Morelia (Centro Histórico, Calzada La Huerta, Camelinas, Ventura Puente, Acueducto, Las Américas, etc.).
3. **Detector Inteligente de Duplicados (<35 metros):**
   - Si un ciudadano intenta reportar una falla existente en un radio de 35 metros, la app le notifica:
     *«¡Reporte cercano detectado a X metros! Folio UF-MOR-XXXX. ¿Deseas sumar tu apoyo (+1)?»*.
   - El ciudadano puede sumar su voto con un toque para dar más prioridad al ticket sin saturar de registros duplicados al C4 ni a las cuadrillas municipales.
4. **Folio Oficial Instantáneo:** Generación de tickets tipo `UF-MOR-XXXX`.
5. **Seguimiento en Vivo y Trazabilidad:** Línea de tiempo visual (`Pendiente` ➔ `En Revisión C4` ➔ `Asignado a Cuadrilla` ➔ `En Obra` ➔ `Resuelto`).
6. **Evidencia de Reparación:** Visualización del "Antes vs. Después" con notas del técnico municipal cuando la obra queda concluida.

---

## 📂 Estructura del Código

```text
mobile/
├── android/                   # Configuración nativa y permisos GPS/Cámara
├── lib/
│   ├── main.dart              # Punto de entrada y tema visual oscuro
│   ├── core/
│   │   └── constants/
│   │       ├── app_colors.dart        # Paleta de diseño GovTech Dark
│   │       └── morelia_locations.dart # Puntos de interés y calles de Morelia
│   ├── models/
│   │   ├── category_model.dart        # Baches, Luminarias, Fugas, Semáforos, Basura
│   │   └── report_model.dart          # Modelo de ticket con historial y coordenadas
│   ├── services/
│   │   ├── duplicate_detector_service.dart # Fórmula de Haversine para detección <35m
│   │   ├── gps_service.dart                # Localización y geocodificación
│   │   └── report_service.dart             # Estado reactivo y gestión de reportes
│   ├── widgets/
│   │   ├── status_badge.dart               # Badges de estado de resolución
│   │   └── duplicate_warning_dialog.dart   # Diálogo interactivo de duplicados
│   └── views/
│       ├── home_view.dart                  # Dashboard con accesos directos y CTA
│       ├── new_report_view.dart            # Asistente de captura de foto, GPS y envío
│       ├── my_reports_view.dart            # Listado con filtros de estado
│       └── report_detail_view.dart         # Detalle con fotos comparativas y timeline
└── pubspec.yaml               # Dependencias del proyecto Flutter
```

---

## 🚀 Cómo Ejecutar la App

### 1. Requisitos Previos:
- Tener instalado el **Flutter SDK** (versión 3.0.0 o superior).
  - *Descarga oficial:* [flutter.dev/docs/get-started/install/windows](https://docs.flutter.dev/get-started/install/windows)
  - Descomprime el zip en `C:\src\flutter` (o tu carpeta preferida) y agrega `C:\src\flutter\bin` a tus Variables de Entorno del Sistema (`PATH`).

### 2. Comandos de Ejecución:

```bash
# Entrar al directorio
cd mobile

# Descargar paquetes
flutter pub get

# Ejecutar en emulador Android o celular conectado
flutter run

# También puedes correrlo en Chrome para pruebas rápidas
flutter run -d chrome
```
