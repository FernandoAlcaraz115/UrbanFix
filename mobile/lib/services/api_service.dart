import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/report_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  /// URL base para comunicarse con el servidor local de UrbanFix
  /// En Chrome / Web o Desktop: localhost:3001
  /// En emulador Android: 10.0.2.2:3001
  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3001/api';
    }
    // En caso de que se ejecute en emulador de Android nativo:
    return 'http://10.0.2.2:3001/api';
  }

  /// Obtiene los reportes desde el servidor C4 Morelia
  Future<List<ReportModel>?> getReports() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/reports'),
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((json) => ReportModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('[UrbanFix API] Servidor offline o no alcanzable: $e');
    }
    return null;
  }

  /// Crea un nuevo reporte en el servidor (desencadena SSE en el panel C4)
  Future<ReportModel?> createReport(ReportModel report) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reports'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(report.toJson()),
      ).timeout(const Duration(seconds: 6));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return ReportModel.fromJson(data);
      }
    } catch (e) {
      debugPrint('[UrbanFix API] Error enviando reporte a servidor: $e');
    }
    return null;
  }

  /// Suma un voto ciudadano (+1) en el servidor
  Future<bool> upvoteReport(String reportId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reports/$reportId/upvote'),
      ).timeout(const Duration(seconds: 4));

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('[UrbanFix API] Error apoyando reporte: $e');
      return false;
    }
  }
}
