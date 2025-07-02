import 'dart:convert'; // Required for jsonDecode
import 'package:flutter/services.dart'
    show rootBundle; // Required for loading assets
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aweytak/models/scenario.dart'; // Adjust this import path

class ScenarioImporter {
  // Method to clear all existing scenarios from the Hive box
  Future<void> clearAllScenarios() async {
    try {
      final box = await Hive.openBox<Scenario>('scenarios');
      await box.clear();
      print('All existing scenarios cleared from Hive.');
    } catch (e) {
      print('Error clearing scenarios: $e');
    }
  }

  // Method to save a single scenario object to Hive
  Future<void> saveScenario(Scenario scenario) async {
    try {
      final box = await Hive.openBox<Scenario>('scenarios');
      await box.put(scenario.id, scenario); // Use put to add or overwrite by ID
      print('Scenario "${scenario.titleEn}" saved successfully to Hive.');
    } catch (e) {
      print('Error saving scenario "${scenario.titleEn}": $e');
    }
  }

  // Method to save multiple scenarios to Hive
  Future<void> saveMultipleScenarios(List<Scenario> scenarios) async {
    try {
      final box = await Hive.openBox<Scenario>('scenarios');
      for (var scenario in scenarios) {
        await box.put(scenario.id, scenario);
        print('Scenario "${scenario.titleEn}" saved.');
      }
      print('All provided scenarios saved successfully to Hive.');
    } catch (e) {
      print('Error saving multiple scenarios: $e');
    }
  }

  // This method will import all initial scenarios from JSON files and mark the import as done
  Future<void> importInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    final hasInitialDataLoaded = prefs.getBool('hasInitialDataLoaded') ?? false;

    if (!hasInitialDataLoaded) {
      print('Initial data import starting from JSON assets...');
      await clearAllScenarios(); // Clear existing data

      List<Scenario> scenariosToImport = [];

      try {
        List<String> scenarioFileNames = [
          // Assessment Category
          'assessment_scene_safety.json',
          'assessment_check_responsiveness.json',
          'assessment_call_help.json',
          'assessment_abc_check.json',
          'assessment_head_to_toe.json',

          // Emergency Action Category
          'emergency_action_check_victim.json',
          'emergency_action_call_ems.json',
          'emergency_action_care_until_help.json',
          'emergency_action_do_not_leave.json',
          'emergency_action_reassure.json',

          // CPR Category
          'cpr_adult.json',
          'cpr_child.json',
          'cpr_infant.json',
          'rescue_breathing_adult.json',
          'rescue_breathing_child.json',
          'cpr_unconscious.json',

          // Bleeding Category
          'bleeding_external.json',
          'bleeding_internal.json',
          'bleeding_nosebleed.json',
          'bleeding_amputation.json',
          'bleeding_puncture_wound.json',
          'bleeding_crush_injury.json',

          // Shock Category
          'shock_general_recognizing.json',
          'shock_treat.json',
          'shock_anaphylactic.json',
          'shock_psychological.json',

          // Burns Category
          'burn_first_degree.json',
          'burn_second_degree.json',
          'burn_third_degree.json',
          'burn_chemical.json',
          'burn_electrical.json',
          'burn_sun.json',

          // Choking Category
          'choking_adult_conscious.json',
          'choking_adult_unconscious.json',
          'choking_child_conscious.json',
          'choking_child_unconscious.json',
          'choking_infant.json',

          // Fractures & Sprains Category
          'fracture_sprain_general.json',
          'fracture_femoral.json',
          'immobilization_slings.json',

          // Bites & Stings Category
          'bite_snake.json',
          'bite_dog.json',
          'sting_insect.json',
          'bite_spider.json',
          'sting_jellyfish.json',

          // Sudden Illnesses Category
          'illness_fainting.json',
          'illness_diabetic.json',
          'illness_seizure.json',
          'illness_stroke.json',
          'illness_heart_attack.json',

          // Environmental Injuries Category
          'env_heat_exhaustion.json',
          'env_heatstroke.json',
          'env_hypothermia.json',
          'env_frostbite.json',
          'env_lightning.json',

          // Other First Aid Topics Category
          'aed_operation.json',
          'bls_cpr.json',
          'head_spinal_eye_injuries.json',
          'poisoning_non_bite.json',
          'chest_abdominal_injuries.json',
        ];

        for (String fileName in scenarioFileNames) {
          String jsonString = await rootBundle.loadString(
            'assets/scenarios/$fileName',
          );
          Map<String, dynamic> jsonMap = jsonDecode(jsonString);
          scenariosToImport.add(Scenario.fromJson(jsonMap));
        }

        await saveMultipleScenarios(scenariosToImport);

        // Mark that initial data has been loaded
        await prefs.setBool('hasInitialDataLoaded', true);
        print('Initial data import completed from JSON assets and flag set.');
      } catch (e) {
        print('Error importing scenarios from JSON assets: $e');
        await prefs.setBool(
          'hasInitialDataLoaded',
          false,
        ); // Reset flag on error
      }
    } else {
      print('Initial data already loaded. Skipping import from JSON assets.');
    }
  }
}
