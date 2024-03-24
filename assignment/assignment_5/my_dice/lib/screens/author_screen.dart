import 'dart:io';
import 'package:flutter/material.dart';

class AuthorScreen extends StatelessWidget {
  const AuthorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a custom text theme
    TextTheme customTextTheme = const TextTheme(
      displayLarge: TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
      bodyLarge: TextStyle(
          fontSize: 20, color: Colors.deepPurple, fontFamily: 'Roboto'),
      bodyMedium: TextStyle(fontSize: 18, fontFamily: 'Raleway'),
    );

    // Apply the custom theme
    ThemeData customTheme = ThemeData(
      primarySwatch: Colors.blue,
      textTheme: customTextTheme,
      brightness: Platform.isIOS ? Brightness.light : Brightness.dark,
      appBarTheme: AppBarTheme(
        backgroundColor: Platform.isIOS ? Colors.blue[300] : Colors.deepPurple,
        foregroundColor: Platform.isIOS ? Colors.white : Colors.white,
      ),
    );

    return Theme(
      data: customTheme, // Apply the custom theme to the Scaffold
      child: Scaffold(
        appBar: AppBar(
          title: const Text('About Author'),
          elevation: 4.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage('assets/aman_velani.jpg'),
              ),
              const SizedBox(height: 20),
              Text(
                'Aman Velani',
                style: customTheme.textTheme.displayLarge,
              ),
              Text(
                'Masters in Computer Science',
                style: customTheme.textTheme.bodyLarge,
              ),
              Text(
                'Syracuse University',
                style: customTheme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'I am a passionate and dedicated Computer Science graduate from Syracuse University. My academic and project experiences have equipped me with a solid foundation in software development, data analysis, and machine learning.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontFamily: 'Roboto'),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Contact: amanvelani@gmail.com',
                style: TextStyle(fontSize: 16, fontFamily: 'Raleway'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
