import 'package:flutter/material.dart';

class WelcomeScreen {
  WelcomeScreen._();
  static final WelcomeScreen _sharedInstance = WelcomeScreen._();
  factory WelcomeScreen.instance() => _sharedInstance;


  OverlayEntry? _currentOverlay;

  void show({
    required BuildContext context
}) {
    if (_currentOverlay != null) {
      return;
    }
    // Implementation for showing the welcome screen overlay
  }

  void hide() {
    // Implementation for hiding the welcome screen overlay
  }
}