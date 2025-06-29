import 'package:hive/hive.dart';
import '../models/scenario.dart';

Future<List<Map<String, String>>> loadScenarioSteps(String scenarioId) async {
  final box = Hive.box<Scenario>('scenarios');
  final scenario = box.get(scenarioId);

  if (scenario == null) {
    // You can log or handle missing data gracefully here
    return [];
  }

  return scenario.steps;
}
