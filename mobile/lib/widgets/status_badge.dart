import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final bool isSmall;

  const StatusBadge({
    Key? key,
    required this.status,
    this.isSmall = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case 'pending':
        color = AppColors.statusPending;
        label = 'Pendiente';
        break;
      case 'in_review':
        color = AppColors.statusReview;
        label = 'En Revisión';
        break;
      case 'assigned':
        color = AppColors.statusAssigned;
        label = 'Asignado';
        break;
      case 'in_progress':
        color = AppColors.statusInProgress;
        label = 'En Obra';
        break;
      case 'resolved':
        color = AppColors.statusResolved;
        label = 'Resuelto';
        break;
      default:
        color = AppColors.primary;
        label = status.toUpperCase();
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8.0 : 12.0,
        vertical: isSmall ? 3.0 : 6.0,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.16),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: color.withOpacity(0.35), width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isSmall ? 6.0 : 8.0,
            height: isSmall ? 6.0 : 8.0,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.6), blurRadius: 4.0),
              ],
            ),
          ),
          SizedBox(width: isSmall ? 5.0 : 7.0),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: isSmall ? 10.5 : 12.0,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
