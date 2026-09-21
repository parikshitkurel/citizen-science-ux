import 'package:flutter/material.dart';
import '../models/observation.dart';
import '../repositories/observation_repository.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/status_badge.dart';
import 'history_screen.dart';

class ReviewSaveScreen extends StatefulWidget {
  final Observation observation;

  const ReviewSaveScreen({super.key, required this.observation});

  @override
  State<ReviewSaveScreen> createState() => _ReviewSaveScreenState();
}

class _ReviewSaveScreenState extends State<ReviewSaveScreen> {
  bool _isSaving = false;

  Future<void> _saveObservation() async {
    setState(() {
      _isSaving = true;
    });

    // Save to local storage
    await ObservationRepository.instance.addObservation(widget.observation);

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    // Show clean success dialog
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.successSurface,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Observation Saved!',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your observation "${widget.observation.title}" was saved locally on your device.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'View Observation History',
              type: CustomButtonType.primary,
              onPressed: () {
                Navigator.pop(ctx); // close dialog
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HistoryScreen(),
                  ),
                  (route) => route.isFirst,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final obs = widget.observation;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Review & Save'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Verify Your Recorded Details',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Double-check your observation entries before saving to local storage.',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                    ),
                    const SizedBox(height: 20),

                    // Non-scientific verification disclaimer alert
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.warningSurface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: AppColors.warning.withOpacity(0.4)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline,
                              color: AppColors.warning, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Citizen Observation Record',
                                  style: TextStyle(
                                    color: AppColors.warning,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'AquaVerify records citizen observations. It does not independently validate laboratory scientific measurements.',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 12,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Card 1: Basic Information
                    _buildReviewCard(
                      title: 'Basic Details',
                      icon: Icons.place_outlined,
                      onEdit: () => Navigator.pop(context),
                      children: [
                        _buildRow('Title', obs.title),
                        _buildRow('Water Body', obs.waterBodyType),
                        _buildRow('Location', obs.location),
                        _buildRow('Date & Time', obs.formattedCreatedAt),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Card 2: Water Appearance
                    _buildReviewCard(
                      title: 'Water Appearance',
                      icon: Icons.water_drop_outlined,
                      onEdit: () => Navigator.pop(context),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Clarity:',
                              style: TextStyle(
                                  color: AppColors.textMuted, fontSize: 14),
                            ),
                            StatusBadge.clarity(obs.clarity),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _buildRow('Visible Colour', obs.visibleColour),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Card 3: Environmental Factors
                    _buildReviewCard(
                      title: 'Environmental Factors',
                      icon: Icons.eco_outlined,
                      onEdit: () => Navigator.pop(context),
                      children: [
                        _buildRow('Odour', obs.odour),
                        _buildRow('Surface Movement', obs.surfaceMovement),
                        _buildRow('Visible Litter', obs.visibleLitter),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Card 4: Additional Notes
                    if (obs.notes.isNotEmpty)
                      _buildReviewCard(
                        title: 'Additional Notes',
                        icon: Icons.notes_outlined,
                        onEdit: () => Navigator.pop(context),
                        children: [
                          Text(
                            obs.notes,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),

            // Save Action Bar
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: AppColors.border, width: 1),
                ),
              ),
              child: CustomButton(
                text: 'Save Observation',
                icon: Icons.save_alt_rounded,
                type: CustomButtonType.primary,
                isLoading: _isSaving,
                onPressed: _saveObservation,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard({
    required String title,
    required IconData icon,
    required VoidCallback onEdit,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: AppColors.primaryTeal, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit, size: 14, color: AppColors.primaryTeal),
                label: const Text(
                  'Edit',
                  style: TextStyle(
                    color: AppColors.primaryTeal,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: AppColors.border, height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
