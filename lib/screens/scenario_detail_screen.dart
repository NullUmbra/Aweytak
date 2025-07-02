import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

import '../providers/language_provider.dart';
import '../models/scenario.dart';
// import '../services/dart_loader.dart'; // This import is no longer needed as data is from Hive

class ScenarioDetailScreen extends StatefulWidget {
  final String scenarioId;

  const ScenarioDetailScreen({super.key, required this.scenarioId});

  @override
  State<ScenarioDetailScreen> createState() => _ScenarioDetailScreenState();
}

class _ScenarioDetailScreenState extends State<ScenarioDetailScreen> {
  Scenario? scenario;

  // This list of categories is used for displaying emoji, not for data loading
  final List<Map<String, dynamic>> categories = const [
    {'id': 'assessment', 'icon': '🔍'},
    {'id': 'emergency_action', 'icon': '🚨'},
    {'id': 'cpr', 'icon': '❤️'},
    {'id': 'bleeding', 'icon': '🩸'},
    {'id': 'shock', 'icon': '⚡'},
    {'id': 'burns', 'icon': '🔥'},
    {'id': 'choking', 'icon': '😮‍💨'},
    {'id': 'fractures', 'icon': '🦴'},
    {'id': 'bites_stings', 'icon': '🐍'},
    {'id': 'illnesses', 'icon': '🤒'},
    {'id': 'environmental', 'icon': '🌍'},
    {'id': 'other_first_aid', 'icon': '➕'},
  ];

  String _getCategoryEmoji(String categoryId) {
    final match = categories.firstWhere(
      (cat) => cat['id'] == categoryId,
      orElse: () => {'icon': '❓'}, // Default emoji if not found
    );
    return match['icon'] ?? '❓';
  }

  @override
  void initState() {
    super.initState();
    // Directly get the scenario from Hive in initState
    final box = Hive.box<Scenario>('scenarios');
    scenario = box.get(widget.scenarioId);
  }

  String _stepLabel(int stepNumber, bool isArabic) {
    return isArabic ? 'الخطوة $stepNumber' : 'Step $stepNumber';
  }

  // Helper to get note icon and color based on type
  Map<String, dynamic> _getNoteStyle(String type) {
    switch (type) {
      case 'warning':
        return {'icon': Icons.warning_amber_rounded, 'color': Colors.orange};
      case 'info':
        return {'icon': Icons.info_outline_rounded, 'color': Colors.blue};
      case 'best_practice':
        return {'icon': Icons.check_circle_outline_rounded, 'color': Colors.green};
      case 'do_not':
        return {'icon': Icons.block_rounded, 'color': Colors.red};
      default:
        return {'icon': Icons.lightbulb_outline_rounded, 'color': Colors.grey};
    }
  }

  // Function to launch URL
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      // Fallback for older Flutter versions or if launchUrl fails
      throw Exception('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Provider.of<LanguageProvider>(context).isArabic;

    if (scenario == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(isArabic ? 'الخطوات الإسعافية' : 'First-Aid Steps'),
        ),
        body: Center(
          child: Text(isArabic ? 'لم يتم العثور على السيناريو.' : 'Scenario not found.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'الخطوات الإسعافية' : 'First-Aid Steps'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Scenario Title and Category
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Changed to center
              children: [
                Text(
                  // Removed emoji icon
                  isArabic ? scenario!.titleAr : scenario!.titleEn,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                ),
                const Divider(thickness: 1.5),
              ],
            ),
          ),

          // Notes Section (Moved above Steps)
          if (scenario!.notes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 10), // Adjusted top padding
              child: Text(
                isArabic ? 'ملاحظات:' : 'Notes:',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
              ),
            ),
          ...scenario!.notes.map((note) {
            final noteStyle = _getNoteStyle(note['type'] ?? '');
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              color: noteStyle['color'].withOpacity(0.1), // Subtle background color
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      noteStyle['icon'],
                      color: noteStyle['color'],
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isArabic ? note['ar'] ?? '' : note['en'] ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 10), // Add some spacing between notes and steps

          // Steps Section Heading
          Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 10), // Adjusted top padding
            child: Text(
              isArabic ? 'الخطوات:' : 'Steps:',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
            ),
          ),
          // Steps
          ...scenario!.steps.asMap().entries.map((entry) {
            final stepNumber = entry.key + 1;
            final step = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _stepLabel(stepNumber, isArabic),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isArabic ? step['ar'] ?? '' : step['en'] ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),

          // Source URL
          if (scenario!.sourceUrl != null && scenario!.sourceUrl!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? 'المصدر:' : 'Source:',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _launchUrl(scenario!.sourceUrl!),
                    child: Text(
                      isArabic ? 'افتح في المتصفح' : 'Open in Browser', // Changed text here
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
