import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joby/core/domain/entities/permission_entity.dart';
import 'package:joby/core/utils/typedef/permission_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';

/// Model for Permission with Firebase support
class PermissionModel extends PermissionEntity {
  const PermissionModel({
    required super.id,
    required super.code,
    required super.name,
    required super.description,
    required super.createdAt,
    required super.createdBy,
    super.activeTill,
  });

  /// Create PermissionModel from Firebase DocumentSnapshot
  factory PermissionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return PermissionModel(
      id: doc.id,
      code: data['code'] as String,
      name: data['name'] as String,
      description: data['description'] as String,
      createdAt: (data['created_at'] as Timestamp).toDate(),
      createdBy: data['created_by'] as UserId,
      activeTill: data['active_till'] != null
          ? (data['active_till'] as Timestamp).toDate()
          : null,
    );
  }

  /// Create PermissionModel from Map
  factory PermissionModel.fromMap(Map<String, dynamic> map, String id) {
    return PermissionModel(
      id: id,
      code: map['code'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
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
      'code': code,
      'name': name,
      'description': description,
      'created_at': Timestamp.fromDate(createdAt),
      'created_by': createdBy,
      'active_till': activeTill != null ? Timestamp.fromDate(activeTill!) : null,
    };
  }

  /// Create PermissionModel from Entity
  factory PermissionModel.fromEntity(PermissionEntity entity) {
    return PermissionModel(
      id: entity.id,
      code: entity.code,
      name: entity.name,
      description: entity.description,
      createdAt: entity.createdAt,
      createdBy: entity.createdBy,
      activeTill: entity.activeTill,
    );
  }

  /// Copy with new values
  @override
  PermissionModel copyWith({
    PermissionId? id,
    String? code,
    String? name,
    String? description,
    DateTime? createdAt,
    UserId? createdBy,
    DateTime? activeTill,
  }) {
    return PermissionModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      activeTill: activeTill ?? this.activeTill,
    );
  }
}