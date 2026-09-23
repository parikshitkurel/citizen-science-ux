import 'package:flutter/material.dart';
import '../models/observation.dart';
import '../utils/app_colors.dart';
import 'status_badge.dart';

class ObservationTile extends StatelessWidget {
  final Observation observation;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const ObservationTile({
    super.key,
    required this.observation,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.lightTealSurface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getWaterIcon(observation.waterBodyType),
                      color: AppColors.primaryTeal,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                observation.title,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (observation.isDemo) ...[
                              const SizedBox(width: 6),
                              StatusBadge.demo(),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                observation.location,
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.textMuted,
                        size: 20,
                      ),
                      onPressed: onDelete,
                      tooltip: 'Delete observation',
                    ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1, color: AppColors.border),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        StatusBadge.waterBody(observation.waterBodyType),
                        StatusBadge.clarity(observation.clarity),
                      ],
                    ),
                  ),
                  Text(
                    observation.formattedDate,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static IconData _getWaterIcon(String type) {
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
}
