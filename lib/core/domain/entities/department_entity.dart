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

  const DepartmentEntity({
    required this.id,
    required this.name,
    required this.typeId,
    this.parentId,
    required this.level
  });

  /// Проверяет, является ли это корневым отделом (компанией)
  bool get isRootDepartment => parentId == null && level == 0;

  /// Check for be delitable
  bool canBeDeleted() {
    // Core department can not be deleted
    if (isRootDepartment) return false;
    // Not active can be deleted
    return activeTill != null;
  }

  /// Chack for active status
  bool get isActiveStatus => activeTill == null;

  @override
  List<Object?> get props => [
    id,
    name,
    typeId,
    parentId,
    level,
    createdBy,
    createdAt,
  ];

  @override
  String toString() => 'DepartmentEntity(id: $id, name: $name, typeId: $typeId, level: $level)';

  @override
  // TODO: implement activeTill
  DateTime? get activeTill => throw UnimplementedError();

  @override
  // TODO: implement createdAt
  DateTime get createdAt => throw UnimplementedError();

  @override
  // TODO: implement createdBy
  UserId get createdBy => throw UnimplementedError();
}