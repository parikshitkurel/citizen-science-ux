class AppConstants {
  static const String appName = 'AquaVerify';
  static const String appTagline = 'Observe water. Understand your surroundings.';
  static const String appPurpose =
      'Help document freshwater environments through simple, guided observations.';
  static const String appSubTitle =
      'A guided freshwater observation tool empowering citizen scientists and students to record clear, reliable water-body records.';

  // Observation Disclaimer
  static const String observationDisclaimer =
      'These records represent citizen observations and are not certified laboratory measurements. They should not be used alone to determine water safety or ecosystem health.';

  // Predefined Sample Locations for quick selection / demonstration
  static const List<String> predefinedLocations = [
    'Willow Creek Bridge',
    'Riverside Urban Canal',
    'Community Mill Pond',
    'Highland Reservoir Park',
    'Greenway Stream Overlook',
    'Centennial Lake Boardwalk',
  ];

  // Water Body Types
  static const List<String> waterBodyTypes = [
    'Stream',
    'River',
    'Pond',
    'Lake',
    'Urban canal',
    'Other',
  ];

  // STEP 2: Water Appearance Options
  static const List<String> clarityOptions = [
    'Clear',
    'Slightly cloudy',
    'Very cloudy',
    'Unsure / Cannot tell',
  ];

  static const List<String> colorOptions = [
    'Normal / Natural-looking',
    'Greenish',
    'Brownish',
    'Unusual',
    'Unsure / Cannot tell',
  ];

  static const List<String> odourOptions = [
    'No unusual odour',
    'Mild unusual odour',
    'Strong unusual odour',
    'Unsure / Cannot tell',
  ];

  // STEP 3: Environmental Factors Options
  static const List<String> movementOptions = [
    'Still',
    'Light movement',
    'Fast movement',
    'Unsure / Cannot tell',
  ];

  static const List<String> litterOptions = [
    'None noticed',
    'Small amount',
    'Large amount',
    'Unsure / Cannot tell',
  ];

  static const List<String> vegetationOptions = [
    'Abundant vegetation',
    'Some vegetation',
    'Little or no vegetation',
    'Unsure / Cannot tell',
  ];

  static const List<String> surroundingEnvironmentOptions = [
    'Natural / Green area',
    'Residential area',
    'Industrial area',
    'Agricultural area',
    'Other',
    'Unsure / Cannot tell',
  ];

  // "Why we ask this" Educational Explanations (Citizen Science UX)
  static const Map<String, String> educationalExplanations = {
    'clarity':
        'Cloudy water can contain suspended particles. This observation is a visual estimate, not a laboratory turbidity measurement.',
    'color':
        'Natural water colour comes from organic tannins, soil minerals, or algae. Unusual or milky colours can point to recent runoff.',
    'odour':
        'Healthy waterways smell like fresh soil and nature. Strong chemical or sulfur smells suggest anaerobic decay or runoff. ⚠️ Safety reminder: Never touch, taste, or inhale questionable water.',
    'movement':
        'Water velocity influences aeration and oxygen availability. Fast riffles oxygenate water for fish and benthic macroinvertebrates.',
    'litter':
        'Visible debris harms aquatic habitats, degrades banks, and introduces microplastics. Documenting trash helps local cleanup efforts.',
    'vegetation':
        'Riparian buffer plants stabilize banks against erosion, provide cooling shade, and filter surface runoff before it enters the water.',
    'environment':
        'The broader landscape context helps researchers identify possible human impacts, runoff patterns, and urbanization pressures.',
  };
}
