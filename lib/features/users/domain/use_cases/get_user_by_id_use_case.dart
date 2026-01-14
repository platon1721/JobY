import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/use_cases/common/use_case.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/features/users/domain/entities/user_entity.dart';
import 'package:joby/features/users/domain/repos/user_repository.dart';

/// Use case for getting a user by their ID
class GetUserByIdUseCase extends UseCase<UserEntity, GetUserByIdParams> {
  final UserRepository repository;

  GetUserByIdUseCase(this.repository);

  @override
  Future<Either<Exception, UserEntity>> call(GetUserByIdParams params) {
    return repository.getUserById(params.userId);
  }
}

/// Parameters for GetUserByIdUseCase
class GetUserByIdParams extends Equatable {
  final UserId userId;

  const GetUserByIdParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
