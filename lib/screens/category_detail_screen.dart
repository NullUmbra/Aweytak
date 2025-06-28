import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoryDetailScreen extends StatelessWidget {
  final String categoryId;

  const CategoryDetailScreen({super.key, required this.categoryId});

  // 🔍 Simulated data (can be replaced with JSON or API)
  List<Map<String, String>> getScenarios(String categoryId) {
    switch (categoryId) {
      case 'burns':
        return [
          {'id': 'burn_mild', 'ar': 'حرق بسيط', 'en': 'Mild Burn'},
          {'id': 'burn_severe', 'ar': 'حرق شديد', 'en': 'Severe Burn'},
        ];
      case 'bleeding':
        return [
          {'id': 'bleed_nose', 'ar': 'نزيف الأنف', 'en': 'Nosebleed'},
          {'id': 'bleed_deepcut', 'ar': 'جرح عميق', 'en': 'Deep Cut'},
        ];
      default:
        return [
          {'id': 'default', 'ar': 'لا توجد حالات', 'en': 'No scenarios found'},
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
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
                GoRouter.of(context).go('/scenario/${scenario['id']}');
              },
            ),
          );
        },
      ),
    );
  }
}
