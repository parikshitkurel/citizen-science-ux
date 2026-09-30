import 'package:flutter/material.dart';
import '../models/observation.dart';
import '../repositories/observation_repository.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/observation_tile.dart';
import 'details_screen.dart';
import 'history_screen.dart';
import 'observation_form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.water_drop, color: AppColors.primaryTeal, size: 22),
            SizedBox(width: 8),
            Text(
              AppConstants.appName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_outlined),
            tooltip: 'Observation History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoryScreen(),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Manage Data',
            onSelected: (value) async {
              if (value == 'restore_demo') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    title: const Text('Restore Demo Samples?'),
                    content: const Text(
                      'This will load default sample observations for demonstration. Your personal observations will not be removed.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryTeal,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Restore Samples'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await ObservationRepository.instance.restoreDemoData();
                }
              } else if (value == 'clear_demo') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    title: const Text('Remove Demo Samples?'),
                    content: const Text(
                      'This will remove demo sample observations. Any observations you created will be kept safely.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryNavy,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Remove Demo Data'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await ObservationRepository.instance.clearDemoData();
                }
              } else if (value == 'clear_all') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    title: const Text('Clear All Observations?'),
                    content: const Text(
                      'This will permanently delete all saved records (both your observations and demo samples) from local storage.',
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
                        child: const Text('Clear All Data'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await ObservationRepository.instance.clearAll();
                }
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'restore_demo',
                child: Row(
                  children: [
                    Icon(Icons.refresh, size: 18, color: AppColors.primaryTeal),
                    SizedBox(width: 8),
                    Text('Restore Demo Data'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear_demo',
                child: Row(
                  children: [
                    Icon(Icons.hide_source_outlined,
                        size: 18, color: AppColors.primaryNavy),
                    SizedBox(width: 8),
                    Text('Hide Demo Samples'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep_outlined,
                        size: 18, color: AppColors.danger),
                    SizedBox(width: 8),
                    Text('Clear All Data'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: ValueListenableBuilder<List<Observation>>(
        valueListenable: ObservationRepository.instance.observationsNotifier,
        builder: (context, observations, _) {
          final totalCount = observations.length;
          final userCount =
              observations.where((obs) => !obs.isDemo).length;
          final demoCount =
              observations.where((obs) => obs.isDemo).length;
          final recentObservations = observations.take(3).toList();

          return SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SECTION 1: Compact workspace header with stats
                      _buildWorkspaceHeader(userCount, demoCount, totalCount),
                      const SizedBox(height: 24),

                      // SECTION 2: PRIMARY CTA — Start New Assessment
                      // (Von Restorff: visually dominant, Selective Attention: one primary action)
                      CustomButton(
                        text: 'Start New Assessment',
                        icon: Icons.add_circle_outline_rounded,
                        type: CustomButtonType.primary,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ObservationFormScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),

                      // SECONDARY CTA — View History
                      CustomButton(
                        text: 'View Observation History',
                        icon: Icons.history_rounded,
                        type: CustomButtonType.outlined,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HistoryScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 28),

                      // SECTION 3: Recent Observations — supporting content
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              userCount > 0
                                  ? 'Recent Observations'
                                  : 'Sample Demonstrations',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (totalCount > 0)
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const HistoryScreen(),
                                  ),
                                );
                              },
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'View All',
                                    style: TextStyle(
                                      color: AppColors.primaryTeal,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12,
                                    color: AppColors.primaryTeal,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Demo sample indicator (when no user observations)
                      if (recentObservations.isEmpty)
                        _buildEmptyState(context)
                      else ...[
                        if (userCount == 0 && demoCount > 0)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline,
                                    size: 14, color: AppColors.info),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Showing demo samples. Start an assessment to record your own.',
                                    style: TextStyle(
                                      color: AppColors.info,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Column(
                          children: recentObservations.map((obs) {
                            return ObservationTile(
                              observation: obs,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailsScreen(observation: obs),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ],

                      const SizedBox(height: 20),

                      // SECTION 4: Citizen Science — TERTIARY, visually receding
                      // (Moved below recent observations so it doesn't compete with primary CTA)
                      _buildCitizenScienceCard(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Compact workspace header.
  /// Stats use simple inline text instead of large card-within-card.
  /// (Law of Common Region: one container for all workspace info)
  Widget _buildWorkspaceHeader(
      int userCount, int demoCount, int totalCount) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryNavy, Color(0xFF244A6F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Text(
                  'Freshwater Observation Workspace',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.wifi_off, size: 12, color: Colors.white70),
                    SizedBox(width: 4),
                    Text(
                      'Offline',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Inline stats row — compact, no card nesting
          Row(
            children: [
              _buildStatChip('$userCount', 'My Records'),
              const SizedBox(width: 16),
              _buildStatChip('$demoCount', 'Demo'),
              const SizedBox(width: 16),
              _buildStatChip('$totalCount', 'Total'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String value, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.lightTealSurface,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  /// Citizen Science explanation — moved to TERTIARY position.
  /// Uses progressive disclosure: compact by default.
  Widget _buildCitizenScienceCard() {
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
            children: [
              Icon(
                Icons.eco_outlined,
                color: AppColors.primaryTeal,
                size: 18,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'What is Citizen Science?',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Citizen science invites community members and students to contribute to environmental monitoring. By recording visual indicators like clarity, colour, and vegetation, you help build baseline knowledge of local waterways.',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Icon(Icons.info_outline, size: 13, color: AppColors.textMuted),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Observations are visual estimates, not certified laboratory tests.',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: AppColors.lightTealSurface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.water_drop_outlined,
              size: 36,
              color: AppColors.primaryTeal,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'No observations yet',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Start your first freshwater assessment.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: 220,
            child: CustomButton(
              text: 'Start Assessment',
              icon: Icons.add,
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
    );
  }
}
