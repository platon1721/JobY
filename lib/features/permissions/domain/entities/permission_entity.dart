import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/enums/permission.dart';
import 'package:joby/core/domain/mixins/auditable.dart';
import 'package:joby/core/utils/typedef/permission_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';

/// Domain entity for permissions
class PermissionEntity extends Equatable with Auditable {
  final PermissionId id;
  final String code;
  final String name;
  final String description;

  @override
  final DateTime createdAt;

  @override
  final UserId createdBy;

  @override
  final DateTime? activeTill;

  const PermissionEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.createdBy,
    this.activeTill,
  });

  /// Get the Permission enum value for this entity
  Permission? get permissionEnum => Permission.fromCode(code);

  @override
  List<Object?> get props => [
    id,
    code,
    name,
    description,
    createdAt,
    createdBy,
    activeTill,
  ];

  @override
  String toString() => 'PermissionEntity(id: $id, code: $code, name: $name)';

  /// Create a copy with updated fields
  PermissionEntity copyWith({
    PermissionId? id,
    String? code,
    String? name,
    String? description,
    DateTime? createdAt,
    UserId? createdBy,
    DateTime? activeTill,
  }) {
    return PermissionEntity(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      activeTill: activeTill ?? this.activeTill,
    );
  }

  /// Check for active status
  bool get isActive => activeTill == null || activeTill!.isAfter(DateTime.now());

  /// Deactivate this relationship
  PermissionEntity deactivate() {
    return copyWith(activeTill: DateTime.now());
  }

  /// TODO: implement logic for safe delete. If permission is assigned to roles, delete with permission user_role_permissions

}