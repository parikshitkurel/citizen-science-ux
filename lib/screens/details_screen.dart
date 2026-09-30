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
Type: ${observation.isDemo ? 'Demo Sample' : 'Citizen Record'}

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
    final isDemo = observation.isDemo;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(isDemo ? 'Delete Demo Sample?' : 'Delete Observation?'),
        content: Text(
          isDemo
              ? 'Remove sample record "${observation.title}"? (You can restore demo samples anytime from the menu).'
              : 'Are you sure you want to delete "${observation.title}"? This cannot be undone.',
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
            icon: const Icon(Icons.copy_outlined, size: 20),
            tooltip: 'Copy Summary',
            onPressed: () => _copySummaryToClipboard(context),
          ),
          // Delete visually separated — uses danger color but smaller icon
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: 'More Actions',
            onSelected: (value) {
              if (value == 'delete') {
                _confirmDelete(context);
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 18, color: AppColors.danger),
                    SizedBox(width: 8),
                    Text('Delete Observation',
                        style: TextStyle(color: AppColors.danger)),
                  ],
                ),
              ),
            ],
          ),
        ],
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
                        // Header Banner
                        _buildHeaderBanner(),
                        const SizedBox(height: 12),

                        // Citizen science notice — compact inline
                        Row(
                          children: [
                            Icon(Icons.verified_outlined,
                                color: AppColors.darkTeal, size: 16),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Citizen Science Record • Visual Estimate',
                                style: TextStyle(
                                  color: AppColors.darkTeal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Section 1: Water Appearance Details
                        _buildDetailSection(
                          title: 'Water Appearance',
                          icon: Icons.water_drop_outlined,
                          items: [
                            _buildDetailItem('Clarity', observation.clarity,
                                widgetValue:
                                    StatusBadge.clarity(observation.clarity)),
                            _buildDetailItem(
                                'Visible Colour', observation.visibleColour),
                            _buildDetailItem(
                                'Water Odour', observation.odour),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Section 2: Environmental Factors
                        _buildDetailSection(
                          title: 'Environmental Factors',
                          icon: Icons.eco_outlined,
                          items: [
                            _buildDetailItem('Surface Movement',
                                observation.surfaceMovement),
                            _buildDetailItem(
                                'Visible Litter', observation.visibleLitter,
                                widgetValue:
                                    StatusBadge.litter(observation.visibleLitter)),
                            _buildDetailItem('Surrounding Vegetation',
                                observation.surroundingVegetation),
                            _buildDetailItem('Surrounding Area',
                                observation.surroundingEnvironment),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Section 3: Notes
                        _buildDetailSection(
                          title: 'Field Notes',
                          icon: Icons.notes_outlined,
                          items: [
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Text(
                                observation.notes.isNotEmpty
                                    ? observation.notes
                                    : 'No additional field notes entered.',
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

                // Bottom CTA
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
        ),
      ),
    );
  }

  Widget _buildHeaderBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primaryNavy,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badges row
          Row(
            children: [
              StatusBadge.waterBody(observation.waterBodyType),
              const SizedBox(width: 8),
              if (observation.isDemo)
                StatusBadge.demo()
              else
                StatusBadge.userRecorded(),
            ],
          ),
          const SizedBox(height: 10),
          // Title
          Text(
            observation.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          // Location
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  color: AppColors.lightTealSurface, size: 15),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  observation.location,
                  style: const TextStyle(
                    color: AppColors.lightTealSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          // Date
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.white54, size: 15),
              const SizedBox(width: 5),
              Text(
                observation.formattedCreatedAt,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Detail section — uses divider + typography hierarchy instead of heavy card borders.
  /// Consistent with Review screen structure (Law of Similarity).
  Widget _buildDetailSection({
    required String title,
    required IconData icon,
    required List<Widget> items,
  }) {
    return Container(
      width: double.infinity,
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
            children: [
              Icon(icon, color: AppColors.primaryTeal, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1, color: AppColors.border),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, {Widget? widgetValue}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
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
                    fontSize: 13,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
