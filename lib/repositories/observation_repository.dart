import 'package:flutter/foundation.dart';
import '../models/observation.dart';
import '../services/storage_service.dart';
import '../utils/sample_data.dart';

class ObservationRepository {
  final StorageService _storageService;

  // Singleton pattern for simple global access without heavy state management libraries
  static final ObservationRepository instance = ObservationRepository._internal(
    StorageService(),
  );

  ObservationRepository._internal(this._storageService);

  final ValueNotifier<List<Observation>> observationsNotifier =
      ValueNotifier<List<Observation>>([]);

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    final loaded = await _storageService.loadObservations();
    if (loaded.isEmpty) {
      // Seed with realistic demo sample data on first run
      final initialData = SampleData.initialSampleObservations;
      await _storageService.saveObservations(initialData);
      observationsNotifier.value = initialData;
    } else {
      observationsNotifier.value = loaded;
    }
    _isInitialized = true;
  }

  List<Observation> get observations => observationsNotifier.value;

  int get totalCount => observations.length;

  int get userSubmittedCount =>
      observations.where((obs) => !obs.isDemo).length;

  Future<void> addObservation(Observation observation) async {
    final updatedList = [observation, ...observationsNotifier.value];
    observationsNotifier.value = updatedList;
    await _storageService.saveObservations(updatedList);
  }

  Future<void> deleteObservation(String id) async {
    final updatedList =
        observationsNotifier.value.where((obs) => obs.id != id).toList();
    observationsNotifier.value = updatedList;
    await _storageService.saveObservations(updatedList);
  }

  Future<void> clearAll() async {
    observationsNotifier.value = [];
    await _storageService.saveObservations([]);
  }

  Future<void> resetToDemo() async {
    final initialData = SampleData.initialSampleObservations;
    observationsNotifier.value = initialData;
    await _storageService.saveObservations(initialData);
  }
}
