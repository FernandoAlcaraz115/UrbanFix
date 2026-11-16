import 'dart:math';
import '../models/report_model.dart';

class DuplicateCheckResult {
  final bool hasDuplicate;
  final ReportModel? existingReport;
  final double distanceMeters;

  DuplicateCheckResult({
    required this.hasDuplicate,
    this.existingReport,
    this.distanceMeters = 0.0,
  });
}

class DuplicateDetectorService {
  /// Calcula la distancia en metros entre dos puntos geográficos (Fórmula de Haversine)
  static double calculateDistanceMeters(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadiusMeters = 6371000.0;
    final double dLat = _degToRad(lat2 - lat1);
    final double dLon = _degToRad(lon2 - lon1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusMeters * c;
  }

  static double _degToRad(double degree) {
    return degree * (pi / 180.0);
  }

  /// Verifica si existe un reporte activo (<30 metros) de la misma categoría
  static DuplicateCheckResult checkNearbyDuplicates({
    required double userLat,
    required double userLon,
    required String categoryId,
    required List<ReportModel> activeReports,
    double radiusMeters = 35.0,
  }) {
    ReportModel? closestReport;
    double minDistance = double.infinity;

    for (final report in activeReports) {
      // Solo comparar con reportes que aún no están resueltos ni cancelados
      if (report.status == 'resolved') continue;

      // Misma categoría de infraestructura (ej. bache con bache)
      if (report.categoryId == categoryId) {
        final double dist = calculateDistanceMeters(
          userLat,
          userLon,
          report.latitude,
          report.longitude,
        );

        if (dist <= radiusMeters && dist < minDistance) {
          minDistance = dist;
          closestReport = report;
        }
      }
    }

    if (closestReport != null) {
      return DuplicateCheckResult(
        hasDuplicate: true,
        existingReport: closestReport,
        distanceMeters: minDistance,
      );
    }

    return DuplicateCheckResult(hasDuplicate: false);
  }
}
