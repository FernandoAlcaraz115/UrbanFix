import 'package:flutter/foundation.dart';
import '../models/report_model.dart';
import '../models/category_model.dart';
import 'duplicate_detector_service.dart';
import 'api_service.dart';

class ReportService extends ChangeNotifier {
  static final ReportService _instance = ReportService._internal();
  factory ReportService() => _instance;

  final ApiService _apiService = ApiService();

  ReportService._internal() {
    _loadInitialData();
    _syncWithServer();
  }

  final List<ReportModel> _reports = [];

  List<ReportModel> get reports => List.unmodifiable(_reports);

  List<ReportModel> get myReports => _reports.where((r) => r.citizenName == 'Tú (Ciudadano)').toList();

  int get totalResolved => _reports.where((r) => r.status == 'resolved').length;
  int get totalActive => _reports.where((r) => r.status != 'resolved').length;

  Future<void> _syncWithServer() async {
    final liveReports = await _apiService.getReports();
    if (liveReports != null && liveReports.isNotEmpty) {
      _reports.clear();
      _reports.addAll(liveReports);
      notifyListeners();
    }
  }

  void _loadInitialData() {
    _reports.addAll([
      ReportModel(
        id: 'rep-001',
        ticketNumber: 'UF-MOR-0101',
        title: 'Bache profundo frente a Plaza de Armas',
        description: 'Bache de aproximadamente 45cm de diámetro que causa ponchaduras constantes sobre Av. Madero Poniente.',
        categoryId: 'cat_bache',
        status: 'in_progress',
        priority: 'high',
        latitude: 19.702750,
        longitude: -101.194100,
        address: 'Av. Francisco I. Madero Poniente #250',
        neighborhood: 'Centro Histórico',
        photoUrl: 'https://images.unsplash.com/photo-1515162816999-a0c47dc192f7?w=800&auto=format&fit=crop&q=80',
        citizenName: 'Alejandro Silva',
        citizenPhone: '443 145 8821',
        upvotesCount: 18,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        history: [
          ReportHistoryItem(status: 'pending', date: DateTime.now().subtract(const Duration(days: 2)), note: 'Reporte registrado vía App'),
          ReportHistoryItem(status: 'in_review', date: DateTime.now().subtract(const Duration(days: 1, hours: 18)), note: 'Validado por C4 Morelia'),
          ReportHistoryItem(status: 'assigned', date: DateTime.now().subtract(const Duration(days: 1)), note: 'Asignado a Brigada Bacheo'),
          ReportHistoryItem(status: 'in_progress', date: DateTime.now().subtract(const Duration(hours: 4)), note: 'Cuadrilla laborando en sitio'),
        ],
      ),
      ReportModel(
        id: 'rep-002',
        ticketNumber: 'UF-MOR-0102',
        title: 'Fuga abundante de agua en banqueta rumbo a Pátzcuaro',
        description: 'Tubería rota bajo la banqueta brotando litros de agua potable hacia Calzada La Huerta.',
        categoryId: 'cat_fuga',
        status: 'assigned',
        priority: 'critical',
        latitude: 19.679200,
        longitude: -101.207800,
        address: 'Calzada La Huerta #840',
        neighborhood: 'Col. Los Pinos',
        photoUrl: 'https://images.unsplash.com/photo-1541888946425-d0fbb18615f3?w=800&auto=format&fit=crop&q=80',
        citizenName: 'Mariana López Tinoco',
        citizenPhone: '443 982 3410',
        upvotesCount: 34,
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        history: [
          ReportHistoryItem(status: 'pending', date: DateTime.now().subtract(const Duration(hours: 8)), note: 'Alerta prioritaria con video'),
          ReportHistoryItem(status: 'assigned', date: DateTime.now().subtract(const Duration(hours: 6)), note: 'Despacho urgente a OOAPAS 24/7'),
        ],
      ),
      ReportModel(
        id: 'rep-003',
        ticketNumber: 'UF-MOR-0103',
        title: 'Luminaria apagada en Calzada San Diego / Las Tarascas',
        description: 'Farola colonial fundida dejando el andador peatonal a oscuras al anochecer.',
        categoryId: 'cat_luminaria',
        status: 'pending',
        priority: 'medium',
        latitude: 19.701500,
        longitude: -101.177200,
        address: 'Calzada Fray Antonio de San Miguel esq. Acueducto',
        neighborhood: 'Centro / San Diego',
        photoUrl: 'https://images.unsplash.com/photo-1509114397022-ed747cca3f65?w=800&auto=format&fit=crop&q=80',
        citizenName: 'Tú (Ciudadano)',
        citizenPhone: '443 555 0199',
        upvotesCount: 9,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        history: [
          ReportHistoryItem(status: 'pending', date: DateTime.now().subtract(const Duration(days: 1)), note: 'Reporte ingresado por ciudadano'),
        ],
      ),
      ReportModel(
        id: 'rep-006',
        ticketNumber: 'UF-MOR-0106',
        title: 'Bache reparado y sellado en Av. Acueducto',
        description: 'Trabajo de bacheo profundo completado con asfalto AC-20 y compactación.',
        categoryId: 'cat_bache',
        status: 'resolved',
        priority: 'high',
        latitude: 19.700800,
        longitude: -101.171200,
        address: 'Av. Acueducto #1050, pasando Bosque Cuauhtémoc',
        neighborhood: 'Col. Chapultepec Norte',
        photoUrl: 'https://images.unsplash.com/photo-1584463699043-4b684cb3501a?w=800&auto=format&fit=crop&q=80',
        resolutionPhotoUrl: 'https://images.unsplash.com/photo-1541888946425-d0fbb18615f3?w=800&auto=format&fit=crop&q=80',
        resolutionNotes: 'Corte perimetral de 2.5m2, aplicación de liga asfáltica y sellado.',
        citizenName: 'Tú (Ciudadano)',
        citizenPhone: '443 555 0199',
        upvotesCount: 12,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        resolvedAt: DateTime.now().subtract(const Duration(days: 2)),
        history: [
          ReportHistoryItem(status: 'pending', date: DateTime.now().subtract(const Duration(days: 5)), note: 'Reporte ciudadano'),
          ReportHistoryItem(status: 'assigned', date: DateTime.now().subtract(const Duration(days: 4)), note: 'Asignado a Brigada Bacheo'),
          ReportHistoryItem(status: 'in_progress', date: DateTime.now().subtract(const Duration(days: 3)), note: 'Inicio de labores'),
          ReportHistoryItem(status: 'resolved', date: DateTime.now().subtract(const Duration(days: 2)), note: 'Reparación verificada con evidencia'),
        ],
      ),
    ]);
  }

