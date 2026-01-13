import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joby/core/domain/entities/department_entity.dart';
import 'package:joby/core/utils/typedef/department_id.dart';
import 'package:joby/core/utils/typedef/department_type_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';

/// Model for Department with Firebase support
class DepartmentModel extends DepartmentEntity {
  const DepartmentModel({
    required super.id,
    required super.name,
    required super.typeId,
    required super.level,
    required super.createdAt,
    required super.createdBy,
    super.activeTill,
  });

  /// Create DepartmentModel from Firebase DocumentSnapshot
  factory DepartmentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return DepartmentModel(
      id: doc.id,
      name: data['name'] as String,
      typeId: data['type_id'] as DepartmentTypeId,
      level: data['level'] as int,
      createdAt: (data['created_at'] as Timestamp).toDate(),
      createdBy: data['created_by'] as UserId,
      activeTill: data['active_till'] != null
          ? (data['active_till'] as Timestamp).toDate()
          : null,
    );
  }

  /// Create DepartmentModel from Map
  factory DepartmentModel.fromMap(Map<String, dynamic> map, String id) {
    return DepartmentModel(
      id: id,
      name: map['name'] as String,
      typeId: map['type_id'] as DepartmentTypeId,
      level: map['level'] as int,
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
      'type_id': typeId,
      'level': level,
      'created_at': Timestamp.fromDate(createdAt),
      'created_by': createdBy,
      'active_till': activeTill != null ? Timestamp.fromDate(activeTill!) : null,
    };
  }

  /// Create DepartmentModel from Entity
  factory DepartmentModel.fromEntity(DepartmentEntity entity) {
    return DepartmentModel(
      id: entity.id,
      name: entity.name,
      typeId: entity.typeId,
      level: entity.level,
      createdAt: entity.createdAt,
      createdBy: entity.createdBy,
      activeTill: entity.activeTill,
    );
  }

  /// Copy with new values
  @override
  DepartmentModel copyWith({
    DepartmentId? id,
    String? name,
    DepartmentTypeId? typeId,
    DepartmentId? parentId,
    int? level,
    DateTime? createdAt,
    UserId? createdBy,
    DateTime? activeTill,
  }) {
    return DepartmentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      typeId: typeId ?? this.typeId,
      level: level ?? this.level,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      activeTill: activeTill ?? this.activeTill,
    );
  }
}