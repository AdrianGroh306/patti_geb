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

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  static double playerY = 0.0;
  double time = 0;
  double height = 0;
  double playerWidth = 0.25;
  double playerHeight = 0.25;
  double initialHeight = playerY;

  // Game variables
  bool gameHasStarted = false;
  bool isGamePaused = false;
  int bestScore = 0;
  int actualScore = 0;
  Timer? _scoreIncrementTimer;

  // Barrier variables
  late AnimationController _animationController;
  bool isBarrierAnimationPaused = false; // New variable to track whether barrier animation is paused
  static List<double> barrierX = [2, 2];
  static double barrierWidth = 0.3;
  static double barrierSpeed = 0.01;
  List<List<double>> barrierHeight = [
    // Between 0-2 height of screen & [topHeight, bottomHeight]
    [0.6, 0.6],
    [0.4, 0.6],
  ];

  @override
  void initState() {
    super.initState();
    startBlinkingText();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1),
    )..addListener(() {
      if (gameHasStarted && !isGamePaused && !isBarrierAnimationPaused) {
        setState(updateBarriers); // Only update barriers state when needed
      }
    });
  }

  void updateBarriers() {
    for (int i = 0; i < barrierX.length; i++) {
      barrierX[i] -= barrierSpeed;

      if (barrierX[i] < -2) {
        barrierX.removeAt(i);
        barrierHeight.removeAt(i);
        i--;
      }
    }

    if (barrierX.isEmpty) {
      barrierX.add(1.2); // Initial barrier position (adjusted)
      barrierHeight = [
        [2, 2], // Initial barrier heights
      ];
    }

    if (barrierX.isNotEmpty && barrierX.last < 1.0) {
      barrierX.add(barrierX.last + 0.8); // Spacing between barriers (adjusted)
      barrierHeight.add([
        Random().nextDouble() * (0.2 - 0.1) + 0.3, // Upper barrier height range (adjusted)
        Random().nextDouble() * (0.2 - 0.1) + 0.3, // Lower barrier height range (adjusted)
      ]);
    }
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
    isBarrierAnimationPaused = false; // Reset barrier animation pause state
    _animationController.repeat(); // Start the barrier animation

    // Cancel the existing score increment timer if it exists
    _scoreIncrementTimer?.cancel();

    _scoreIncrementTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (playerIsDead() == false) {
        if (!isGamePaused) {
          setState(() {
            actualScore++; // Increment the actual score every second
          });
        }
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
          _showDialog();
        }
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
      isBarrierAnimationPaused = true;
      return true;
    }

    // Check if player hits the barrier
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= playerWidth &&
          barrierX[i] + barrierWidth >= -playerWidth &&
          (playerY <= -1.2 + barrierHeight[i][0] || playerY + playerHeight >= 1.2 - barrierHeight[i][1])) {
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
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),
            ),
          ),
          actions: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "BEST ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      bestScore.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Image.asset(
                  "lib/images/dobby.png",
                  height: 100,
                  width: 100,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Score ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      actualScore.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: resetGame,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 25),
                    color: Colors.white,
                    child: const Text(
                      "PLAY AGAIN",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15)
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
     // 'lib/images/tower_background_blue.png',
      'lib/images/tower_background_green.png',
   // 'lib/images/tower_background_gelb.png',
    //'lib/images/tower_background_red.png',
    ];

    List<Widget> barriers = [];
    const double gapSize = 0.3; // Set the desired gap size (adjust this value to change the gap size)

    // Ensure there are enough elements in barrierX to create multiple barriers
    while (barrierX.length < 5) {
      barrierX.add(barrierX.last + 1.2); // Spacing between barriers
      double upperBarrierHeight = Random().nextDouble() + gapSize; // Random upper barrier height between 0 and (1 - 2 * gapSize)
      double lowerBarrierHeight = 1.6 - upperBarrierHeight ; // Calculate the corresponding lower barrier height
      barrierHeight.add([upperBarrierHeight, lowerBarrierHeight]);
    }

    // Iterate through the barrierX list and create barriers
    for (int i = 0; i < barrierX.length; i++) {
      final randomIndex = Random().nextInt(backgroundImages.length);
      final backgroundImage = backgroundImages[randomIndex];

      barriers.add(buildBarrier(
        barrierX[i],
        barrierHeight[i][0],
        false,
        backgroundImage,
      ));

      barriers.add(buildBarrier(
        barrierX[i],
        barrierHeight[i][1],
        true,
        backgroundImage,
      ));
    }

    return barriers;
  }

  bool isTextVisible = true;

  void startBlinkingText() {
    Timer.periodic(const Duration(milliseconds: 800), (timer) {
      setState(() {
        isTextVisible = !isTextVisible;
      });
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
                fit: StackFit.expand,
                children: [
                  FittedBox(
                    fit: BoxFit.fill,
                    child: Image.asset('lib/images/background_hogwarts.png', fit: BoxFit.cover,),
                  ),
                  Container(
                    child: MyPlayer(
                      playerY: playerY,
                      playerWidth: playerWidth,
                      playerHeight: playerHeight,
                    ),
                  ),
                  ...buildBarriers(), // Barriers should appear below the player and above the score text
                  Positioned.fill(
                    child: Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15, top: 32),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "BEST",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    bestScore.toString(),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 30,
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
                              padding: const EdgeInsets.only(right: 15, top: 32),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    "SCORE",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    actualScore.toString(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
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
                      child: AnimatedOpacity(
                        opacity: isTextVisible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: gameHasStarted
                            ? const Text("")
                            : const Text(
                          "TAP TO PLAY",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: const Color.fromRGBO(110, 220, 180, 1),
                child: Center(
                  child: Image.asset(
                    'lib/images/patti_potter_logo_glow.png',
                    width: MediaQuery.of(context).size.width * 0.6,
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
