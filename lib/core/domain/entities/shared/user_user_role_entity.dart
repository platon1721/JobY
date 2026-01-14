import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/mixins/auditable.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/core/utils/typedef/user_role_id.dart';
import 'package:joby/core/utils/typedef/user_user_role_id.dart';

/// Entity mapping users to their roles
class UserUserRoleEntity extends Equatable with Auditable {
  final UserUserRoleId id;
  final UserId userId;
  final UserRoleId roleId;

  @override
  final DateTime createdAt;

  @override
  final UserId createdBy;

  @override
  final DateTime? activeTill;

  const UserUserRoleEntity({
    required this.id,
    required this.userId,
    required this.roleId,
    required this.createdAt,
    required this.createdBy,
    this.activeTill,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    roleId,
    createdAt,
    createdBy,
    activeTill,
  ];

  @override
  String toString() => 'UserUserRoleEntity(id: $id, user: $userId, role: $roleId)';

  /// Create a copy with updated fields
  UserUserRoleEntity copyWith({
    UserUserRoleId? id,
    UserId? userId,
    UserRoleId? roleId,
    DateTime? createdAt,
    UserId? createdBy,
    DateTime? activeTill,
  }) {
    return UserUserRoleEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      roleId: roleId ?? this.roleId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      activeTill: activeTill ?? this.activeTill,
    );
  }

  /// Check for active status
  bool get isActive => activeTill == null || activeTill!.isAfter(DateTime.now());

  /// Deactivate this relationship
  UserUserRoleEntity deactivate() {
    return copyWith(activeTill: DateTime.now());
  }
}