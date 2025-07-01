import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  static const _languageKey = 'language';

  String _language = 'AR'; // default to Arabic

  String get language => _language;
  bool get isArabic => _language == 'AR';

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString(_languageKey);
    if (savedLang != null && savedLang.isNotEmpty) {
      _language = savedLang;
      notifyListeners();
    }
  }

  Future<void> _saveLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, lang);
  }

  void toggleLanguage() {
    _language = (_language == 'AR') ? 'EN' : 'AR';
    notifyListeners();
    _saveLanguage(_language);
  }

  // Optional: method to explicitly set language
  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
    _saveLanguage(lang);
  }
}
