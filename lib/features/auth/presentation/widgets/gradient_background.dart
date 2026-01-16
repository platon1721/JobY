import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment(0.8, 1),
            colors: <Color>[
              Color(0xff084594),
              Color(0xff2171B5),
              Color(0xff4292C6),
              Color(0xff6BAED6),
              Color(0xff9ECAE1),
              Color(0xffC6DBEF),
              Color(0xffDEEBF7),
              Color(0xffF7FBFF),
            ],
            tileMode: TileMode.mirror,
          ),
        ),
        child: child,
        ),
      );
  }
}