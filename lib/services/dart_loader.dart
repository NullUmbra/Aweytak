import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<List<Map<String, dynamic>>> loadScenarioSteps(String scenarioId) async {
  try {
    final path = 'assets/steps_$scenarioId.json';
    ('📂 Attempting to load: $path');
    final jsonString = await rootBundle.loadString(path);
    final data = json.decode(jsonString);
    return List<Map<String, dynamic>>.from(data['steps']);
  } catch (e) {
    ('Error loading steps for $scenarioId: $e');
    return [];
  }
}
