import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/category_model.dart';
import '../services/report_service.dart';
import '../widgets/status_badge.dart';
import 'new_report_view.dart';
import 'my_reports_view.dart';
import 'report_detail_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  final _reportService = ReportService();

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
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: _currentIndex == 0 ? _buildHomeContent() : const MyReportsView(),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.bgCard,
          border: Border(top: BorderSide(color: AppColors.borderSubtle)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppColors.primaryLight,
          unselectedItemColor: AppColors.textDim,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.0),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11.0),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_rounded),
              label: 'Mis Reportes',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    final recentReports = _reportService.reports.take(4).toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Municipal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42.0,
                      height: 42.0,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryCyan],
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.35),
                            blurRadius: 10.0,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.location_city_rounded, color: Colors.white, size: 24.0),
                    ),
                    const SizedBox(width: 12.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'UrbanFix',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          'H. Ayuntamiento de Morelia',
                          style: TextStyle(
                            color: AppColors.textDim,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Pill C4 en vivo
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    color: AppColors.statusResolved.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: AppColors.statusResolved.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 7.0,
                        height: 7.0,
                        decoration: const BoxDecoration(
                          color: AppColors.statusResolved,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6.0),
                      const Text(
                        'C4 Morelia',
                        style: TextStyle(
                          color: AppColors.statusResolved,
                          fontSize: 11.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            // Banner Principal CTA (Reportar Ahora)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E3A8A), Color(0xFF0F172A)],
                ),
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 20.0,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: const Text(
                          'REPORTE CIUDADANO EN 15s',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    '¿Viste un bache o una fuga en Morelia?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  const Text(
                    'Saca una foto y nuestro GPS georreferencia el lugar exacto para despachar a la cuadrilla municipal.',
                    style: TextStyle(
                      color: Color(0xFFCBD5E1),
                      fontSize: 12.5,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 18.0),
                  SizedBox(
                    width: double.infinity,
                    height: 48.0,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const NewReportView()),
                        );
                      },
                      icon: const Icon(Icons.add_a_photo_rounded, color: Colors.white, size: 20.0),
                      label: const Text(
                        'REPORTAR AHORA CON FOTO',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // Categorías Rápidas
            const Text(
              'CATEGORÍAS DE ATENCIÓN',
              style: TextStyle(
                color: AppColors.textDim,
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 12.0),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: CategoryModel.defaults.map((cat) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NewReportView(initialCategory: cat),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(14.0),
                      child: Container(
                        width: 110.0,
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: AppColors.bgCard,
                          borderRadius: BorderRadius.circular(14.0),
                          border: Border.all(color: AppColors.borderSubtle),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: cat.color.withOpacity(0.16),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(cat.icon, color: cat.color, size: 20.0),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              cat.name.split('/')[0].trim(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 26.0),

            // Actividad Reciente en Morelia
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'REPORTES RECIENTES EN MORELIA',
                  style: TextStyle(
                    color: AppColors.textDim,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _currentIndex = 1),
                  child: const Text(
                    'Ver Todos',
                    style: TextStyle(color: AppColors.primaryLight, fontSize: 12.0, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6.0),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentReports.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10.0),
              itemBuilder: (context, index) {
                final report = recentReports[index];
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
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: SizedBox(
                            width: 50.0,
                            height: 50.0,
                            child: Image.network(report.photoUrl, fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    category.name.split('/')[0].trim(),
                                    style: TextStyle(
                                      color: category.color,
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  StatusBadge(status: report.status, isSmall: true),
                                ],
                              ),
                              const SizedBox(height: 3.0),
                              Text(
                                report.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3.0),
                              Text(
                                report.neighborhood,
                                style: const TextStyle(color: AppColors.textDim, fontSize: 11.0),
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
          ],
        ),
      ),
    );
  }
}
