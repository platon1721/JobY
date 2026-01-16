import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:joby/features/auth/presentation/controllers/auth_controller.dart';
import 'package:joby/features/dashboard/presentation/components/side_menu_item.dart';
import 'package:joby/features/dashboard/presentation/widgets/side_menu.dart';
import 'package:joby/features/dashboard/presentation/widgets/sidebar_header.dart';
import 'package:joby/features/users/presentation/controllers/user_controller.dart';
import 'package:joby/features/users/presentation/controllers/user_state.dart';

class DashboardDrawer extends ConsumerStatefulWidget {
  const DashboardDrawer({super.key});

  @override
  ConsumerState<DashboardDrawer> createState() => _DashboardDrawerState();
}

class _DashboardDrawerState extends ConsumerState<DashboardDrawer> {
  @override
  void initState() {
    super.initState();
    // Laadi kasutaja andmed kui drawer avaneb
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userControllerProvider.notifier).loadCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userControllerProvider);

    return Drawer(
      child: Column(
        children: [
          // Kasutaja info header
          SidebarHeader(userState: userState),

          // Menüü elemendid
          SideMenu(menuItems: [
            SideMenuItem(
              icon: Icons.dashboard,
              title: 'Dashboard',
              onTap: () {
                Navigator.pop(context);
                context.go('/home');
              },
            ),
            SideMenuItem(
              icon: Icons.person,
              title: 'My Profile',
              onTap: () {
                Navigator.pop(context);
                context.push('/profile');
              },
            ),
            const SideMenuItem.divider(),
            SideMenuItem(
              icon: Icons.business,
              title: 'Departments',
              onTap: () {
                Navigator.pop(context);
                context.push('/departments');
              },
            ),
            SideMenuItem(
              icon: Icons.security,
              title: 'Roles & Permissions',
              onTap: () {
                Navigator.pop(context);
                context.push('/roles');
              },
            ),
            const SideMenuItem.divider(),
            SideMenuItem(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to settings
              },
            ),
          ]),

          // Logout nupp all
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              Navigator.pop(context); // Sulge drawer
              await ref.read(authControllerProvider.notifier).logout();
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildUserHeader(UserState userState) {
    return userState.maybeWhen(
      loaded: (user) => UserAccountsDrawerHeader(
        accountName: Text(user.surName),
        accountEmail: Text(user.email),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.white,
          child: Text(
            user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : '?',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
      ),
      loading: () => const DrawerHeader(
        decoration: BoxDecoration(color: Colors.grey),
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      ),
      error: (message) => DrawerHeader(
        decoration: const BoxDecoration(color: Colors.grey),
        child: Center(
          child: Text(
            'Error: $message',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      orElse: () => const DrawerHeader(
        decoration: BoxDecoration(color: Colors.grey),
        child: Center(
          child: Text(
            'Loading...',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
