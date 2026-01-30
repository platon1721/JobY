import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:joby/features/departments/domain/entities/department_entity.dart';
import 'package:joby/features/departments/presentation/controllers/department_controller.dart';
import 'package:joby/features/departments/presentation/controllers/department_hierarchy_controller.dart';
import 'package:joby/features/departments/presentation/controllers/department_hierarchy_state.dart';
import 'package:joby/features/departments/presentation/controllers/department_state.dart';
import 'package:joby/features/departments/presentation/providers/department_providers.dart';

class AddChildDepartmentDialog extends ConsumerStatefulWidget {
  final DepartmentEntity parentDepartment;

  const AddChildDepartmentDialog({
    super.key,
    required this.parentDepartment,
  });

  @override
  ConsumerState<AddChildDepartmentDialog> createState() =>
      _AddChildDepartmentDialogState();
}

class _AddChildDepartmentDialogState
    extends ConsumerState<AddChildDepartmentDialog> {
  DepartmentEntity? _selectedDepartment;
  List<DepartmentEntity> _availableDepartments = [];
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadAvailableDepartments());
  }


  Future<void> _loadAvailableDepartments() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repository = ref.read(departmentRepositoryProvider);
      final result = await repository.getAllDepartments();

      if (result.isLeft()) {
        if (mounted) {
          setState(() {
            _error = result.fold((l) => l.toString(), (r) => '');
            _isLoading = false;
          });
        }
        return;
      }

      final departments = result.fold((l) => <DepartmentEntity>[], (r) => r);

      final hierarchyController =
      ref.read(departmentHierarchyControllerProvider.notifier);

      final descendants =
      await hierarchyController.getAllDescendants(widget.parentDepartment.id);
      final descendantIds = descendants.map((d) => d.id).toSet();

      final parentResult = await hierarchyController.getParentDepartment(widget.parentDepartment.id);
      Set<String> ancestorIds = {widget.parentDepartment.id};

      DepartmentEntity? current = parentResult;
      while (current != null) {
        ancestorIds.add(current.id);
        current = await hierarchyController.getParentDepartment(current.id);
      }

      final available = departments.where((dept) {
        if (dept.id == widget.parentDepartment.id) return false;
        if (descendantIds.contains(dept.id)) return false;
        if (ancestorIds.contains(dept.id)) return false;
        if (!dept.isActive) return false;

        return true;
      }).toList();

      if (mounted) {
        setState(() {
          _availableDepartments = available;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _addChild() async {
    if (_selectedDepartment == null) return;

    setState(() => _isSaving = true);

    final success = await ref
        .read(departmentHierarchyControllerProvider.notifier)
        .createRelationship(
      parentId: widget.parentDepartment.id,
      childId: _selectedDepartment!.id,
    );

    setState(() => _isSaving = false);

    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Child to "${widget.parentDepartment.name}"'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400, // Fixed height to prevent overflow
        child: _buildContent(),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed:
          (_isSaving || _selectedDepartment == null) ? null : _addChild,
          child: _isSaving
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Text('Add as Child'),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: Colors.red[300], size: 48),
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _loadAvailableDepartments,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_availableDepartments.isEmpty) {
      return SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info_outline, color: Colors.grey[400], size: 48),
                const SizedBox(height: 8),
                Text(
                  'No available departments to add as children.\n'
                      'Create new departments first or check if all departments '
                      'are already in the hierarchy.',
                  style: TextStyle(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select a department to add as a child:',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: _availableDepartments.length,
            itemBuilder: (context, index) {
              final dept = _availableDepartments[index];
              final isSelected = _selectedDepartment?.id == dept.id;

              return Card(
                color: isSelected
                    ? Theme.of(context).primaryColor.withOpacity(0.1)
                    : null,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey[300],
                    child: Text(
                      dept.name.isNotEmpty ? dept.name[0].toUpperCase() : '?',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  ),
                  title: Text(dept.name),
                  subtitle: Text('Level ${dept.hierarchyLevel}'),
                  trailing: isSelected
                      ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).primaryColor,
                  )
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedDepartment = dept;
                    });
                  },
                ),
              );
            },
          ),
        ),
        if (_selectedDepartment != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '"${_selectedDepartment!.name}" will become a child of '
                        '"${widget.parentDepartment.name}"',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}