import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joby/features/dashboard/presentation/components/side_menu_item.dart';

class SideMenuTile extends StatelessWidget {
  final SideMenuItem item;

  const SideMenuTile({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(14),
        splashColor: Colors.white.withOpacity(0.08),
        highlightColor: Colors.white.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                item.icon,
                color: Colors.white.withOpacity(0.95),
                size: 22,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  item.title,
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.95),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
