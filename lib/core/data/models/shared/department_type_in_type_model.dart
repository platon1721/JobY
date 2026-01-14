import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joby/core/domain/entities/shared/department_type_in_type_entity.dart';
import 'package:joby/core/utils/typedef/department_type_id.dart';
import 'package:joby/core/utils/typedef/department_type_in_type_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';

/// Model for DepartmentTypeInType with Firebase support
class DepartmentTypeInTypeModel extends DepartmentTypeInTypeEntity {
  const DepartmentTypeInTypeModel({
    required super.id,
    required super.parentTypeId,
    required super.childTypeId,
    required super.createdAt,
    required super.createdBy,
    super.activeTill,
  });

  /// Create DepartmentTypeInTypeModel from Firebase DocumentSnapshot
  factory DepartmentTypeInTypeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return DepartmentTypeInTypeModel(
      id: doc.id,
      parentTypeId: data['parent_type_id'] as DepartmentTypeId,
      childTypeId: data['child_type_id'] as DepartmentTypeId,
      createdAt: (data['created_at'] as Timestamp).toDate(),
      createdBy: data['created_by'] as UserId,
      activeTill: data['active_till'] != null
          ? (data['active_till'] as Timestamp).toDate()
          : null,
    );
  }

  /// Create DepartmentTypeInTypeModel from Map
  factory DepartmentTypeInTypeModel.fromMap(Map<String, dynamic> map, String id) {
    return DepartmentTypeInTypeModel(
      id: id,
      parentTypeId: map['parent_type_id'] as DepartmentTypeId,
      childTypeId: map['child_type_id'] as DepartmentTypeId,
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
      'parent_type_id': parentTypeId,
      'child_type_id': childTypeId,
      'created_at': Timestamp.fromDate(createdAt),
      'created_by': createdBy,
      'active_till': activeTill != null ? Timestamp.fromDate(activeTill!) : null,
    };
  }

  /// Create DepartmentTypeInTypeModel from Entity
  factory DepartmentTypeInTypeModel.fromEntity(DepartmentTypeInTypeEntity entity) {
    return DepartmentTypeInTypeModel(
      id: entity.id,
      parentTypeId: entity.parentTypeId,
      childTypeId: entity.childTypeId,
      createdAt: entity.createdAt,
      createdBy: entity.createdBy,
      activeTill: entity.activeTill,
    );
  }

  /// Copy with new values
  @override
  DepartmentTypeInTypeModel copyWith({
    DepartmentTypeInTypeId? id,
    DepartmentTypeId? parentTypeId,
    DepartmentTypeId? childTypeId,
    DateTime? createdAt,
    UserId? createdBy,
    DateTime? activeTill,
  }) {
    return DepartmentTypeInTypeModel(
      id: id ?? this.id,
      parentTypeId: parentTypeId ?? this.parentTypeId,
      childTypeId: childTypeId ?? this.childTypeId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      activeTill: activeTill ?? this.activeTill,
    );
  }
}