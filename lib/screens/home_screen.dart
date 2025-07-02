import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart'; // New import for SharedPreferences
import 'package:flutter/services.dart'; // New import for SystemNavigator.pop()

import '../models/scenario.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import 'disclaimer_screen.dart'; // Import the DisclaimerScreenContent (your dialog content)

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<Scenario> _filteredScenarios = [];
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Key for SharedPreferences to store disclaimer acceptance status
  static const String _disclaimerAcceptedKey = 'disclaimerAccepted';

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_fadeController);

    _fadeController.forward();

    // Use addPostFrameCallback to show the dialog after the first frame is rendered
    // and after a 1-second delay.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 1), () {
        _showDisclaimerIfNeeded();
      });
    });
  }

  Future<void> _showDisclaimerIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final bool disclaimerAccepted = prefs.getBool(_disclaimerAcceptedKey) ?? false;

    if (!disclaimerAccepted) {
      // Ensure the dialog is shown only once and cannot be dismissed without action
      await showDialog<void>(
        context: context,
        barrierDismissible: false, // User must make a choice
        builder: (BuildContext dialogContext) { // Use dialogContext to avoid using context after async gap
          return DisclaimerScreenContent(
            onAccept: () async {
              await prefs.setBool(_disclaimerAcceptedKey, true);
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop(); // Dismiss the dialog
              }
            },
            onReject: () {
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop(); // Dismiss the dialog
              }
              SystemNavigator.pop(); // Exit the app
            },
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<TextSpan> _highlightMatch(
    String text,
    String query,
    BuildContext context,
  ) {
    if (query.isEmpty) return [TextSpan(text: text)];
    final brightness = Theme.of(context).brightness;
    final highlightColor = brightness == Brightness.dark
        ? Colors.orange.withAlpha(77)
        : const Color.fromARGB(255, 241, 241, 104);

    final lowercaseText = text.toLowerCase();
    final lowercaseQuery = query.toLowerCase();
    final matchIndex = lowercaseText.indexOf(lowercaseQuery);

    if (matchIndex == -1) return [TextSpan(text: text)];

    return [
      TextSpan(text: text.substring(0, matchIndex)),
      TextSpan(
        text: text.substring(matchIndex, matchIndex + query.length),
        style: TextStyle(
          backgroundColor: highlightColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(text: text.substring(matchIndex + query.length)),
    ];
  }

  // Updated categories list - 'icon' field removed as per request
  final List<Map<String, dynamic>> categories = [
    {
      'id': 'assessment',
      'en': 'Initial Assessment',
      'ar': 'التقييم الأولي',
      'urgency': 'high',
    },
    {
      'id': 'emergency_action',
      'en': 'Emergency Action Steps',
      'ar': 'خطوات الطوارئ',
      'urgency': 'high',
    },
    {
      'id': 'cpr',
      'en': 'CPR & Rescue Breathing',
      'ar': 'الإنعاش القلبي الرئوي والتنفس الإنقاذي',
      'urgency': 'high',
    },
    {
      'id': 'bleeding',
      'en': 'Bleeding & Wounds',
      'ar': 'النزيف والجروح',
      'urgency': 'high',
    },
    {
      'id': 'shock',
      'en': 'Shock',
      'ar': 'الصدمة',
      'urgency': 'medium',
    },
    {
      'id': 'burns',
      'en': 'Burns',
      'ar': 'الحروق',
      'urgency': 'medium',
    },
    {
      'id': 'choking',
      'en': 'Choking',
      'ar': 'الاختناق',
      'urgency': 'high',
    },
    {
      'id': 'fractures',
      'en': 'Fractures & Sprains',
      'ar': 'الكسور والالتواءات',
      'urgency': 'medium',
    },
    {
      'id': 'bites_stings',
      'en': 'Bites & Stings',
      'ar': 'اللدغات واللسعات',
      'urgency': 'medium',
    },
    {
      'id': 'illnesses',
      'en': 'Sudden Illnesses',
      'ar': 'الأمراض المفاجئة',
      'urgency': 'low',
    },
    {
      'id': 'environmental',
      'en': 'Environmental Injuries',
      'ar': 'إصابات بيئية',
      'urgency': 'medium',
    },
    {
      'id': 'other_first_aid',
      'en': 'Other First Aid Topics',
      'ar': 'مواضيع إسعافية أخرى',
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isArabic = languageProvider.isArabic;

    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Directionality(
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  isArabic ? 'أويتك' : 'Aweytak',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
                leading: IconButton(
                  onPressed: () => languageProvider.toggleLanguage(),
                  icon: const Icon(Icons.language),
                  tooltip: 'Toggle Language',
                ),
                actions: [
                  IconButton(
                    onPressed: () => themeProvider.toggleTheme(),
                    icon: Icon(
                      themeProvider.isDarkMode
                          ? Icons.light_mode
                          : Icons.dark_mode,
                    ),
                    tooltip: isArabic ? 'الوضع الليلي' : 'Toggle Theme',
                  ),
                  IconButton(
                    onPressed: () => GoRouter.of(context).push('/settings'),
                    icon: const Icon(Icons.settings),
                    tooltip: isArabic ? 'الإعدادات' : 'Settings',
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Align(
                      alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                      child: Text(
                        isArabic
                            ? 'ما هي حالة الطوارئ؟'
                            : 'What is the emergency?',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
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
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintStyle: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7)),
                      ),
                      style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                    ),
                    const SizedBox(height: 16),
                    if (_searchController.text.isEmpty)
                      _buildCategoryList(isArabic)
                    else if (_filteredScenarios.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          itemCount: _filteredScenarios.length,
                          itemBuilder: (context, index) {
                            final scenario = _filteredScenarios[index];
                            return ListTile(
                              leading: Icon(Icons.medical_services, color: Theme.of(context).iconTheme.color),
                              title: Text.rich(
                                TextSpan(
                                  children: _highlightMatch(
                                    isArabic
                                        ? scenario.titleAr
                                        : scenario.titleEn,
                                    _searchController.text,
                                    context,
                                  ),
                                ),
                              ),
                              subtitle: Text(
                                isArabic
                                    ? 'ضمن: ${_getCategoryTitle(scenario.categoryId, isArabic)}'
                                    : 'In: ${_getCategoryTitle(scenario.categoryId, isArabic)}',
                                style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
                              ),
                              onTap: () => GoRouter.of(
                                context,
                              ).push('/scenario/${scenario.id}'),
                            );
                          },
                        ),
                      )
                    else
                      Text(
                        isArabic ? 'لم يتم العثور على سيناريوهات مطابقة.' : 'No matching scenarios found.',
                        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // New method to build the compact category list with glowing underline and shaded background
  Widget _buildCategoryList(bool isArabic) {
    return Expanded(
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 7.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.7),
                  spreadRadius: 0,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              title: Align(
                alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                child: Text(
                  isArabic ? category['ar']! : category['en']!,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              onTap: () => GoRouter.of(context).push('/category/${category['id']}'),
              trailing: isArabic ? null : Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).iconTheme.color),
              leading: isArabic ? Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).iconTheme.color) : null,
            ),
          );
        },
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
