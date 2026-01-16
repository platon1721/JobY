import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/use_cases/common/use_case.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/features/users/domain/entities/user_entity.dart';
import 'package:joby/features/users/domain/repos/user_repository.dart';

/// Use case for creating a new user
class CreateUserUseCase extends UseCase<UserEntity, CreateUserParams> {
  final UserRepository repository;

  CreateUserUseCase(this.repository);

  @override
  Future<Either<Exception, UserEntity>> call(CreateUserParams params) {
    return repository.createUser(
      userId: params.userId,
      firstName: params.firstName,
      surName: params.surName,
      email: params.email,
      phoneNumber: params.phoneNumber,
      createdBy: params.createdBy,
    );
  }
}

/// Parameters for CreateUserUseCase
class CreateUserParams extends Equatable {
  final UserId userId;
  final String firstName;
  final String surName;
  final String email;
  final String? phoneNumber;
  final UserId createdBy;

  const CreateUserParams({
    required this.userId,
    required this.firstName,
    required this.surName,
    required this.email,
    this.phoneNumber,
    required this.createdBy,
  });

  @override
  List<Object?> get props => [firstName, surName, email, phoneNumber, createdBy];
}
