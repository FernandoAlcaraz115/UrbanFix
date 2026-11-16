import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class CategoryModel {
  final String id;
  final String name;
  final String slug;
  final IconData icon;
  final Color color;
  final String department;
  final int slaHours;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.icon,
    required this.color,
    required this.department,
    required this.slaHours,
  });

  static const List<CategoryModel> defaults = [
    CategoryModel(
      id: 'cat_bache',
      name: 'Bache / Asfalto Dañado',
      slug: 'bache',
      icon: Icons.warning_amber_rounded,
      color: AppColors.catBache,
      department: 'Secretaría de Obras Públicas de Morelia',
      slaHours: 72,
    ),
    CategoryModel(
      id: 'cat_luminaria',
      name: 'Luminaria Fundida / Apagada',
      slug: 'luminaria',
      icon: Icons.lightbulb_outline_rounded,
      color: AppColors.catLuminaria,
      department: 'Dirección de Alumbrado Público de Morelia',
      slaHours: 48,
    ),
    CategoryModel(
      id: 'cat_fuga',
      name: 'Fuga de Agua / Drenaje',
      slug: 'fuga',
      icon: Icons.water_drop_outlined,
      color: AppColors.catFuga,
      department: 'OOAPAS Morelia (Agua Potable y Alcantarillado)',
      slaHours: 24,
    ),
    CategoryModel(
      id: 'cat_semaforo',
      name: 'Semáforo Averiado',
      slug: 'semaforo',
      icon: Icons.traffic_rounded,
      color: AppColors.catSemaforo,
      department: 'Secretaría de Movilidad Urbana (SEMOV Morelia)',
      slaHours: 12,
    ),
    CategoryModel(
      id: 'cat_basura',
      name: 'Basura / Escombros en Vía Pública',
      slug: 'basura',
      icon: Icons.delete_outline_rounded,
      color: AppColors.catBasura,
      department: 'Secretaría de Servicios Públicos y Limpia',
      slaHours: 36,
    ),
  ];
}
