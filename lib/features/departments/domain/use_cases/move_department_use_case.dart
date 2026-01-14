import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/repos/shared/department_in_department_repository.dart';
import 'package:joby/core/domain/use_cases/common/use_case.dart';
import 'package:joby/core/utils/typedef/department_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';

/// Use case for moving a department to a new parent
/// 
/// This handles all the complexity of:
/// - Removing old parent relationship
/// - Creating new parent relationship
/// - Updating hierarchy levels
/// - Validating circular references
class MoveDepartmentUseCase extends UseCase<void, MoveDepartmentParams> {
  final DepartmentInDepartmentRepository repository;
  MoveDepartmentUseCase(this.repository);

  @override
  Future<Either<Exception, void>> call(MoveDepartmentParams params) {
    return repository.moveDepartment(
      departmentId: params.departmentId,
      newParentId: params.newParentId,
      movedBy: params.movedBy,
    );
  }
}

class MoveDepartmentParams extends Equatable {
  final DepartmentId departmentId;
  final DepartmentId newParentId;
  final UserId movedBy;

  const MoveDepartmentParams({
    required this.departmentId,
    required this.newParentId,
    required this.movedBy,
  });

  @override
  List<Object?> get props => [departmentId, newParentId, movedBy];
}
