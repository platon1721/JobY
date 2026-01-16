import 'package:flutter/material.dart';

class SideMenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDivider;

  const SideMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  }) : isDivider = false;

  const SideMenuItem.divider()
      : icon = Icons.circle,
        title = '',
        onTap = _empty,
        isDivider = true;

  static void _empty() {}
}
