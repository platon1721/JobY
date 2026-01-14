import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joby/core/domain/entities/shared/department_user_entity.dart';
import 'package:joby/core/utils/typedef/department_id.dart';
import 'package:joby/core/utils/typedef/department_user_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/core/utils/typedef/user_role_id.dart';

/// Model for DepartmentUser with Firebase support
class DepartmentUserModel extends DepartmentUserEntity {
  const DepartmentUserModel({
    required super.id,
    required super.departmentId,
    required super.userId,
    required super.roleId,
    required super.createdAt,
    required super.createdBy,
    super.activeTill,
  });

  /// Create DepartmentUserModel from Firebase DocumentSnapshot
  factory DepartmentUserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return DepartmentUserModel(
      id: doc.id,
      departmentId: data['department_id'] as DepartmentId,
      userId: data['user_id'] as UserId,
      roleId: data['role_id'] as UserRoleId,
      createdAt: (data['created_at'] as Timestamp).toDate(),
      createdBy: data['created_by'] as UserId,
      activeTill: data['active_till'] != null
          ? (data['active_till'] as Timestamp).toDate()
          : null,
    );
  }

  /// Create DepartmentUserModel from Map
  factory DepartmentUserModel.fromMap(Map<String, dynamic> map, String id) {
    return DepartmentUserModel(
      id: id,
      departmentId: map['department_id'] as DepartmentId,
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
      'department_id': departmentId,
      'user_id': userId,
      'role_id': roleId,
      'created_at': Timestamp.fromDate(createdAt),
      'created_by': createdBy,
      'active_till': activeTill != null ? Timestamp.fromDate(activeTill!) : null,
    };
  }

  /// Create DepartmentUserModel from Entity
  factory DepartmentUserModel.fromEntity(DepartmentUserEntity entity) {
    return DepartmentUserModel(
      id: entity.id,
      departmentId: entity.departmentId,
      userId: entity.userId,
      roleId: entity.roleId,
      createdAt: entity.createdAt,
      createdBy: entity.createdBy,
      activeTill: entity.activeTill,
    );
  }

  /// Copy with new values
  @override
  DepartmentUserModel copyWith({
    DepartmentUserId? id,
    DepartmentId? departmentId,
    UserId? userId,
    UserRoleId? roleId,
    DateTime? createdAt,
    UserId? createdBy,
    DateTime? activeTill,
  }) {
    return DepartmentUserModel(
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