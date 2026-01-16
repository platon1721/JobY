import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:joby/features/departments/domain/entities/department_type_entity.dart';
import 'package:joby/features/departments/presentation/controllers/department_controller.dart';
import 'package:joby/features/departments/presentation/providers/department_providers.dart';

class CreateDepartmentDialog extends ConsumerStatefulWidget {
  const CreateDepartmentDialog({super.key});

  @override
  ConsumerState<CreateDepartmentDialog> createState() => _CreateDepartmentDialogState();
}

class _CreateDepartmentDialogState extends ConsumerState<CreateDepartmentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  DepartmentTypeEntity? _selectedType;
  int _selectedLevel = 0;
  bool _isLoading = false;
  bool _isLoadingTypes = true;
  List<DepartmentTypeEntity> _departmentTypes = [];
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadDepartmentTypes();
  }

  Future<void> _loadDepartmentTypes() async {
    setState(() {
      _isLoadingTypes = true;
      _loadError = null;
    });

    try {
      final repository = ref.read(departmentTypeRepositoryProvider);
      final result = await repository.getAllDepartmentTypes();

      result.fold(
            (error) {
          setState(() {
            _loadError = error.toString();
            _isLoadingTypes = false;
          });
        },
            (types) {
          setState(() {
            _departmentTypes = types;
            _isLoadingTypes = false;
            // Vali esimene tüüp vaikimisi kui on olemas
            if (types.isNotEmpty) {
              _selectedType = types.first;
            }
          });
        },
      );
    } catch (e) {
      setState(() {
        _loadError = e.toString();
        _isLoadingTypes = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createDepartment() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a department type'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final success = await ref.read(departmentControllerProvider.notifier).createDepartment(
      name: _nameController.text.trim(),
      typeId: _selectedType!.id,
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
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Department Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Department Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.business),
                    hintText: 'e.g., Engineering, Sales, HR',
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

                // Department Type Dropdown
                if (_isLoadingTypes)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (_loadError != null)
                  Column(
                    children: [
                      Text(
                        'Failed to load types: $_loadError',
                        style: const TextStyle(color: Colors.red),
                      ),
                      TextButton(
                        onPressed: _loadDepartmentTypes,
                        child: const Text('Retry'),
                      ),
                    ],
                  )
                else if (_departmentTypes.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.warning, color: Colors.orange),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'No department types available. Please create a department type first.',
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    DropdownButtonFormField<DepartmentTypeEntity>(
                      value: _selectedType,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Department Type',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                      ),
                      items: _departmentTypes.map((type) {
                        return DropdownMenuItem<DepartmentTypeEntity>(
                          value: type,
                          child: Text(type.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value;
                          _selectedLevel = _getDefaultLevelForType(value?.name ?? '');
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a department type';
                        }
                        return null;
                      },
                    ),

                // Show selected type description
                if (_selectedType?.description != null && _selectedType!.description!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: Text(
                      _selectedType!.description!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Hierarchy Level
                DropdownButtonFormField<int>(
                  value: _selectedLevel,
                  decoration: const InputDecoration(
                    labelText: 'Hierarchy Level',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.layers),
                    helperText: 'Lower number = higher in organization',
                  ),
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('0 - Top Level (Company)')),
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
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: (_isLoading || _departmentTypes.isEmpty) ? null : _createDepartment,
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

  int _getDefaultLevelForType(String name) {
    final nameLower = name.toLowerCase();
    if (nameLower.contains('company')) return 0;
    if (nameLower.contains('division')) return 1;
    if (nameLower.contains('department')) return 2;
    if (nameLower.contains('team')) return 3;
    if (nameLower.contains('unit')) return 4;
    return 2; // Default to department level
  }
}