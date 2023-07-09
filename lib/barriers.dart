import 'package:flutter/material.dart';
import 'dart:math';

class MyBarrier extends StatelessWidget {
  final double barrierWidth;
  final double barrierHeight;
  final double barrierX;
  final bool isThisBottomBarrier;

  final String backgroundImage;

  MyBarrier({super.key,
    required this.barrierWidth,
    required this.barrierHeight,
    required this.barrierX,
    required this.isThisBottomBarrier,
  }) : backgroundImage = _getRandomBackgroundImage();

  static String _getRandomBackgroundImage() {
    final List<String> backgroundImages = [
      'lib/images/tower_background_green.jpg',
      'lib/images/tower_background_blue.jpg',
      'lib/images/tower_background_yellow.jpg',
      'lib/images/tower_background_red.jpg',
    ];

    final random = Random();
    return backgroundImages[random.nextInt(backgroundImages.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(
        (2 * barrierX + barrierWidth) / (2 - barrierWidth),
        isThisBottomBarrier ? 1.1 : -1.1,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * barrierWidth / 2,
        height: MediaQuery.of(context).size.height * 3 / 4 * barrierHeight / 2,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
