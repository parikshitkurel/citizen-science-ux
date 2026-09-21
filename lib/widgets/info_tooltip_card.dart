import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class InfoTooltipCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;

  const InfoTooltipCard({
    super.key,
    required this.title,
    required this.description,
    this.icon = Icons.info_outline,
  });

  @override
  State<InfoTooltipCard> createState() => _InfoTooltipCardState();
}

class _InfoTooltipCardState extends State<InfoTooltipCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightTealSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryTeal.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  Icon(widget.icon, color: AppColors.darkTeal, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: AppColors.darkTeal,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.darkTeal,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 14, right: 14, bottom: 12),
              child: Text(
                widget.description,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
