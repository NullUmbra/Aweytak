class ScenarioMetadataService {
  static final Map<String, String> _categoryMap = {
    'cpr': 'cpr',
    'bleed': 'bleeding',
    'burn': 'burns',
    'choking': 'choking',
    'fever': 'fever_seizures',
    'seizure': 'fever_seizures',
    'bite': 'bites_stings',
    'sting': 'bites_stings',
    'spider': 'bites_stings',
    'shock': 'fainting_shock',
    'fainting': 'fainting_shock',
    'malaria': 'diseases',
    'cholera': 'diseases',
    'hepatitis': 'diseases',
    'tb': 'diseases',
    'diarrhea': 'diseases',
    'typhoid': 'diseases',
    'measles': 'diseases',
    'dengue': 'diseases',
    'diabetes': 'diseases',
    'asthma': 'diseases',
  };

  static final Map<String, Map<String, String>> _titles = {
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

  static String getCategoryId(String scenarioId) {
    for (final key in _categoryMap.keys) {
      if (scenarioId.contains(key)) return _categoryMap[key]!;
    }
    return 'unknown';
  }

  static String getTitle(String scenarioId, String lang) {
    return _titles[scenarioId]?[lang] ?? scenarioId.replaceAll('_', ' ');
  }
}
