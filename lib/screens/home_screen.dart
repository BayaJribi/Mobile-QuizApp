import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDark;
  final Function(Locale) changeLocale;
  final Locale? currentLocale;

  const HomeScreen({
    super.key,
    required this.toggleTheme,
    required this.isDark,
    required this.changeLocale,
    required this.currentLocale,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<Locale>(
              value: currentLocale ?? const Locale('en'),
              icon: const Icon(Icons.language),
              onChanged: (Locale? locale) {
                if (locale != null) changeLocale(locale);
              },
              items: const [
                DropdownMenuItem(
                  value: Locale('en'),
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: Locale('fr'),
                  child: Text('Français'),
                ),
                DropdownMenuItem(
                  value: Locale('ar'),
                  child: Text('العربية'),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: isDark
                ? AppLocalizations.of(context)!.lightMode
                : AppLocalizations.of(context)!.darkMode,
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text(AppLocalizations.of(context)!.startQuiz),// tarjem ellougha
              onPressed: () => Navigator.pushNamed(context, '/setup'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: Text(AppLocalizations.of(context)!.leaderboard),
              onPressed: () => Navigator.pushNamed(context, '/leaderboard'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: Text(AppLocalizations.of(context)!.about),
              onPressed: () {
                showAboutDialog(
                  context: context,
                  applicationName: "Quiz App",
                  applicationVersion: "1.0",
                  children: [
                    Text(AppLocalizations.of(context)!.about),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
