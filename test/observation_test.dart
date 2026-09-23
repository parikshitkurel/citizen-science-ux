import 'package:flutter_test/flutter_test.dart';
import 'package:aqua_verify/models/observation.dart';

void main() {
  group('Observation Model Tests', () {
    final now = DateTime.now();
    final sampleObservation = Observation(
      id: 'test-id-1',
      title: 'Stream Check',
      waterBodyType: 'Stream',
      location: 'Willow Creek Bridge',
      observationDate: now,
      clarity: 'Clear',
      visibleColour: 'Normal / Natural-looking',
      odour: 'No unusual odour',
      surfaceMovement: 'Light movement',
      visibleLitter: 'None noticed',
      surroundingVegetation: 'Abundant vegetation',
      surroundingEnvironment: 'Natural / Green area',
      notes: 'Water is clean and flowing smoothly.',
      isDemo: false,
      createdAt: now,
    );

    test('toJson and fromJson correctly serialize and deserialize all Track 1 fields', () {
      final json = sampleObservation.toJson();
      final reconstructed = Observation.fromJson(json);

      expect(reconstructed.id, equals(sampleObservation.id));
      expect(reconstructed.title, equals(sampleObservation.title));
      expect(reconstructed.waterBodyType, equals(sampleObservation.waterBodyType));
      expect(reconstructed.location, equals(sampleObservation.location));
      expect(reconstructed.clarity, equals(sampleObservation.clarity));
      expect(reconstructed.visibleColour, equals(sampleObservation.visibleColour));
      expect(reconstructed.odour, equals(sampleObservation.odour));
      expect(reconstructed.surfaceMovement, equals(sampleObservation.surfaceMovement));
      expect(reconstructed.visibleLitter, equals(sampleObservation.visibleLitter));
      expect(reconstructed.surroundingVegetation, equals(sampleObservation.surroundingVegetation));
      expect(reconstructed.surroundingEnvironment, equals(sampleObservation.surroundingEnvironment));
      expect(reconstructed.notes, equals(sampleObservation.notes));
      expect(reconstructed.isDemo, equals(false));
    });

    test('fromJson handles legacy data without surrounding vegetation/environment gracefully', () {
      final legacyJson = {
        'id': 'legacy-id',
        'title': 'Legacy Obs',
        'waterBodyType': 'River',
        'location': 'Old River',
        'observationDate': now.toIso8601String(),
        'clarity': 'Clear',
        'visibleColour': 'Normal / Natural-looking',
        'odour': 'No unusual odour',
        'surfaceMovement': 'Still',
        'visibleLitter': 'None noticed',
        'notes': 'Legacy notes',
        'isDemo': false,
        'createdAt': now.toIso8601String(),
      };

      final reconstructed = Observation.fromJson(legacyJson);
      expect(reconstructed.surroundingVegetation, equals('Unsure / Cannot tell'));
      expect(reconstructed.surroundingEnvironment, equals('Unsure / Cannot tell'));
    });

    test('copyWith updates specified fields only', () {
      final updated = sampleObservation.copyWith(
        title: 'Updated Title',
        clarity: 'Very cloudy',
        surroundingVegetation: 'Little or no vegetation',
      );

      expect(updated.id, equals(sampleObservation.id));
      expect(updated.title, equals('Updated Title'));
      expect(updated.clarity, equals('Very cloudy'));
      expect(updated.surroundingVegetation, equals('Little or no vegetation'));
      expect(updated.surroundingEnvironment, equals(sampleObservation.surroundingEnvironment));
      expect(updated.location, equals(sampleObservation.location));
    });

    test('formatted getters return non-empty strings', () {
      expect(sampleObservation.formattedDate, isNotEmpty);
      expect(sampleObservation.formattedTime, isNotEmpty);
      expect(sampleObservation.formattedCreatedAt, isNotEmpty);
    });
  });
}
