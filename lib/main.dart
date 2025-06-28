import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/category_detail_screen.dart';
import 'screens/scenario_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

// ✅ 1. Define your router
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router, // ✅ connect router
      title: 'Aweytak',
      theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Cairo'),
    );
  }
}
