import 'package:dartz/dartz.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/features/users/domain/entities/user_entity.dart';

/// Abstract repository for User operations
/// This interface defines what operations are available
/// The actual implementation (Firebase, SQL, etc) is in data layer
abstract class UserRepository {
  /// Get user by ID
  /// Returns Either<Exception, UserEntity>
  /// - Left: exception if something went wrong
  /// - Right: user entity if found
  Future<Either<Exception, UserEntity>> getUserById(UserId userId);

  /// Get all active users
  Future<Either<Exception, List<UserEntity>>> getAllUsers();

  /// Get users by email (for search)
  Future<Either<Exception, List<UserEntity>>> getUsersByEmail(String email);

  /// Create new user
  Future<Either<Exception, UserEntity>> createUser({
    required String firstName,
    required String surName,
    required String email,
    String? phoneNumber,
    required UserId createdBy,
  });

  /// Update user information
  Future<Either<Exception, UserEntity>> updateUser({
    required UserId userId,
    String? firstName,
    String? surName,
    String? email,
    String? phoneNumber,
  });

  /// Deactivate user (soft delete by setting activeTill)
  Future<Either<Exception, void>> deactivateUser({
    required UserId userId,
    required DateTime deactivationDate,
  });

  /// Check if user exists
  Future<Either<Exception, bool>> userExists(UserId userId);

  /// Get users by department
  Future<Either<Exception, List<UserEntity>>> getUsersByDepartment(
    String departmentId,
  );
}
