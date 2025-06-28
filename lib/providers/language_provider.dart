import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  String _language = 'AR';

  String get language => _language;
  bool get isArabic => _language == 'AR';

  void toggleLanguage() {
    _language = (_language == 'AR') ? 'EN' : 'AR';
    notifyListeners();
  }
}
