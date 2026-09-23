import 'package:flutter/material.dart';
import '../models/observation.dart';
import '../repositories/observation_repository.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/observation_tile.dart';
import 'details_screen.dart';
import 'observation_form_screen.dart';

enum ObservationScopeFilter { all, userOnly, demoOnly }

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  ObservationScopeFilter _scopeFilter = ObservationScopeFilter.all;
  String _selectedWaterBody = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete(Observation observation) async {
    final isDemo = observation.isDemo;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(isDemo ? 'Delete Demo Sample?' : 'Delete Observation?'),
        content: Text(
          isDemo
              ? 'Remove sample observation "${observation.title}"? (You can restore demo samples anytime from the menu).'
              : 'Are you sure you want to delete "${observation.title}"? This observation will be permanently removed from local device storage.',
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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Observation "${observation.title}" removed.'),
          backgroundColor: AppColors.primaryNavy,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Observation History'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Manage Data',
            onSelected: (value) async {
              final messenger = ScaffoldMessenger.of(context);
              if (value == 'restore_demo') {
                await ObservationRepository.instance.restoreDemoData();
                if (!mounted) return;
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Demo sample observations restored.'),
                    backgroundColor: AppColors.primaryNavy,
                  ),
                );
              } else if (value == 'clear_demo') {
                await ObservationRepository.instance.clearDemoData();
                if (!mounted) return;
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Demo samples removed. Personal observations kept.'),
                    backgroundColor: AppColors.primaryNavy,
                  ),
                );
              } else if (value == 'clear_all') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    title: const Text('Clear All Observations?'),
                    content: const Text(
                      'This will permanently delete all saved records (both personal entries and demo samples) from local storage.',
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
                  if (!mounted) return;
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('All observations cleared from device.'),
                      backgroundColor: AppColors.primaryNavy,
                    ),
                  );
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
                    Text('Restore Demo Samples'),
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
                    Text('Remove Demo Samples'),
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
                    Text('Clear All Records'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ObservationFormScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add_circle_outline),
        label: const Text('Start Assessment'),
      ),
      body: ValueListenableBuilder<List<Observation>>(
        valueListenable: ObservationRepository.instance.observationsNotifier,
        builder: (context, observations, _) {
          final userObservations =
              observations.where((obs) => !obs.isDemo).toList();
          final demoObservations =
              observations.where((obs) => obs.isDemo).toList();

          // Filter by scope (All vs My Entries vs Demo Samples)
          List<Observation> scopedList;
          switch (_scopeFilter) {
            case ObservationScopeFilter.userOnly:
              scopedList = userObservations;
              break;
            case ObservationScopeFilter.demoOnly:
              scopedList = demoObservations;
              break;
            case ObservationScopeFilter.all:
              scopedList = observations;
              break;
          }

          // Filter by query and water body type
          final query = _searchController.text.toLowerCase().trim();
          final filtered = scopedList.where((obs) {
            final matchesSearch = obs.title.toLowerCase().contains(query) ||
                obs.location.toLowerCase().contains(query) ||
                obs.notes.toLowerCase().contains(query);
            final matchesWaterBody = _selectedWaterBody == 'All' ||
                obs.waterBodyType.toLowerCase() ==
                    _selectedWaterBody.toLowerCase();
            return matchesSearch && matchesWaterBody;
          }).toList();

          return SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Column(
                  children: [
                    // Search Bar & Filter Controls
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _searchController,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              hintText:
                                  'Search by title, location, or notes...',
                              prefixIcon: const Icon(Icons.search,
                                  color: AppColors.primaryTeal),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, size: 18),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() {});
                                      },
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Scope Filter (All / My Entries / Demo Samples)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildScopeChip(
                                  label: 'All (${observations.length})',
                                  isSelected:
                                      _scopeFilter == ObservationScopeFilter.all,
                                  onSelected: () => setState(() =>
                                      _scopeFilter = ObservationScopeFilter.all),
                                ),
                                const SizedBox(width: 8),
                                _buildScopeChip(
                                  label:
                                      'My Observations (${userObservations.length})',
                                  icon: Icons.person_pin_outlined,
                                  isSelected: _scopeFilter ==
                                      ObservationScopeFilter.userOnly,
                                  onSelected: () => setState(() => _scopeFilter =
                                      ObservationScopeFilter.userOnly),
                                ),
                                const SizedBox(width: 8),
                                _buildScopeChip(
                                  label:
                                      'Demo Samples (${demoObservations.length})',
                                  icon: Icons.science_outlined,
                                  isSelected: _scopeFilter ==
                                      ObservationScopeFilter.demoOnly,
                                  onSelected: () => setState(() => _scopeFilter =
                                      ObservationScopeFilter.demoOnly),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Water Body Type Filter Chips
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                'All',
                                ...AppConstants.waterBodyTypes
                              ].map((filter) {
                                final isSelected =
                                    _selectedWaterBody == filter;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 6.0),
                                  child: FilterChip(
                                    label: Text(filter),
                                    selected: isSelected,
                                    selectedColor: AppColors.lightTealSurface,
                                    checkmarkColor: AppColors.primaryTeal,
                                    labelStyle: TextStyle(
                                      color: isSelected
                                          ? AppColors.darkTeal
                                          : AppColors.textPrimary,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: 12,
                                    ),
                                    onSelected: (selected) {
                                      setState(() {
                                        _selectedWaterBody = filter;
                                      });
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Count summary bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              'Showing ${filtered.length} of ${scopedList.length} records',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '100% Offline',
                            style: TextStyle(
                              color: AppColors.primaryTeal,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Observations List or Empty State
                    Expanded(
                      child: filtered.isEmpty
                          ? _buildEmptyState(
                              totalEmpty: observations.isEmpty,
                              userEmpty: userObservations.isEmpty &&
                                  _scopeFilter ==
                                      ObservationScopeFilter.userOnly,
                              demoEmpty: demoObservations.isEmpty &&
                                  _scopeFilter ==
                                      ObservationScopeFilter.demoOnly,
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 6.0, 20.0, 80.0),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final obs = filtered[index];
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
                                  onDelete: () => _confirmDelete(obs),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScopeChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
    IconData? icon,
  }) {
    return ChoiceChip(
      avatar: icon != null
          ? Icon(icon,
              size: 14,
              color: isSelected ? AppColors.darkTeal : AppColors.textMuted)
          : null,
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.lightTealSurface,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.darkTeal : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
      onSelected: (_) => onSelected(),
    );
  }

  Widget _buildEmptyState({
    required bool totalEmpty,
    required bool userEmpty,
    required bool demoEmpty,
  }) {
    String title;
    String subtitle;
    IconData icon;

    if (userEmpty) {
      title = 'No personal observations yet';
      subtitle =
          'You haven\'t recorded any freshwater observations yet. Tap "Start Assessment" below to record your first stream check.';
      icon = Icons.person_pin_outlined;
    } else if (demoEmpty) {
      title = 'No demo samples loaded';
      subtitle =
          'Demo observations are currently hidden. You can reload sample data anytime from the menu in the top right.';
      icon = Icons.science_outlined;
    } else if (totalEmpty) {
      title = 'No observations saved';
      subtitle =
          'Your local workspace is empty. Tap "Start Assessment" below or reload sample data from the menu.';
      icon = Icons.folder_open_outlined;
    } else {
      title = 'No matching observations';
      subtitle =
          'Try clearing your search query or switching your scope and water body filters.';
      icon = Icons.search_off_outlined;
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: AppColors.lightTealSurface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 44,
                color: AppColors.primaryTeal,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
