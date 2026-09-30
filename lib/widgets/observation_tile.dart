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
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.lightTealSurface,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getWaterIcon(observation.waterBodyType),
                      color: AppColors.primaryTeal,
                      size: 20,
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
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
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
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 13,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(width: 3),
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
                        size: 18,
                      ),
                      onPressed: onDelete,
                      tooltip: 'Delete observation',
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              // Metadata row — badges + date
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
                      fontSize: 11,
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
