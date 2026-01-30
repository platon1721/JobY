import 'package:joby/features/auth/presentation/controllers/auth_controller.dart';
import 'package:joby/features/auth/presentation/controllers/auth_state.dart';
import 'package:joby/features/permissions/presentation/controllers/role_state.dart';
import 'package:joby/features/permissions/presentation/providers/permissions_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'role_controller.g.dart';

@riverpod
class RoleController extends _$RoleController {
  @override
  RoleState build() {
    return const RoleState.initial();
  }

  Future<void> loadAllRoles() async {
    state = const RoleState.loading();

    try {
      final roleRepository = ref.read(userRoleRepositoryProvider);
      final result = await roleRepository.getAllRoles();

      result.fold(
        (error) => state = RoleState.error(error.toString()),
        (roles) => state = RoleState.loaded(roles),
      );
    } catch (e) {
      state = RoleState.error('Error: $e');
    }
  }

  Future<void> loadRoleById(String roleId) async {
    state = const RoleState.loading();

    try {
      final roleRepository = ref.read(userRoleRepositoryProvider);
      final permissionRepository = ref.read(permissionRepositoryProvider);

      final roleResult = await roleRepository.getRoleById(roleId);

      await roleResult.fold(
        (error) async => state = RoleState.error(error.toString()),
        (role) async {
          final permissionsResult = await permissionRepository.getAllPermissions();
          
          permissionsResult.fold(
            (error) => state = RoleState.error(error.toString()),
            (permissions) => state = RoleState.detail(
              role: role,
              permissions: permissions,
            ),
          );
        },
      );
    } catch (e) {
      state = RoleState.error('error: $e');
    }
  }

  Future<bool> createRole({
    required String name,
    required String description,
  }) async {
    state = const RoleState.loading();

    try {
      final roleRepository = ref.read(userRoleRepositoryProvider);
      
      final authState = ref.read(authControllerProvider);
      String? userId;
      if (authState is AuthStateAuthenticated) {
        userId = authState.user.uid;
      }

      if (userId == null) {
        state = const RoleState.error('Error');
        return false;
      }

      final result = await roleRepository.createRole(
        name: name,
        description: description,
        createdBy: userId,
      );

      return result.fold(
        (error) {
          state = RoleState.error(error.toString());
          return false;
        },
        (role) {
          state = const RoleState.success('Nice');
          Future.delayed(const Duration(milliseconds: 500), () {
            loadAllRoles();
          });
          return true;
        },
      );
    } catch (e) {
      state = RoleState.error('Errors: $e');
      return false;
    }
  }

  void clearError() {
    if (state is RoleStateError) {
      state = const RoleState.initial();
    }
  }
}
