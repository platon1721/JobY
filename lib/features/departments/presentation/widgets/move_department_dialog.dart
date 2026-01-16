import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:joby/features/departments/domain/entities/department_entity.dart';
import 'package:joby/features/departments/presentation/controllers/department_controller.dart';
import 'package:joby/features/departments/presentation/controllers/department_hierarchy_controller.dart';
import 'package:joby/features/departments/presentation/controllers/department_state.dart';

class MoveDepartmentDialog extends ConsumerStatefulWidget {
  final DepartmentEntity department;

  const MoveDepartmentDialog({
    super.key,
    required this.department,
  });

  @override
  ConsumerState<MoveDepartmentDialog> createState() =>
      _MoveDepartmentDialogState();
}

class _MoveDepartmentDialogState extends ConsumerState<MoveDepartmentDialog> {
  DepartmentEntity? _selectedNewParent;
  List<DepartmentEntity> _availableParents = [];
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;
  DepartmentEntity? _currentParent;

  @override
  void initState() {
    super.initState();
    _loadAvailableParents();
  }

  Future<void> _loadAvailableParents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final hierarchyController =
          ref.read(departmentHierarchyControllerProvider.notifier);

      // Get current parent
      _currentParent =
          await hierarchyController.getParentDepartment(widget.department.id);

      // Get all descendants to exclude them
      final descendants =
          await hierarchyController.getAllDescendants(widget.department.id);
      final descendantIds = descendants.map((d) => d.id).toSet();

      // Load all departments
      await ref.read(departmentControllerProvider.notifier).loadAllDepartments();

      final state = ref.read(departmentControllerProvider);

      state.maybeWhen(
        loaded: (departments) {
          final available = departments.where((dept) {
            // Exclude the department itself
            if (dept.id == widget.department.id) return false;
            // Exclude descendants (prevents circular reference)
            if (descendantIds.contains(dept.id)) return false;
            // Exclude current parent (no point in moving to same parent)
            if (_currentParent != null && dept.id == _currentParent!.id) {
              return false;
            }
            // Only active departments
            if (!dept.isActive) return false;

            return true;
          }).toList();

          if (mounted) {
            setState(() {
              _availableParents = available;
              _isLoading = false;
            });
          }
        },
        error: (message) {
          if (mounted) {
            setState(() {
              _error = message;
              _isLoading = false;
            });
          }
        },
        orElse: () {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _moveDepartment() async {
    if (_selectedNewParent == null) return;

    setState(() => _isSaving = true);

    final success = await ref
        .read(departmentHierarchyControllerProvider.notifier)
        .moveDepartment(
          departmentId: widget.department.id,
          newParentId: _selectedNewParent!.id,
        );

    setState(() => _isSaving = false);

    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Move "${widget.department.name}"'),
      content: SizedBox(
        width: double.maxFinite,
        child: _buildContent(),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed:
              (_isSaving || _selectedNewParent == null) ? null : _moveDepartment,
          child: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Move'),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: Colors.red[300], size: 48),
          const SizedBox(height: 8),
          Text(_error!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _loadAvailableParents,
            child: const Text('Retry'),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Current parent info
        if (_currentParent != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.folder, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Current parent: ${_currentParent!.name}',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.info, color: Colors.orange, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'This is currently a root department (no parent)',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        Text(
          'Select new parent department:',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),

        if (_availableParents.isEmpty) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Icon(Icons.info_outline, color: Colors.grey[400], size: 40),
                const SizedBox(height: 8),
                Text(
                  'No available departments to move to.',
                  style: TextStyle(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ] else ...[
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _availableParents.length,
              itemBuilder: (context, index) {
                final dept = _availableParents[index];
                final isSelected = _selectedNewParent?.id == dept.id;

                return Card(
                  color: isSelected
                      ? Theme.of(context).primaryColor.withOpacity(0.1)
                      : null,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isSelected
                          ? Theme.of(context).primaryColor
                          : _getColorForLevel(dept.hierarchyLevel),
                      child: Text(
                        dept.name.isNotEmpty ? dept.name[0].toUpperCase() : '?',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(dept.name),
                    subtitle: Text(_getLevelName(dept.hierarchyLevel)),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle,
                            color: Theme.of(context).primaryColor,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedNewParent = dept;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],

        if (_selectedNewParent != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.arrow_forward, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '"${widget.department.name}" will be moved under '
                    '"${_selectedNewParent!.name}"',
                    style: const TextStyle(fontSize: 12, color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
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
}
