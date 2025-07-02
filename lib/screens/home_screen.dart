import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
// No need for shared_preferences here anymore

import '../models/scenario.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';

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
              // The Scaffold will use the theme's background color for overall page design
              appBar: AppBar(
                // Removed explicit backgroundColor to revert to theme default
                title: Text(
                  isArabic ? 'أويتك' : 'Aweytak',
                  // Removed explicit color to revert to theme default for AppBar title
                  style: const TextStyle(
                    fontSize: 22, // Fancier: slightly larger font size
                    fontWeight: FontWeight.bold, // Fancier: bold font weight
                  ),
                ),
                centerTitle: true, // Center the title
                leading: IconButton( // Language toggle on the left
                  onPressed: () => languageProvider.toggleLanguage(),
                  icon: const Icon(Icons.language),
                  tooltip: 'Toggle Language',
                  // Removed explicit color to revert to theme default for AppBar icons
                ),
                actions: [ // Theme and Settings on the right
                  IconButton(
                    onPressed: () => themeProvider.toggleTheme(),
                    icon: Icon(
                      themeProvider.isDarkMode
                          ? Icons.light_mode
                          : Icons.dark_mode,
                    ),
                    tooltip: isArabic ? 'الوضع الليلي' : 'Toggle Theme',
                    // Removed explicit color to revert to theme default for AppBar icons
                  ),
                  IconButton(
                    onPressed: () => GoRouter.of(context).push('/settings'),
                    icon: const Icon(Icons.settings),
                    tooltip: isArabic ? 'الإعدادات' : 'Settings',
                    // Removed explicit color to revert to theme default for AppBar icons
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Align(
                      alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft, // Align based on language
                      child: Text(
                        isArabic
                            ? 'ما هي حالة الطوارئ؟'
                            : 'What is the emergency?',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color, // Dynamic color based on theme
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
                          color: Theme.of(context).iconTheme.color, // Icon color from theme
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        // Ensure hint text color also adapts
                        hintStyle: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7)),
                      ),
                      style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color), // Input text color from theme
                    ),
                    const SizedBox(height: 16),
                    if (_searchController.text.isEmpty)
                      _buildCategoryList(isArabic) // Call the new list builder
                    else if (_filteredScenarios.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          itemCount: _filteredScenarios.length,
                          itemBuilder: (context, index) {
                            final scenario = _filteredScenarios[index];
                            return ListTile(
                              leading: Icon(Icons.medical_services, color: Theme.of(context).iconTheme.color), // Icon color from theme
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
                                style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color), // Subtitle color from theme
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
                        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color), // Text color from theme
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
            margin: const EdgeInsets.symmetric(vertical: 7.0), // Increased vertical distance
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor, // Shaded background color from theme
              borderRadius: BorderRadius.circular(12.0), // Rounder corners
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.7), // Green glow color
                  spreadRadius: 0,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // Shadow at the bottom
                ),
              ],
            ),
            child: ListTile(
              dense: true, // Makes the ListTile more compact vertically
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0), // Adjust padding
              title: Align(
                alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft, // Align text based on language
                child: Text(
                  isArabic ? category['ar']! : category['en']!,
                  style: TextStyle(
                    fontSize: 15, // Font size 12 as requested
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color, // Inherit comfy color from theme
                  ),
                ),
              ),
              onTap: () => GoRouter.of(context).push('/category/${category['id']}'),
              // Trailing/Leading arrow icons for direction, using theme's icon color
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
