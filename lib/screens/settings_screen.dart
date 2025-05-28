import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../Models/settings.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  final Settings settings;
  final ValueChanged<Settings> onSettingsChanged;
  final bool isDark;
  final VoidCallback toggleTheme;

  const SettingsScreen({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
    required this.isDark,
    required this.toggleTheme,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Settings currentSettings;
  late bool isDark;

  @override
  void initState() {
    super.initState();
    currentSettings = widget.settings;
    isDark = widget.isDark;
  }

  void _updateSettings(Settings newSettings) {
    setState(() {
      currentSettings = newSettings;
    });
    SettingsService.saveSettings(newSettings);
    widget.onSettingsChanged(newSettings);
  }

  void _toggleTheme() {
    widget.toggleTheme();
    setState(() {
      isDark = !isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.settings),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🌍 Language
            Text(loc.language, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: currentSettings.languageCode,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'fr', child: Text('Français')),
                DropdownMenuItem(value: 'ar', child: Text('العربية')),
              ],
              onChanged: (value) {
                if (value != null) {
                  _updateSettings(currentSettings.copyWith(languageCode: value));
                }
              },
            ),
            const SizedBox(height: 24),

            // 🔊 Sound
            Text(loc.sound, style: Theme.of(context).textTheme.titleLarge),
            SwitchListTile(
              title: Text(loc.sound),
              value: currentSettings.enableSound,
              onChanged: (value) {
                _updateSettings(currentSettings.copyWith(enableSound: value));
              },
            ),

            const SizedBox(height: 24),

            // 🌙 Dark mode
            Text(loc.theme, style: Theme.of(context).textTheme.titleLarge),
            SwitchListTile(
              title: Text(isDark ? loc.darkMode : loc.lightMode),
              value: isDark,
              onChanged: (_) => _toggleTheme(),
            ),
          ],
        ),
      ),
    );
  }
}
