import 'package:flutter/material.dart';
import 'package:joby/features/dashboard/presentation/components/side_menu_item.dart';

class SideMenu extends StatelessWidget {
  final List<SideMenuItem> menuItems;

  const SideMenu({
    super.key,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: menuItems.map((item) {
          if (item.isDivider) {
            return const Divider();
          }

          return ListTile(
            leading: Icon(item.icon),
            title: Text(item.title),
            onTap: item.onTap,
          );
        }).toList(),
      ),
    );
  }
}
