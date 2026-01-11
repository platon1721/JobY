import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/mixins/auditable.dart';
import 'package:joby/core/utils/typedef/department_type_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';

class DepartmentTypeEntity extends Equatable with Auditable {
  final DepartmentTypeId id;
  final String name;
  final String? description;

  @override
  final DateTime createdAt;

  @override
  final UserId createdBy;

  @override
  final DateTime? activeTill;

  const DepartmentTypeEntity({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
    required this.createdBy,
    this.activeTill,
  });

  /// Check if this type is active
  bool get isActive => activeTill == null || activeTill!.isAfter(DateTime.now());

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    createdAt,
    createdBy,
    activeTill,
  ];

  @override
  String toString() => 'DepartmentTypeEntity(id: $id, name: $name)';

  /// Create a copy with updated fields
  DepartmentTypeEntity copyWith({
    DepartmentTypeId? id,
    String? name,
    String? description,
    DateTime? createdAt,
    UserId? createdBy,
    DateTime? activeTill,
  }) {
    return DepartmentTypeEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      activeTill: activeTill ?? this.activeTill,
    );
  }
}