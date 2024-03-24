class DiceModel {
  int userBalance;
  int computerBalance;
  double betPercentage;
  int userDiceValue;
  int computerDiceValue;
  int roundsCount;
  bool isGameOver;

  DiceModel({
    required this.userBalance,
    required this.computerBalance,
    required this.betPercentage,
    required this.userDiceValue,
    required this.computerDiceValue,
    required this.roundsCount,
    required this.isGameOver,
  });
  DiceModel copyWith({
    int? userBalance,
    int? computerBalance,
    double? betPercentage,
    int? userDiceValue,
    int? computerDiceValue,
    int? roundsCount,
    bool? isGameOver,
  }) {
    return DiceModel(
      userBalance: userBalance ?? this.userBalance,
      computerBalance: computerBalance ?? this.computerBalance,
      betPercentage: betPercentage ?? this.betPercentage,
      userDiceValue: userDiceValue ?? this.userDiceValue,
      computerDiceValue: computerDiceValue ?? this.computerDiceValue,
      roundsCount: roundsCount ?? this.roundsCount,
      isGameOver: isGameOver ?? this.isGameOver,
    );
  }
}
