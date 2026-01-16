import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:joby/features/departments/domain/entities/department_entity.dart';
import 'package:joby/features/departments/presentation/controllers/department_controller.dart';
import 'package:joby/features/departments/presentation/controllers/department_hierarchy_controller.dart';
import 'package:joby/features/departments/presentation/controllers/department_hierarchy_state.dart';
import 'package:joby/features/departments/presentation/controllers/department_state.dart';
import 'package:joby/features/departments/presentation/widgets/add_child_department_dialog.dart';

class DepartmentDetailView extends ConsumerStatefulWidget {
  final String departmentId;

  const DepartmentDetailView({
    super.key,
    required this.departmentId,
  });

  @override
  ConsumerState<DepartmentDetailView> createState() => _DepartmentDetailViewState();
}

class _DepartmentDetailViewState extends ConsumerState<DepartmentDetailView> {
  List<DepartmentEntity> _childDepartments = [];
  DepartmentEntity? _parentDepartment;
  bool _isLoadingHierarchy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(departmentControllerProvider.notifier).loadDepartmentById(widget.departmentId);
      _loadHierarchyInfo();
    });
  }

  Future<void> _loadHierarchyInfo() async {
    setState(() => _isLoadingHierarchy = true);

    final hierarchyController = ref.read(departmentHierarchyControllerProvider.notifier);

    // Load children
    final children = await hierarchyController.getChildDepartments(widget.departmentId);
    
    // Load parent
    final parent = await hierarchyController.getParentDepartment(widget.departmentId);

    if (mounted) {
      setState(() {
        _childDepartments = children;
        _parentDepartment = parent;
        _isLoadingHierarchy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final departmentState = ref.watch(departmentControllerProvider);

    // Listen for hierarchy changes to reload
    ref.listen<DepartmentHierarchyState>(
      departmentHierarchyControllerProvider,
      (previous, next) {
        if (next is DepartmentHierarchyStateSuccess) {
          _loadHierarchyInfo();
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: departmentState is DepartmentStateDetail
            ? Text((departmentState as DepartmentStateDetail).department.name)
            : const Text('Department Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Edit department
            },
          ),
        ],
      ),
      body: departmentState is DepartmentStateLoading
          ? const Center(child: CircularProgressIndicator())
          : departmentState is DepartmentStateDetail
              ? _buildDepartmentDetails((departmentState as DepartmentStateDetail).department)
              : departmentState is DepartmentStateError
                  ? _buildErrorState((departmentState as DepartmentStateError).message)
                  : const Center(child: Text('Loading...')),
    );
  }

  Widget _buildDepartmentDetails(DepartmentEntity department) {
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
                    backgroundColor: _getColorForLevel(department.hierarchyLevel),
                    child: Text(
                      department.name.isNotEmpty ? department.name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          department.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: department.isActive
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            department.isActive ? 'Active' : 'Inactive',
                            style: TextStyle(
                              color: department.isActive ? Colors.green : Colors.red,
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

          // Parent Department (if exists)
          if (_parentDepartment != null) ...[
            Text(
              'Parent Department',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getColorForLevel(_parentDepartment!.hierarchyLevel),
                  child: Text(
                    _parentDepartment!.name.isNotEmpty 
                        ? _parentDepartment!.name[0].toUpperCase() 
                        : '?',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(_parentDepartment!.name),
                subtitle: Text(_getLevelName(_parentDepartment!.hierarchyLevel)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to parent
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DepartmentDetailView(
                        departmentId: _parentDepartment!.id,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Department Info
          Text(
            'Department Information',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _InfoRow(
                    label: 'Department ID',
                    value: department.id,
                  ),
                  const Divider(),
                  _InfoRow(
                    label: 'Type ID',
                    value: department.typeId,
                  ),
                  const Divider(),
                  _InfoRow(
                    label: 'Hierarchy Level',
                    value: '${department.hierarchyLevel} (${_getLevelName(department.hierarchyLevel)})',
                  ),
                  const Divider(),
                  _InfoRow(
                    label: 'Created At',
                    value: _formatDate(department.createdAt),
                  ),
                  const Divider(),
                  _InfoRow(
                    label: 'Created By',
                    value: department.createdBy,
                  ),
                  if (department.activeTill != null) ...[
                    const Divider(),
                    _InfoRow(
                      label: 'Active Till',
                      value: _formatDate(department.activeTill!),
                      valueColor: Colors.red,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Members section (placeholder)
          Text(
            'Members',
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
                      'No members yet',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () {
                        // TODO: Add member
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Add Member feature coming soon'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.person_add),
                      label: const Text('Add Member'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Child Departments section
          Text(
            'Child Departments',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _buildChildDepartmentsSection(department),
        ],
      ),
    );
  }

  Widget _buildChildDepartmentsSection(DepartmentEntity department) {
    if (_isLoadingHierarchy) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_childDepartments.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.account_tree_outlined,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 8),
                Text(
                  'No child departments',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => _showAddChildDialog(department),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Child Department'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      child: Column(
        children: [
          ..._childDepartments.map((child) => ListTile(
            leading: CircleAvatar(
              backgroundColor: _getColorForLevel(child.hierarchyLevel),
              child: Text(
                child.name.isNotEmpty ? child.name[0].toUpperCase() : '?',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(child.name),
            subtitle: Text(_getLevelName(child.hierarchyLevel)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DepartmentDetailView(
                    departmentId: child.id,
                  ),
                ),
              );
            },
          )),
          const Divider(height: 1),
          TextButton.icon(
            onPressed: () => _showAddChildDialog(department),
            icon: const Icon(Icons.add),
            label: const Text('Add Child Department'),
          ),
        ],
      ),
    );
  }

  void _showAddChildDialog(DepartmentEntity department) {
    showDialog(
      context: context,
      builder: (context) => AddChildDepartmentDialog(parentDepartment: department),
    ).then((result) {
      // Reload hierarchy info after dialog closes
      if (result == true) {
        _loadHierarchyInfo();
      }
    });
  }

  String _getLevelName(int level) {
    switch (level) {
      case 0:
        return 'Company';
      case 1:
        return 'Division';
      case 2:
        return 'Department';
      case 3:
        return 'Team';
      default:
        return 'Level $level';
    }
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
            'Error loading department',
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
              ref.read(departmentControllerProvider.notifier).loadDepartmentById(widget.departmentId);
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
