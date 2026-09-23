import 'package:intl/intl.dart';

class Observation {
  final String id;
  final String title;
  final String waterBodyType;
  final String location;
  final DateTime observationDate;
  final String clarity;
  final String visibleColour;
  final String odour;
  final String surfaceMovement;
  final String visibleLitter;
  final String surroundingVegetation;
  final String surroundingEnvironment;
  final String notes;
  final bool isDemo;
  final DateTime createdAt;

  const Observation({
    required this.id,
    required this.title,
    required this.waterBodyType,
    required this.location,
    required this.observationDate,
    required this.clarity,
    required this.visibleColour,
    required this.odour,
    required this.surfaceMovement,
    required this.visibleLitter,
    this.surroundingVegetation = 'Unsure / Cannot tell',
    this.surroundingEnvironment = 'Unsure / Cannot tell',
    required this.notes,
    this.isDemo = false,
    required this.createdAt,
  });

  String get formattedDate {
    return DateFormat('MMM dd, yyyy').format(observationDate);
  }

  String get formattedTime {
    return DateFormat('hh:mm a').format(observationDate);
  }

  String get formattedCreatedAt {
    return DateFormat('MMM dd, yyyy • hh:mm a').format(createdAt);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'waterBodyType': waterBodyType,
      'location': location,
      'observationDate': observationDate.toIso8601String(),
      'clarity': clarity,
      'visibleColour': visibleColour,
      'odour': odour,
      'surfaceMovement': surfaceMovement,
      'visibleLitter': visibleLitter,
      'surroundingVegetation': surroundingVegetation,
      'surroundingEnvironment': surroundingEnvironment,
      'notes': notes,
      'isDemo': isDemo,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Observation.fromJson(Map<String, dynamic> json) {
    return Observation(
      id: json['id'] as String,
      title: json['title'] as String,
      waterBodyType: json['waterBodyType'] as String,
      location: json['location'] as String,
      observationDate: DateTime.parse(json['observationDate'] as String),
      clarity: json['clarity'] as String,
      visibleColour: json['visibleColour'] as String,
      odour: json['odour'] as String,
      surfaceMovement: json['surfaceMovement'] as String,
      visibleLitter: json['visibleLitter'] as String,
      surroundingVegetation:
          (json['surroundingVegetation'] as String?) ?? 'Unsure / Cannot tell',
      surroundingEnvironment:
          (json['surroundingEnvironment'] as String?) ?? 'Unsure / Cannot tell',
      notes: (json['notes'] as String?) ?? '',
      isDemo: (json['isDemo'] as bool?) ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Observation copyWith({
    String? id,
    String? title,
    String? waterBodyType,
    String? location,
    DateTime? observationDate,
    String? clarity,
    String? visibleColour,
    String? odour,
    String? surfaceMovement,
    String? visibleLitter,
    String? surroundingVegetation,
    String? surroundingEnvironment,
    String? notes,
    bool? isDemo,
    DateTime? createdAt,
  }) {
    return Observation(
      id: id ?? this.id,
      title: title ?? this.title,
      waterBodyType: waterBodyType ?? this.waterBodyType,
      location: location ?? this.location,
      observationDate: observationDate ?? this.observationDate,
      clarity: clarity ?? this.clarity,
      visibleColour: visibleColour ?? this.visibleColour,
      odour: odour ?? this.odour,
      surfaceMovement: surfaceMovement ?? this.surfaceMovement,
      visibleLitter: visibleLitter ?? this.visibleLitter,
      surroundingVegetation:
          surroundingVegetation ?? this.surroundingVegetation,
      surroundingEnvironment:
          surroundingEnvironment ?? this.surroundingEnvironment,
      notes: notes ?? this.notes,
      isDemo: isDemo ?? this.isDemo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
