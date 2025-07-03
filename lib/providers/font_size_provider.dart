import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontSizeProvider extends ChangeNotifier {
  static const String _textScaleFactorKey = 'textScaleFactor';
  double _textScaleFactor = 1.0; // Default text scale factor

  double get textScaleFactor => _textScaleFactor;

  FontSizeProvider() {
    _loadTextScaleFactor();
  }

  Future<void> _loadTextScaleFactor() async {
    final prefs = await SharedPreferences.getInstance();
    _textScaleFactor = prefs.getDouble(_textScaleFactorKey) ?? 1.0;
    notifyListeners();
  }

  Future<void> setTextScaleFactor(double newScaleFactor) async {
    if (_textScaleFactor != newScaleFactor) {
      _textScaleFactor = newScaleFactor;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_textScaleFactorKey, newScaleFactor);
      notifyListeners();
    }
  }
}
