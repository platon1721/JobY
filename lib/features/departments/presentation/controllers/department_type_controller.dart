import 'package:joby/features/auth/presentation/controllers/auth_controller.dart';
import 'package:joby/features/auth/presentation/controllers/auth_state.dart';
import 'package:joby/features/departments/presentation/controllers/department_type_state.dart';
import 'package:joby/features/departments/presentation/providers/department_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'department_type_controller.g.dart';

@riverpod
class DepartmentTypeController extends _$DepartmentTypeController {
  @override
  DepartmentTypeState build() {
    return const DepartmentTypeState.initial();
  }

  Future<void> loadAllDepartmentTypes() async {
    state = const DepartmentTypeState.loading();

    try {
      final repository = ref.read(departmentTypeRepositoryProvider);
      final result = await repository.getAllDepartmentTypes();

      result.fold(
            (error) => state = DepartmentTypeState.error(error.toString()),
            (types) => state = DepartmentTypeState.loaded(types),
      );
    } catch (e) {
      state = DepartmentTypeState.error('Failed to load department types: $e');
    }
  }

  Future<bool> createDepartmentType({
    required String name,
    String? description,
  }) async {
    state = const DepartmentTypeState.loading();

    try {
      final repository = ref.read(departmentTypeRepositoryProvider);

      final authState = ref.read(authControllerProvider);
      String? userId;
      if (authState is AuthStateAuthenticated) {
        userId = authState.user.uid;
      }

      if (userId == null) {
        state = const DepartmentTypeState.error('User not authenticated');
        return false;
      }

      final result = await repository.createDepartmentType(
        name: name,
        description: description,
        createdBy: userId,
      );

      return result.fold(
            (error) {
          state = DepartmentTypeState.error(error.toString());
          return false;
        },
            (type) {
          state = const DepartmentTypeState.success('Department type created successfully');
          Future.delayed(const Duration(milliseconds: 500), () {
            loadAllDepartmentTypes();
          });
          return true;
        },
      );
    } catch (e) {
      state = DepartmentTypeState.error('Failed to create department type: $e');
      return false;
    }
  }

  /// Uuenda department tüüpi
  Future<bool> updateDepartmentType({
    required String typeId,
    String? name,
    String? description,
  }) async {
    state = const DepartmentTypeState.loading();

    try {
      final repository = ref.read(departmentTypeRepositoryProvider);

      final result = await repository.updateDepartmentType(
        typeId: typeId,
        name: name,
        description: description,
      );

      return result.fold(
            (error) {
          state = DepartmentTypeState.error(error.toString());
          return false;
        },
            (type) {
          state = const DepartmentTypeState.success('Department type updated successfully');
          Future.delayed(const Duration(milliseconds: 500), () {
            loadAllDepartmentTypes();
          });
          return true;
        },
      );
    } catch (e) {
      state = DepartmentTypeState.error('Failed to update department type: $e');
      return false;
    }
  }

  /// Deaktiveeri department tüüp
  Future<bool> deactivateDepartmentType(String typeId) async {
    state = const DepartmentTypeState.loading();

    try {
      final repository = ref.read(departmentTypeRepositoryProvider);

      final result = await repository.deactivateDepartmentType(
        typeId: typeId,
        deactivationDate: DateTime.now(),
      );

      return result.fold(
            (error) {
          state = DepartmentTypeState.error(error.toString());
          return false;
        },
            (_) {
          state = const DepartmentTypeState.success('Department type deleted successfully');
          Future.delayed(const Duration(milliseconds: 500), () {
            loadAllDepartmentTypes();
          });
          return true;
        },
      );
    } catch (e) {
      state = DepartmentTypeState.error('Failed to delete department type: $e');
      return false;
    }
  }

  void clearError() {
    if (state is DepartmentTypeStateError) {
      state = const DepartmentTypeState.initial();
    }
  }
}