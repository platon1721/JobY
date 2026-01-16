import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:joby/features/departments/domain/entities/department_type_entity.dart';
import 'package:joby/features/departments/presentation/controllers/department_type_controller.dart';
import 'package:joby/features/departments/presentation/controllers/department_type_state.dart';
import 'package:joby/features/departments/presentation/widgets/create_department_type_dialog.dart';

class DepartmentTypesView extends ConsumerStatefulWidget {
  const DepartmentTypesView({super.key});

  @override
  ConsumerState<DepartmentTypesView> createState() => _DepartmentTypesViewState();
}

class _DepartmentTypesViewState extends ConsumerState<DepartmentTypesView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(departmentTypeControllerProvider.notifier).loadAllDepartmentTypes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(departmentTypeControllerProvider);

    ref.listen<DepartmentTypeState>(departmentTypeControllerProvider, (previous, next) {
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
        title: const Text('Department Types'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(departmentTypeControllerProvider.notifier).loadAllDepartmentTypes();
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
          await ref.read(departmentTypeControllerProvider.notifier).loadAllDepartmentTypes();
        },
        child: state.maybeWhen(
          loading: () => const Center(child: CircularProgressIndicator()),
          loaded: (types) => _buildTypesList(types),
          error: (message) => _buildErrorState(message),
          orElse: () => const Center(child: Text('Loading...')),
        ),
      ),
    );
  }

  Widget _buildTypesList(List<DepartmentTypeEntity> types) {
    if (types.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No department types yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to create the first type',
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
      itemCount: types.length,
      itemBuilder: (context, index) {
        final type = types[index];
        return _buildTypeCard(type);
      },
    );
  }

  Widget _buildTypeCard(DepartmentTypeEntity type) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(
            _getIconForType(type.name),
            color: Colors.white,
          ),
        ),
        title: Text(
          type.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (type.description != null && type.description!.isNotEmpty)
              Text(type.description!),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: type.isActive
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                type.isActive ? 'Active' : 'Inactive',
                style: TextStyle(
                  fontSize: 12,
                  color: type.isActive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _showEditDialog(context, type);
            } else if (value == 'delete') {
              _showDeleteConfirmation(context, type);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(String name) {
    final nameLower = name.toLowerCase();
    if (nameLower.contains('company')) return Icons.business;
    if (nameLower.contains('division')) return Icons.account_tree;
    if (nameLower.contains('department')) return Icons.folder;
    if (nameLower.contains('team')) return Icons.group;
    if (nameLower.contains('unit')) return Icons.people;
    return Icons.category;
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
            'Error loading department types',
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
              ref.read(departmentTypeControllerProvider.notifier).loadAllDepartmentTypes();
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
      builder: (context) => const CreateDepartmentTypeDialog(),
    );
  }

  void _showEditDialog(BuildContext context, DepartmentTypeEntity type) {
    showDialog(
      context: context,
      builder: (context) => CreateDepartmentTypeDialog(existingType: type),
    );
  }

  void _showDeleteConfirmation(BuildContext context, DepartmentTypeEntity type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Department Type'),
        content: Text('Are you sure you want to delete "${type.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(departmentTypeControllerProvider.notifier).deactivateDepartmentType(type.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}