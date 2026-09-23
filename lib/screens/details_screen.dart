import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/observation.dart';
import '../repositories/observation_repository.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/status_badge.dart';
import 'observation_form_screen.dart';

class DetailsScreen extends StatelessWidget {
  final Observation observation;

  const DetailsScreen({super.key, required this.observation});

  void _copySummaryToClipboard(BuildContext context) {
    final summaryText = '''
🌊 AquaVerify Freshwater Observation Report
----------------------------------------
Title: ${observation.title}
Water Body: ${observation.waterBodyType}
Location: ${observation.location}
Date & Time: ${observation.formattedCreatedAt}

💧 Water Appearance:
- Clarity: ${observation.clarity}
- Colour: ${observation.visibleColour}
- Odour: ${observation.odour}

🌿 Environmental Factors:
- Surface Movement: ${observation.surfaceMovement}
- Visible Litter: ${observation.visibleLitter}
- Surrounding Vegetation: ${observation.surroundingVegetation}
- Surrounding Area: ${observation.surroundingEnvironment}

📝 Field Notes:
${observation.notes.isNotEmpty ? observation.notes : 'None provided.'}

ℹ️ Transparency Disclaimer:
${AppConstants.observationDisclaimer}
''';

    Clipboard.setData(ClipboardData(text: summaryText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Observation summary copied to clipboard!'),
        backgroundColor: AppColors.primaryNavy,
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Delete Observation?'),
        content: Text(
          'Are you sure you want to delete "${observation.title}"? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ObservationRepository.instance.deleteObservation(observation.id);
      if (context.mounted) {
        Navigator.pop(context); // return to history
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Observation Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Copy Summary',
            onPressed: () => _copySummaryToClipboard(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.danger),
            tooltip: 'Delete',
            onPressed: () => _confirmDelete(context),
          ),
        ],
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
                    // Header Banner Card
                    _buildHeaderBanner(),
                    const SizedBox(height: 16),

                    // Citizen science tag & non-lab disclaimer
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.lightTealSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primaryTeal.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.verified_outlined,
                              color: AppColors.darkTeal, size: 18),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Citizen Science Record • Visual Estimate (Not Certified Laboratory Data)',
                              style: TextStyle(
                                color: AppColors.darkTeal,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Section 1: Water Appearance Details
                    _buildDetailCard(
                      title: 'Water Appearance',
                      icon: Icons.water_drop_outlined,
                      items: [
                        _buildDetailItem('Clarity', observation.clarity,
                            widgetValue: StatusBadge.clarity(observation.clarity)),
                        _buildDetailItem('Visible Colour', observation.visibleColour),
                        _buildDetailItem('Water Odour', observation.odour),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Section 2: Environmental Factors
                    _buildDetailCard(
                      title: 'Environmental Factors',
                      icon: Icons.eco_outlined,
                      items: [
                        _buildDetailItem(
                            'Surface Movement', observation.surfaceMovement),
                        _buildDetailItem('Visible Litter', observation.visibleLitter,
                            widgetValue: StatusBadge.litter(observation.visibleLitter)),
                        _buildDetailItem('Surrounding Vegetation',
                            observation.surroundingVegetation),
                        _buildDetailItem('Surrounding Area',
                            observation.surroundingEnvironment),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Section 3: Notes
                    _buildDetailCard(
                      title: 'Field Notes',
                      icon: Icons.notes_outlined,
                      items: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            observation.notes.isNotEmpty
                                ? observation.notes
                                : 'No additional field notes entered for this observation.',
                            style: TextStyle(
                              color: observation.notes.isNotEmpty
                                  ? AppColors.textPrimary
                                  : AppColors.textMuted,
                              fontStyle: observation.notes.isNotEmpty
                                  ? FontStyle.normal
                                  : FontStyle.italic,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Bottom CTA bar ("Make Another Observation")
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: AppColors.border, width: 1),
                ),
              ),
              child: CustomButton(
                text: 'Start New Assessment',
                icon: Icons.add_circle_outline,
                type: CustomButtonType.primary,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ObservationFormScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryNavy,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusBadge.waterBody(observation.waterBodyType),
              if (observation.isDemo) ...[
                const SizedBox(width: 8),
                StatusBadge.demo(),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Text(
            observation.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  color: AppColors.lightTealSurface, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  observation.location,
                  style: const TextStyle(
                    color: AppColors.lightTealSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.white60, size: 16),
              const SizedBox(width: 6),
              Text(
                observation.formattedCreatedAt,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required IconData icon,
    required List<Widget> items,
  }) {
    return Container(
      width: double.infinity,
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
          const Divider(color: AppColors.border, height: 16),
          ...items,
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, {Widget? widgetValue}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
          ),
          const SizedBox(width: 8),
          widgetValue ??
              Flexible(
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
