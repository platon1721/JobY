import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/entities/user_entity.dart';
import 'package:joby/core/domain/repos/user_repository.dart';
import 'package:joby/core/domain/use_cases/common/use_case.dart';
import 'package:joby/core/utils/typedef/user_id.dart';

/// Use case for updating an existing user's information
class UpdateUserUseCase extends UseCase<UserEntity, UpdateUserParams> {
  final UserRepository repository;

  UpdateUserUseCase(this.repository);

  @override
  Future<Either<Exception, UserEntity>> call(UpdateUserParams params) {
    return repository.updateUser(
      userId: params.userId,
      firstName: params.firstName,
      surName: params.surName,
      email: params.email,
      phoneNumber: params.phoneNumber,
    );
  }
}

/// Parameters for UpdateUserUseCase
class UpdateUserParams extends Equatable {
  final UserId userId;
  final String? firstName;
  final String? surName;
  final String? email;
  final String? phoneNumber;

  const UpdateUserParams({
    required this.userId,
    this.firstName,
    this.surName,
    this.email,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [userId, firstName, surName, email, phoneNumber];
}
