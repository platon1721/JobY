import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joby/features/dashboard/presentation/widgets/glass_container.dart';

class HeaderMessage extends StatelessWidget {
  final String text;
  final IconData icon;

  const HeaderMessage({
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
