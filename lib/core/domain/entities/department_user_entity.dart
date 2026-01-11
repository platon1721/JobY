import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/mixins/auditable.dart';
import 'package:joby/core/utils/typedef/department_id.dart';
import 'package:joby/core/utils/typedef/department_user_id.dart';
import 'package:joby/core/utils/typedef/user_role_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';

/// Entity representing user membership in a department with a specific role
class DepartmentUserEntity extends Equatable with Auditable {
  final DepartmentUserId id;
  final DepartmentId departmentId;
  final UserId userId;
  final UserRoleId roleId;

  @override
  final DateTime createdAt;

  @override
  final UserId createdBy;

  @override
  final DateTime? activeTill;

  const DepartmentUserEntity({
    required this.id,
    required this.departmentId,
    required this.userId,
    required this.roleId,
    required this.createdAt,
    required this.createdBy,
    this.activeTill,
  });

  /// Check if this membership is active
  bool get isActive => activeTill == null || activeTill!.isAfter(DateTime.now());

  @override
  List<Object?> get props => [
    id,
    departmentId,
    userId,
    roleId,
    createdAt,
    createdBy,
    activeTill,
  ];

  @override
  String toString() =>
      'DepartmentUserEntity(id: $id, dept: $departmentId, user: $userId, role: $roleId)';

  /// Create a copy with updated fields
  DepartmentUserEntity copyWith({
    DepartmentUserId? id,
    DepartmentId? departmentId,
    UserId? userId,
    UserRoleId? roleId,
    DateTime? createdAt,
    UserId? createdBy,
    DateTime? activeTill,
  }) {
    return DepartmentUserEntity(
      id: id ?? this.id,
      departmentId: departmentId ?? this.departmentId,
      userId: userId ?? this.userId,
      roleId: roleId ?? this.roleId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      activeTill: activeTill ?? this.activeTill,
    );
  }
}