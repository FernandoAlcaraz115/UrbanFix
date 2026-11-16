import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/report_model.dart';
import '../services/report_service.dart';
import '../widgets/status_badge.dart';
import 'report_detail_view.dart';
import 'new_report_view.dart';

class MyReportsView extends StatefulWidget {
  const MyReportsView({Key? key}) : super(key: key);

  @override
  State<MyReportsView> createState() => _MyReportsViewState();
}

class _MyReportsViewState extends State<MyReportsView> {
  final _reportService = ReportService();
  String _filter = 'all'; // 'all', 'active', 'resolved'

  @override
  void initState() {
    super.initState();
    _reportService.addListener(_onReportsChanged);
  }

  @override
  void dispose() {
    _reportService.removeListener(_onReportsChanged);
    super.dispose();
  }

  void _onReportsChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final allReports = _reportService.reports;
    final filtered = allReports.where((r) {
      if (_filter == 'active') return r.status != 'resolved';
      if (_filter == 'resolved') return r.status == 'resolved';
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgCard,
        elevation: 0,
        title: const Text(
          'Mis Reportes & Seguimiento',
          style: TextStyle(color: AppColors.textMain, fontSize: 16.5, fontWeight: FontWeight.w700),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                _buildFilterChip('Todos (${allReports.length})', 'all'),
                const SizedBox(width: 8.0),
                _buildFilterChip('En Proceso (${_reportService.totalActive})', 'active'),
                const SizedBox(width: 8.0),
                _buildFilterChip('Resueltos (${_reportService.totalResolved})', 'resolved'),
              ],
            ),
          ),
        ),
      ),
      body: filtered.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_rounded, size: 54.0, color: AppColors.textDim.withOpacity(0.5)),
                  const SizedBox(height: 12.0),
                  const Text(
                    'No tienes reportes en esta sección',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 14.0),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12.0),
              itemBuilder: (context, index) {
                final report = filtered[index];
                final category = _reportService.getCategory(report.categoryId);

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReportDetailView(report: report),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(14.0),
                  child: Container(
                    padding: const EdgeInsets.all(14.0),
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      borderRadius: BorderRadius.circular(14.0),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Miniatura fotográfica
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: SizedBox(
                            width: 64.0,
                            height: 64.0,
                            child: Image.network(report.photoUrl, fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(width: 14.0),

                        // Datos del reporte
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    report.ticketNumber,
                                    style: const TextStyle(
                                      color: AppColors.primaryLight,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  StatusBadge(status: report.status, isSmall: true),
                                ],
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                report.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                '${category.name.split('/')[0]} • ${report.neighborhood}',
                                style: const TextStyle(color: AppColors.textDim, fontSize: 11.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewReportView()),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_a_photo_rounded, color: Colors.white, size: 20.0),
        label: const Text(
          'Nuevo Reporte',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filter == value;
    return GestureDetector(
      onTap: () => setState(() => _filter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderSubtle,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.primaryLight : AppColors.textMuted,
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
