import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_dice/model/dice_model.dart';

class DiceControlsWidget extends StatelessWidget {
  final DiceModel gameState;
  final Function() onPlayRound;
  final Function() onResetGame;
  final ValueChanged<double> onBetPercentageChanged;

  const DiceControlsWidget({
    super.key,
    required this.gameState,
    required this.onPlayRound,
    required this.onResetGame,
    required this.onBetPercentageChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Define a smaller TextStyle for buttons
    TextStyle smallButtonTextStyle = const TextStyle(
      fontSize: 18, // Smaller font size
    );

    // Define a smaller button padding for Material buttons
    EdgeInsets smallButtonPadding = const EdgeInsets.symmetric(
      vertical: 15.0,
      horizontal: 20.0,
    );

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Slider(
          value: gameState.betPercentage,
          min: 0,
          max: 100,
          divisions: 20,
          label: '${gameState.betPercentage.round()}%',
          onChanged: onBetPercentageChanged,
          activeColor: Colors.deepPurple,
          inactiveColor: Colors.deepPurple.withOpacity(0.3),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Bet Percentage: ${gameState.betPercentage.toStringAsFixed(0)}%',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Platform.isIOS
                ? CupertinoButton(
                    color: CupertinoColors.activeBlue,
                    padding: smallButtonPadding, // Applies only if feasible
                    onPressed: onPlayRound,
                    child: Text('Roll', style: smallButtonTextStyle),
                  )
                : ElevatedButton(
                    onPressed: onPlayRound,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      padding: smallButtonPadding,
                      textStyle: smallButtonTextStyle,
                    ),
                    child: const Text('Roll'),
                  ),
            Platform.isIOS
                ? CupertinoButton(
                    color: CupertinoColors.destructiveRed,
                    padding: smallButtonPadding, // Applies only if feasible
                    onPressed: onResetGame,
                    child: Text('Reset Game', style: smallButtonTextStyle),
                  )
                : ElevatedButton(
                    onPressed: onResetGame,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      padding: smallButtonPadding,
                      textStyle: smallButtonTextStyle,
                    ),
                    child: const Text('Reset Game'),
                  ),
          ],
        ),
      ],
    );
  }
}
