import 'package:joby/features/auth/presentation/controllers/auth_controller.dart';
import 'package:joby/features/auth/presentation/controllers/auth_state.dart';
import 'package:joby/features/permissions/presentation/controllers/role_state.dart';
import 'package:joby/features/permissions/presentation/providers/permissions_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'role_controller.g.dart';

/// RoleController - haldab rollide olekut ja operatsioone
@riverpod
class RoleController extends _$RoleController {
  @override
  RoleState build() {
    return const RoleState.initial();
  }

  /// Laadi kõik rollid
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
      state = RoleState.error('Rollide laadimine ebaõnnestus: $e');
    }
  }

  /// Laadi roll ID järgi koos õigustega
  Future<void> loadRoleById(String roleId) async {
    state = const RoleState.loading();

    try {
      final roleRepository = ref.read(userRoleRepositoryProvider);
      final permissionRepository = ref.read(permissionRepositoryProvider);

      final roleResult = await roleRepository.getRoleById(roleId);

      await roleResult.fold(
        (error) async => state = RoleState.error(error.toString()),
        (role) async {
          // Laadi ka õigused
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
      state = RoleState.error('Rolli laadimine ebaõnnestus: $e');
    }
  }

  /// Loo uus roll
  Future<bool> createRole({
    required String name,
    required String description,
  }) async {
    state = const RoleState.loading();

    try {
      final roleRepository = ref.read(userRoleRepositoryProvider);
      
      // Võta kasutaja ID auth staatusest
      final authState = ref.read(authControllerProvider);
      String? userId;
      if (authState is AuthStateAuthenticated) {
        userId = authState.user.uid;
      }

      if (userId == null) {
        state = const RoleState.error('Kasutaja pole autentitud');
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
          state = const RoleState.success('Roll edukalt loodud');
          // Laadi uuesti nimekiri
          Future.delayed(const Duration(milliseconds: 500), () {
            loadAllRoles();
          });
          return true;
        },
      );
    } catch (e) {
      state = RoleState.error('Rolli loomine ebaõnnestus: $e');
      return false;
    }
  }

  /// Puhasta viga olek
  void clearError() {
    if (state is RoleStateError) {
      state = const RoleState.initial();
    }
  }
}
