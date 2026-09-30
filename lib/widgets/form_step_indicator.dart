import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// Multi-step progress indicator showing clear assessment progress.
/// Applies Goal-Gradient Effect: users see exactly where they are
/// and how close they are to completion.
class FormStepIndicator extends StatelessWidget {
  final int currentStep; // 1 to totalSteps
  final int totalSteps;
  final List<String> stepTitles;

  const FormStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepTitles,
  });

  @override
  Widget build(BuildContext context) {
    final currentTitle = stepTitles[currentStep - 1];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: const Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step counter + title row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Step $currentStep of $totalSteps',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  currentTitle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Segmented progress bar — each segment = one step
          Row(
            children: List.generate(totalSteps, (index) {
              final stepNum = index + 1;
              final isCompleted = stepNum < currentStep;
              final isCurrent = stepNum == currentStep;

              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: index < totalSteps - 1 ? 4 : 0),
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: isCompleted
                        ? AppColors.primaryTeal
                        : isCurrent
                            ? AppColors.primaryTeal.withOpacity(0.5)
                            : AppColors.border,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
