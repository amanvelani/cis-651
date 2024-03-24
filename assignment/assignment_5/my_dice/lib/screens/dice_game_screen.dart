import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_dice/bloc/dice_game_bloc.dart';
import 'package:my_dice/model/dice_model.dart';
import 'package:my_dice/widgets/dice_display_widget.dart';
import 'package:my_dice/widgets/dice_controls_widget.dart';

class DiceGame extends StatefulWidget {
  const DiceGame({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DiceGameState createState() => _DiceGameState();
}

class _DiceGameState extends State<DiceGame> {
  late DiceGameBloc _diceGameBloc;

  @override
  void initState() {
    super.initState();
    _diceGameBloc = DiceGameBloc();
  }

  @override
  void dispose() {
    _diceGameBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dice Game'),
        elevation: 4.0,
        backgroundColor: Platform.isIOS ? Colors.grey[300] : Colors.deepPurple,
        foregroundColor: Platform.isIOS ? Colors.black : Colors.white,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<DiceModel>(
          stream: _diceGameBloc.gameStateStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final gameState = snapshot.data!;
            if (gameState.isGameOver) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // Check if the platform is iOS
                    if (Platform.isIOS) {
                      // Use CupertinoAlertDialog for iOS
                      return CupertinoAlertDialog(
                        title: const Text('Game Over'),
                        content: Text(gameState.userBalance <= 0
                            ? 'You lost!'
                            : 'You won!'),
                        actions: <CupertinoDialogAction>[
                          CupertinoDialogAction(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              _diceGameBloc.resetGame();
                            },
                          ),
                        ],
                      );
                    } else {
                      return AlertDialog(
                        title: const Text('Game Over'),
                        content: Text(gameState.userBalance <= 0
                            ? 'You lost!'
                            : 'You won!'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              _diceGameBloc.resetGame();
                            },
                          ),
                        ],
                      );
                    }
                  },
                );
              });
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                Text(
                  'User Balance: \$${gameState.userBalance}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Computer Balance: \$${gameState.computerBalance}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                DiceDisplayWidget(gameState),
                const SizedBox(height: 20),
                DiceControlsWidget(
                  gameState: gameState,
                  onPlayRound: _diceGameBloc.playRound,
                  onResetGame: _diceGameBloc.resetGame,
                  onBetPercentageChanged: _diceGameBloc.updateBetPercentage,
                ),
                const SizedBox(height: 20),
                Text(
                  'Rounds Played: ${gameState.roundsCount}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Platform.isIOS
                    ? CupertinoButton(
                        color: CupertinoColors.activeBlue,
                        onPressed: () {
                          Navigator.pushNamed(context, '/rules');
                        },
                        child: const Text('Rules'),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/rules');
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text('Rules'),
                      ),
                const SizedBox(height: 10),
                Platform.isIOS
                    ? CupertinoButton(
                        color: CupertinoColors.activeBlue,
                        onPressed: () {
                          Navigator.pushNamed(context, '/author');
                        },
                        child: const Text('Author'),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/author');
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text('Author'),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}
