import 'package:flutter/material.dart';
import 'package:joby/features/dashboard/presentation/widgets/glass_container.dart';

class HeaderLoading extends StatelessWidget {
  const HeaderLoading();

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: const Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
