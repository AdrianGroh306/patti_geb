import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patti_geb/caracter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double caracYaxis = 0;
  double time = 0;
  double height = 0;
  double initialHeight = caracYaxis;
  bool gameHasStarted = false;

  void flyUp() {
    setState(() {
      time = 0;
      initialHeight = caracYaxis;
    });
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      time += 0.05;
      height = -4.9 * time * time + 2 * time;
      setState(() {
        caracYaxis = initialHeight - height;
      });
      if (caracYaxis > 1) {
        timer.cancel();
        gameHasStarted = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () {
                if (gameHasStarted) {
                  flyUp();
                } else {
                  startGame();
                }
              },
              child: AnimatedContainer(
                alignment: Alignment(0, caracYaxis), // x,y
                color: Colors.grey,
                duration: const Duration(milliseconds: 0),
                child: const MyCaracter(),
              ),
            ),
          ),
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
                      Text("SCORE",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      Text("0",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                      SizedBox(height: 25,),
                    ],
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("BEST",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      Text("10",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                      SizedBox(height: 25,),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
