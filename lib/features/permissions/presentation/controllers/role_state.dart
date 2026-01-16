import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:joby/features/permissions/domain/entities/permission_entity.dart';
import 'package:joby/features/permissions/domain/entities/user_role_entity.dart';

part 'role_state.freezed.dart';

@freezed
class RoleState with _$RoleState {
  const factory RoleState.initial() = RoleStateInitial;
  const factory RoleState.loading() = RoleStateLoading;
  const factory RoleState.loaded(List<UserRoleEntity> roles) = RoleStateLoaded;
  const factory RoleState.detail({
    required UserRoleEntity role,
    required List<PermissionEntity> permissions,
  }) = RoleStateDetail;
  const factory RoleState.success(String message) = RoleStateSuccess;
  const factory RoleState.error(String message) = RoleStateError;
}
