import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:joby/features/permissions/domain/entities/user_role_entity.dart';
import 'package:joby/features/permissions/presentation/controllers/role_controller.dart';
import 'package:joby/features/permissions/presentation/controllers/role_state.dart';
import 'package:joby/features/permissions/presentation/widgets/create_role_dialog.dart';

class RolesView extends ConsumerStatefulWidget {
  const RolesView({super.key});

  @override
  ConsumerState<RolesView> createState() => _RolesViewState();
}

class _RolesViewState extends ConsumerState<RolesView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(roleControllerProvider.notifier).loadAllRoles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final roleState = ref.watch(roleControllerProvider);

    // Kuula state muutusi success/error jaoks
    ref.listen<RoleState>(roleControllerProvider, (previous, next) {
      next.maybeWhen(
        success: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.green,
            ),
          );
        },
        error: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
            ),
          );
        },
        orElse: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Roles & Permissions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(roleControllerProvider.notifier).loadAllRoles();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context),
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(roleControllerProvider.notifier).loadAllRoles();
        },
        child: roleState.maybeWhen(
          loading: () => const Center(child: CircularProgressIndicator()),
          loaded: (roles) => _buildRolesList(roles),
          error: (message) => _buildErrorState(message),
          orElse: () => const Center(child: Text('Loading roles...')),
        ),
      ),
    );
  }

  Widget _buildRolesList(List<UserRoleEntity> roles) {
    if (roles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.security_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No roles yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to create the first role',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: roles.length,
      itemBuilder: (context, index) {
        final role = roles[index];
        return _buildRoleCard(role);
      },
    );
  }

  Widget _buildRoleCard(UserRoleEntity role) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getColorForRole(role.name),
          child: const Icon(
            Icons.shield,
            color: Colors.white,
          ),
        ),
        title: Text(
          role.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              role.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: role.isActive
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                role.isActive ? 'Active' : 'Inactive',
                style: TextStyle(
                  fontSize: 12,
                  color: role.isActive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          context.push('/roles/${role.id}');
        },
      ),
    );
  }

  Color _getColorForRole(String name) {
    final nameLower = name.toLowerCase();
    if (nameLower.contains('admin')) {
      return Colors.red;
    } else if (nameLower.contains('manager')) {
      return Colors.orange;
    } else if (nameLower.contains('user') || nameLower.contains('member')) {
      return Colors.blue;
    } else if (nameLower.contains('guest') || nameLower.contains('viewer')) {
      return Colors.grey;
    }
    return Colors.purple;
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading roles',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(roleControllerProvider.notifier).loadAllRoles();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateRoleDialog(),
    );
  }
}
