import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => GameState();
}

int numberOfSquers = 760;
var randomNumber = Random();
int food = randomNumber.nextInt(700);

class GameState extends State<Game> {
  List<int> snakePosition = [45, 65, 85, 105, 125];

  void genrateFood() {
    food = randomNumber.nextInt(700);
  }

  bool gameOver() {
    for (int i = 0; i < snakePosition.length; i++) {
      int count = 0;
      for (int j = 0; j < snakePosition.length; j++) {
        if (snakePosition[i] == snakePosition[j]) {
          count++;
        }
        if (count == 2) {
          return true;
        }
      }
    }

    return false;
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text('Your Score is ' + snakePosition.length.toString()),
          actions: <Widget>[
            FlatButton(
              child: const Text('Restart'),
              onPressed: () {
                startgame();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  var dirction = 'down';

  void updateSnack() {
    setState(() {
      switch (dirction) {
        case 'down':
          if (snakePosition.last > 740) {
            snakePosition.add(snakePosition.last + 20 - 760);
          } else {
            snakePosition.add(snakePosition.last + 20);
          }
          break;
        case 'up':
          if (snakePosition.last < 20) {
            snakePosition.add(snakePosition.last - 20 + 760);
          } else {
            snakePosition.add(snakePosition.last - 20);
          }
          break;
        case 'left':
          if (snakePosition.last % 20 == 0) {
            snakePosition.add(snakePosition.last - 1 + 20);
          } else {
            snakePosition.add(snakePosition.last - 1);
          }
          break;
        case 'right':
          if ((snakePosition.last + 1) % 20 == 0) {
            snakePosition.add(snakePosition.last + 1 - 20);
          } else {
            snakePosition.add(snakePosition.last + 1);
          }
          break;

        default:
      }
      if (snakePosition.last == food) {
        genrateFood();
      } else {
        snakePosition.removeAt(0);
      }
    });
  }

  /*void updateSnack() {
    setState(() {
      if (dirction == 'down') {
        snakePosition.add(snakePosition.last + 740);
      } else if (dirction == 'up') {
        snakePosition.add(snakePosition.last - 20);
      } else if (dirction == 'right') {
        snakePosition.add(snakePosition.last + 1);
      } else if (dirction == 'left') {
        snakePosition.add(snakePosition.last - 1);
      }

      if (snakePosition.last == food) {
        genrateFood();
      } else {
        snakePosition.removeAt(0);
      }
    });
  }*/

  void startgame() {
    snakePosition = [45, 65, 85, 105, 125];
    const duration = Duration(milliseconds: 300);
    Timer.periodic(duration, (Timer timer) {
      updateSnack();
      if (gameOver()) {
        timer.cancel();
        showGameOverDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (dirction != 'up' && details.delta.dy > 0) {
                  dirction = 'down';
                } else if (dirction != 'down' && details.delta.dy < 0) {
                  dirction = 'up';
                }
              },
              onHorizontalDragUpdate: (details) {
                if (dirction != 'left' && details.delta.dx > 0) {
                  dirction = 'right';
                } else if (dirction != 'right' && details.delta.dx < 0) {
                  dirction = 'left';
                }
              },
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 20),
                itemCount: numberOfSquers,
                itemBuilder: (BuildContext context, int index) {
                  if (snakePosition.contains(index)) {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }
                  if (index == food) {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      padding: const EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          color: Colors.grey[600],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.all(2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  child: const Text('Start'),
                  onPressed: () {
                    startgame();
                  },
                ),
                const Text(
                  'Created by: ISLAM KARAM',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
