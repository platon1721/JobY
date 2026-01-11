import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/mixins/auditable.dart';
import 'package:joby/core/utils/typedef/department_type_id.dart';
import 'package:joby/core/utils/typedef/department_type_in_type_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';

/// Entity defining which department types can be children of other types
class DepartmentTypeInTypeEntity extends Equatable with Auditable {
  final DepartmentTypeInTypeId id;
  final DepartmentTypeId parentTypeId;
  final DepartmentTypeId childTypeId;

  @override
  final DateTime createdAt;

  @override
  final UserId createdBy;

  @override
  final DateTime? activeTill;

  const DepartmentTypeInTypeEntity({
    required this.id,
    required this.parentTypeId,
    required this.childTypeId,
    required this.createdAt,
    required this.createdBy,
    this.activeTill,
  });

  /// Check if this relationship is active
  bool get isActive => activeTill == null || activeTill!.isAfter(DateTime.now());

  @override
  List<Object?> get props => [
    id,
    parentTypeId,
    childTypeId,
    createdAt,
    createdBy,
    activeTill,
  ];

  @override
  String toString() =>
      'DepartmentTypeInType(id: $id, parent: $parentTypeId, child: $childTypeId)';

  /// Create a copy with updated fields
  DepartmentTypeInTypeEntity copyWith({
    DepartmentTypeInTypeId? id,
    DepartmentTypeId? parentTypeId,
    DepartmentTypeId? childTypeId,
    DateTime? createdAt,
    UserId? createdBy,
    DateTime? activeTill,
  }) {
    return DepartmentTypeInTypeEntity(
      id: id ?? this.id,
      parentTypeId: parentTypeId ?? this.parentTypeId,
      childTypeId: childTypeId ?? this.childTypeId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      activeTill: activeTill ?? this.activeTill,
    );
  }
}