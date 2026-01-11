import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/mixins/auditable.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/core/utils/typedef/user_role_id.dart';

class UserRoleEntity extends Equatable with Auditable{
  final UserRoleId id;
  final String name;
  final String description;
  const UserRoleEntity({
    required this.id,
    required this.name,
    required this.description,
  });


  @override
  DateTime? get activeTill => throw UnimplementedError();
  @override
  DateTime get createdAt => throw UnimplementedError();
  @override
  UserId get createdBy => throw UnimplementedError();
  @override
  List<Object?> get props => throw UnimplementedError();}