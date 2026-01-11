import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/mixins/auditable.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/core/utils/typedef/user_role_id.dart';

class UserRoleEntity extends Equatable with Auditable {
  final UserRoleId id;
  final String name;
  final String description;

  @override
  final DateTime createdAt;

  @override
  final UserId createdBy;

  @override
  final DateTime? activeTill;

  const UserRoleEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.createdBy,
    this.activeTill,
  });

  /// Check if role is active
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
  String toString() => 'UserRoleEntity(id: $id, name: $name)';

  /// Create a copy with updated fields
  UserRoleEntity copyWith({
    UserRoleId? id,
    String? name,
    String? description,
    DateTime? createdAt,
    UserId? createdBy,
    DateTime? activeTill,
  }) {
    return UserRoleEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      activeTill: activeTill ?? this.activeTill,
    );
  }
}