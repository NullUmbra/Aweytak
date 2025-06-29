import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../models/scenario.dart';

Future<void> importScenariosToHive() async {
  final box = Hive.box<Scenario>('scenarios');

  if (box.isNotEmpty) return; // Skip if already imported

  final files = [
    'assets/steps_cpr_adult.json',
    'assets/steps_cpr_child.json',
    'assets/steps_cpr_infant.json',
    'assets/steps_cpr_choking.json',
    'assets/steps_cpr_unconscious.json',
    'assets/steps_bleed_nose.json',
    'assets/steps_bleed_deepcut.json',
    'assets/steps_bleed_minor.json',
    'assets/steps_bleed_severe.json',
    'assets/steps_bleed_internal.json',
    'assets/steps_burn_mild.json',
    'assets/steps_burn_severe.json',
    'assets/steps_burn_chemical.json',
    'assets/steps_burn_electrical.json',
    'assets/steps_burn_sun.json',
    'assets/steps_choking_adult.json',
    'assets/steps_choking_child.json',
    'assets/steps_choking_infant.json',
    'assets/steps_choking_unconscious.json',
    'assets/steps_choking_severe.json',
    'assets/steps_fever_high.json',
    'assets/steps_fever_low.json',
    'assets/steps_seizure_generalized.json',
    'assets/steps_seizure_febrile.json',
    'assets/steps_seizure_status_epilepticus.json',
    'assets/steps_snake_bite.json',
    'assets/steps_insect_sting.json',
    'assets/steps_scorpion_sting.json',
    'assets/steps_spider_bite.json',
    'assets/steps_bee_sting.json',
    'assets/steps_fainting.json',
    'assets/steps_shock.json',
    'assets/steps_heat_exhaustion.json',
    'assets/steps_hypovolemic_shock.json',
    'assets/steps_anaphylactic_shock.json',
    'assets/steps_malaria.json',
    'assets/steps_cholera.json',
    'assets/steps_hepatitis.json',
    'assets/steps_tb.json',
    'assets/steps_diarrhea.json',
    'assets/steps_typhoid.json',
    'assets/steps_measles.json',
    'assets/steps_dengue.json',
    'assets/steps_diabetes.json',
    'assets/steps_asthma.json',
  ];

  for (final path in files) {
    final content = await rootBundle.loadString(path);
    final data = json.decode(content);

    final steps = (data['steps'] as List)
        .map((s) => {'ar': s['ar'] as String, 'en': s['en'] as String})
        .toList();

    final scenarioId = data['scenarioId'];

    final scenario = Scenario(
      id: scenarioId,
      categoryId: _getCategoryIdFromScenarioId(scenarioId),
      titleAr: _getScenarioTitle(scenarioId, 'ar'),
      titleEn: _getScenarioTitle(scenarioId, 'en'),
      steps: steps,
    );

    await box.put(scenario.id, scenario);
  }
}

String _getCategoryIdFromScenarioId(String scenarioId) {
  if (scenarioId.startsWith('cpr_')) return 'cpr';
  if (scenarioId.startsWith('bleed_')) return 'bleeding';
  if (scenarioId.startsWith('burn_')) return 'burns';
  if (scenarioId.startsWith('choking_')) return 'choking';
  if (scenarioId.startsWith('fever_') || scenarioId.startsWith('seizure_')) {
    return 'fever_seizures';
  }
  if (scenarioId.contains('bite') ||
      scenarioId.contains('sting') ||
      scenarioId.contains('spider')) {
    return 'bites_stings';
  }
  if (scenarioId.contains('shock') || scenarioId.contains('fainting')) {
    return 'fainting_shock';
  }
  if (scenarioId.contains('malaria') ||
      scenarioId.contains('cholera') ||
      scenarioId.contains('hepatitis') ||
      scenarioId.contains('tb') ||
      scenarioId.contains('diarrhea') ||
      scenarioId.contains('typhoid') ||
      scenarioId.contains('measles') ||
      scenarioId.contains('dengue') ||
      scenarioId.contains('diabetes') ||
      scenarioId.contains('asthma')) {
    return 'diseases';
  }
  return 'unknown';
}

