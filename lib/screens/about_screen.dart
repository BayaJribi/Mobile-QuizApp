import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('À propos')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "Application quiz Flutter.\nDonnées fournies par OpenTDB.",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
