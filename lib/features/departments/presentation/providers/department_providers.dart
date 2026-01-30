import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:joby/core/providers/firebase_provider.dart';
import 'package:joby/features/departments/data/repos/firebase_department_repository.dart';
import 'package:joby/features/departments/data/repos/firebase_department_type_repository.dart';
import 'package:joby/features/departments/domain/repos/department_repository.dart';
import 'package:joby/features/departments/domain/repos/department_type_repository.dart';
import 'package:joby/features/departments/domain/use_cases/create_department_use_case.dart';
import 'package:joby/features/departments/domain/use_cases/get_all_departments_use_case.dart';
import 'package:joby/features/departments/domain/use_cases/get_department_by_id_use_case.dart';

part 'department_providers.g.dart';

/// Department repository - Firebase teostus
@riverpod
DepartmentRepository departmentRepository(Ref ref) {
  return FirebaseDepartmentRepository(
    firestore: ref.watch(firebaseFirestoreProvider),
  );
}

@riverpod
DepartmentTypeRepository departmentTypeRepository(Ref ref) {
  return FirebaseDepartmentTypeRepository(
    firestore: ref.watch(firebaseFirestoreProvider),
  );
}
@riverpod
GetAllDepartmentsUseCase getAllDepartmentsUseCase(Ref ref) {
  return GetAllDepartmentsUseCase(ref.watch(departmentRepositoryProvider));
}

@riverpod
GetDepartmentByIdUseCase getDepartmentByIdUseCase(Ref ref) {
  return GetDepartmentByIdUseCase(ref.watch(departmentRepositoryProvider));
}

@riverpod
CreateDepartmentUseCase createDepartmentUseCase(Ref ref) {
  return CreateDepartmentUseCase(ref.watch(departmentRepositoryProvider));
}
