import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/observation.dart';

class StorageService {
  static const String _observationsKey = 'aqua_verify_observations';

  Future<List<Observation>> loadObservations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_observationsKey);
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      final List<dynamic> decodedList = jsonDecode(jsonString) as List<dynamic>;
      return decodedList
          .map((item) => Observation.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // In case of parsing error, return empty list safely
      return [];
    }
  }

  Future<bool> saveObservations(List<Observation> observations) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> jsonList =
          observations.map((obs) => obs.toJson()).toList();
      final String encoded = jsonEncode(jsonList);
      return await prefs.setString(_observationsKey, encoded);
    } catch (e) {
      return false;
    }
  }
}
