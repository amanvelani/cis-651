import 'package:flutter/material.dart';
import 'package:my_dice/model/dice_model.dart';

class DiceDisplayWidget extends StatelessWidget {
  final DiceModel diceModel;

  // Removed the {required int diceValue} parameter
  const DiceDisplayWidget(this.diceModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset('assets/images/dice${diceModel.userDiceValue}.png',
              width: 50, height: 50),
          Image.asset('assets/images/dice${diceModel.computerDiceValue}.png',
              width: 50, height: 50),
        ],
      ),
    );
  }
}
