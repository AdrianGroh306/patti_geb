import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:patti_geb/barriers.dart';
import 'package:patti_geb/myPlayer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  static double playerY = 0.0;
  double time = 0;
  double height = 0;
  double playerWidth = 0.2;
  double playerHeight = 0.2;
  double initialHeight = playerY;

  // Game variables
  bool gameHasStarted = false;
  bool isGamePaused = false;
  int bestScore = 0;
  int actualScore = 0;

  // Barrier variables
  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    // Between 0-2 height of screen & [topHeight, bottomHeight]
    [0.6, 0.4],
    [0.4, 0.6],
  ];

  late AnimationController _animationController;
  static double barrierSpeed = 0.02; // Adjust this value to control the speed

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    )..addListener(() {
      setState(() {
        // Update barrierX positions if the game is not paused
        if (gameHasStarted) {
          barrierX[0] -= barrierSpeed;
          barrierX[1] -= barrierSpeed;

          // Check if barriers have gone off-screen and reset their positions
          if (barrierX[0] < -2 - barrierWidth) {
            barrierX[0] = barrierX[1];
            barrierHeight[0] = barrierHeight[1];
          }
          if (barrierX[1] < -2 - barrierWidth) {
            barrierX[1] = barrierX[0];
            barrierHeight[1] = barrierHeight[0];
          }
        }
      });
    });
  }

  void flyUp() {
    setState(() {
      time = 0;
      initialHeight = playerY;
    });
  }

  void startGame() {
    gameHasStarted = true;
    isGamePaused = false;
    _animationController.repeat(); // Start the barrier animation
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!isGamePaused) {
        setState(() {
          actualScore++; // Increment the actual score every second
        });
      }
    });

    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!isGamePaused) {
        time += 0.05;
        height = -3 * time * time + 2 * time;
        setState(() {
          playerY = initialHeight - height;
        });

        // Check if player is dead
        if (playerIsDead()) {
          timer.cancel();
          gameHasStarted = false;
          actualScore = 0;
          _showDialog();
        }

        // Time counter
        time += 0.05;
      }
    });
  }

  void resetGame() {
    _animationController.stop(); // Stop the barrier animation
    Navigator.pop(context);
    setState(() {
      playerY = 0;
      gameHasStarted = false;
      time = 0;
      initialHeight = playerY;

      isGamePaused = true;

      if (bestScore < actualScore) {
        bestScore = actualScore;
      }
      actualScore = 0;

      // Reset barrier positions and heights
      barrierX = [2, 2 + 1.5];
      barrierHeight = [
        [0.6, 0.4],
        [0.4, 0.6],
      ];
    });
  }

  bool playerIsDead() {
    // Check if player is dead (hitting top or bottom)
    if (playerY < -1 || playerY > 1) {
      return true;
    }

    // Check if player hits the barrier
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= playerWidth &&
          barrierX[i] + barrierWidth >= -playerWidth &&
          (playerY <= -1 + barrierHeight[i][0] ||
              playerY + playerHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }
    return false;
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
      },
    );
  }

  Widget buildBarrier(double barrierX, double barrierHeight, bool isThisBottomBarrier, String backgroundImage) {
    return MyBarrier(
      barrierX: barrierX,
      barrierWidth: barrierWidth,
      barrierHeight: barrierHeight,
      isThisBottomBarrier: isThisBottomBarrier,
      backgroundImage: backgroundImage,
    );
  }

  List<Widget> buildBarriers() {
    final List<String> backgroundImages = [
      'lib/images/tower_background_green.jpg',
      'lib/images/tower_background_blue.jpg',
      'lib/images/tower_background_yellow.jpg',
      'lib/images/tower_background_red.jpg',
    ];

    return List.generate(barrierX.length, (index) {
      final randomIndex = Random().nextInt(backgroundImages.length);
      final backgroundImage = backgroundImages[randomIndex];
      return buildBarrier(barrierX[index], barrierHeight[index][0], index % 2 == 1, backgroundImage);
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
              flex: 5,
              child: Stack(
                children: [
                 Image.asset(
                      'lib/images/background_hogwarts.png'),
                  Container(

                    child: MyPlayer(
                      playerY: playerY,
                      playerWidth: playerWidth,
                      playerHeight: playerHeight,
                    ),
                  ),
                  Positioned.fill(
                    child: Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15, top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "BEST",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    bestScore.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 50),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15, top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    "SCORE",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    actualScore.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 50),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      alignment: const Alignment(0, -0.3),
                      child: gameHasStarted
                          ? const Text("")
                          : const Text(
                        "TAP TO PLAY",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  ...buildBarriers(),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Image.asset(
                    'lib/images/patti_potter_logo.png',
                    width: MediaQuery.of(context).size.width * 0.6,
                    //fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
