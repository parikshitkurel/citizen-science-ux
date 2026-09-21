import 'package:flutter/material.dart';
import '../models/observation.dart';
import '../repositories/observation_repository.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/observation_tile.dart';
import 'details_screen.dart';
import 'observation_form_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete(BuildContext context, Observation observation) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Observation?'),
        content: Text(
          'Are you sure you want to delete "${observation.title}"? This action cannot be undone.',
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
          content: Text('Observation "${observation.title}" deleted.'),
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
        icon: const Icon(Icons.add),
        label: const Text('New Observation'),
      ),
      body: ValueListenableBuilder<List<Observation>>(
        valueListenable: ObservationRepository.instance.observationsNotifier,
        builder: (context, observations, _) {
          // Apply search & water body filtering
          final query = _searchController.text.toLowerCase().trim();
          final filtered = observations.where((obs) {
            final matchesSearch = obs.title.toLowerCase().contains(query) ||
                obs.location.toLowerCase().contains(query);
            final matchesFilter = _selectedFilter == 'All' ||
                obs.waterBodyType.toLowerCase() ==
                    _selectedFilter.toLowerCase();
            return matchesSearch && matchesFilter;
          }).toList();

          return SafeArea(
            child: Column(
              children: [
                // Search Bar & Filter Chips
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Search by title or location...',
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
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ['All', ...AppConstants.waterBodyTypes]
                              .map((filter) {
                            final isSelected = _selectedFilter == filter;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Text(filter),
                                selected: isSelected,
                                selectedColor: AppColors.lightTealSurface,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? AppColors.darkTeal
                                      : AppColors.textPrimary,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      _selectedFilter = filter;
                                    });
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                // Observations List or Empty State
                Expanded(
                  child: filtered.isEmpty
                      ? _buildEmptyState(observations.isEmpty)
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                              onDelete: () => _confirmDelete(context, obs),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(bool isTotalEmpty) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.lightTealSurface,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.folder_open_outlined,
                size: 48,
                color: AppColors.primaryTeal,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isTotalEmpty
                  ? 'No saved observations yet'
                  : 'No matching observations found',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isTotalEmpty
                  ? 'Tap "+ New Observation" to record your first stream or water-body check.'
                  : 'Try clearing your search query or switching filters.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
