import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/repos/user_user_role_repository.dart';
import 'package:joby/core/domain/use_cases/common/use_case.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/core/utils/typedef/user_role_id.dart';

/// Use case for removing a role from a user
/// 
/// This deactivates the relationship between a user and a role,
/// revoking all permissions associated with that role from the user.
class RemoveRoleFromUserUseCase extends UseCase<void, RemoveRoleFromUserParams> {
  final UserUserRoleRepository repository;

  RemoveRoleFromUserUseCase(this.repository);

  @override
  Future<Either<Exception, void>> call(RemoveRoleFromUserParams params) {
    return repository.removeRoleFromUser(
      userId: params.userId,
      roleId: params.roleId,
    );
  }
}

/// Parameters for RemoveRoleFromUserUseCase
class RemoveRoleFromUserParams extends Equatable {
  final UserId userId;
  final UserRoleId roleId;

  const RemoveRoleFromUserParams({
    required this.userId,
    required this.roleId,
  });

  @override
  List<Object?> get props => [userId, roleId];
}
