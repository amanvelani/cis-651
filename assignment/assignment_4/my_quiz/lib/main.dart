import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(const MyQuiz());

// This class is the root of the application.
// It is a stateless widget because it doesn't need to maintain any state.
class MyQuiz extends StatelessWidget {
  const MyQuiz({super.key});

  @override
  Widget build(BuildContext context) {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS
        ? const CupertinoApp(
            title: 'My Quiz',
            theme: CupertinoThemeData(
              primaryColor: CupertinoColors.activeBlue,
              textTheme: CupertinoTextThemeData(
                navLargeTitleTextStyle: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
                textStyle: TextStyle(fontSize: 24.0),
              ),
            ),
            home: QuizPage(title: 'myQuiz'),
          )
        : MaterialApp(
            title: 'My Quiz',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              textTheme: const TextTheme(
                // ignore: deprecated_member_use
                headline1:
                    TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                // ignore: deprecated_member_use
                bodyText2: TextStyle(fontSize: 24.0),
              ),
            ),
            home: const QuizPage(title: 'myQuiz'),
          );
  }
}

// This class is the stateful widget that the main application instantiates.
// It maintains the state for the QuizPage.
class QuizPage extends StatefulWidget {
  const QuizPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _QuizPageState createState() => _QuizPageState();
}

// This class is the state for the QuizPage.
// It maintains the state for the QuizPage.
class _QuizPageState extends State<QuizPage> {
  int? numberOne;
  int? numberTwo;
  String expression = 'Expression';
  String solution = 'Solution';
  int totalRounds = 0;
  bool isFirstPlay = true;

  void _generateExpression() {
    setState(() {
      numberOne = Random().nextInt(101);
      numberTwo = Random().nextInt(101);
      expression = '$numberOne + $numberTwo';
      solution = 'Solution'; // Reset solution text
      totalRounds++;
      isFirstPlay = false;
    });
  }

  void _solveExpression() {
    if (numberOne != null && numberTwo != null) {
      setState(() {
        solution = '${numberOne! + numberTwo!}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text(widget.title),
            ),
            child: buildPageBody(context),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: buildPageBody(context),
          );
  }

// This method builds the body of the page.
// It is called from the build method.
  Widget buildPageBody(BuildContext context) {
    return Center(
      child: OrientationBuilder(builder: (context, orientation) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                expression,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                solution,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.green),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Total Rounds display
                if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    child: Text(
                      'Total Rounds: $totalRounds',
                      style: const TextStyle(
                          color: CupertinoColors.black, fontSize: 16),
                    ),
                  )
                else
                  // Material Design
                  Chip(
                    backgroundColor: Colors.blue.shade100,
                    avatar: CircleAvatar(
                      backgroundColor: Colors.blue.shade900,
                      child: Text(
                        '$totalRounds',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                    label: Text(
                      'Total Rounds',
                      style:
                          TextStyle(fontSize: 12, color: Colors.blue.shade900),
                    ),
                  ),
                const SizedBox(
                  width: 5,
                ),
                // Play/Play Again button
                if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS)
                  CupertinoButton.filled(
                    onPressed: _generateExpression,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Text(isFirstPlay ? 'Play' : 'Play Again',
                          style: const TextStyle(fontSize: 12)),
                    ),
                  )
                else
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10.0),
                    ),
                    onPressed: _generateExpression,
                    child: Text(
                      isFirstPlay ? 'Play' : 'Play Again',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            // Solve button
            if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS)
              CupertinoButton.filled(
                onPressed: _solveExpression,
                child: const Text('Solve'),
              )
            else
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: _solveExpression,
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  child: Text('Solve',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
          ],
        );
      }),
    );
  }
}
