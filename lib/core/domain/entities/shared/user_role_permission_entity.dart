import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/mixins/auditable.dart';
import 'package:joby/core/utils/typedef/permission_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/core/utils/typedef/user_role_id.dart';
import 'package:joby/core/utils/typedef/user_role_permission_id.dart';

/// Entity mapping permissions to roles
class UserRolePermissionEntity extends Equatable with Auditable {
  final UserRolePermissionId id;
  final UserRoleId roleId;
  final PermissionId permissionId;

  @override
  final DateTime createdAt;

  @override
  final UserId createdBy;

  @override
  final DateTime? activeTill;

  const UserRolePermissionEntity({
    required this.id,
    required this.roleId,
    required this.permissionId,
    required this.createdAt,
    required this.createdBy,
    this.activeTill,
  });


  @override
  List<Object?> get props => [
    id,
    roleId,
    permissionId,
    createdAt,
    createdBy,
    activeTill,
  ];

  @override
  String toString() =>
      'UserRolePermissionEntity(id: $id, role: $roleId, permission: $permissionId)';

  /// Create a copy with updated fields
  UserRolePermissionEntity copyWith({
    UserRolePermissionId? id,
    UserRoleId? roleId,
    PermissionId? permissionId,
    DateTime? createdAt,
    UserId? createdBy,
    DateTime? activeTill,
  }) {
    return UserRolePermissionEntity(
      id: id ?? this.id,
      roleId: roleId ?? this.roleId,
      permissionId: permissionId ?? this.permissionId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      activeTill: activeTill ?? this.activeTill,
    );
  }

  /// Check for active status
  bool get isActive => activeTill == null || activeTill!.isAfter(DateTime.now());

  /// Deactivate this relationship
  UserRolePermissionEntity deactivate() {
    return copyWith(activeTill: DateTime.now());
  }
}