import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
  });

  factory StatusBadge.demo() {
    return const StatusBadge(
      label: 'Demo Sample',
      backgroundColor: AppColors.lightBlueSurface,
      textColor: AppColors.info,
      icon: Icons.science_outlined,
    );
  }

  factory StatusBadge.userRecorded() {
    return const StatusBadge(
      label: 'Verified Citizen Entry',
      backgroundColor: AppColors.successSurface,
      textColor: AppColors.success,
      icon: Icons.check_circle_outline,
    );
  }

  factory StatusBadge.waterBody(String type) {
    return StatusBadge(
      label: type,
      backgroundColor: AppColors.lightTealSurface,
      textColor: AppColors.darkTeal,
      icon: _getWaterBodyIcon(type),
    );
  }

  factory StatusBadge.clarity(String clarity) {
    Color bg = AppColors.inputBackground;
    Color text = AppColors.textPrimary;
    IconData ic = Icons.water_drop_outlined;

    switch (clarity.toLowerCase()) {
      case 'clear':
        bg = AppColors.successSurface;
        text = AppColors.success;
        ic = Icons.water_drop;
        break;
      case 'slightly cloudy':
        bg = AppColors.warningSurface;
        text = AppColors.warning;
        ic = Icons.blur_on;
        break;
      case 'very cloudy':
        bg = AppColors.dangerSurface;
        text = AppColors.danger;
        ic = Icons.cloud;
        break;
      case 'unsure':
      default:
        bg = AppColors.inputBackground;
        text = AppColors.textMuted;
        ic = Icons.help_outline;
        break;
    }

    return StatusBadge(
      label: clarity,
      backgroundColor: bg,
      textColor: text,
      icon: ic,
    );
  }

  static IconData _getWaterBodyIcon(String type) {
    switch (type.toLowerCase()) {
      case 'river':
        return Icons.waves;
      case 'stream':
        return Icons.water_outlined;
      case 'pond':
        return Icons.pool;
      case 'lake':
        return Icons.landscape;
      case 'canal':
        return Icons.alt_route;
      default:
        return Icons.water;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
