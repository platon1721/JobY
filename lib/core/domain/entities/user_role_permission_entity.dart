import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/mixins/auditable.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/core/utils/typedef/user_role_id.dart';
import 'package:joby/core/utils/typedef/user_role_permission_id.dart';

class UserRolePermissionEntity extends Equatable with Auditable{
  final UserRolePermissionId id;
  final UserRoleId roleId;

  // TODO: implement permissionId


  const UserRolePermissionEntity({
    required this.id,
    required this.roleId,

  });


  @override
  DateTime? get activeTill => throw UnimplementedError();
  @override
  DateTime get createdAt => throw UnimplementedError();
  @override
  UserId get createdBy => throw UnimplementedError();
  @override
  List<Object?> get props => throw UnimplementedError();
}
