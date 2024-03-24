import 'package:flutter/material.dart';
import 'package:my_dice/screens/author_screen.dart';
import 'package:my_dice/screens/dice_game_screen.dart';
import 'package:my_dice/screens/rules_screen.dart';

void main() => runApp(const MyApp());

// Define a class to hold your theme colors for better organization and maintainability
class AppColors {
  static const Color primary = Colors.blue;
  static const Color accent = Colors.green;
  static const Color textLight = Colors.black87;
  static const Color textDark = Colors.black54;
}

// Utilize a separate function or class for theme to keep main.dart clean and focused
ThemeData buildAppTheme() {
  return ThemeData(
    primaryColor: AppColors.primary,
    hintColor: AppColors.accent,
    fontFamily: 'Roboto', // This can stay as is.
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black), // was headline4
      headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black), // was headline5
      bodyLarge:
          TextStyle(fontSize: 16, color: AppColors.textLight), // was bodyText1
      bodyMedium:
          TextStyle(fontSize: 14, color: AppColors.textDark), // was bodyText2
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Dice Game App',
      debugShowCheckedModeBanner: false, // Remove debug banner for a cleaner UI
      theme: buildAppTheme(), // Apply the custom theme
      initialRoute: '/', // Define initial route
      routes: {
        '/': (context) =>
            const DiceGame(), // Follow naming conventions for clarity
        '/rules': (context) => const RulesScreen(),
        '/author': (context) => const AuthorScreen(),
      },
    );
  }
}
