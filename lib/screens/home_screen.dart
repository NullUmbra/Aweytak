import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, dynamic>> categories = const [
    {
      'id': 'cpr',
      'icon': '❤️',
      'ar': 'الإنعاش القلبي الرئوي',
      'en': 'CPR',
      'urgency': 'high',
    },
    {
      'id': 'bleeding',
      'icon': '🩸',
      'ar': 'النزيف',
      'en': 'Bleeding',
      'urgency': 'high',
    },
    {
      'id': 'burns',
      'icon': '🔥',
      'ar': 'الحروق',
      'en': 'Burns',
      'urgency': 'medium',
    },
    {
      'id': 'choking',
      'icon': '😮‍💨',
      'ar': 'الاختناق',
      'en': 'Choking',
      'urgency': 'medium',
    },
    {
      'id': 'fever_seizures',
      'icon': '🌡️',
      'ar': 'الحمى والتشنجات',
      'en': 'Fever & Seizures',
      'urgency': 'low',
    },
    {
      'id': 'bites_stings',
      'icon': '🐍',
      'ar': 'لسعات الحشرات والثعابين',
      'en': 'Bites & Stings',
      'urgency': 'medium',
    },
    {
      'id': 'fainting_shock',
      'icon': '😵',
      'ar': 'الإغماء والصدمة',
      'en': 'Fainting & Shock',
      'urgency': 'low',
    },
  ];

  Color urgencyColor(String urgency) {
    switch (urgency) {
      case 'high':
        return Colors.red[300]!;
      case 'medium':
        return Colors.orange[300]!;
      default:
        return Colors.green[300]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isArabic = languageProvider.isArabic;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isArabic ? 'أويتك' : 'Aweytak'),
          actions: [
            IconButton(
              onPressed: () => languageProvider.toggleLanguage(),
              icon: const Icon(Icons.language),
              tooltip: 'Toggle Language',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  isArabic ? 'ما هي حالة الطوارئ؟' : 'What is the emergency?',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  hintText: isArabic
                      ? 'ابحث عن حالة'
                      : 'Search for a condition',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: categories.map((category) {
                    return GestureDetector(
                      onTap: () {
                        final id = category['id'];
                        if (id != null) {
                          GoRouter.of(context).go('/category/$id');
                        } else {
                          debugPrint('Category ID missing!');
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: urgencyColor(category['urgency']),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              category['icon'],
                              style: const TextStyle(fontSize: 40),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              category[isArabic ? 'ar' : 'en'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
