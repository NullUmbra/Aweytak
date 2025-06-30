import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

import 'models/scenario.dart';
import 'providers/language_provider.dart';
import 'screens/home_screen.dart';
import 'screens/category_detail_screen.dart';
import 'screens/scenario_detail_screen.dart';
import 'services/import_scenarios.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(ScenarioAdapter());

  await Hive.openBox<Scenario>('scenarios');

  try {
    final stopwatch = Stopwatch()..start();
    await importScenariosToHive();
    print('✅ Scenarios imported in ${stopwatch.elapsed}');
  } catch (e) {
    print('❌ Error during import: $e');
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: const MyApp(),
    ),
  );

  print('🚀 App started successfully');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    final router = GoRouter(
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
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'Aweytak',
      theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Cairo'),
      locale: Locale(languageProvider.language.toLowerCase()),
      builder: (context, child) {
        return Directionality(
          textDirection: languageProvider.isArabic
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: child!,
        );
      },
    );
  }
}
