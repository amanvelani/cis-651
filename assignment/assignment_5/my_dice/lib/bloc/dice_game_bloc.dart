import 'dart:async';
import 'dart:math';
import 'package:my_dice/model/dice_model.dart';
import 'package:rxdart/rxdart.dart';

class DiceGameBloc {
  final _gameState = BehaviorSubject<DiceModel>.seeded(DiceModel(
    userBalance: 100,
    computerBalance: 100,
    betPercentage: 50.0,
    userDiceValue: 1,
    computerDiceValue: 1,
    roundsCount: 0,
    isGameOver: false,
  ));

  Stream<DiceModel> get gameStateStream => _gameState.stream;

  void updateBetPercentage(double value) {
    final currentState = _gameState.value;
    _gameState.add(currentState.copyWith(betPercentage: value));
  }

  void playRound() {
    final currentState = _gameState.value;
    final int userDiceValue = 1 + Random().nextInt(6);
    final int computerDiceValue = 1 + Random().nextInt(6);
    int userBalance = currentState.userBalance;
    int computerBalance = currentState.computerBalance;
    final int betAmount =
        (userBalance * (currentState.betPercentage / 100)).round();

    if (userDiceValue > computerDiceValue) {
      userBalance += betAmount;
      computerBalance -= betAmount;
    } else if (userDiceValue < computerDiceValue) {
      userBalance -= betAmount;
      computerBalance += betAmount;
    }

    bool isGameOver = userBalance <= 0 || computerBalance <= 0;

    _gameState.add(currentState.copyWith(
      userBalance: userBalance,
      computerBalance: computerBalance,
      userDiceValue: userDiceValue,
      computerDiceValue: computerDiceValue,
      roundsCount: currentState.roundsCount + 1,
      isGameOver: isGameOver,
    ));
  }

  void resetGame() {
    _gameState.add(DiceModel(
      userBalance: 100,
      computerBalance: 100,
      betPercentage: 50.0,
      userDiceValue: 1,
      computerDiceValue: 1,
      roundsCount: 0,
      isGameOver: false,
    ));
  }

  void dispose() {
    _gameState.close();
  }
}
