import 'package:flutter/material.dart';
import 'package:aweytak/services/dart_loader.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class ScenarioDetailScreen extends StatefulWidget {
  final String scenarioId;

  const ScenarioDetailScreen({super.key, required this.scenarioId});

  @override
  State<ScenarioDetailScreen> createState() => _ScenarioDetailScreenState();
}

class _ScenarioDetailScreenState extends State<ScenarioDetailScreen> {
  late Future<List<Map<String, dynamic>>> stepsFuture;
  List<bool> done = [];

  @override
  void initState() {
    super.initState();
    ('🧪 Loading scenario: ${widget.scenarioId}');
    stepsFuture = loadScenarioSteps(widget.scenarioId);
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
          done = List.generate(steps.length, (index) => false);

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: steps.length,
            itemBuilder: (context, index) {
              final step = steps[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: CheckboxListTile(
                  value: done[index],
                  onChanged: (val) {
                    setState(() {
                      done[index] = val!;
                    });
                  },
                  title: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          isArabic ? step['ar'] ?? '' : step['en'] ?? '',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
