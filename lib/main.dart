import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/quiz_setup_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/result_screen.dart';
import 'screens/about_screen.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/setup': (context) => const QuizSetupScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/result': (context) => const ResultScreen(score: 0, total: 0),
        '/about': (context) => const AboutScreen(),
        '/leaderboard': (context) => const LeaderboardScreen(),

      },
    );
  }
}
