import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:joby/features/departments/domain/entities/department_entity.dart';

part 'department_state.freezed.dart';

@freezed
class DepartmentState with _$DepartmentState {
  const factory DepartmentState.initial() = DepartmentStateInitial;
  const factory DepartmentState.loading() = DepartmentStateLoading;
  const factory DepartmentState.loaded(List<DepartmentEntity> departments) = DepartmentStateLoaded;
  const factory DepartmentState.detail(DepartmentEntity department) = DepartmentStateDetail;
  const factory DepartmentState.success(String message) = DepartmentStateSuccess;
  const factory DepartmentState.error(String message) = DepartmentStateError;
}
