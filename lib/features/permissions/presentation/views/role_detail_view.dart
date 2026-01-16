import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:joby/features/permissions/domain/entities/permission_entity.dart';
import 'package:joby/features/permissions/domain/entities/user_role_entity.dart';
import 'package:joby/features/permissions/presentation/controllers/role_controller.dart';
import 'package:joby/features/permissions/presentation/controllers/role_state.dart';

class RoleDetailView extends ConsumerStatefulWidget {
  final String roleId;

  const RoleDetailView({
    super.key,
    required this.roleId,
  });

  @override
  ConsumerState<RoleDetailView> createState() => _RoleDetailViewState();
}

class _RoleDetailViewState extends ConsumerState<RoleDetailView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(roleControllerProvider.notifier).loadRoleById(widget.roleId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final roleState = ref.watch(roleControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: roleState.maybeWhen(
          detail: (role, _) => Text(role.name),
          orElse: () => const Text('Role Details'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Edit role
            },
          ),
        ],
      ),
      body: roleState.maybeWhen(
        loading: () => const Center(child: CircularProgressIndicator()),
        detail: (role, permissions) => _buildRoleDetails(role, permissions),
        error: (message) => _buildErrorState(message),
        orElse: () => const Center(child: Text('Loading...')),
      ),
    );
  }

  Widget _buildRoleDetails(UserRoleEntity role, List<PermissionEntity> permissions) {
    // Grupeeri õigused kategooriate järgi
    final groupedPermissions = <String, List<PermissionEntity>>{};
    for (final permission in permissions) {
      final category = permission.code.split('.').first;
      groupedPermissions.putIfAbsent(category, () => []).add(permission);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: _getColorForRole(role.name),
                    child: const Icon(
                      Icons.shield,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          role.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          role.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: role.isActive
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            role.isActive ? 'Active' : 'Inactive',
                            style: TextStyle(
                              color: role.isActive ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Role Info
          Text(
            'Role Information',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _InfoRow(
                    label: 'Role ID',
                    value: role.id,
                  ),
                  const Divider(),
                  _InfoRow(
                    label: 'Created At',
                    value: _formatDate(role.createdAt),
                  ),
                  const Divider(),
                  _InfoRow(
                    label: 'Created By',
                    value: role.createdBy,
                  ),
                  if (role.activeTill != null) ...[
                    const Divider(),
                    _InfoRow(
                      label: 'Active Till',
                      value: _formatDate(role.activeTill!),
                      valueColor: Colors.red,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Permissions section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Permissions',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton.icon(
                onPressed: () {
                  // TODO: Manage permissions
                },
                icon: const Icon(Icons.settings),
                label: const Text('Manage'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (permissions.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No permissions assigned',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            ...groupedPermissions.entries.map((entry) => _buildPermissionCategory(
              entry.key,
              entry.value,
            )),

          const SizedBox(height: 24),

          // Users with this role (placeholder)
          Text(
            'Users with this Role',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.group_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No users assigned to this role',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () {
                        // TODO: Assign users
                      },
                      icon: const Icon(Icons.person_add),
                      label: const Text('Assign Users'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionCategory(String category, List<PermissionEntity> permissions) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Icon(
          _getCategoryIcon(category),
          color: _getCategoryColor(category),
        ),
        title: Text(
          _formatCategoryName(category),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('${permissions.length} permissions'),
        children: permissions.map((permission) => ListTile(
          leading: const Icon(Icons.check_circle, color: Colors.green, size: 20),
          title: Text(permission.name),
          subtitle: Text(
            permission.description,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: Text(
            permission.code,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[500],
              fontFamily: 'monospace',
            ),
          ),
        )).toList(),
      ),
    );
  }

  String _formatCategoryName(String category) {
    return category[0].toUpperCase() + category.substring(1);
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'user':
        return Icons.person;
      case 'department':
        return Icons.business;
      case 'role':
        return Icons.security;
      case 'permission':
        return Icons.lock;
      case 'report':
        return Icons.assessment;
      case 'settings':
        return Icons.settings;
      default:
        return Icons.category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'user':
        return Colors.blue;
      case 'department':
        return Colors.green;
      case 'role':
        return Colors.orange;
      case 'permission':
        return Colors.red;
      case 'report':
        return Colors.purple;
      case 'settings':
        return Colors.grey;
      default:
        return Colors.teal;
    }
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

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
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
            'Error loading role',
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
              ref.read(roleControllerProvider.notifier).loadRoleById(widget.roleId);
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
