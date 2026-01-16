import 'package:flutter/material.dart';
import 'package:joby/theme/app_colors.dart';

@immutable
class AppButtonStyles {
  static ButtonStyle primaryPillButtonStyle() => ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryColor,
    foregroundColor: Colors.black,
    elevation: 0,
    minimumSize: const Size.fromHeight(54),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
  );

  static ButtonStyle secondaryPillOutlineStyle() => OutlinedButton.styleFrom(
    foregroundColor: Colors.white,
    side: const BorderSide(color: Colors.white, width: 2),
    minimumSize: const Size.fromHeight(54),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
  );

  const AppButtonStyles._();
}