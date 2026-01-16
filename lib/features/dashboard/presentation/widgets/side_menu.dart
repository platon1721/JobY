import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joby/features/dashboard/presentation/components/side_menu_item.dart';

class SideMenu extends StatelessWidget {
  final List<SideMenuItem> menuItems;

  const SideMenu({
    super.key,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: menuItems.map((item) {
        if (item.isDivider) {
          return Divider(
            color: Colors.white.withOpacity(0.2),
            height: 1,
          );
        }

        return ListTile(
          leading: Icon(item.icon, color: Colors.white),
          title: Text(
            item.title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: item.onTap,
        );
      }).toList(),
    );
  }
}