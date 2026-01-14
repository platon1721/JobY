import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joby/core/domain/entities/user_role_permission_entity.dart';
import 'package:joby/core/utils/typedef/permission_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/core/utils/typedef/user_role_id.dart';
import 'package:joby/core/utils/typedef/user_role_permission_id.dart';

/// Model for UserRolePermission with Firebase support
class UserRolePermissionModel extends UserRolePermissionEntity {
  const UserRolePermissionModel({
    required super.id,
    required super.roleId,
    required super.permissionId,
    required super.createdAt,
    required super.createdBy,
    super.activeTill,
  });

  /// Create UserRolePermissionModel from Firebase DocumentSnapshot
  factory UserRolePermissionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserRolePermissionModel(
      id: doc.id,
      roleId: data['role_id'] as UserRoleId,
      permissionId: data['permission_id'] as PermissionId,
      createdAt: (data['created_at'] as Timestamp).toDate(),
      createdBy: data['created_by'] as UserId,
      activeTill: data['active_till'] != null
          ? (data['active_till'] as Timestamp).toDate()
          : null,
    );
  }

  /// Create UserRolePermissionModel from Map
  factory UserRolePermissionModel.fromMap(Map<String, dynamic> map, String id) {
    return UserRolePermissionModel(
      id: id,
      roleId: map['role_id'] as UserRoleId,
      permissionId: map['permission_id'] as PermissionId,
      createdAt: (map['created_at'] as Timestamp).toDate(),
      createdBy: map['created_by'] as UserId,
      activeTill: map['active_till'] != null
          ? (map['active_till'] as Timestamp).toDate()
          : null,
    );
  }

  /// Convert to Firestore Map
  Map<String, dynamic> toFirestore() {
    return {
      'role_id': roleId,
      'permission_id': permissionId,
      'created_at': Timestamp.fromDate(createdAt),
      'created_by': createdBy,
      'active_till': activeTill != null ? Timestamp.fromDate(activeTill!) : null,
    };
  }

  /// Create UserRolePermissionModel from Entity
  factory UserRolePermissionModel.fromEntity(UserRolePermissionEntity entity) {
    return UserRolePermissionModel(
      id: entity.id,
      roleId: entity.roleId,
      permissionId: entity.permissionId,
      createdAt: entity.createdAt,
      createdBy: entity.createdBy,
      activeTill: entity.activeTill,
    );
  }

  /// Copy with new values
  @override
  UserRolePermissionModel copyWith({
    UserRolePermissionId? id,
    UserRoleId? roleId,
    PermissionId? permissionId,
    DateTime? createdAt,
    UserId? createdBy,
    DateTime? activeTill,
  }) {
    return UserRolePermissionModel(
      id: id ?? this.id,
      roleId: roleId ?? this.roleId,
      permissionId: permissionId ?? this.permissionId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      activeTill: activeTill ?? this.activeTill,
    );
  }
}