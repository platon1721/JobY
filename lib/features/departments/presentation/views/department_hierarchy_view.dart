import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:joby/features/departments/domain/entities/department_entity.dart';
import 'package:joby/features/departments/presentation/controllers/department_hierarchy_controller.dart';
import 'package:joby/features/departments/presentation/controllers/department_hierarchy_state.dart';
import 'package:joby/features/departments/presentation/widgets/department_tree_node.dart';
import 'package:joby/features/departments/presentation/widgets/add_child_department_dialog.dart';
import 'package:joby/features/departments/presentation/widgets/move_department_dialog.dart';

class DepartmentHierarchyView extends ConsumerStatefulWidget {
  const DepartmentHierarchyView({super.key});

  @override
  ConsumerState<DepartmentHierarchyView> createState() =>
      _DepartmentHierarchyViewState();
}

class _DepartmentHierarchyViewState
    extends ConsumerState<DepartmentHierarchyView> {
  final Set<String> _expandedNodes = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(departmentHierarchyControllerProvider.notifier).loadHierarchy();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(departmentHierarchyControllerProvider);

    ref.listen<DepartmentHierarchyState>(
      departmentHierarchyControllerProvider,
      (previous, next) {
        if (next is DepartmentHierarchyStateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (next is DepartmentHierarchyStateError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Department Hierarchy'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref
                  .read(departmentHierarchyControllerProvider.notifier)
                  .loadHierarchy();
            },
          ),
          IconButton(
            icon: const Icon(Icons.unfold_more),
            tooltip: 'Expand All',
            onPressed: () => _expandAll(state),
          ),
          IconButton(
            icon: const Icon(Icons.unfold_less),
            tooltip: 'Collapse All',
            onPressed: () {
              setState(() {
                _expandedNodes.clear();
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(departmentHierarchyControllerProvider.notifier)
              .loadHierarchy();
        },
        child: _buildBody(state),
      ),
    );
  }

  void _expandAll(DepartmentHierarchyState state) {
    if (state is DepartmentHierarchyStateLoaded) {
      setState(() {
        _expandedNodes.clear();
        for (final root in state.rootDepartments) {
          _expandedNodes.add(root.id);
          _expandAllChildren(root.id, state.childrenMap);
        }
      });
    }
  }

  Widget _buildBody(DepartmentHierarchyState state) {
    if (state is DepartmentHierarchyStateLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is DepartmentHierarchyStateLoaded) {
      return _buildHierarchyTree(state.rootDepartments, state.childrenMap);
    } else if (state is DepartmentHierarchyStateError) {
      return _buildErrorState(state.message);
    } else {
      return const Center(child: Text('Loading hierarchy...'));
    }
  }

  void _expandAllChildren(
    String parentId,
    Map<String, List<DepartmentEntity>> childrenMap,
  ) {
    final children = childrenMap[parentId] ?? [];
    for (final child in children) {
      _expandedNodes.add(child.id);
      _expandAllChildren(child.id, childrenMap);
    }
  }

  Widget _buildHierarchyTree(
    List<DepartmentEntity> roots,
    Map<String, List<DepartmentEntity>> childrenMap,
  ) {
    if (roots.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_tree_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No department hierarchy',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create departments and organize them into a hierarchy',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context.push('/departments'),
              icon: const Icon(Icons.add),
              label: const Text('Go to Departments'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: roots.length,
      itemBuilder: (context, index) {
        final root = roots[index];
        return _buildTreeNode(
          department: root,
          childrenMap: childrenMap,
          level: 0,
        );
      },
    );
  }

  Widget _buildTreeNode({
    required DepartmentEntity department,
    required Map<String, List<DepartmentEntity>> childrenMap,
    required int level,
  }) {
    final children = childrenMap[department.id] ?? [];
    final hasChildren = children.isNotEmpty;
    final isExpanded = _expandedNodes.contains(department.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DepartmentTreeNode(
          department: department,
          level: level,
          hasChildren: hasChildren,
          isExpanded: isExpanded,
          onToggleExpand: () {
            setState(() {
              if (isExpanded) {
                _expandedNodes.remove(department.id);
              } else {
                _expandedNodes.add(department.id);
              }
            });
          },
          onTap: () => context.push('/departments/${department.id}'),
          onAddChild: () => _showAddChildDialog(department),
          onMove: () => _showMoveDialog(department),
          onRemoveFromParent: () => _confirmRemoveFromParent(department),
        ),
        if (isExpanded && hasChildren)
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Column(
              children: children
                  .map(
                    (child) => _buildTreeNode(
                      department: child,
                      childrenMap: childrenMap,
                      level: level + 1,
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }

  void _showAddChildDialog(DepartmentEntity parent) {
    showDialog(
      context: context,
      builder: (context) => AddChildDepartmentDialog(parentDepartment: parent),
    );
  }

  void _showMoveDialog(DepartmentEntity department) {
    showDialog(
      context: context,
      builder: (context) => MoveDepartmentDialog(department: department),
    );
  }

  Future<void> _confirmRemoveFromParent(DepartmentEntity department) async {
    final parent = await ref
        .read(departmentHierarchyControllerProvider.notifier)
        .getParentDepartment(department.id);

    if (parent == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This department has no parent'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove from Parent'),
        content: Text(
          'Are you sure you want to remove "${department.name}" from "${parent.name}"?\n\n'
          'This will make it a root department.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref
          .read(departmentHierarchyControllerProvider.notifier)
          .removeRelationship(
            parentId: parent.id,
            childId: department.id,
          );
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
            'Error loading hierarchy',
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
              ref
                  .read(departmentHierarchyControllerProvider.notifier)
                  .loadHierarchy();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
