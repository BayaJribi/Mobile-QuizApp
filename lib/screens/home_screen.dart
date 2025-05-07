import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDark;

  const HomeScreen({super.key, required this.toggleTheme, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: isDark ? 'Passer au mode clair' : 'Passer au mode sombre',
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("Commencer un quiz"),
              onPressed: () => Navigator.pushNamed(context, '/setup'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text("Classement"),
              onPressed: () => Navigator.pushNamed(context, '/leaderboard'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text("À propos"),
              onPressed: () {
                showAboutDialog(
                  context: context,
                  applicationName: "Quiz App",
                  applicationVersion: "1.0",
                  children: [const Text("Application de quiz Flutter.")],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
