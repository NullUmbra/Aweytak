import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'providers/language_provider.dart';
import 'screens/home_screen.dart';
import 'screens/category_detail_screen.dart';
import 'screens/scenario_detail_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    // ✅ Define router here so it gets updated if needed in future
    final _router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/category/:id',
          builder: (context, state) {
            final categoryId = state.pathParameters['id']!;
            return CategoryDetailScreen(categoryId: categoryId);
          },
        ),
        GoRoute(
          path: '/scenario/:id',
          builder: (context, state) {
            final scenarioId = state.pathParameters['id']!;
            return ScenarioDetailScreen(scenarioId: scenarioId);
          },
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: _router,
      title: 'Aweytak',
      theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Cairo'),
    );
  }
}
