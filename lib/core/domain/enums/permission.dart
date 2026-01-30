/// Hardcoded system permissions
enum Permission {
  // Department permissions
  departmentCreate('department.create', 'Create departments'),
  departmentRead('department.read', 'View departments'),
  departmentUpdate('department.update', 'Update departments'),
  departmentDelete('department.delete', 'Delete departments'),

  // User management permissions
  userCreate('user.create', 'Create users'),
  userRead('user.read', 'View users'),
  userUpdate('user.update', 'Update users'),
  userDelete('user.delete', 'Delete users'),
  userAssignRole('user.assign_role', 'Assign roles to users'),

  // Role management permissions
  roleCreate('role.create', 'Create roles'),
  roleRead('role.read', 'View roles'),
  roleUpdate('role.update', 'Update roles'),
  roleDelete('role.delete', 'Delete roles'),
  roleAssignPermission('role.assign_permission', 'Assign permissions to roles'),

  // Department type permissions
  departmentTypeCreate('department_type.create', 'Create department types'),
  departmentTypeRead('department_type.read', 'View department types'),
  departmentTypeUpdate('department_type.update', 'Update department types'),
  departmentTypeDelete('department_type.delete', 'Delete department types'),

  // Report permissions
  reportGenerate('report.generate', 'Generate reports'),
  reportView('report.view', 'View reports'),
  reportExport('report.export', 'Export reports');

  final String code;
  final String description;

  const Permission(this.code, this.description);

  /// Get permission by code
  static Permission? fromCode(String code) {
    try {
      return Permission.values.firstWhere((p) => p.code == code);
    } catch (e) {
      return null;
    }
  }

  /// Check if this permission allows the action
  bool allows(String action) => code == action;
}