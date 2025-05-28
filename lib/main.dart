import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'services/theme_service.dart';
import 'services/locale_service.dart';

import 'screens/home_screen.dart';
import 'screens/quiz_setup_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/result_screen.dart';
import 'screens/leaderboard_screen.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatefulWidget {
  const QuizApp({super.key});

  @override
  State<QuizApp> createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  bool isDarkMode = false;
  bool loading = true;
  Locale? _currentLocale;

  @override
  void initState() {
    super.initState();
    _initializeSettings();
  }

  Future<void> _initializeSettings() async {
    final theme = await ThemeService.loadTheme();
    final locale = await LocaleService.loadLocale();
    setState(() {
      isDarkMode = theme;
      _currentLocale = locale;
      loading = false;
    });
  }

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
    ThemeService.saveTheme(isDarkMode);
  }

  void _changeLocale(Locale locale) {
    LocaleService.saveLocale(locale.languageCode);
    setState(() {
      _currentLocale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      locale: _currentLocale,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
        Locale('ar'),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },

      home: HomeScreen(
        toggleTheme: toggleTheme,
        isDark: isDarkMode,
        changeLocale: _changeLocale,
        currentLocale: _currentLocale,
      ),
      routes: {
        '/setup': (context) => const QuizSetupScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/result': (context) => const ResultScreen(score: 0, total: 0),
        '/leaderboard': (context) => const LeaderboardScreen(),
      },
    );
  }
}