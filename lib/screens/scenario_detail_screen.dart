import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';

import '../providers/language_provider.dart';
import '../models/scenario.dart';
import '../services/dart_loader.dart';

class ScenarioDetailScreen extends StatefulWidget {
  final String scenarioId;

  const ScenarioDetailScreen({super.key, required this.scenarioId});

  @override
  State<ScenarioDetailScreen> createState() => _ScenarioDetailScreenState();
}

class _ScenarioDetailScreenState extends State<ScenarioDetailScreen> {
  late Future<List<Map<String, dynamic>>> stepsFuture;
  Scenario? scenario;

  final List<Map<String, dynamic>> categories = const [
    {'id': 'cpr', 'icon': '❤️'},
    {'id': 'bleeding', 'icon': '🩸'},
    {'id': 'burns', 'icon': '🔥'},
    {'id': 'choking', 'icon': '😮‍💨'},
    {'id': 'fever_seizures', 'icon': '🌡️'},
    {'id': 'bites_stings', 'icon': '🐍'},
    {'id': 'fainting_shock', 'icon': '😵'},
    {'id': 'diseases', 'icon': '🦠'},
  ];

  String _getCategoryEmoji(String categoryId) {
    final match = categories.firstWhere(
      (cat) => cat['id'] == categoryId,
      orElse: () => {},
    );
    return match['icon'] ?? '';
  }

  @override
  void initState() {
    super.initState();
    stepsFuture = loadScenarioSteps(widget.scenarioId);
    final box = Hive.box<Scenario>('scenarios');
    scenario = box.get(widget.scenarioId);
  }

  String _stepLabel(int stepNumber, bool isArabic) {
    return isArabic ? 'الخطوة $stepNumber' : 'Step $stepNumber';
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Provider.of<LanguageProvider>(context).isArabic;

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'الخطوات الإسعافية' : 'First-Aid Steps'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: stepsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                isArabic ? 'فشل في تحميل الخطوات' : 'Failed to load steps',
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(isArabic ? 'لا توجد خطوات' : 'No steps found'),
            );
          }

          final steps = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: steps.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_getCategoryEmoji(scenario?.categoryId ?? '')} '
                        '${isArabic ? scenario?.titleAr ?? '...' : scenario?.titleEn ?? '...'}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(thickness: 1.5),
                    ],
                  ),
                );
              }

              final step = steps[index - 1];
              final stepNumber = index;

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
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
