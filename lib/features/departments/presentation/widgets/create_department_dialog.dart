import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:joby/features/departments/presentation/controllers/department_controller.dart';

class CreateDepartmentDialog extends ConsumerStatefulWidget {
  const CreateDepartmentDialog({super.key});

  @override
  ConsumerState<CreateDepartmentDialog> createState() => _CreateDepartmentDialogState();
}

class _CreateDepartmentDialogState extends ConsumerState<CreateDepartmentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeIdController = TextEditingController();
  int _selectedLevel = 0;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _typeIdController.dispose();
    super.dispose();
  }

  Future<void> _createDepartment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final success = await ref.read(departmentControllerProvider.notifier).createDepartment(
      name: _nameController.text.trim(),
      typeId: _typeIdController.text.trim(),
      hierarchyLevel: _selectedLevel,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Department'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Department Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter department name';
                  }
                  if (value.length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _typeIdController,
                decoration: const InputDecoration(
                  labelText: 'Type ID',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                  hintText: 'e.g., company, division, team',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter type ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _selectedLevel,
                decoration: const InputDecoration(
                  labelText: 'Hierarchy Level',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.layers),
                ),
                items: const [
                  DropdownMenuItem(value: 0, child: Text('0 - Company')),
                  DropdownMenuItem(value: 1, child: Text('1 - Division')),
                  DropdownMenuItem(value: 2, child: Text('2 - Department')),
                  DropdownMenuItem(value: 3, child: Text('3 - Team')),
                  DropdownMenuItem(value: 4, child: Text('4 - Sub-team')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedLevel = value);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _createDepartment,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create'),
        ),
      ],
    );
  }
}
