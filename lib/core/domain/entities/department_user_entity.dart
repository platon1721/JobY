

import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/mixins/auditable.dart';
import 'package:joby/core/utils/typedef/department_id.dart';
import 'package:joby/core/utils/typedef/department_user_id.dart';
import 'package:joby/core/utils/typedef/user_role_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';

class DepartmentUserEntity extends Equatable with Auditable{
  final DepartmentUserId id;
  final DepartmentId departmentId;
  final UserId userId;
  final UserRoleId role;
  const DepartmentUserEntity({
    required this.id,
    required this.departmentId,
    required this.userId,
    required this.role,
  });

  @override
  // TODO: implement activeTill
  DateTime? get activeTill => throw UnimplementedError();

  @override
  // TODO: implement createdAt
  DateTime get createdAt => throw UnimplementedError();

  @override
  // TODO: implement createdBy
  UserId get createdBy => throw UnimplementedError();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}