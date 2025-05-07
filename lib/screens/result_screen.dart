import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final int total;

  const ResultScreen({super.key, required this.score, required this.total});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool saved = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!saved) {
      final args = ModalRoute.of(context)!.settings.arguments as Map?;
      final int finalScore = args?['score'] ?? widget.score;
      final int finalTotal = args?['total'] ?? widget.total;
      final String categoryName = args?['category_name'] ?? 'unknown';
      final String difficulty = args?['difficulty'] ?? 'unknown';

      LocalStorageService.saveScore(
        category: categoryName, // ✅ send category name not ID
        difficulty: difficulty,
        score: finalScore,
        total: finalTotal,
      );

      saved = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    final int finalScore = args?['score'] ?? widget.score;
    final int finalTotal = args?['total'] ?? widget.total;
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
