import 'package:flutter/material.dart';
import 'package:joby/features/dashboard/presentation/components/side_menu_item.dart';
import 'package:joby/features/dashboard/presentation/widgets/glass_container.dart';
import 'package:joby/features/dashboard/presentation/widgets/side_menu_title.dart';


class SideMenu extends StatelessWidget {
  final List<SideMenuItem> menuItems;

  const SideMenu({
    super.key,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: EdgeInsets.zero,
      child: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: menuItems.map((item) {
          if (item.isDivider) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                color: Colors.white.withOpacity(0.25),
                height: 20,
              ),
            );
          }

          return SideMenuTile(item: item);
        }).toList(),
      ),
    );
  }
}
