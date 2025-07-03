import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/scenario.dart';
import 'providers/language_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/font_size_provider.dart'; // NEW: Import the font size provider
import 'screens/home_screen.dart';
import 'screens/category_detail_screen.dart';
import 'screens/scenario_detail_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';
// Note: disclaimer_screen.dart is now imported in home_screen.dart for the dialog
import 'services/scenario_importer.dart'; // Import your new service

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  // IMPORTANT: Register the adapter BEFORE opening the box or putting/getting data
  Hive.registerAdapter(ScenarioAdapter());

  await Hive.openBox<Scenario>('scenarios');

  // Initialize and run the scenario importer
  final scenarioImporter = ScenarioImporter();
  final prefs = await SharedPreferences.getInstance();

  // TEMPORARY: Force disclaimer to show for testing. REMOVE THIS LINE AFTER TESTING!
  //await prefs.setBool('disclaimerAccepted', false);

  // TEMPORARY: Force re-import by resetting the flag for one run
  // await prefs.setBool('hasInitialDataLoaded', false); // UNCOMMENT FOR ONE RUN, THEN REMOVE!

  await scenarioImporter
      .importInitialData(); // This will now handle the one-time import

  // The SharedPreferences instance for isDarkMode should be obtained AFTER
  // the scenarioImporter.importInitialData() if you uncommented the temporary line above,
  // to avoid conflicts with the temporary flag reset.
  // The 'prefs' variable is already declared above, no need to redeclare.
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider()..setTheme(isDarkMode),
        ),
        ChangeNotifierProvider(
            create: (_) => FontSizeProvider()), // NEW: Add FontSizeProvider
      ],
      child: const MyApp(),
    ),
  );
}

// --------------------
// Router declared outside widget to avoid rebuilds
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
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
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer3 to listen to Language, Theme, and NEW: FontSize providers
    return Consumer3<LanguageProvider, ThemeProvider, FontSizeProvider>(
      builder: (context, languageProvider, themeProvider, fontSizeProvider, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: _router,
          title: 'Aweytak',
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.green,
            fontFamily: 'Cairo',
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.green,
            fontFamily: 'Cairo',
            scaffoldBackgroundColor: const Color(0xFF121212),
            colorScheme: ColorScheme.dark(
              surface: const Color(0xFF121212),
              primary: Colors.green,
              secondary: Colors.orange,
            ),
            cardColor: const Color(0xFF1E1E1E),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white70),
              bodyMedium: TextStyle(color: Colors.white70),
            ),
            highlightColor: Colors.orange.withAlpha(77),
          ),
          themeMode:
              themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          locale: Locale(languageProvider.language.toLowerCase()),
          builder: (context, child) {
            // NEW: Apply text scaling globally using MediaQuery
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  textScaler:
                      TextScaler.linear(fontSizeProvider.textScaleFactor)),
              child: Directionality(
                textDirection: languageProvider.isArabic
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: child!,
              ),
            );
          },
        );
      },
    );
  }
}
