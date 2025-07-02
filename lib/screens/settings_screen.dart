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

    // Disclaimer text
    final String disclaimerEn = """
This application provides general first-aid information for use in emergency situations where immediate medical help may be far or unavailable, and every second might count. It is not a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of a qualified healthcare provider for any medical conditions or emergencies.

In a life-threatening emergency, call your local emergency services immediately.

The information contained herein is compiled from various public sources and is intended to be a quick reference. While efforts have been made to ensure accuracy, the developer is not responsible for any errors or omissions, or for the results obtained from the use of this information.
""";

    final String disclaimerAr = """
يوفر هذا التطبيق معلومات إسعافات أولية عامة للاستخدام في حالات الطوارئ حيث قد تكون المساعدة الطبية الفورية بعيدة أو غير متوفرة، وقد يكون كل ثانية مهمة. إنه ليس بديلاً عن المشورة الطبية المتخصصة أو التشخيص أو العلاج. اطلب دائماً نصيحة مقدم رعاية صحية مؤهل لأي حالات طبية أو طوارئ.

في حالة الطوارئ التي تهدد الحياة، اتصل بخدمات الطوارئ المحلية فوراً.

المعلومات الواردة هنا مجمعة من مصادر عامة مختلفة وتهدف إلى أن تكون مرجعاً سريعاً. بينما بذلت جهود لضمان الدقة، فإن المطور غير مسؤول عن أي أخطاء أو سهو، أو عن النتائج التي تم الحصول عليها من استخدام هذه المعلومات.
""";

    // License information
    final String licenseEn = """
This application's first-aid content is derived from Wikibooks (https://en.wikibooks.org/wiki/First_Aid), which is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License (CC BY-SA 4.0).

You can view a copy of this license at: https://creativecommons.org/licenses/by-sa/4.0/

As the developer, it is our intention that this application remains perpetually free to use and is never to be sold.
""";

    final String licenseAr = """
محتوى الإسعافات الأولية في هذا التطبيق مستمد من ويكيبوكس (https://ar.wikibooks.org/wiki/%D8%A7%D9%84%D8%A5%D8%B3%D8%B9%D8%A7%D9%81%D8%A7%D8%AA_%D8%A7%D9%84%D8%A3%D9%88%D9%84%D9%8A%D8%A9), وهو مرخص بموجب ترخيص المشاع الإبداعي نَسب المُصنَّف-المشاركة بالمثل 4.0 دولي (CC BY-SA 4.0).

يمكنك الاطلاع على نسخة من هذا الترخيص على الرابط التالي: https://creativecommons.org/licenses/by-sa/4.0/

بصفتنا المطورين، نعتزم أن يظل هذا التطبيق مجانياً للاستخدام بشكل دائم ولا يتم بيعه أبداً.
""";

    // Privacy Policy text
    final String privacyPolicyEn = """
Your privacy is important to us. This application does not collect any personal data or track your usage. All data, including scenario information, is stored locally on your device using Hive and is not transmitted to any external servers.

We do not use cookies or any other tracking technologies. We do not share any information with third parties.

By using this app, you agree to the terms of this Privacy Policy.
""";

    final String privacyPolicyAr = """
خصوصيتك مهمة بالنسبة لنا. لا يقوم هذا التطبيق بجمع أي بيانات شخصية أو تتبع استخدامك. يتم تخزين جميع البيانات، بما في ذلك معلومات السيناريو، محلياً على جهازك باستخدام Hive ولا يتم نقلها إلى أي خوادم خارجية.

نحن لا نستخدم ملفات تعريف الارتباط أو أي تقنيات تتبع أخرى. نحن لا نشارك أي معلومات مع أطراف ثالثة.

باستخدام هذا التطبيق، فإنك توافق على شروط سياسة الخصوصية هذه.
""";

    void _showInfoDialog(String title, String content) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: Text(content),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(isArabic ? 'إغلاق' : 'Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

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
              subtitle: const Text('kei.softcraft@gmail.com'),
            ),
            const Divider(), // Divider before new sections
            ListTile(
              leading: const Icon(Icons.gavel),
              title: Text(isArabic ? 'إخلاء المسؤولية' : 'Disclaimer'),
              onTap: () => _showInfoDialog(
                isArabic ? 'إخلاء المسؤولية' : 'Disclaimer',
                isArabic ? disclaimerAr : disclaimerEn,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: Text(isArabic ? 'معلومات الترخيص' : 'License Information'),
              onTap: () => _showInfoDialog(
                isArabic ? 'معلومات الترخيص' : 'License Information',
                isArabic ? licenseAr : licenseEn,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: Text(isArabic ? 'سياسة الخصوصية' : 'Privacy Policy'),
              onTap: () => _showInfoDialog(
                isArabic ? 'سياسة الخصوصية' : 'Privacy Policy',
                isArabic ? privacyPolicyAr : privacyPolicyEn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
