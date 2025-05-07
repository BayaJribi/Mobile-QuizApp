// ... all your original imports
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:html_unescape/html_unescape.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final unescape = HtmlUnescape();
  List<Map<String, dynamic>> questions = [];
  Map<int, List<String>> shuffledAnswers = {};
  int currentIndex = 0;
  int score = 0;
  bool isLoading = true;
  bool answered = false;
  String? selectedAnswer;

  late Timer timer;
  int timeLeft = 10;

  late String category;
  late String categoryName; // ✅ added
  late String difficulty;
  late int amount;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    category = args['category'];
    categoryName = args['category_name'] ?? 'unknown'; // ✅ added
    difficulty = args['difficulty'];
    amount = args['amount'];
    _fetchQuestions(
      category: category,
      difficulty: difficulty,
      amount: amount,
    );
  }

  Future<void> _fetchQuestions({required String category, required String difficulty, required int amount}) async {
    final url = Uri.parse(
      'https://opentdb.com/api.php?amount=$amount&category=$category&difficulty=$difficulty&type=multiple',
    );
    try {
      final response = await http.get(url);
      final data = json.decode(response.body);
      final List results = data['results'];
      setState(() {
        questions = results.cast<Map<String, dynamic>>();
        for (int i = 0; i < questions.length; i++) {
          shuffledAnswers[i] = _getShuffledAnswers(questions[i]);
        }
        isLoading = false;
      });
      _startTimer();
    } catch (e) {
      debugPrint('Erreur chargement questions : $e');
    }
  }

  List<String> _getShuffledAnswers(Map question) {
    final List<String> answers = List<String>.from(question['incorrect_answers']);
    answers.add(question['correct_answer']);
    answers.shuffle(Random());
    return answers;
  }

  void _startTimer() {
    timeLeft = 10;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        timeLeft--;
        if (timeLeft <= 0) {
          timer.cancel();
          _autoNextQuestion();
        }
      });
    });
  }

  void _autoNextQuestion() {
    setState(() {
      answered = true;
      selectedAnswer = null;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (currentIndex < questions.length - 1) {
        setState(() {
          currentIndex++;
          answered = false;
          selectedAnswer = null;
        });
        _startTimer();
      } else {
        Navigator.pushNamed(context, '/result', arguments: {
          'score': score,
          'total': questions.length,
          'category_name': categoryName, // ✅ changed from category ID to name
          'difficulty': difficulty,
        });
      }
    });
  }

  void checkAnswer(String answer) {
    timer.cancel();
    setState(() {
      answered = true;
      selectedAnswer = answer;
      if (answer == questions[currentIndex]['correct_answer']) {
        score++;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (currentIndex < questions.length - 1) {
        setState(() {
          currentIndex++;
          answered = false;
          selectedAnswer = null;
        });
        _startTimer();
      } else {
        Navigator.pushNamed(context, '/result', arguments: {
          'score': score,
          'total': questions.length,
          'category_name': categoryName, // ✅ changed from category ID to name
          'difficulty': difficulty,
        });
      }
    });
  }

  @override
  void dispose() {
    if (timer.isActive) timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = questions[currentIndex];
    final answers = shuffledAnswers[currentIndex]!;
    final correct = question['correct_answer'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${currentIndex + 1}/${questions.length}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              unescape.convert(question['question']),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 12),
            Text(
              'Temps restant : $timeLeft s',
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
            const SizedBox(height: 20),
            ...answers.map((ans) {
              final isCorrect = ans == correct;
              final isSelected = ans == selectedAnswer;

              Color? bgColor;
              if (answered) {
                if (isCorrect) bgColor = Colors.green;
                else if (isSelected) bgColor = Colors.red;
                else bgColor = Colors.grey[300];
              }

              return Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bgColor ?? Colors.blue,
                    foregroundColor: (bgColor == Colors.grey[300]) ? Colors.black : Colors.white,
                  ).copyWith(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
                      if (states.contains(MaterialState.disabled)) {
                        return bgColor ?? Colors.blue;
                      }
                      return bgColor ?? Colors.blue;
                    }),
                    foregroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
                      if (bgColor == Colors.grey[300]) return Colors.black;
                      return Colors.white;
                    }),
                  ),
                  onPressed: answered ? null : () => checkAnswer(ans),
                  child: Text(unescape.convert(ans)),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
