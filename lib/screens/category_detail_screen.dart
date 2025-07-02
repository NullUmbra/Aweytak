import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class CategoryDetailScreen extends StatelessWidget {
  final String categoryId;

  const CategoryDetailScreen({super.key, required this.categoryId});

  List<Map<String, String>> getScenarios(String categoryId) {
    switch (categoryId) {
      case 'assessment':
        return [
          {
            'id': 'scene_safety',
            'en': 'Check Scene Safety',
            'ar': 'تأكد من سلامة المكان',
          },
          {
            'id': 'check_responsiveness',
            'en': 'Check Responsiveness',
            'ar': 'تحقق من الاستجابة',
          },
          {
            'id': 'call_help',
            'en': 'Call for Help',
            'ar': 'اتصل للحصول على المساعدة',
          },
          {
            'id': 'abc_check',
            'en': 'Airway, Breathing, Circulation (ABC)',
            'ar': 'فتح مجرى الهواء والتنفس والدورة الدموية',
          },
          {
            'id': 'head_to_toe',
            'en': 'Head-to-Toe Examination',
            'ar': 'الفحص من الرأس للقدمين',
          },
        ];

      case 'emergency_action':
        return [
          {'id': 'check_victim', 'en': 'Check the Victim', 'ar': 'افحص المصاب'},
          {
            'id': 'call_ems',
            'en': 'Call Emergency Services',
            'ar': 'اتصل بخدمات الطوارئ',
          },
          {
            'id': 'care_until_help',
            'en': 'Care Until Help Arrives',
            'ar': 'قدم الرعاية حتى وصول المساعدة',
          },
          {
            'id': 'do_not_leave',
            'en': 'Do Not Leave Victim Alone',
            'ar': 'لا تترك المصاب وحده',
          },
          {
            'id': 'reassure',
            'en': 'Reassure and Calm the Victim',
            'ar': 'طمئن وهدئ المصاب',
          },
        ];

      case 'cpr':
        return [
          {
            'id': 'cpr_adult',
            'en': 'CPR for Adults',
            'ar': 'الإنعاش القلبي للبالغين',
          },
          {
            'id': 'cpr_child',
            'en': 'CPR for Children',
            'ar': 'الإنعاش القلبي للأطفال',
          },
          {
            'id': 'cpr_infant',
            'en': 'CPR for Infants',
            'ar': 'الإنعاش القلبي للرضع',
          },
          {
            'id': 'rescue_breathing_adult',
            'en': 'Rescue Breathing (Adult)',
            'ar': 'التنفس الإنقاذي (بالغ)',
          },
          {
            'id': 'rescue_breathing_child',
            'en': 'Rescue Breathing (Child/Infant)',
            'ar': 'التنفس الإنقاذي (طفل/رضيع)',
          },
          {
            'id': 'cpr_unconscious',
            'en': 'Unconscious with No Breathing',
            'ar': 'فاقد الوعي بدون تنفس',
          },
        ];

      case 'bleeding':
        return [
          {
            'id': 'external_bleeding',
            'en': 'External Bleeding',
            'ar': 'النزيف الخارجي',
          },
          {
            'id': 'internal_bleeding',
            'en': 'Internal Bleeding',
            'ar': 'النزيف الداخلي',
          },
          {'id': 'nosebleed', 'en': 'Nosebleed', 'ar': 'نزيف الأنف'},
          {'id': 'amputation', 'en': 'Amputation Wounds', 'ar': 'بتر الأطراف'},
          {
            'id': 'puncture_wound',
            'en': 'Puncture Wounds',
            'ar': 'الجروح النافذة',
          },
          {'id': 'crush_injury', 'en': 'Crush Injury', 'ar': 'إصابة السحق'},
        ];

      case 'shock':
        return [
          {
            'id': 'general_shock',
            'en': 'Recognizing Shock',
            'ar': 'التعرف على الصدمة',
          },
          {'id': 'treat_shock', 'en': 'Treating Shock', 'ar': 'علاج الصدمة'},
          {
            'id': 'anaphylactic_shock',
            'en': 'Anaphylactic Shock',
            'ar': 'الصدمة التحسسية',
          },
          {
            'id': 'psychological_shock',
            'en': 'Psychological Shock',
            'ar': 'الصدمة النفسية',
          },
        ];

      case 'burns':
        return [
          {
            'id': 'burn_first_degree',
            'en': 'First-Degree Burns',
            'ar': 'الحروق من الدرجة الأولى',
          },
          {
            'id': 'burn_second_degree',
            'en': 'Second-Degree Burns',
            'ar': 'الحروق من الدرجة الثانية',
          },
          {
            'id': 'burn_third_degree',
            'en': 'Third-Degree Burns',
            'ar': 'الحروق من الدرجة الثالثة',
          },
          {
            'id': 'burn_chemical',
            'en': 'Chemical Burns',
            'ar': 'الحروق الكيميائية',
          },
          {
            'id': 'burn_electrical',
            'en': 'Electrical Burns',
            'ar': 'الحروق الكهربائية',
          },
          {'id': 'burn_sun', 'en': 'Sunburn', 'ar': 'حروق الشمس'},
        ];

      case 'choking':
        return [
          {
            'id': 'choking_adult_conscious',
            'en': 'Conscious Adult Choking',
            'ar': 'اختناق بالغ واعٍ',
          },
          {
            'id': 'choking_adult_unconscious',
            'en': 'Unconscious Adult Choking',
            'ar': 'اختناق بالغ فاقد الوعي',
          },
          {
            'id': 'choking_child_conscious',
            'en': 'Conscious Child Choking',
            'ar': 'اختناق طفل واعٍ',
          },
          {
            'id': 'choking_child_unconscious',
            'en': 'Unconscious Child Choking',
            'ar': 'اختناق طفل فاقد الوعي',
          },
          {'id': 'choking_infant', 'en': 'Infant Choking', 'ar': 'اختناق رضيع'},
        ];

      case 'fractures':
        return [
          {'id': 'fracture_closed', 'en': 'Closed Fracture', 'ar': 'كسر مغلق'},
          {
            'id': 'fracture_open',
            'en': 'Open (Compound) Fracture',
            'ar': 'كسر مفتوح (مضاعف)',
          },
          {
            'id': 'sprain_strain',
            'en': 'Sprain or Strain',
            'ar': 'الالتواء أو الشد العضلي',
          },
          {'id': 'dislocation', 'en': 'Dislocation', 'ar': 'الخلع'},
          {
            'id': 'splinting',
            'en': 'Splinting a Limb',
            'ar': 'تجبير الطرف المصاب',
          },
        ];

      case 'bites_stings':
        return [
          {'id': 'bite_snake', 'en': 'Snake Bite', 'ar': 'لدغة ثعبان'},
          {'id': 'bite_dog', 'en': 'Dog Bite', 'ar': 'عضة كلب'},
          {'id': 'sting_insect', 'en': 'Insect Sting', 'ar': 'لسعة حشرة'},
          {'id': 'bite_spider', 'en': 'Spider Bite', 'ar': 'لدغة عنكبوت'},
          {
            'id': 'sting_jellyfish',
            'en': 'Jellyfish Sting',
            'ar': 'لسعة قنديل البحر',
          },
        ];

      case 'illnesses':
        return [
          {'id': 'illness_fainting', 'en': 'Fainting', 'ar': 'الإغماء'},
          {
            'id': 'illness_diabetic',
            'en': 'Diabetic Emergency',
            'ar': 'طوارئ السكري',
          },
          {'id': 'illness_seizure', 'en': 'Seizure', 'ar': 'نوبة تشنج'},
          {'id': 'illness_stroke', 'en': 'Stroke', 'ar': 'السكتة الدماغية'},
          {
            'id': 'illness_heart_attack',
            'en': 'Heart Attack',
            'ar': 'النوبة القلبية',
          },
        ];

      case 'environmental':
        return [
          {
            'id': 'env_heat_exhaustion',
            'en': 'Heat Exhaustion',
            'ar': 'الإرهاق الحراري',
          },
          {'id': 'env_heatstroke', 'en': 'Heatstroke', 'ar': 'ضربة الشمس'},
          {
            'id': 'env_hypothermia',
            'en': 'Hypothermia',
            'ar': 'انخفاض حرارة الجسم',
          },
          {'id': 'env_frostbite', 'en': 'Frostbite', 'ar': 'قضمة الصقيع'},
          {'id': 'env_lightning', 'en': 'Lightning Strike', 'ar': 'ضربة برق'},
        ];
      case 'other_first_aid':
        return [
          {
            'id': 'bls_cpr',
            'en': 'Basic Life Support & CPR',
            'ar': 'دعم الحياة الأساسي والإنعاش القلبي الرئوي',
          },
          {
            'id': 'aed_operation',
            'en': 'Automated External Defibrillation (AED) Operation',
            'ar': 'تشغيل جهاز إزالة الرجفان الخارجي الآلي (AED)',
          },
          {
            'id': 'severe_bleeding',
            'en': 'Severe Bleeding Control',
            'ar': 'السيطرة على النزيف الشديد',
          },
          {
            'id': 'burns_electrocution',
            'en': 'Burns & Electrocution',
            'ar': 'الحروق والصدمة الكهربائية',
          },
          {
            'id': 'head_spinal_eye_injuries',
            'en': 'Head, Spinal & Eye Injuries',
            'ar': 'إصابات الرأس والعمود الفقري والعين',
          },
          {
            'id': 'poisoning_non_bite',
            'en': 'General Poisoning (Ingestion, Inhalation, Absorption)',
            'ar': 'التسمم العام (الابتلاع، الاستنشاق، الامتصاص)',
          },
        ];

      default:
        return [
          {'id': 'default', 'ar': 'لا توجد حالات', 'en': 'No scenarios found'},
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Provider.of<LanguageProvider>(context).isArabic;
    final scenarios = getScenarios(categoryId);

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'تفاصيل الطوارئ' : 'Emergency Details'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: scenarios.length,
        itemBuilder: (context, index) {
          final scenario = scenarios[index];
          return Card(
            elevation: 2,
            child: ListTile(
              title: Text(isArabic ? scenario['ar']! : scenario['en']!),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                final id = scenario['id'];
                ('Navigating to scenario: $id');
                GoRouter.of(context).push('/scenario/${scenario['id']}');
              },
            ),
          );
        },
      ),
    );
  }
}
