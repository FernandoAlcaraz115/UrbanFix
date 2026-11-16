import 'dart:math';
import '../core/constants/morelia_locations.dart';

class UserLocationResult {
  final double latitude;
  final double longitude;
  final String address;
  final String neighborhood;

  UserLocationResult({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.neighborhood,
  });
}

class GpsService {
  /// Obtiene la ubicación del ciudadano.
  /// En modo desarrollo / demo, selecciona o simula un punto dentro de Morelia con precisión.
  static Future<UserLocationResult> getCurrentLocation({MoreliaLocation? preset}) async {
    // Simular pequeño retardo de sensor GPS
    await Future.delayed(const Duration(milliseconds: 600));

    final location = preset ?? MoreliaLocations.catedral;
    
    // Añadir una variación mínima aleatoria de GPS (± 5 metros) para realismo
    final random = Random();
    final double jitterLat = (random.nextDouble() - 0.5) * 0.0001;
    final double jitterLon = (random.nextDouble() - 0.5) * 0.0001;

    return UserLocationResult(
      latitude: location.latitude + jitterLat,
      longitude: location.longitude + jitterLon,
      address: location.address,
      neighborhood: location.neighborhood,
    );
  }
}
