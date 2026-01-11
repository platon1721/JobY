import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joby/core/domain/entities/user_user_role_entity.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/core/utils/typedef/user_role_id.dart';
import 'package:joby/core/utils/typedef/user_user_role_id.dart';

/// Model for UserUserRole with Firebase support
class UserUserRoleModel extends UserUserRoleEntity {
  const UserUserRoleModel({
    required super.id,
    required super.userId,
    required super.roleId,
    required super.createdAt,
    required super.createdBy,
    super.activeTill,
  });

  /// Create UserUserRoleModel from Firebase DocumentSnapshot
  factory UserUserRoleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserUserRoleModel(
      id: doc.id,
      userId: data['user_id'] as UserId,
      roleId: data['role_id'] as UserRoleId,
      createdAt: (data['created_at'] as Timestamp).toDate(),
      createdBy: data['created_by'] as UserId,
      activeTill: data['active_till'] != null
          ? (data['active_till'] as Timestamp).toDate()
          : null,
    );
  }

  /// Create UserUserRoleModel from Map
  factory UserUserRoleModel.fromMap(Map<String, dynamic> map, String id) {
    return UserUserRoleModel(
      id: id,
      userId: map['user_id'] as UserId,
      roleId: map['role_id'] as UserRoleId,
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
      'user_id': userId,
      'role_id': roleId,
      'created_at': Timestamp.fromDate(createdAt),
      'created_by': createdBy,
      'active_till': activeTill != null ? Timestamp.fromDate(activeTill!) : null,
    };
  }

  /// Create UserUserRoleModel from Entity
  factory UserUserRoleModel.fromEntity(UserUserRoleEntity entity) {
    return UserUserRoleModel(
      id: entity.id,
      userId: entity.userId,
      roleId: entity.roleId,
      createdAt: entity.createdAt,
      createdBy: entity.createdBy,
      activeTill: entity.activeTill,
    );
  }

  /// Copy with new values
  @override
  UserUserRoleModel copyWith({
    UserUserRoleId? id,
    UserId? userId,
    UserRoleId? roleId,
    DateTime? createdAt,
    UserId? createdBy,
    DateTime? activeTill,
  }) {
    return UserUserRoleModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      roleId: roleId ?? this.roleId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      activeTill: activeTill ?? this.activeTill,
    );
  }
}