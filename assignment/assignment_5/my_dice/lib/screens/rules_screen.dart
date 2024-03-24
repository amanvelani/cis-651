import 'dart:io';
import 'package:flutter/material.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Theme data for customization
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Rules'),
        elevation: 4.0,
        backgroundColor:
            Platform.isIOS ? theme.colorScheme.secondary : theme.primaryColor,
        foregroundColor: Platform.isIOS
            ? theme.colorScheme.onSecondary
            : theme.colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Welcome to the Dice Game!',
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Gameplay Rules:',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...List<Widget>.from([
                '1. The left dice is for the player, and the right dice is for the computer.',
                '2. Each player starts with a balance of \$100.',
                '3. Decide on a percentage of your balance to bet each round.',
                '4. Press "Roll Dice" to play a round against the computer.',
                '5. The player with the higher dice value wins the round and claims the bet amount.',
                "6. If you or the computer balance's reaches \$0, the game is over."
              ].map((rule) => Text(rule, style: theme.textTheme.titleMedium))),
              const SizedBox(height: 20),
              Text(
                'Tips:',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...List<Widget>.from([
                '• Betting a smaller percentage can extend gameplay.',
                '• Try different strategies to see which works best for you.',
              ].map((tip) => Text(tip, style: theme.textTheme.titleMedium))),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back to Game'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
