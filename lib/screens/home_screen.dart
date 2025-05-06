import 'package:flutter/material.dart';
import 'quiz_setup_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accueil')),
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
              child: const Text("À propos"),
              onPressed: () => Navigator.pushNamed(context, '/about'),
            ),
          ],
        ),
      ),
    );
  }
}