  /// Verifica si existe un reporte duplicado a menos de 35 metros
  DuplicateCheckResult checkDuplicate({
    required double lat,
    required double lon,
    required String categoryId,
  }) {
    return DuplicateDetectorService.checkNearbyDuplicates(
      userLat: lat,
      userLon: lon,
      categoryId: categoryId,
      activeReports: _reports,
      radiusMeters: 35.0,
    );
  }

  /// Registra un nuevo reporte y lo sincroniza en tiempo real con el C4 Morelia
  void addReport(ReportModel report) {
    _reports.insert(0, report);
    notifyListeners();

    // Sincronizar asíncronamente con el servidor en tiempo real
    _apiService.createReport(report).then((createdReport) {
      if (createdReport != null) {
        final idx = _reports.indexWhere((r) => r.id == report.id);
        if (idx != -1) {
          _reports[idx] = createdReport;
          notifyListeners();
        }
      }
    });
  }

  /// Suma apoyo (+1 voto ciudadano) a un reporte existente para aumentar su prioridad
  void upvoteReport(String reportId) {
    final index = _reports.indexWhere((r) => r.id == reportId);
    if (index != -1) {
      _reports[index].upvotesCount++;
      _reports[index].history.add(
        ReportHistoryItem(
          status: _reports[index].status,
          date: DateTime.now(),
          note: 'Apoyo ciudadano (+1) sumado por vecino en la misma zona',
        ),
      );
      notifyListeners();

      // Sincronizar en el servidor
      _apiService.upvoteReport(reportId);
    }
  }

  CategoryModel getCategory(String categoryId) {
    return CategoryModel.defaults.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => CategoryModel.defaults.first,
    );
  }
}
