import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:joby/features/departments/domain/entities/department_type_entity.dart';

part 'department_type_state.freezed.dart';

@freezed
class DepartmentTypeState with _$DepartmentTypeState {
  const factory DepartmentTypeState.initial() = DepartmentTypeStateInitial;
  const factory DepartmentTypeState.loading() = DepartmentTypeStateLoading;
  const factory DepartmentTypeState.loaded(List<DepartmentTypeEntity> types) = DepartmentTypeStateLoaded;
  const factory DepartmentTypeState.success(String message) = DepartmentTypeStateSuccess;
  const factory DepartmentTypeState.error(String message) = DepartmentTypeStateError;
}