String _getScenarioTitle(String scenarioId, String lang) {
  final titles = {
    'cpr_adult': {'en': 'Adult CPR', 'ar': 'الإنعاش القلبي للبالغ'},
    'cpr_child': {'en': 'Child CPR', 'ar': 'الإنعاش القلبي للأطفال'},
    'cpr_infant': {'en': 'Infant CPR', 'ar': 'الإنعاش القلبي للرضيع'},
    'cpr_choking': {'en': 'CPR with Choking', 'ar': 'الإنعاش مع الاختناق'},
    'cpr_unconscious': {
      'en': 'CPR for Unconscious',
      'ar': 'الإنعاش لحالة فقدان الوعي',
    },

    'bleed_nose': {'en': 'Nosebleed', 'ar': 'نزيف الأنف'},
    'bleed_deepcut': {'en': 'Deep Cut', 'ar': 'جرح عميق'},
    'bleed_minor': {'en': 'Minor Bleeding', 'ar': 'نزيف بسيط'},
    'bleed_severe': {'en': 'Severe Bleeding', 'ar': 'نزيف شديد'},
    'bleed_internal': {'en': 'Internal Bleeding', 'ar': 'نزيف داخلي'},

    'burn_mild': {'en': 'Mild Burn', 'ar': 'حرق بسيط'},
    'burn_severe': {'en': 'Severe Burn', 'ar': 'حرق شديد'},
    'burn_chemical': {'en': 'Chemical Burn', 'ar': 'حرق كيميائي'},
    'burn_electrical': {'en': 'Electrical Burn', 'ar': 'حرق كهربائي'},
    'burn_sun': {'en': 'Sunburn', 'ar': 'ضربة شمس'},

    'choking_adult': {'en': 'Adult Choking', 'ar': 'اختناق بالغ'},
    'choking_child': {'en': 'Child Choking', 'ar': 'اختناق طفل'},
    'choking_infant': {'en': 'Infant Choking', 'ar': 'اختناق رضيع'},
    'choking_unconscious': {
      'en': 'Choking & Unconscious',
      'ar': 'اختناق مع فقدان وعي',
    },
    'choking_severe': {'en': 'Severe Choking', 'ar': 'اختناق شديد'},

    'fever_high': {'en': 'High Fever', 'ar': 'حمى شديدة'},
    'fever_low': {'en': 'Low Fever', 'ar': 'حمى خفيفة'},
    'seizure_generalized': {'en': 'Generalized Seizure', 'ar': 'تشنج عام'},
    'seizure_febrile': {'en': 'Febrile Seizure', 'ar': 'تشنج بسبب الحمى'},
    'seizure_status_epilepticus': {
      'en': 'Status Epilepticus',
      'ar': 'حالة صرعية مستمرة',
    },

    'snake_bite': {'en': 'Snake Bite', 'ar': 'لدغة أفعى'},
    'insect_sting': {'en': 'Insect Sting', 'ar': 'لسعة حشرة'},
    'scorpion_sting': {'en': 'Scorpion Sting', 'ar': 'لسعة عقرب'},
    'spider_bite': {'en': 'Spider Bite', 'ar': 'لدغة عنكبوت'},
    'bee_sting': {'en': 'Bee Sting', 'ar': 'لسعة نحلة'},

    'fainting': {'en': 'Fainting', 'ar': 'إغماء'},
    'shock': {'en': 'Shock', 'ar': 'صدمة'},
    'heat_exhaustion': {'en': 'Heat Exhaustion', 'ar': 'إجهاد حراري'},
    'hypovolemic_shock': {'en': 'Hypovolemic Shock', 'ar': 'صدمة نقص حجم الدم'},
    'anaphylactic_shock': {'en': 'Anaphylactic Shock', 'ar': 'صدمة تحسسية'},

    'malaria': {'en': 'Malaria', 'ar': 'الملاريا'},
    'cholera': {'en': 'Cholera', 'ar': 'الكوليرا'},
    'hepatitis': {'en': 'Hepatitis', 'ar': 'التهاب الكبد'},
    'tb': {'en': 'Tuberculosis', 'ar': 'السل'},
    'diarrhea': {'en': 'Diarrhea', 'ar': 'الإسهال'},
    'typhoid': {'en': 'Typhoid', 'ar': 'التيفويد'},
    'measles': {'en': 'Measles', 'ar': 'الحصبة'},
    'dengue': {'en': 'Dengue Fever', 'ar': 'حمى الضنك'},
    'diabetes': {'en': 'Diabetic Emergency', 'ar': 'حالة سكري طارئة'},
    'asthma': {'en': 'Asthma Attack', 'ar': 'نوبة ربو'},
  };

  return titles[scenarioId]?[lang] ?? scenarioId.replaceAll('_', ' ');
}
