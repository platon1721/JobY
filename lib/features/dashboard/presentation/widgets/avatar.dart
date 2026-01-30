import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Avatar extends StatelessWidget {
  final String letter;

  const Avatar({required this.letter});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.20),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
