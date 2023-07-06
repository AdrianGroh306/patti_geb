import 'package:flutter/material.dart';

class MyPlayer extends StatelessWidget {
  final playerY;
  final double playerWidth;
  final double playerHeight;

  const MyPlayer({this.playerY,required this.playerWidth,required this.playerHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, (2* playerY + playerHeight) / (2-playerHeight)),
      child: Image.asset(
        'lib/images/patti_potter.png',
        height: MediaQuery.of(context).size.height *  3/4 * playerHeight / 2,
        width: MediaQuery.of(context).size.height * playerWidth / 2.5,
        fit: BoxFit.fill,
      ),
    );
  }
}