import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuizSetupScreen extends StatefulWidget {
  const QuizSetupScreen({super.key});

  @override
  State<QuizSetupScreen> createState() => _QuizSetupScreenState();
}

class _QuizSetupScreenState extends State<QuizSetupScreen> {
  List<Map<String, dynamic>> categories = [];
  final List<String> difficulties = ['easy', 'medium', 'hard'];
  final List<int> numberOptions = [5, 10, 15, 20];

  String? selectedCategoryId;
  String? selectedCategoryName;
  String? selectedDifficulty;
  int? selectedAmount;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final url = Uri.parse('https://opentdb.com/api_category.php');
    final response = await http.get(url);
    final data = json.decode(response.body);

    setState(() {
      categories = List<Map<String, dynamic>>.from(data['trivia_categories']);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.quizSettings)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: loc.category),
              items: categories
                  .map((cat) => DropdownMenuItem<String>(
                value: cat['id'].toString(),
                child: Text(cat['name']),
              ))
                  .toList(),
              onChanged: (val) {
                final selectedCat = categories.firstWhere((cat) => cat['id'].toString() == val);
                setState(() {
                  selectedCategoryId = val;
                  selectedCategoryName = selectedCat['name'];
                });
              },
              value: selectedCategoryId,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: loc.difficulty),
              items: difficulties
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (val) => setState(() => selectedDifficulty = val),
              value: selectedDifficulty,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(labelText: loc.numberOfQuestions),
              items: numberOptions
                  .map((n) => DropdownMenuItem(value: n, child: Text('$n')))
                  .toList(),
              onChanged: (val) => setState(() => selectedAmount = val),
              value: selectedAmount,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: (selectedCategoryId != null &&
                  selectedCategoryName != null &&
                  selectedDifficulty != null &&
                  selectedAmount != null)
                  ? () {
                Navigator.pushNamed(context, '/quiz', arguments: {
                  'category': selectedCategoryId,
                  'category_name': selectedCategoryName,
                  'difficulty': selectedDifficulty,
                  'amount': selectedAmount,
                });
              }
                  : null,
              child: Text(loc.startQuiz),
            ),
          ],
        ),
      ),
    );
  }
}
