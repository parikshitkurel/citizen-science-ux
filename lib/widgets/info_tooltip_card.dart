import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// Progressive disclosure widget for educational explanations.
/// Defaults to COLLAPSED so the question and answer choices remain
/// the dominant visual element (Selective Attention, Hick's Law).
/// Users tap to expand if they want context (Tesler's Law —
/// complexity absorbed by the interface, not the user).
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

class _InfoTooltipCardState extends State<InfoTooltipCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightTealSurface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: AppColors.darkTeal,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isExpanded ? widget.title : 'Why we ask this',
                      style: const TextStyle(
                        color: AppColors.darkTeal,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.darkTeal,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 10),
              child: Text(
                widget.description,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
