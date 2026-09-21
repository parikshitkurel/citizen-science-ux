class AppConstants {
  static const String appName = 'AquaVerify';
  static const String appTagline = 'Observe water. Understand your surroundings.';
  static const String appSubTitle =
      'A guided freshwater observation tool empowering citizen scientists to record clear, reliable stream and water-body records.';

  // Form Options
  static const List<String> waterBodyTypes = [
    'River',
    'Stream',
    'Pond',
    'Lake',
    'Canal',
    'Other',
  ];

  static const List<String> clarityOptions = [
    'Clear',
    'Slightly cloudy',
    'Very cloudy',
    'Unsure',
  ];

  static const List<String> colorOptions = [
    'Normal/natural',
    'Greenish',
    'Brownish',
    'Unusual',
    'Unsure',
  ];

  static const List<String> odourOptions = [
    'No unusual odour',
    'Mild unusual odour',
    'Strong unusual odour',
    'Unsure',
  ];

  static const List<String> movementOptions = [
    'Still',
    'Light movement',
    'Fast movement',
    'Unsure',
  ];

  static const List<String> litterOptions = [
    'None noticed',
    'Small amount',
    'Large amount',
    'Unsure',
  ];

  // Helper Explanations for Beginners (Citizen Science UX)
  static const Map<String, String> optionTooltips = {
    'clarity':
        'Water clarity shows how easily light penetrates the water. Clear water allows submerged plants to thrive, while high cloudiness (turbidity) can indicate sediment runoff or algae.',
    'color':
        'Natural water can range from crystal clear to tea-brown due to harmless leaves and organic matter. Bright green often suggests algae growth, while greyish or unusual hues may indicate runoff.',
    'odour':
        'Healthy freshwater typically smells like fresh earth or damp soil. Strong sour, chemical, or sewage smells can signal localized pollution.',
    'movement':
        'Movement affects oxygen levels in water. Fast riffles introduce fresh oxygen for fish and aquatic insects, while still water warms up faster.',
    'litter':
        'Floating or submerged trash impacts wildlife habitat. Documenting litter helps local conservation groups target cleanup efforts.',
  };
}
