import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    final int finalScore = args?['score'] ?? score;
    final int finalTotal = args?['total'] ?? total;
    final double percent = finalScore / finalTotal * 100;

    String getMessage() {
      if (percent == 100) return "Parfait !";
      if (percent >= 80) return "Excellent 👏";
      if (percent >= 60) return "Bien joué 👍";
      if (percent >= 40) return "Pas mal 😅";
      return "Tu peux mieux faire...";
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Résultats')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ton score : $finalScore / $finalTotal',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                getMessage(),
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/setup');
                },
                child: const Text('Rejouer'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                },
                child: const Text("Retour à l'accueil"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
