import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:joby/features/dashboard/presentation/widgets/dashboard_drawer.dart';
import 'package:joby/features/users/presentation/controllers/user_controller.dart';
import 'package:joby/features/users/presentation/controllers/user_state.dart';

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  @override
  void initState() {
    super.initState();
    // Laadi kasutaja andmed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userControllerProvider.notifier).loadCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      drawer: const DashboardDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(userControllerProvider.notifier).loadCurrentUser();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tervituse kaart
              _buildWelcomeCard(userState),
              const SizedBox(height: 24),

              // Kiirlingid
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              _buildQuickActions(),
              const SizedBox(height: 24),

              // Statistika (placeholder)
              Text(
                'Overview',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              _buildOverviewCards(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(UserState userState) {
    String welcomeName = 'Welcome!';

    if (userState is UserStateLoaded) {
      welcomeName = 'Welcome, ${userState.user.firstName}!';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(Icons.waving_hand, size: 40, color: Colors.amber),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    welcomeName,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'What would you like to do today?',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            icon: Icons.person,
            label: 'Profile',
            color: Colors.blue,
            onTap: () {
              // TODO: Navigate to profile
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionCard(
            icon: Icons.business,
            label: 'Departments',
            color: Colors.green,
            onTap: () {
              // TODO: Navigate to departments
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionCard(
            icon: Icons.group,
            label: 'Team',
            color: Colors.orange,
            onTap: () {
              // TODO: Navigate to team
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewCards() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _OverviewCard(
          title: 'Departments',
          value: '-',
          icon: Icons.business,
          color: Colors.blue,
        ),
        _OverviewCard(
          title: 'Team Members',
          value: '-',
          icon: Icons.group,
          color: Colors.green,
        ),
        _OverviewCard(
          title: 'Active Tasks',
          value: '-',
          icon: Icons.task_alt,
          color: Colors.orange,
        ),
        _OverviewCard(
          title: 'Messages',
          value: '-',
          icon: Icons.message,
          color: Colors.purple,
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _OverviewCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}