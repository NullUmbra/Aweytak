import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart'; // Import Hive
import '../providers/language_provider.dart';
import '../models/scenario.dart'; // Import your Scenario model

class CategoryDetailScreen extends StatelessWidget {
  final String categoryId;

  const CategoryDetailScreen({super.key, required this.categoryId});

  // This method will now fetch scenarios from Hive
  Future<List<Scenario>> _getScenariosFromHive(String categoryId) async {
    final box = await Hive.openBox<Scenario>('scenarios');
    // Filter scenarios by categoryId
    return box.values
        .where((scenario) => scenario.categoryId == categoryId)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Provider.of<LanguageProvider>(context).isArabic;

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'تفاصيل الطوارئ' : 'Emergency Details'),
      ),
      body: FutureBuilder<List<Scenario>>(
        future: _getScenariosFromHive(categoryId), // Call the async method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            ); // Show loading indicator
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            ); // Show error
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                isArabic
                    ? 'لا توجد حالات في هذه الفئة.'
                    : 'No scenarios found in this category.',
              ),
            ); // No data
          } else {
            final scenarios = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: scenarios.length,
              itemBuilder: (context, index) {
                final scenario = scenarios[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    title: Text(
                      isArabic ? scenario.titleAr : scenario.titleEn,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.green,
                    ),
                    onTap: () {
                      GoRouter.of(context).push('/scenario/${scenario.id}');
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
