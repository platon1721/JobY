import 'package:flutter/material.dart';
import 'package:joby/views/constants/app_colors.dart';
import 'package:joby/views/constants/app_strings.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingScreen {
  LoadingScreen._();

  static final LoadingScreen _sharedInstance = LoadingScreen._();

  factory LoadingScreen.instance() => _sharedInstance;

  OverlayEntry? _currentOverlay;

  void show({
    required BuildContext context,
     String text = AppStrings.loading,
}) {
    if (_currentOverlay != null) {
      return;
    }

    final overlayState = Overlay.of(context);

    _currentOverlay = OverlayEntry(builder: (context) {
      return Material(
        color: Colors.black.withAlpha(128),
        child: Center(
          child: LoadingAnimationWidget.discreteCircle(
              color: AppColors.loginButtonColor,
              size: 150,
              secondRingColor: AppColors.primaryColor,
              thirdRingColor: AppColors.secondaryColor
          ),
        )
      );
    });


    overlayState.insert(_currentOverlay!);
  }

  void hide() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }
}