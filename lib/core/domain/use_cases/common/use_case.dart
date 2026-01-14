import 'package:dartz/dartz.dart';

/// Base class for all use cases
/// 
/// Use cases encapsulate a single piece of business logic.
/// They take parameters (Params) and return Either<Exception, Result>
/// 
/// Example:
/// ```dart
/// class GetUserByIdUseCase extends UseCase<UserEntity, GetUserByIdParams> {
///   final UserRepository repository;
///   
///   GetUserByIdUseCase(this.repository);
///   
///   @override
///   Future<Either<Exception, UserEntity>> call(GetUserByIdParams params) {
///     return repository.getUserById(params.userId);
///   }
/// }
/// ```
abstract class UseCase<Type, Params> {
  /// Execute the use case
  Future<Either<Exception, Type>> call(Params params);
}

/// Use case that doesn't require parameters
/// 
/// Example:
/// ```dart
/// class GetAllUsersUseCase extends UseCaseNoParams<List<UserEntity>> {
///   final UserRepository repository;
///   
///   GetAllUsersUseCase(this.repository);
///   
///   @override
///   Future<Either<Exception, List<UserEntity>>> call() {
///     return repository.getAllUsers();
///   }
/// }
/// ```
abstract class UseCaseNoParams<Type> {
  /// Execute the use case without parameters
  Future<Either<Exception, Type>> call();
}

/// Marker class for use cases that don't have parameters
class NoParams {
  const NoParams();
}
