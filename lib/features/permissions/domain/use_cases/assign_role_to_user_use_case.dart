import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/entities/shared/user_user_role_entity.dart';
import 'package:joby/core/domain/repos/shared/user_user_role_repository.dart';
import 'package:joby/core/domain/use_cases/common/use_case.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/core/utils/typedef/user_role_id.dart';

class AssignRoleToUserUseCase extends UseCase<UserUserRoleEntity, AssignRoleToUserParams> {
  final UserUserRoleRepository repository;

  AssignRoleToUserUseCase(this.repository);

  @override
  Future<Either<Exception, UserUserRoleEntity>> call(AssignRoleToUserParams params) {
    return repository.assignRoleToUser(
      userId: params.userId,
      roleId: params.roleId,
      createdBy: params.createdBy,
    );
  }
}

class AssignRoleToUserParams extends Equatable {
  final UserId userId;
  final UserRoleId roleId;
  final UserId createdBy;

  const AssignRoleToUserParams({
    required this.userId,
    required this.roleId,
    required this.createdBy,
  });

  @override
  List<Object?> get props => [userId, roleId, createdBy];
}
