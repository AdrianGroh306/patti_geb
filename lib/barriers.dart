import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';

class MyBarrier extends StatelessWidget {
  final double barrierWidth;
  final double barrierHeight;
  final double barrierX;
  final bool isThisBottomBarrier;
  final String backgroundImage;

  MyBarrier({
    Key? key,
    required this.barrierWidth,
    required this.barrierHeight,
    required this.barrierX,
    required this.isThisBottomBarrier,
    required this.backgroundImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(
        (2 * barrierX + barrierWidth) / (2 - barrierWidth),
        isThisBottomBarrier ? 1.1 : -1.1,
      ),
      child: PhysicalModel(
        color: Colors.transparent,
        shadowColor: Colors.white,
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: GlowContainer(
          // Use GlowContainer to wrap the existing barrier
          glowColor: Colors.white, // Set the glow color to white
          //borderRadius: BorderRadius.circular(5),
          spreadRadius: 5, // Control the spread radius of the glow effect
          child: Container(
            width: MediaQuery.of(context).size.width * barrierWidth / 1.8,
            height: MediaQuery.of(context).size.height * 3 / 4 * barrierHeight / 2,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(backgroundImage),
                fit: BoxFit.fitWidth,
              ),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ),
    );
  }
}
