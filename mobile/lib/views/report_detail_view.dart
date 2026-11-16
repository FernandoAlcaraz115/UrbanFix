import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/constants/app_colors.dart';
import '../models/report_model.dart';
import '../services/report_service.dart';
import '../widgets/status_badge.dart';

class ReportDetailView extends StatelessWidget {
  final ReportModel report;

  const ReportDetailView({Key? key, required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reportService = ReportService();
    final category = reportService.getCategory(report.categoryId);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm', 'es_MX');

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgCard,
        elevation: 0,
        title: Text(
          report.ticketNumber,
          style: const TextStyle(
            color: AppColors.textMain,
            fontSize: 15.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textMain),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: StatusBadge(status: report.status),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.borderSubtle, height: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Categoría y Título
            Row(
              children: [
                Icon(category.icon, size: 16.0, color: category.color),
                const SizedBox(width: 8.0),
                Text(
                  category.name,
                  style: TextStyle(
                    color: category.color,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              report.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w800,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 10.0),

            // Dirección y colonia
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_rounded, size: 16.0, color: AppColors.primaryLight),
                const SizedBox(width: 6.0),
                Expanded(
                  child: Text(
                    '${report.address} (${report.neighborhood})',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 13.0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18.0),

            // Tarjetas de Fotos: Antes y Después
            if (report.resolutionPhotoUrl != null) ...[
              const Text(
                'EVIDENCIA COMPARATIVA (ANTES VS. DESPUÉS)',
                style: TextStyle(
                  color: AppColors.textDim,
                  fontSize: 11.0,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: _buildPhotoBox(
                      'Reporte Inicial',
                      report.photoUrl,
                      AppColors.catBache,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: _buildPhotoBox(
                      'Reparación Concluida',
                      report.resolutionPhotoUrl!,
                      AppColors.statusResolved,
                    ),
                  ),
                ],
              ),
            ] else ...[
              const Text(
                'FOTOGRAFÍA CAPTURADA POR EL CIUDADANO',
                style: TextStyle(
                  color: AppColors.textDim,
                  fontSize: 11.0,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8.0),
              _buildPhotoBox(
                'Evidencia en Sitio con GPS',
                report.photoUrl,
                AppColors.primary,
                height: 200.0,
              ),
            ],

            const SizedBox(height: 20.0),

            // Descripción
            Container(
              padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Descripción ciudadana',
                    style: TextStyle(color: AppColors.textDim, fontSize: 11.5, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    report.description,
                    style: const TextStyle(color: AppColors.textMain, fontSize: 13.5, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22.0),

            // Línea de tiempo de avance
            const Text(
              'TRAZABILIDAD Y SEGUIMIENTO EN VIVO',
              style: TextStyle(
                color: AppColors.textDim,
                fontSize: 11.0,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 12.0),

            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(14.0),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                children: report.history.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isLast = index == report.history.length - 1;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 14.0,
                            height: 14.0,
                            decoration: BoxDecoration(
                              color: isLast ? AppColors.primary : AppColors.statusResolved,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2.0),
                            ),
                          ),
                          if (!isLast)
                            Container(
                              width: 2.0,
                              height: 38.0,
                              color: AppColors.borderSubtle,
                            ),
                        ],
                      ),
                      const SizedBox(width: 14.0),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.note,
                                style: const TextStyle(
                                  color: AppColors.textMain,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.5,
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                dateFormat.format(item.date),
                                style: const TextStyle(color: AppColors.textDim, fontSize: 11.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20.0),

            // Apoyo ciudadano
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: AppColors.statusReview.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: AppColors.statusReview.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.thumb_up_alt_rounded, color: AppColors.statusReview, size: 20.0),
                  const SizedBox(width: 12.0),
                  Text(
                    '${report.upvotesCount} vecinos apoyan este reporte en Morelia',
                    style: const TextStyle(
                      color: AppColors.textMain,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoBox(String title, String url, Color accentColor, {double height = 130.0}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: accentColor.withOpacity(0.35)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(url, fit: BoxFit.cover),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              color: Colors.black.withOpacity(0.7),
              child: Text(
                title,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
