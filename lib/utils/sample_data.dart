import '../models/observation.dart';

class SampleData {
  static List<Observation> get initialSampleObservations {
    final now = DateTime.now();
    return [
      Observation(
        id: 'demo-obs-1',
        title: 'Morning Stream Survey',
        waterBodyType: 'Stream',
        location: 'Willow Creek Bridge',
        observationDate: now.subtract(const Duration(hours: 3)),
        clarity: 'Clear',
        visibleColour: 'Normal / Natural-looking',
        odour: 'No unusual odour',
        surfaceMovement: 'Light movement',
        visibleLitter: 'None noticed',
        surroundingVegetation: 'Abundant vegetation',
        surroundingEnvironment: 'Natural / Green area',
        notes:
            'Water appeared calm and transparent with visible pebble bed. Dragonflies and small minnows observed near native shoreline grasses.',
        isDemo: true,
        createdAt: now.subtract(const Duration(hours: 3)),
      ),
      Observation(
        id: 'demo-obs-2',
        title: 'Canal Bank Inspection',
        waterBodyType: 'Urban canal',
        location: 'Riverside Urban Canal',
        observationDate: now.subtract(const Duration(days: 1, hours: 2)),
        clarity: 'Slightly cloudy',
        visibleColour: 'Greenish',
        odour: 'Mild unusual odour',
        surfaceMovement: 'Still',
        visibleLitter: 'Small amount',
        surroundingVegetation: 'Some vegetation',
        surroundingEnvironment: 'Residential area',
        notes:
            'Mild algal film noticed along the stone bank. Two plastic beverage containers observed near the storm outfall.',
        isDemo: true,
        createdAt: now.subtract(const Duration(days: 1, hours: 2)),
      ),
      Observation(
        id: 'demo-obs-3',
        title: 'Park Pond Seasonal Check',
        waterBodyType: 'Pond',
        location: 'Community Mill Pond',
        observationDate: now.subtract(const Duration(days: 3, hours: 5)),
        clarity: 'Clear',
        visibleColour: 'Brownish',
        odour: 'No unusual odour',
        surfaceMovement: 'Still',
        visibleLitter: 'None noticed',
        surroundingVegetation: 'Abundant vegetation',
        surroundingEnvironment: 'Natural / Green area',
        notes:
            'Natural tea-brown tannin tint from autumn oak foliage. High water clarity, mallard ducks present.',
        isDemo: true,
        createdAt: now.subtract(const Duration(days: 3, hours: 5)),
      ),
    ];
  }
}
