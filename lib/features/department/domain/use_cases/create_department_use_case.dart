import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/entities/department_entity.dart';
import 'package:joby/core/domain/repos/department_repository.dart';
import 'package:joby/core/domain/use_cases/common/use_case.dart';
import 'package:joby/core/utils/typedef/department_type_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';

class CreateDepartmentUseCase extends UseCase<DepartmentEntity, CreateDepartmentParams> {
  final DepartmentRepository repository;
  CreateDepartmentUseCase(this.repository);

  @override
  Future<Either<Exception, DepartmentEntity>> call(CreateDepartmentParams params) {
    return repository.createDepartment(
      name: params.name,
      typeId: params.typeId,
      hierarchyLevel: params.hierarchyLevel,
      createdBy: params.createdBy,
    );
  }
}

class CreateDepartmentParams extends Equatable {
  final String name;
  final DepartmentTypeId typeId;
  final int hierarchyLevel;
  final UserId createdBy;

  const CreateDepartmentParams({
    required this.name,
    required this.typeId,
    required this.hierarchyLevel,
    required this.createdBy,
  });

  @override
  List<Object?> get props => [name, typeId, hierarchyLevel, createdBy];
}
