import 'package:joby/features/auth/presentation/controllers/auth_controller.dart';
import 'package:joby/features/auth/presentation/controllers/auth_state.dart';
import 'package:joby/features/departments/domain/entities/department_entity.dart';
import 'package:joby/features/departments/domain/use_cases/create_department_use_case.dart';
import 'package:joby/features/departments/domain/use_cases/get_all_departments_use_case.dart';
import 'package:joby/features/departments/domain/use_cases/get_department_by_id_use_case.dart';
import 'package:joby/features/departments/presentation/controllers/department_state.dart';
import 'package:joby/features/departments/presentation/providers/department_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'department_controller.g.dart';

/// DepartmentController - haldab osakondade olekut ja operatsioone
@riverpod
class DepartmentController extends _$DepartmentController {
  @override
  DepartmentState build() {
    return const DepartmentState.initial();
  }

  /// Laadi kõik osakonnad
  Future<void> loadAllDepartments() async {
    state = const DepartmentState.loading();

    try {
      final getAllDepartmentsUseCase = ref.read(getAllDepartmentsUseCaseProvider);
      final result = await getAllDepartmentsUseCase();

      result.fold(
            (error) => state = DepartmentState.error(error.toString()),
            (departments) => state = DepartmentState.loaded(departments),
      );
    } catch (e) {
      state = DepartmentState.error('Osakondade laadimine ebaõnnestus: $e');
    }
  }

  /// Laadi osakond ID järgi
  Future<void> loadDepartmentById(String departmentId) async {
    state = const DepartmentState.loading();

    try {
      final getDepartmentByIdUseCase = ref.read(getDepartmentByIdUseCaseProvider);
      final result = await getDepartmentByIdUseCase(
        GetDepartmentByIdParams(departmentId: departmentId),
      );

      result.fold(
            (error) => state = DepartmentState.error(error.toString()),
            (department) => state = DepartmentState.detail(department),
      );
    } catch (e) {
      state = DepartmentState.error('Osakonna laadimine ebaõnnestus: $e');
    }
  }

  /// Loo uus osakond
  Future<bool> createDepartment({
    required String name,
    required String typeId,
    required int hierarchyLevel,
  }) async {
    state = const DepartmentState.loading();

    try {
      final createDepartmentUseCase = ref.read(createDepartmentUseCaseProvider);

      // Võta kasutaja ID auth staatusest
      final authState = ref.read(authControllerProvider);
      String? userId;
      if (authState is AuthStateAuthenticated) {
        userId = authState.user.uid;
      }

      if (userId == null) {
        state = const DepartmentState.error('Kasutaja pole autentitud');
        return false;
      }

      final result = await createDepartmentUseCase(
        CreateDepartmentParams(
          name: name,
          typeId: typeId,
          hierarchyLevel: hierarchyLevel,
          createdBy: userId,
        ),
      );

      return result.fold(
            (error) {
          state = DepartmentState.error(error.toString());
          return false;
        },
            (department) {
          state = const DepartmentState.success('Osakond edukalt loodud');
          // Laadi uuesti nimekiri
          Future.delayed(const Duration(milliseconds: 500), () {
            loadAllDepartments();
          });
          return true;
        },
      );
    } catch (e) {
      state = DepartmentState.error('Osakonna loomine ebaõnnestus: $e');
      return false;
    }
  }

  /// Puhasta viga olek
  void clearError() {
    if (state is DepartmentStateError) {
      state = const DepartmentState.initial();
    }
  }
}