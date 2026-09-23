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
      label: 'Citizen Entry',
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

    final lower = clarity.toLowerCase();
    if (lower.contains('clear') && !lower.contains('cloudy')) {
      bg = AppColors.successSurface;
      text = AppColors.success;
      ic = Icons.water_drop;
    } else if (lower.contains('slightly cloudy')) {
      bg = AppColors.warningSurface;
      text = AppColors.warning;
      ic = Icons.blur_on;
    } else if (lower.contains('very cloudy')) {
      bg = AppColors.dangerSurface;
      text = AppColors.danger;
      ic = Icons.cloud;
    } else {
      bg = AppColors.inputBackground;
      text = AppColors.textMuted;
      ic = Icons.help_outline;
    }

    return StatusBadge(
      label: clarity,
      backgroundColor: bg,
      textColor: text,
      icon: ic,
    );
  }

  factory StatusBadge.litter(String litter) {
    Color bg = AppColors.inputBackground;
    Color text = AppColors.textPrimary;
    IconData ic = Icons.delete_outline;

    final lower = litter.toLowerCase();
    if (lower.contains('none')) {
      bg = AppColors.successSurface;
      text = AppColors.success;
      ic = Icons.eco_outlined;
    } else if (lower.contains('small')) {
      bg = AppColors.warningSurface;
      text = AppColors.warning;
      ic = Icons.delete_outline;
    } else if (lower.contains('large')) {
      bg = AppColors.dangerSurface;
      text = AppColors.danger;
      ic = Icons.warning_amber_rounded;
    } else {
      bg = AppColors.inputBackground;
      text = AppColors.textMuted;
      ic = Icons.help_outline;
    }

    return StatusBadge(
      label: litter,
      backgroundColor: bg,
      textColor: text,
      icon: ic,
    );
  }

  static IconData _getWaterBodyIcon(String type) {
    final lower = type.toLowerCase();
    if (lower.contains('river')) {
      return Icons.waves;
    } else if (lower.contains('stream')) {
      return Icons.water_outlined;
    } else if (lower.contains('pond')) {
      return Icons.pool;
    } else if (lower.contains('lake')) {
      return Icons.landscape;
    } else if (lower.contains('canal')) {
      return Icons.alt_route;
    } else {
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
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
