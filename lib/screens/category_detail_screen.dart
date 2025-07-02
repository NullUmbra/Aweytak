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
                return Container( // Changed from Card to Container for custom styling
                  margin: const EdgeInsets.symmetric(vertical: 7.0), // Matched HomeScreen's vertical margin
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor, // Use theme's card color for shaded background
                    borderRadius: BorderRadius.circular(12.0), // Matched HomeScreen's rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.7), // Matched HomeScreen's green glow color
                        spreadRadius: 0, // Matched HomeScreen's spread radius
                        blurRadius: 5, // Matched HomeScreen's blur radius
                        offset: const Offset(0, 3), // Matched HomeScreen's shadow offset
                      ),
                    ],
                  ),
                  child: ListTile(
                    dense: true, // Makes the ListTile more compact vertically
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0), // Adjust padding
                    tileColor: Colors.transparent, // Ensure ListTile background is also transparent
                    title: Align(
                      alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft, // Align text based on language
                      child: Text(
                        isArabic ? scenario.titleAr : scenario.titleEn,
                        style: TextStyle(
                          fontSize: 15, // Matched HomeScreen's font size
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color, // Inherit comfy color from theme
                        ),
                      ),
                    ),
                    trailing: isArabic ? null : Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).iconTheme.color),
                    leading: isArabic ? Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).iconTheme.color) : null,
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
