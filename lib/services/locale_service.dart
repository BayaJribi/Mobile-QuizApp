import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService {
  static const String _localeKey = 'locale';

  static Future<Locale?> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_localeKey);
    if (code != null) {
      return Locale(code);
    }
    return null;
  }

  static Future<void> saveLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, languageCode);
  }
}
