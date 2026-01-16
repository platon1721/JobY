import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:joby/features/departments/domain/entities/department_type_entity.dart';
import 'package:joby/features/departments/presentation/controllers/department_type_controller.dart';

class CreateDepartmentTypeDialog extends ConsumerStatefulWidget {
  final DepartmentTypeEntity? existingType;

  const CreateDepartmentTypeDialog({
    super.key,
    this.existingType,
  });

  @override
  ConsumerState<CreateDepartmentTypeDialog> createState() => _CreateDepartmentTypeDialogState();
}

class _CreateDepartmentTypeDialogState extends ConsumerState<CreateDepartmentTypeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  bool get isEditing => widget.existingType != null;

  @override
  void initState() {
    super.initState();
    if (widget.existingType != null) {
      _nameController.text = widget.existingType!.name;
      _descriptionController.text = widget.existingType!.description ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    bool success;
    if (isEditing) {
      success = await ref.read(departmentTypeControllerProvider.notifier).updateDepartmentType(
        typeId: widget.existingType!.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      );
    } else {
      success = await ref.read(departmentTypeControllerProvider.notifier).createDepartmentType(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      );
    }

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Edit Department Type' : 'Create Department Type'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Type Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                  hintText: 'e.g., Company, Division, Team',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter type name';
                  }
                  if (value.length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                  hintText: 'What is this type used for?',
                ),
                maxLines: 3,
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
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : Text(isEditing ? 'Save' : 'Create'),
        ),
      ],
    );
  }
}