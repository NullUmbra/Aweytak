import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class CategoryDetailScreen extends StatelessWidget {
  final String categoryId;

  const CategoryDetailScreen({super.key, required this.categoryId});

  List<Map<String, String>> getScenarios(String categoryId) {
    switch (categoryId) {
      case 'cpr':
        return [
          {
            'id': 'cpr_adult',
            'ar': 'الإسعاف القلبي الرئوي للكبار',
            'en': 'Adult CPR',
          },
          {
            'id': 'cpr_child',
            'ar': 'الإسعاف القلبي الرئوي للأطفال',
            'en': 'Child CPR',
          },
          {
            'id': 'cpr_infant',
            'ar': 'الإسعاف القلبي الرئوي للرضع',
            'en': 'Infant CPR',
          },
          {
            'id': 'cpr_choking',
            'ar': 'الإسعاف القلبي الرئوي عند الاختناق',
            'en': 'CPR for Choking',
          },
          {
            'id': 'cpr_unconscious',
            'ar': 'الإسعاف القلبي الرئوي للمصابين فاقدي الوعي',
            'en': 'CPR for Unconscious Victims',
          },
        ];

      case 'burns':
        return [
          {'id': 'burn_mild', 'ar': 'حرق بسيط', 'en': 'Mild Burn'},
          {'id': 'burn_severe', 'ar': 'حرق شديد', 'en': 'Severe Burn'},
        ];
      case 'bleeding':
        return [
          {'id': 'bleed_nose', 'ar': 'نزيف الأنف', 'en': 'Nosebleed'},
          {'id': 'bleed_deepcut', 'ar': 'جرح عميق', 'en': 'Deep Cut'},
          {'id': 'bleed_minor', 'ar': 'نزيف بسيط', 'en': 'Minor Bleeding'},
          {'id': 'bleed_severe', 'ar': 'نزيف شديد', 'en': 'Severe Bleeding'},
          {
            'id': 'bleed_internal',
            'ar': 'نزيف داخلي',
            'en': 'Internal Bleeding',
          },
        ];
      case 'diseases':
        return [
          {
            'id': 'diabetes_emergency',
            'ar': 'حالة طارئة لمرض السكري',
            'en': 'Diabetes Emergency',
          },
          {'id': 'asthma_attack', 'ar': 'نوبة ربو', 'en': 'Asthma Attack'},
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
