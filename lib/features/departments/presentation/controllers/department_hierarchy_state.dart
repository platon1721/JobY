import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:joby/features/departments/domain/entities/department_entity.dart';

part 'department_hierarchy_state.freezed.dart';

@freezed
class DepartmentHierarchyState with _$DepartmentHierarchyState {
  const factory DepartmentHierarchyState.initial() = DepartmentHierarchyStateInitial;
  const factory DepartmentHierarchyState.loading() = DepartmentHierarchyStateLoading;
  
  /// Loaded state with hierarchy tree data
  const factory DepartmentHierarchyState.loaded({
    required List<DepartmentEntity> rootDepartments,
    required Map<String, List<DepartmentEntity>> childrenMap,
    DepartmentEntity? selectedDepartment,
    List<DepartmentEntity>? ancestryPath,
  }) = DepartmentHierarchyStateLoaded;
  
  const factory DepartmentHierarchyState.success(String message) = DepartmentHierarchyStateSuccess;
  const factory DepartmentHierarchyState.error(String message) = DepartmentHierarchyStateError;
}
