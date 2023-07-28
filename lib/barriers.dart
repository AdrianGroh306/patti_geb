import 'package:flutter/material.dart';

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
      child: Container(
        width: MediaQuery.of(context).size.width * barrierWidth / 1.8,
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

