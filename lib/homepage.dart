import 'dart:async';
import 'package:flutter/material.dart';
import 'package:patti_geb/barriers.dart';
import 'package:patti_geb/player.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double playerY = 0;
  double initialPos = playerY;
  double height = 0;
  double time = 0;
  double gravity = -0.01; //how strong the gravity
  double velocity = 10; // how strong the flying
  double playerWidth = 0.2;
  double playerHeight = 0.2;

  //game settings
  bool gameHasStarted = false;

  //barrier variables
  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWith = 0.5;
  List<List<double>> barrierHeight = [
    //between 0-2 height of screen & [topHeight,bottomHeight]
    [0.6, 0.4],
    [0.4, 0.6],
  ];

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      height = gravity * time * time + velocity * time;

      setState(() {
        playerY = initialPos - height;
      });

      // check if player is dead
      if (playerIsDead()) {
        timer.cancel();
        gameHasStarted = false;
        _showDialog();
      }

      // Decrease velocity gradually
      velocity -= 0.2;

      // Time counter
      time += 0.05;
    });
  }


  void resetGame() {
    Navigator.pop(context);
    setState(() {
      playerY = 0;
      gameHasStarted = false;
      time = 0;
      initialPos = playerY;
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: const Center(
              child: Text(
                "GAME OVER",
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(17),
                      color: Colors.white,
                      child: const Text(
                        "PLAY AGAIN",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  void flyUp() {
    setState(() {
      time = 0;
      initialPos = playerY;
     // velocity = 5;
    });
  }

  bool playerIsDead() {
    //check if player is dead ( hitting top or bottom)
    if (playerY < -1 || playerY > 1) {
      return true;
    }

    //check if player hits the barrier
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= playerWidth &&
          barrierX[i] + barrierWith >= -playerWidth &&
          (playerY <= -1 + barrierHeight[i][0] ||
              playerY + playerHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted ? flyUp : startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                flex: 3,
                child: Container(
                  color: Colors.blueAccent,
                  child: Stack(
                    children: [
                      MyPlayer(
                        playerY: playerY,
                        playerWidth: playerWidth,
                        playerHeight: playerHeight,
                      ),
                      Container(
                        alignment: const Alignment(0, -0.3),
                        child: Text(
                          gameHasStarted ? "" : "TAP TO PLAY",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      ),
                      MyBarrier(
                        barrierX: barrierX[0],
                        barrierWidth: barrierWith,
                        barrierHeight: barrierHeight[0][0],
                        isThisBottomBarrier: false,
                      ),
                      MyBarrier(
                        barrierX: barrierX[0],
                        barrierWidth: barrierWith,
                        barrierHeight: barrierHeight[0][1],
                        isThisBottomBarrier: false,
                      ),
                    ],
                  ),
                )),
            Expanded(
                child: Container(
              color: Colors.grey,
            )),
          ],
        ),
      ),
    );
  }
}
