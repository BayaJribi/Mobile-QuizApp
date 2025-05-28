import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'services/theme_service.dart';
import 'services/settings_service.dart';
import 'Models/settings.dart';
import 'screens/home_screen.dart';
import 'screens/quiz_setup_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/result_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isDarkMode = await ThemeService.loadTheme();
  final settings = await SettingsService.loadSettings();

  runApp(QuizApp(isDarkMode: isDarkMode, settings: settings));
}

class QuizApp extends StatefulWidget {
  final bool isDarkMode;
  final Settings settings;

  const QuizApp({super.key, required this.isDarkMode, required this.settings});

  @override
  State<QuizApp> createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  late bool isDarkMode;
  late Settings settings;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
    settings = widget.settings;
  }

  void toggleTheme() {
    setState(() => isDarkMode = !isDarkMode);
    ThemeService.saveTheme(isDarkMode);
  }

  void updateSettings(Settings newSettings) {
    setState(() => settings = newSettings);
    SettingsService.saveSettings(newSettings);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
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
      debugShowCheckedModeBanner: false,
      locale: Locale(settings.languageCode),
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
        Locale('ar'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: HomeScreen(
        toggleTheme: toggleTheme,
        isDark: isDarkMode,
        settings: settings,
        updateSettings: updateSettings,
      ),
      onGenerateRoute: (settingsRoute) {
        if (settingsRoute.name == '/settings') {
          final args = settingsRoute.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => SettingsScreen(
              settings: args['settings'],
              onSettingsChanged: args['updateSettings'],
              isDark: args['isDark'],
              toggleTheme: args['toggleTheme'],
            ),
          );
        }
        return null;
      },
      routes: {
        '/setup': (context) => const QuizSetupScreen(),
        '/quiz': (context) => QuizScreen(settings: settings),
        '/result': (context) => const ResultScreen(score: 0, total: 0),
        '/leaderboard': (context) => const LeaderboardScreen(),
      },
    );
  }
}
