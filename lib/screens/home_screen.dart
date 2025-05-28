import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../Models/settings.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDark;
  final Settings settings;
  final ValueChanged<Settings> updateSettings;

  const HomeScreen({
    super.key,
    required this.toggleTheme,
    required this.isDark,
    required this.settings,
    required this.updateSettings,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: loc.settings,
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/settings',
                arguments: {
                  'settings': settings,
                  'updateSettings': updateSettings,
                  'isDark': isDark,
                  'toggleTheme': toggleTheme,
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/setup'),
              child: Text(loc.startQuiz),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/leaderboard'),
              child: Text(loc.leaderboard),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showAboutDialog(
                  context: context,
                  applicationName: loc.appTitle,
                  applicationVersion: '1.0',
                  children: [
                    Text(loc.about),
                  ],
                );
              },
              child: Text(loc.about),
            ),
          ],
        ),
      ),
    );
  }
}
