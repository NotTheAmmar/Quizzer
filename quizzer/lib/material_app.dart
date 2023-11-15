import 'package:flutter/material.dart';
import 'package:quizzer/leaderboard_page.dart';
import 'package:quizzer/player_homepage.dart';
import 'package:quizzer/player_selection_page.dart';
import 'package:quizzer/quiz_page.dart';
import 'package:quizzer/splashscreen.dart';

class MaterialAPP extends StatelessWidget {
  const MaterialAPP({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quizzer',
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFED843),
          background: const Color(0xFF669EFF),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontSize: 40),
          bodyMedium: TextStyle(color: Colors.white, fontSize: 20),
          bodySmall: TextStyle(color: Colors.white, fontSize: 14),
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 50,
          ),
          titleMedium: TextStyle(color: Colors.white, fontSize: 25),
        ),
        useMaterial3: true,
      ),
      routes: {
        '/splashscreen': (context) => const SplashScreen(),
        '/playerSelectionPage': (context) => const PlayerSelectionPage(),
        '/playerHomepage': (context) => const PlayerHomepage(),
        '/quizPage': (context) => const QuizPage(),
        '/leaderboardPage': (context) => const LeaderboardPage()
      },
      initialRoute: '/splashscreen',
    );
  }
}
