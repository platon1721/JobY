import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/repos/shared/user_user_role_repository.dart';
import 'package:joby/core/domain/use_cases/common/use_case.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/features/permissions/domain/entities/user_role_entity.dart';

class GetUserRolesUseCase extends UseCase<List<UserRoleEntity>, GetUserRolesParams> {
  final UserUserRoleRepository repository;

  GetUserRolesUseCase(this.repository);

  @override
  Future<Either<Exception, List<UserRoleEntity>>> call(GetUserRolesParams params) {
    return repository.getRolesForUser(params.userId);
  }
}

class GetUserRolesParams extends Equatable {
  final UserId userId;

  const GetUserRolesParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
