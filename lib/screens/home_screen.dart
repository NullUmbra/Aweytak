import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';

import '../models/scenario.dart';
import '../providers/language_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Scenario> _filteredScenarios = [];

  List<TextSpan> _highlightMatch(String text, String query) {
    if (query.isEmpty) return [TextSpan(text: text)];
    final lowercaseText = text.toLowerCase();
    final lowercaseQuery = query.toLowerCase();

    final matchIndex = lowercaseText.indexOf(lowercaseQuery);
    if (matchIndex == -1) return [TextSpan(text: text)];

    return [
      TextSpan(text: text.substring(0, matchIndex)),
      TextSpan(
        text: text.substring(matchIndex, matchIndex + query.length),
        style: const TextStyle(
          backgroundColor: Color.fromARGB(255, 241, 241, 104),
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(text: text.substring(matchIndex + query.length)),
    ];
  }

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
    {
      'id': 'diseases',
      'icon': '🦠',
      'ar': 'الأمراض الشائعة',
      'en': 'Common Diseases',
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

  void _onSearchChanged(String query, bool isArabic) {
    final box = Hive.box<Scenario>('scenarios');
    final all = box.values.toList();

    setState(() {
      _filteredScenarios = all.where((s) {
        final title = isArabic ? s.titleAr : s.titleEn;
        return title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
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
                controller: _searchController,
                onChanged: (val) => _onSearchChanged(val, isArabic),
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
              if (_searchController.text.isEmpty)
                _buildCategoryGrid(isArabic)
              else if (_filteredScenarios.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredScenarios.length,
                    itemBuilder: (context, index) {
                      final scenario = _filteredScenarios[index];
                      return ListTile(
                        leading: const Icon(Icons.medical_services),
                        title: Text.rich(
                          TextSpan(
                            children: _highlightMatch(
                              isArabic ? scenario.titleAr : scenario.titleEn,
                              _searchController.text,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          isArabic
                              ? 'ضمن: ${_getCategoryTitle(scenario.categoryId, isArabic)}'
                              : 'In: ${_getCategoryTitle(scenario.categoryId, isArabic)}',
                        ),
                        onTap: () => GoRouter.of(
                          context,
                        ).push('/scenario/${scenario.id}'),
                      );
                    },
                  ),
                )
              else
                const Text("No matching scenarios found."),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(bool isArabic) {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.2,
        children: categories.map((category) {
          return GestureDetector(
            onTap: () {
              final id = category['id'];
              GoRouter.of(context).push('/category/$id');
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
                  Text(category['icon'], style: const TextStyle(fontSize: 40)),
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
    );
  }

  String _getCategoryTitle(String categoryId, bool isArabic) {
    final match = categories.firstWhere(
      (cat) => cat['id'] == categoryId,
      orElse: () => {},
    );
    return match[isArabic ? 'ar' : 'en'] ?? categoryId;
  }
}
