import 'package:flutter/material.dart';

class MyAppIcon extends StatelessWidget {
  static const double size = 32;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SizedBox(
          width: size,
          height: size,
          child: Image.asset('assets/logo.png'),
        ),
      ),
    );
  }
}
