import 'package:flutter_test/flutter_test.dart';
import 'package:aqua_verify/models/observation.dart';

void main() {
  group('Observation Model Tests', () {
    final now = DateTime.now();
    final sampleObservation = Observation(
      id: 'test-id-1',
      title: 'Stream Check',
      waterBodyType: 'Stream',
      location: 'Local Park Stream',
      observationDate: now,
      clarity: 'Clear',
      visibleColour: 'Normal/natural',
      odour: 'No unusual odour',
      surfaceMovement: 'Light movement',
      visibleLitter: 'None noticed',
      notes: 'Water is clean and flowing smoothly.',
      isDemo: false,
      createdAt: now,
    );

    test('toJson and fromJson correctly serialize and deserialize', () {
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
      expect(reconstructed.notes, equals(sampleObservation.notes));
      expect(reconstructed.isDemo, equals(false));
    });

    test('copyWith updates specified fields only', () {
      final updated = sampleObservation.copyWith(
        title: 'Updated Title',
        clarity: 'Very cloudy',
      );

      expect(updated.id, equals(sampleObservation.id));
      expect(updated.title, equals('Updated Title'));
      expect(updated.clarity, equals('Very cloudy'));
      expect(updated.location, equals(sampleObservation.location));
    });

    test('formatted getters return non-empty strings', () {
      expect(sampleObservation.formattedDate, isNotEmpty);
      expect(sampleObservation.formattedTime, isNotEmpty);
      expect(sampleObservation.formattedCreatedAt, isNotEmpty);
    });
  });
}
