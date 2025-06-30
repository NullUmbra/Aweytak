import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isArabic = languageProvider.isArabic;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(isArabic ? 'الإعدادات' : 'Settings')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              value: languageProvider.isArabic,
              onChanged: (_) => languageProvider.toggleLanguage(),
              title: Text(isArabic ? 'اللغة: العربية' : 'Language: English'),
              secondary: const Icon(Icons.language),
            ),
            const Divider(),
            SwitchListTile(
              value: themeProvider.isDarkMode,
              onChanged: (_) => themeProvider.toggleTheme(),
              title: Text(isArabic ? 'الوضع الداكن' : 'Dark Mode'),
              secondary: const Icon(Icons.brightness_6),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(isArabic ? 'حول التطبيق' : 'About App'),
              subtitle: Text(
                isArabic
                    ? 'تطبيق للإسعافات الأولية يعمل بدون إنترنت'
                    : 'Offline-first first-aid app for emergencies',
              ),
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: Text(isArabic ? 'تواصل معنا' : 'Contact Us'),
              subtitle: Text('kei.softcraft@gmail.com'),
            ),
          ],
        ),
      ),
    );
  }
}
