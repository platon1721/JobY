import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joby/core/domain/entities/shared/department_in_department_entity.dart';
import 'package:joby/core/utils/typedef/department_id.dart';
import 'package:joby/core/utils/typedef/department_in_department_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';

/// Model for DepartmentInDepartment with Firebase support
class DepartmentInDepartmentModel extends DepartmentInDepartmentEntity {
  const DepartmentInDepartmentModel({
    required super.id,
    required super.parentId,
    required super.childId,
    required super.createdAt,
    required super.createdBy,
    super.activeTill,
  });

  /// Create DepartmentInDepartmentModel from Firebase DocumentSnapshot
  factory DepartmentInDepartmentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return DepartmentInDepartmentModel(
      id: doc.id,
      parentId: data['parent_id'] as DepartmentId,
      childId: data['child_id'] as DepartmentId,
      createdAt: (data['created_at'] as Timestamp).toDate(),
      createdBy: data['created_by'] as UserId,
      activeTill: data['active_till'] != null
          ? (data['active_till'] as Timestamp).toDate()
          : null,
    );
  }

  /// Create DepartmentInDepartmentModel from Map
  factory DepartmentInDepartmentModel.fromMap(Map<String, dynamic> map, String id) {
    return DepartmentInDepartmentModel(
      id: id,
      parentId: map['parent_id'] as DepartmentId,
      childId: map['child_id'] as DepartmentId,
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
      'parent_id': parentId,
      'child_id': childId,
      'created_at': Timestamp.fromDate(createdAt),
      'created_by': createdBy,
      'active_till': activeTill != null ? Timestamp.fromDate(activeTill!) : null,
    };
  }

  /// Create DepartmentInDepartmentModel from Entity
  factory DepartmentInDepartmentModel.fromEntity(
    DepartmentInDepartmentEntity entity,
  ) {
    return DepartmentInDepartmentModel(
      id: entity.id,
      parentId: entity.parentId,
      childId: entity.childId,
      createdAt: entity.createdAt,
      createdBy: entity.createdBy,
      activeTill: entity.activeTill,
    );
  }

  /// Copy with new values
  @override
  DepartmentInDepartmentModel copyWith({
    DepartmentInDepartmentId? id,
    DepartmentId? parentId,
    DepartmentId? childId,
    DateTime? createdAt,
    UserId? createdBy,
    DateTime? activeTill,
  }) {
    return DepartmentInDepartmentModel(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      childId: childId ?? this.childId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      activeTill: activeTill ?? this.activeTill,
    );
  }
}
