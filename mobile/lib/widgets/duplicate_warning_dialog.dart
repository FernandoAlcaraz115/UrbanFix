import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/report_model.dart';
import 'status_badge.dart';

class DuplicateWarningDialog extends StatelessWidget {
  final ReportModel existingReport;
  final double distanceMeters;
  final VoidCallback onUpvoteExisting;
  final VoidCallback onProceedAnyway;

  const DuplicateWarningDialog({
    Key? key,
    required this.existingReport,
    required this.distanceMeters,
    required this.onUpvoteExisting,
    required this.onProceedAnyway,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.bgCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: const BorderSide(color: AppColors.borderSubtle, width: 1.0),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con icono de alerta inteligente
            Row(
              children: [
                Container(
                  width: 44.0,
                  height: 44.0,
                  decoration: BoxDecoration(
                    color: AppColors.catBache.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: AppColors.catBache.withOpacity(0.4)),
                  ),
                  child: const Icon(
                    Icons.radar_rounded,
                    color: AppColors.catBache,
                    size: 24.0,
                  ),
                ),
                const SizedBox(width: 14.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '¡Reporte Cercano Detectado!',
                        style: TextStyle(
                          color: AppColors.textMain,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'A solo ${distanceMeters.toStringAsFixed(0)} metros de tu ubicación',
                        style: const TextStyle(
                          color: AppColors.catBache,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Tarjeta del reporte existente
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: AppColors.bgDark,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        existingReport.ticketNumber,
                        style: const TextStyle(
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                        ),
                      ),
                      StatusBadge(status: existingReport.status, isSmall: true),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    existingReport.title,
                    style: const TextStyle(
                      color: AppColors.textMain,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.0,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6.0),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14.0, color: AppColors.textDim),
                      const SizedBox(width: 4.0),
                      Expanded(
                        child: Text(
                          existingReport.address,
                          style: const TextStyle(color: AppColors.textDim, fontSize: 11.5),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(Icons.thumb_up_alt_rounded, size: 14.0, color: AppColors.statusReview),
                      const SizedBox(width: 6.0),
                      Text(
                        '${existingReport.upvotesCount} ciudadanos ya apoyaron este reporte',
                        style: const TextStyle(
                          color: AppColors.statusReview,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            const Text(
              'Para agilizar la atención municipal y no saturar a las cuadrillas, te recomendamos sumar tu apoyo (+1) a este reporte existente.',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12.0,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 20.0),

            // Botón 1: Sumar mi apoyo (Recomendado)
            SizedBox(
              width: double.infinity,
              height: 48.0,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  onUpvoteExisting();
                },
                icon: const Icon(Icons.thumb_up_alt_rounded, size: 18.0, color: Colors.white),
                label: const Text(
                  'Sumar mi apoyo (+1) a este reporte',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  elevation: 2,
                ),
              ),
            ),
            const SizedBox(height: 10.0),

            // Botón 2: Es una falla diferente
            SizedBox(
              width: double.infinity,
              height: 44.0,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onProceedAnyway();
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.borderSubtle),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                ),
                child: const Text(
                  'No, es otra falla distinta (Continuar)',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
