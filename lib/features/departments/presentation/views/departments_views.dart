import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:joby/features/departments/domain/entities/department_entity.dart';
import 'package:joby/features/departments/presentation/controllers/department_controller.dart';
import 'package:joby/features/departments/presentation/controllers/department_state.dart';
import 'package:joby/features/departments/presentation/widgets/create_department_dialog.dart';

class DepartmentsView extends ConsumerStatefulWidget {
  const DepartmentsView({super.key});

  @override
  ConsumerState<DepartmentsView> createState() => _DepartmentsViewState();
}

class _DepartmentsViewState extends ConsumerState<DepartmentsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(departmentControllerProvider.notifier).loadAllDepartments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final departmentState = ref.watch(departmentControllerProvider);

    ref.listen<DepartmentState>(departmentControllerProvider, (previous, next) {
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
        title: const Text('Departments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(departmentControllerProvider.notifier).loadAllDepartments();
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
          await ref.read(departmentControllerProvider.notifier).loadAllDepartments();
        },
        child: departmentState.maybeWhen(
          loading: () => const Center(child: CircularProgressIndicator()),
          loaded: (departments) => _buildDepartmentsList(departments),
          error: (message) => _buildErrorState(message),
          orElse: () => const Center(child: Text('Laadi osakonnad...')),
        ),
      ),
    );
  }

  Widget _buildDepartmentsList(List<DepartmentEntity> departments) {
    if (departments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.business_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No departments yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to create the first department',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    // Grupeeri hierarhia taseme järgi
    final groupedDepartments = <int, List<DepartmentEntity>>{};
    for (final dept in departments) {
      groupedDepartments.putIfAbsent(dept.hierarchyLevel, () => []).add(dept);
    }

    final sortedLevels = groupedDepartments.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedLevels.length,
      itemBuilder: (context, index) {
        final level = sortedLevels[index];
        final levelDepts = groupedDepartments[level]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                _getLevelName(level),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...levelDepts.map((dept) => _buildDepartmentCard(dept)),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  String _getLevelName(int level) {
    switch (level) {
      case 0:
        return 'Company Level';
      case 1:
        return 'Division Level';
      case 2:
        return 'Department Level';
      case 3:
        return 'Team Level';
      default:
        return 'Level $level';
    }
  }

  Widget _buildDepartmentCard(DepartmentEntity department) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getColorForLevel(department.hierarchyLevel),
          child: Text(
            department.name.isNotEmpty ? department.name[0].toUpperCase() : '?',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(department.name),
        subtitle: Text(
          'Level ${department.hierarchyLevel} • ${department.isActive ? 'Active' : 'Inactive'}',
          style: TextStyle(
            color: department.isActive ? Colors.green : Colors.red,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          context.push('/departments/${department.id}');
        },
      ),
    );
  }

  Color _getColorForLevel(int level) {
    switch (level) {
      case 0:
        return Colors.purple;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.orange;
      default:
        return Colors.grey;
    }
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
            'Error loading departments',
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
              ref.read(departmentControllerProvider.notifier).loadAllDepartments();
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
      builder: (context) => const CreateDepartmentDialog(),
    );
  }
}
