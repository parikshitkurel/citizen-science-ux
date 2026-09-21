import '../models/observation.dart';

class SampleData {
  static List<Observation> get initialSampleObservations {
    final now = DateTime.now();
    return [
      Observation(
        id: 'demo-obs-1',
        title: 'Morning River Check',
        waterBodyType: 'River',
        location: 'Demo Riverbank Park',
        observationDate: now.subtract(const Duration(hours: 4)),
        clarity: 'Clear',
        visibleColour: 'Normal/natural',
        odour: 'No unusual odour',
        surfaceMovement: 'Light movement',
        visibleLitter: 'None noticed',
        notes:
            'Water appeared translucent and calm. Small minnows were visible near the rocky edge. No floating debris seen.',
        isDemo: true,
        createdAt: now.subtract(const Duration(hours: 4)),
      ),
      Observation(
        id: 'demo-obs-2',
        title: 'Pond Edge Survey',
        waterBodyType: 'Pond',
        location: 'Community Botanical Pond',
        observationDate: now.subtract(const Duration(days: 1, hours: 2)),
        clarity: 'Slightly cloudy',
        visibleColour: 'Greenish',
        odour: 'No unusual odour',
        surfaceMovement: 'Still',
        visibleLitter: 'Small amount',
        notes:
            'A light algal film observed along the eastern shore. One plastic bottle noticed near duck feeding station.',
        isDemo: true,
        createdAt: now.subtract(const Duration(days: 1, hours: 2)),
      ),
    ];
  }
}
