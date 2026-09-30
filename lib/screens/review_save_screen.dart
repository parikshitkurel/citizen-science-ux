import 'package:flutter/material.dart';
import '../models/observation.dart';
import '../repositories/observation_repository.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/status_badge.dart';
import 'history_screen.dart';
import 'observation_form_screen.dart';

class ReviewSaveScreen extends StatefulWidget {
  final Observation observation;

  const ReviewSaveScreen({super.key, required this.observation});

  @override
  State<ReviewSaveScreen> createState() => _ReviewSaveScreenState();
}

class _ReviewSaveScreenState extends State<ReviewSaveScreen> {
  bool _isSaving = false;
  bool _acknowledgedDisclaimer = true;

  void _editStep(int step) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ObservationFormScreen(
          initialObservation: widget.observation,
          initialStep: step,
        ),
      ),
    );
  }

  Future<void> _saveObservation() async {
    if (_isSaving) return;

    // Validation checks
    if (widget.observation.location.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a location name before saving.'),
          backgroundColor: AppColors.danger,
        ),
      );
      _editStep(1);
      return;
    }

    if (!_acknowledgedDisclaimer) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please acknowledge the citizen science disclaimer.'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    // Save to local storage repository
    await ObservationRepository.instance.addObservation(widget.observation);

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    // Success dialog — strong Peak-End Rule moment
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            // Success icon — large, celebratory
            Container(
              padding: const EdgeInsets.all(18),
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
            const SizedBox(height: 18),
            const Text(
              'Observation Saved!',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '"${widget.observation.title}" has been saved locally on this device.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            // Primary: View history
            CustomButton(
              text: 'View Observation History',
              icon: Icons.history_rounded,
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
            const SizedBox(height: 8),
            // Secondary: start another
            SizedBox(
              width: double.infinity,
              height: 44,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pop(ctx); // close dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ObservationFormScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add_circle_outline,
                    color: AppColors.primaryTeal, size: 18),
                label: const Text(
                  'Start Another Assessment',
                  style: TextStyle(
                    color: AppColors.primaryTeal,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
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
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Review Your Assessment',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Check your entries before saving to local storage.',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 14),
                        ),
                        const SizedBox(height: 18),

                        // Card 1: Step 1 Basic Details
                        _buildReviewCard(
                          title: 'Location & Water Body',
                          stepNumber: 1,
                          icon: Icons.place_outlined,
                          onEdit: () => _editStep(1),
                          children: [
                            _buildRow('Title', obs.title),
                            _buildRow('Water Body', obs.waterBodyType),
                            _buildRow('Location', obs.location),
                            _buildRow('Date & Time', obs.formattedCreatedAt),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Card 2: Step 2 Water Appearance
                        _buildReviewCard(
                          title: 'Water Appearance',
                          stepNumber: 2,
                          icon: Icons.water_drop_outlined,
                          onEdit: () => _editStep(2),
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
                            _buildRow('Water Odour', obs.odour),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Card 3: Step 3 Environmental Factors
                        _buildReviewCard(
                          title: 'Environmental Factors',
                          stepNumber: 3,
                          icon: Icons.eco_outlined,
                          onEdit: () => _editStep(3),
                          children: [
                            _buildRow('Water Movement', obs.surfaceMovement),
                            _buildRow('Visible Litter', obs.visibleLitter),
                            _buildRow('Vegetation', obs.surroundingVegetation),
                            _buildRow('Surrounding Area',
                                obs.surroundingEnvironment),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Card 4: Step 4 Field Notes
                        _buildReviewCard(
                          title: 'Field Notes & Summary',
                          stepNumber: 4,
                          icon: Icons.notes_outlined,
                          onEdit: () => _editStep(4),
                          children: [
                            Text(
                              obs.notes.isNotEmpty
                                  ? obs.notes
                                  : 'No additional notes provided.',
                              style: TextStyle(
                                color: obs.notes.isNotEmpty
                                    ? AppColors.textPrimary
                                    : AppColors.textMuted,
                                fontSize: 14,
                                fontStyle: obs.notes.isNotEmpty
                                    ? FontStyle.normal
                                    : FontStyle.italic,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Disclaimer & Acknowledgement — compact
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.warningSurface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: AppColors.warning.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.verified_outlined,
                                      color: AppColors.warning, size: 18),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Citizen Science Transparency Notice',
                                      style: TextStyle(
                                        color: AppColors.warning,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                AppConstants.observationDisclaimer,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 6),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _acknowledgedDisclaimer =
                                        !_acknowledgedDisclaimer;
                                  });
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Checkbox(
                                        value: _acknowledgedDisclaimer,
                                        activeColor: AppColors.primaryTeal,
                                        onChanged: (val) {
                                          setState(() {
                                            _acknowledgedDisclaimer =
                                                val ?? true;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Expanded(
                                      child: Text(
                                        'I understand this is a citizen visual estimate.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Actions — Save is visually DOMINANT (Von Restorff + Peak-End Rule)
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: AppColors.border, width: 1),
                    ),
                  ),
                  child: Column(
                    children: [
                      CustomButton(
                        text: 'Save Observation',
                        icon: Icons.save_alt_rounded,
                        type: CustomButtonType.primary,
                        isLoading: _isSaving,
                        onPressed: _saveObservation,
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: TextButton.icon(
                          onPressed: () => _editStep(1),
                          icon: const Icon(Icons.edit_note,
                              color: AppColors.textMuted, size: 18),
                          label: const Text(
                            'Edit Responses',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard({
    required String title,
    required int stepNumber,
    required IconData icon,
    required VoidCallback onEdit,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(icon, color: AppColors.primaryTeal, size: 18),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '$stepNumber. $title',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: onEdit,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.edit,
                          size: 14, color: AppColors.primaryTeal),
                      SizedBox(width: 4),
                      Text(
                        'Edit',
                        style: TextStyle(
                          color: AppColors.primaryTeal,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1, color: AppColors.border),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
