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
  final int hierarchyLevel;

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
    required this.hierarchyLevel,
    required this.createdAt,
    required this.createdBy,
    this.activeTill,
  });

  // TODO: Check if is root department


  ///TODO: Check if can be deleted
  // bool canBeDeleted() {
  //   // Root department cannot be deleted
  //   if (isRootDepartment) return false;
  //   // Inactive departments can be deleted
  //   return activeTill != null;
  // }

  @override
  List<Object?> get props => [
    id,
    name,
    typeId,
    hierarchyLevel,
    createdBy,
    createdAt,
    activeTill,
  ];

  @override
  String toString() =>
      'DepartmentEntity(id: $id, name: $name, typeId: $typeId, hierarchy_level: $hierarchyLevel)';

  /// Create a copy with updated fields
  DepartmentEntity copyWith({
    DepartmentId? id,
    String? name,
    DepartmentTypeId? typeId,
    DepartmentId? parentId,
    int? hierarchyLevel,
    DateTime? createdAt,
    UserId? createdBy,
    DateTime? activeTill,
  }) {
    return DepartmentEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      typeId: typeId ?? this.typeId,
      hierarchyLevel: hierarchyLevel ?? this.hierarchyLevel,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      activeTill: activeTill ?? this.activeTill,
    );
  }

  /// Check for active status
  bool get isActive => activeTill == null || activeTill!.isAfter(DateTime.now());

  /// Deactivate this relationship
  DepartmentEntity deactivate() {
    return copyWith(activeTill: DateTime.now());
  }

  /// TODO: implement logic for safe delete. If department has children, if department has users, etc.

}