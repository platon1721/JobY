import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joby/core/utils/typedef/department_type_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/features/departments/domain/entities/department_type_entity.dart';

/// Model for DepartmentType with Firebase support
class DepartmentTypeModel extends DepartmentTypeEntity {
  const DepartmentTypeModel({
    required super.id,
    required super.name,
    super.description,
    required super.createdAt,
    required super.createdBy,
    super.activeTill,
  });

  /// Create DepartmentTypeModel from Firebase DocumentSnapshot
  factory DepartmentTypeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return DepartmentTypeModel(
      id: doc.id,
      name: data['name'] as String,
      description: data['description'] as String?,
      createdAt: (data['created_at'] as Timestamp).toDate(),
      createdBy: data['created_by'] as UserId,
      activeTill: data['active_till'] != null
          ? (data['active_till'] as Timestamp).toDate()
          : null,
    );
  }

  /// Create DepartmentTypeModel from Map
  factory DepartmentTypeModel.fromMap(Map<String, dynamic> map, String id) {
    return DepartmentTypeModel(
      id: id,
      name: map['name'] as String,
      description: map['description'] as String?,
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
      'name': name,
      'description': description,
      'created_at': Timestamp.fromDate(createdAt),
      'created_by': createdBy,
      'active_till': activeTill != null ? Timestamp.fromDate(activeTill!) : null,
    };
  }

  /// Create DepartmentTypeModel from Entity
  factory DepartmentTypeModel.fromEntity(DepartmentTypeEntity entity) {
    return DepartmentTypeModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      createdAt: entity.createdAt,
      createdBy: entity.createdBy,
      activeTill: entity.activeTill,
    );
  }

  /// Copy with new values
  @override
  DepartmentTypeModel copyWith({
    DepartmentTypeId? id,
    String? name,
    String? description,
    DateTime? createdAt,
    UserId? createdBy,
    DateTime? activeTill,
  }) {
    return DepartmentTypeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      activeTill: activeTill ?? this.activeTill,
    );
  }
}