import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/mixins/auditable.dart';
import 'package:joby/core/utils/typedef/department_id.dart';
import 'package:joby/core/utils/typedef/department_type_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';

/// Domain entity for department
class DepartmentEntity extends Equatable with Auditable {
  final DepartmentId id;
  final String name;
  final DepartmentTypeId typeId;
  final DepartmentId? parentId;
  final int level;

  @override
  final DateTime createdAt;

  @override
  final UserId createdBy;

  @override
  final DateTime? activeTill;

  const DepartmentEntity({
    required this.id,
    required this.name,
    required this.typeId,
    this.parentId,
    required this.level,
    required this.createdAt,
    required this.createdBy,
    this.activeTill,
  });

  /// Проверяет, является ли это корневым отделом (компанией)
  bool get isRootDepartment => parentId == null && level == 0;

  /// Check if can be deleted
  bool canBeDeleted() {
    // Root department cannot be deleted
    if (isRootDepartment) return false;
    // Inactive departments can be deleted
    return activeTill != null;
  }

  /// Check for active status
  bool get isActive => activeTill == null || activeTill!.isAfter(DateTime.now());

  @override
  List<Object?> get props => [
    id,
    name,
    typeId,
    parentId,
    level,
    createdBy,
    createdAt,
    activeTill,
  ];

  @override
  String toString() =>
      'DepartmentEntity(id: $id, name: $name, typeId: $typeId, level: $level)';

  /// Create a copy with updated fields
  DepartmentEntity copyWith({
    DepartmentId? id,
    String? name,
    DepartmentTypeId? typeId,
    DepartmentId? parentId,
    int? level,
    DateTime? createdAt,
    UserId? createdBy,
    DateTime? activeTill,
  }) {
    return DepartmentEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      typeId: typeId ?? this.typeId,
      parentId: parentId ?? this.parentId,
      level: level ?? this.level,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      activeTill: activeTill ?? this.activeTill,
    );
  }
}