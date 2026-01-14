import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/mixins/auditable.dart';
import 'package:joby/core/utils/typedef/department_id.dart';
import 'package:joby/core/utils/typedef/department_in_department_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';

class DepartmentInDepartmentEntity extends Equatable with Auditable {
  final DepartmentInDepartmentId id;
  final DepartmentId parentId;
  final DepartmentId childId;
  @override
  final DateTime createdAt;
  @override
  final UserId createdBy;
  @override
  final DateTime? activeTill;

  const DepartmentInDepartmentEntity({
    required this.id,
    required this.parentId,
    required this.childId,
    required this.createdAt,
    required this.createdBy,
    this.activeTill,
  });

  @override
  List<Object?> get props => [
    id,
    parentId,
    childId,
    createdAt,
    createdBy,
    activeTill,
  ];

  @override
  String toString() =>
      'DepartmentInDepartmentEntity(id: $id, parentId: $parentId, childId: $childId)';

  /// Copy with method for creating modified instances
  DepartmentInDepartmentEntity copyWith({
    DepartmentInDepartmentId? id,
    DepartmentId? parentId,
    DepartmentId? childId,
    DateTime? createdAt,
    UserId? createdBy,
    DateTime? activeTill,
  }) {
    return DepartmentInDepartmentEntity(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      childId: childId ?? this.childId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      activeTill: activeTill ?? this.activeTill,
    );
  }

  /// Check for active status
  bool get isActive =>
      activeTill == null || activeTill!.isAfter(DateTime.now());

  /// Deactivate this relationship
  DepartmentInDepartmentEntity deactivate() {
    return copyWith(activeTill: DateTime.now());
  }
}
