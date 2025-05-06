import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _fetchQuestions(
      category: args['category'],
      difficulty: args['difficulty'],
      amount: args['amount'],
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

  void checkAnswer(String answer) {
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
      } else {
        Navigator.pushNamed(context, '/result', arguments: {
          'score': score,
          'total': questions.length,
        });
      }
    });
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
            const SizedBox(height: 24),
            ...answers.map((ans) {
              final isCorrect = ans == correct;
              final isSelected = ans == selectedAnswer;

              Color? bgColor;
              if (answered) {
                if (isCorrect) {
                  bgColor = Colors.green;
                } else if (isSelected) {
                  bgColor = Colors.red;
                } else {
                  bgColor = Colors.grey[300];
                }
              }

              return Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bgColor ?? Colors.blue,
                    foregroundColor: Colors.white,
                  ).copyWith(
                    // Fix pour garder la couleur même quand on est disabled
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
                      if (states.contains(MaterialState.disabled)) {
                        return bgColor ?? Colors.blue;
                      }
                      return bgColor ?? Colors.blue;
                    }),
                  ),
                  onPressed: answered ? null : () => checkAnswer(ans),
                  child: Text(
                    unescape.convert(ans),
                    textAlign: TextAlign.center,
                  ),
                ),
              );

            }),
          ],
        ),
      ),
    );
  }
}
