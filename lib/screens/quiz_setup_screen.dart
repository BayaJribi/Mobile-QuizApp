import 'package:flutter/material.dart';
import '../services/api_service.dart';

class QuizSetupScreen extends StatefulWidget {
  const QuizSetupScreen({super.key});

  @override
  State<QuizSetupScreen> createState() => _QuizSetupScreenState();
}

class _QuizSetupScreenState extends State<QuizSetupScreen> {
  List<Map<String, dynamic>> _categories = [];
  String? _selectedCategory;
  String _selectedDifficulty = 'easy';
  int _selectedAmount = 5;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await ApiService.fetchCategories();
      setState(() {
        _categories = categories;
        if (_categories.isNotEmpty) {
          _selectedCategory = _categories.first['id'].toString();
        }
      });
    } catch (e) {
      debugPrint('Erreur lors du chargement des catégories: \$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuration du Quiz')),
      body: _categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Catégorie :'),
            DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category['id'].toString(),
                  child: Text(category['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text('Difficulté :'),
            DropdownButton<String>(
              value: _selectedDifficulty,
              isExpanded: true,
              items: ['easy', 'medium', 'hard'].map((level) {
                return DropdownMenuItem(
                  value: level,
                  child: Text(level),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDifficulty = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text('Nombre de questions :'),
            DropdownButton<int>(
              value: _selectedAmount,
              isExpanded: true,
              items: [5, 10, 15, 20].map((number) {
                return DropdownMenuItem(
                  value: number,
                  child: Text('$number'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedAmount = value!;
                });
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (_selectedCategory != null) {
                  Navigator.pushNamed(
                    context,
                    '/quiz',
                    arguments: {
                      'category': _selectedCategory,
                      'difficulty': _selectedDifficulty,
                      'amount': _selectedAmount,
                    },
                  );
                }
              },
              child: const Text('Démarrer le quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
