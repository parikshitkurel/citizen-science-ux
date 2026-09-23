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

    // Success dialog
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
                      'Review Your Assessment',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Check your entries before saving to local device storage.',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                    ),
                    const SizedBox(height: 16),

                    // Card 1: Step 1 Basic Details
                    _buildReviewCard(
                      title: '1. Location & Water Body',
                      icon: Icons.place_outlined,
                      onEdit: () => _editStep(1),
                      children: [
                        _buildRow('Title', obs.title),
                        _buildRow('Water Body', obs.waterBodyType),
                        _buildRow('Location', obs.location),
                        _buildRow('Date & Time', obs.formattedCreatedAt),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Card 2: Step 2 Water Appearance
                    _buildReviewCard(
                      title: '2. Water Appearance',
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
                    const SizedBox(height: 16),

                    // Card 3: Step 3 Environmental Factors
                    _buildReviewCard(
                      title: '3. Environmental Factors',
                      icon: Icons.eco_outlined,
                      onEdit: () => _editStep(3),
                      children: [
                        _buildRow('Water Movement', obs.surfaceMovement),
                        _buildRow('Visible Litter', obs.visibleLitter),
                        _buildRow('Vegetation', obs.surroundingVegetation),
                        _buildRow('Surrounding Area', obs.surroundingEnvironment),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Card 4: Step 4 Field Notes
                    _buildReviewCard(
                      title: '4. Field Notes & Summary',
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
                    const SizedBox(height: 20),

                    // Disclaimer & Acknowledgement Checkbox
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.warningSurface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: AppColors.warning.withOpacity(0.4)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.verified_outlined,
                                  color: AppColors.warning, size: 20),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Citizen Science Transparency Notice',
                                  style: TextStyle(
                                    color: AppColors.warning,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            AppConstants.observationDisclaimer,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _acknowledgedDisclaimer = !_acknowledgedDisclaimer;
                              });
                            },
                            child: Row(
                              children: [
                                Checkbox(
                                  value: _acknowledgedDisclaimer,
                                  activeColor: AppColors.primaryTeal,
                                  onChanged: (val) {
                                    setState(() {
                                      _acknowledgedDisclaimer = val ?? true;
                                    });
                                  },
                                ),
                                const Expanded(
                                  child: Text(
                                    'I understand this is a citizen visual estimate.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
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

            // Bottom Actions (Save Observation + Edit Responses)
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
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: () => _editStep(1),
                      icon: const Icon(Icons.edit_note, color: AppColors.primaryNavy, size: 18),
                      label: const Text(
                        'Edit Responses',
                        style: TextStyle(
                          color: AppColors.primaryNavy,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
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
              Expanded(
                child: Row(
                  children: [
                    Icon(icon, color: AppColors.primaryTeal, size: 20),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
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
          const SizedBox(width: 8),
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
