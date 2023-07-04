import 'package:flutter/material.dart';

class MyCaracter extends StatelessWidget {
  const MyCaracter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 80,
      child: Image.asset(
        'lib/images/patti_potter.png'
      ),
    );
  }
}
