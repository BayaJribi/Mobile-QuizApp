import 'package:shared_preferences/shared_preferences.dart';
import '../Models/settings.dart';

class SettingsService {
  static const _langKey = 'languageCode';
  static const _soundKey = 'soundEnabled';

  static Future<Settings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return Settings(
      languageCode: prefs.getString(_langKey) ?? 'en',
      enableSound: prefs.getBool(_soundKey) ?? true,
    );
  }

  static Future<void> saveSettings(Settings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, settings.languageCode);
    await prefs.setBool(_soundKey, settings.enableSound);
  }
}