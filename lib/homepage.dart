import 'dart:async';
import 'package:flutter/material.dart';
import 'package:patti_geb/barriers.dart';
import 'package:patti_geb/myPlayer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double playerY = 0.0;
  double time = 0;
  double height = 0;
  double playerWidth = 0.2;
  double playerHeight = 0.2;
  double initialHeight = playerY;
  bool gameHasStarted = false;

  void flyUp() {
    setState(() {
      time = 0;
      initialHeight = playerY;
    });
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      time += 0.05;
      height = -4.9 * time * time + 2 * time;
      setState(() {
        playerY = initialHeight - height;
      });
      if (playerY > 1) {
        timer.cancel();
        gameHasStarted = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {
          flyUp();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    Container(
                      color: Colors.grey,
                      child: MyPlayer(playerY: playerY,
                          playerWidth: playerWidth, playerHeight: playerHeight),
                    ),
                    Container(
                      alignment: const Alignment(0, -0.3),
                      child: gameHasStarted
                          ? const Text("")
                          : const Text(
                              "TAP TO PLAY",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                    ),
                    AnimatedContainer(
                      alignment: const Alignment(0, 1.1),
                      duration: const Duration(milliseconds: 0),
                      child: MyBarrier(
                        size: 200.0,
                      ),
                    ),
                  ],
                )),
            Container(
              height: 15,
              color: Colors.black,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "0",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "SCORE",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "10",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "BEST",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height:50 ,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
