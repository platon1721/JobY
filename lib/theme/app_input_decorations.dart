import 'package:flutter/material.dart';

class AppInputDecorations {
  AppInputDecorations._();

  static InputDecoration authField({
    required String label,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,

      labelStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),

      floatingLabelStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),

      filled: true,
      fillColor: Colors.white.withOpacity(0.28),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.25),
          width: 1.5,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          color: Colors.white,
          width: 2,
        ),
      ),

      suffixIcon: suffixIcon,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),
    );
  }
}
