import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/morelia_locations.dart';
import '../models/category_model.dart';
import '../models/report_model.dart';
import '../services/gps_service.dart';
import '../services/report_service.dart';
import '../widgets/duplicate_warning_dialog.dart';

class NewReportView extends StatefulWidget {
  final CategoryModel? initialCategory;

  const NewReportView({Key? key, this.initialCategory}) : super(key: key);

  @override
  State<NewReportView> createState() => _NewReportViewState();
}

class _NewReportViewState extends State<NewReportView> {
  final _formKey = GlobalKey<FormState>();
  final _reportService = ReportService();

  late CategoryModel _selectedCategory;
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _nameController = TextEditingController(text: 'Tú (Ciudadano)');
  final _phoneController = TextEditingController(text: '443 555 0199');

  bool _isLocating = true;
  UserLocationResult? _location;
  MoreliaLocation _selectedZonePreset = MoreliaLocations.catedral;

  String _selectedPhotoUrl =
      'https://images.unsplash.com/photo-1515162816999-a0c47dc192f7?w=800&auto=format&fit=crop&q=80';

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? CategoryModel.defaults.first;
    _fetchLocation();
  }

  Future<void> _fetchLocation([MoreliaLocation? preset]) async {
    setState(() => _isLocating = true);
    final loc = await GpsService.getCurrentLocation(preset: preset ?? _selectedZonePreset);
    setState(() {
      _location = loc;
      _isLocating = false;
    });
  }

  void _onCategoryChanged(CategoryModel cat) {
    setState(() {
      _selectedCategory = cat;
      // Actualizar foto de ejemplo según categoría
      if (cat.slug == 'bache') {
        _selectedPhotoUrl = 'https://images.unsplash.com/photo-1515162816999-a0c47dc192f7?w=800&auto=format&fit=crop&q=80';
      } else if (cat.slug == 'fuga') {
        _selectedPhotoUrl = 'https://images.unsplash.com/photo-1541888946425-d0fbb18615f3?w=800&auto=format&fit=crop&q=80';
      } else if (cat.slug == 'luminaria') {
        _selectedPhotoUrl = 'https://images.unsplash.com/photo-1509114397022-ed747cca3f65?w=800&auto=format&fit=crop&q=80';
      } else if (cat.slug == 'semaforo') {
        _selectedPhotoUrl = 'https://images.unsplash.com/photo-1572970725354-93ff912a208c?w=800&auto=format&fit=crop&q=80';
      } else {
        _selectedPhotoUrl = 'https://images.unsplash.com/photo-1611288875685-147054941d42?w=800&auto=format&fit=crop&q=80';
      }
    });
  }

  void _submitReport() {
    if (!_formKey.currentState!.validate() || _location == null) return;

    // 1. Detección Inteligente de Duplicados en Morelia (<35m)
    final dupResult = _reportService.checkDuplicate(
      lat: _location!.latitude,
      lon: _location!.longitude,
      categoryId: _selectedCategory.id,
    );

    if (dupResult.hasDuplicate && dupResult.existingReport != null) {
      // Mostrar Diálogo Inteligente de Alerta de Duplicado
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => DuplicateWarningDialog(
          existingReport: dupResult.existingReport!,
          distanceMeters: dupResult.distanceMeters,
          onUpvoteExisting: () {
            _reportService.upvoteReport(dupResult.existingReport!.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.statusResolved,
                content: Text(
                  '¡Apoyo sumado con éxito al ticket ${dupResult.existingReport!.ticketNumber}! Aumentaste su prioridad.',
                ),
              ),
            );
            Navigator.of(context).pop();
          },
          onProceedAnyway: () {
            _saveNewReport();
          },
        ),
      );
    } else {
      _saveNewReport();
    }
  }

  void _saveNewReport() {
    final ticketNum = 'UF-MOR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    final newReport = ReportModel(
      id: 'rep-${DateTime.now().millisecondsSinceEpoch}',
      ticketNumber: ticketNum,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      categoryId: _selectedCategory.id,
      status: 'pending',
      priority: 'high',
      latitude: _location!.latitude,
      longitude: _location!.longitude,
      address: _location!.address,
      neighborhood: _location!.neighborhood,
      photoUrl: _selectedPhotoUrl,
      citizenName: _nameController.text.trim(),
      citizenPhone: _phoneController.text.trim(),
      createdAt: DateTime.now(),
      history: [
        ReportHistoryItem(
          status: 'pending',
          date: DateTime.now(),
          note: 'Reporte ciudadano ingresado con GPS verificado en Morelia',
        ),
      ],
    );

    _reportService.addReport(newReport);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: const BorderSide(color: AppColors.borderSubtle),
        ),
        title: Row(
          children: const [
            Icon(Icons.check_circle_rounded, color: AppColors.statusResolved, size: 28.0),
            SizedBox(width: 10.0),
            Text('¡Reporte Enviado!', style: TextStyle(color: Colors.white, fontSize: 17.0)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tu reporte ha sido canalizado directamente al Centro de Despacho C4 de Morelia.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 13.0),
            ),
            const SizedBox(height: 14.0),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: AppColors.bgDark,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Folio Oficial:', style: TextStyle(color: AppColors.textDim, fontSize: 12.0)),
                  Text(
                    ticketNum,
                    style: const TextStyle(
                      color: AppColors.primaryLight,
                      fontWeight: FontWeight.w800,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Ver Mis Reportes', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgCard,
        elevation: 0,
        title: const Text(
          'Nuevo Reporte Ciudadano',
          style: TextStyle(color: AppColors.textMain, fontSize: 16.5, fontWeight: FontWeight.w700),
        ),
        iconTheme: const IconThemeData(color: AppColors.textMain),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.borderSubtle, height: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. FOTO DE LA FALLA
              const Text(
                '1. FOTOGRAFÍA DE EVIDENCIA',
                style: TextStyle(
                  color: AppColors.textDim,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                height: 180.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(_selectedPhotoUrl, fit: BoxFit.cover),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.75)],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12.0,
                      left: 12.0,
                      right: 12.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.65),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.camera_alt_rounded, size: 14.0, color: AppColors.primaryLight),
                                SizedBox(width: 6.0),
                                Text(
                                  'Cámara Activa (Foto Lista)',
                                  style: TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22.0),

              // 2. GEOLOCALIZACIÓN GPS EN MORELIA
              const Text(
                '2. UBICACIÓN GPS AUTOMÁTICA (MORELIA, MICH.)',
                style: TextStyle(
                  color: AppColors.textDim,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(14.0),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: AppColors.primaryCyan.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Icon(Icons.my_location_rounded, color: AppColors.primaryCyan, size: 20.0),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: _isLocating
                              ? const Text(
                                  'Obteniendo satélites GPS en Morelia...',
                                  style: TextStyle(color: AppColors.textMuted, fontSize: 12.5),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _location?.address ?? 'Dirección no detectada',
                                      style: const TextStyle(
                                        color: AppColors.textMain,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.0,
                                      ),
                                    ),
                                    const SizedBox(height: 2.0),
                                    Text(
                                      '${_location?.neighborhood} • Lat: ${_location?.latitude.toStringAsFixed(5)}, Lon: ${_location?.longitude.toStringAsFixed(5)}',
                                      style: const TextStyle(color: AppColors.textDim, fontSize: 11.5),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    const Divider(color: AppColors.borderSubtle, height: 1.0),
                    const SizedBox(height: 10.0),
                    // Selector rápido de zona para pruebas de duplicados
                    Row(
                      children: [
                        const Text(
                          'Simular Zona de Morelia:',
                          style: TextStyle(color: AppColors.textDim, fontSize: 11.0, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<MoreliaLocation>(
                              value: _selectedZonePreset,
                              dropdownColor: AppColors.bgCardLight,
                              isDense: true,
                              style: const TextStyle(color: AppColors.primaryLight, fontSize: 11.5),
                              items: MoreliaLocations.all.map((loc) {
                                return DropdownMenuItem(
                                  value: loc,
                                  child: Text(loc.name, overflow: TextOverflow.ellipsis),
                                );
                              }).toList(),
                              onChanged: (loc) {
                                if (loc != null) {
                                  setState(() => _selectedZonePreset = loc);
                                  _fetchLocation(loc);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22.0),

              // 3. TIPO DE INFRAESTRUCTURA
              const Text(
                '3. TIPO DE FALLA URBANA',
                style: TextStyle(
                  color: AppColors.textDim,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10.0),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: CategoryModel.defaults.map((cat) {
                  final isSelected = _selectedCategory.id == cat.id;
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(cat.icon, size: 16.0, color: isSelected ? Colors.white : cat.color),
                        const SizedBox(width: 6.0),
                        Text(cat.name.split('/')[0].trim()),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) _onCategoryChanged(cat);
                    },
                    selectedColor: cat.color,
                    backgroundColor: AppColors.bgCard,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textMuted,
                      fontSize: 12.0,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                        color: isSelected ? cat.color : AppColors.borderSubtle,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 22.0),

              // 4. DETALLES DEL REPORTE
              const Text(
                '4. DETALLES Y DESCRIPCIÓN',
                style: TextStyle(
                  color: AppColors.textDim,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white, fontSize: 13.5),
                decoration: InputDecoration(
                  labelText: 'Título breve (ej. Bache grande en carril derecho)',
                  labelStyle: const TextStyle(color: AppColors.textDim, fontSize: 12.5),
                  filled: true,
                  fillColor: AppColors.bgCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: AppColors.borderSubtle),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: AppColors.borderSubtle),
                  ),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Ingresa un título' : null,
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white, fontSize: 13.5),
                decoration: InputDecoration(
                  labelText: 'Descripción detallada para la cuadrilla municipal',
                  labelStyle: const TextStyle(color: AppColors.textDim, fontSize: 12.5),
                  filled: true,
                  fillColor: AppColors.bgCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: AppColors.borderSubtle),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: AppColors.borderSubtle),
                  ),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Ingresa una descripción' : null,
              ),
              const SizedBox(height: 30.0),

              // BOTÓN DE ENVÍO
              SizedBox(
                width: double.infinity,
                height: 52.0,
                child: ElevatedButton.icon(
                  onPressed: _isLocating ? null : _submitReport,
                  icon: const Icon(Icons.send_rounded, size: 20.0, color: Colors.white),
                  label: const Text(
                    'ENVIAR REPORTE AL C4 MORELIA',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
                    elevation: 3,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
