// dashboard_drawer.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joby/features/auth/presentation/widgets/gradient_background.dart';
import 'package:joby/features/auth/presentation/controllers/auth_controller.dart';
import 'package:joby/features/dashboard/presentation/components/side_menu_item.dart';
import 'package:joby/features/dashboard/presentation/widgets/side_menu.dart';
import 'package:joby/features/dashboard/presentation/widgets/sidebar_header.dart';
import 'package:joby/features/users/presentation/controllers/user_controller.dart';

class DashboardDrawer extends ConsumerStatefulWidget {
  const DashboardDrawer({super.key});

  @override
  ConsumerState<DashboardDrawer> createState() => _DashboardDrawerState();
}

class _DashboardDrawerState extends ConsumerState<DashboardDrawer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userControllerProvider.notifier).loadCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userControllerProvider);

    return Drawer(
      backgroundColor: Colors.transparent,
      child: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Kui SidebarHeader on sul praegu “valge”/default,
              // soovitan sinna ka valge tekst + läbipaistev bg panna.
              SidebarHeader(userState: userState),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withOpacity(0.20)),
                  ),
                  child: SideMenu(
                    menuItems: [
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
                        icon: Icons.settings,
                        title: 'Settings',
                        onTap: () => Navigator.pop(context),
                      ),
                      SideMenuItem(
                        icon: Icons.business,
                        title: 'Departments',
                        onTap: () {
                          Navigator.pop(context);
                          context.push('/departments');
                        },
                      ),
                    SideMenuItem(
                        icon: Icons.category,
                        title: 'Department Types',
                        onTap: () {
                          Navigator.pop(context);
                          context.push('/department-types');
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
                    ],
                  ),
                ),
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withOpacity(0.20)),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.logout, color: Colors.white),
                    title: Text(
                      'Logout',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Sign out of Job.Y',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 12,
                      ),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      await ref.read(authControllerProvider.notifier).logout();
                    },
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
