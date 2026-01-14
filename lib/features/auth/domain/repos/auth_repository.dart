import 'package:dartz/dartz.dart';
import 'package:joby/features/auth/domain/entities/auth_user_entity.dart';

/// Abstract repository for authentication operations
/// 
/// This interface defines all auth operations.
/// Firebase implementation is in the data layer.
abstract class AuthRepository {
  /// Get currently authenticated user
  /// Returns null if no user is logged in
  Future<Either<Exception, AuthUserEntity?>> getCurrentUser();

  /// Stream of authentication state changes
  /// Emits when user logs in, logs out, or token refreshes
  Stream<AuthUserEntity?> authStateChanges();

  /// Login with email and password
  Future<Either<Exception, AuthUserEntity>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  /// Register new user with email and password
  Future<Either<Exception, AuthUserEntity>> register({
    required String email,
    required String password,
    String? displayName,
  });

  /// Logout current user
  Future<Either<Exception, void>> logout();

  /// Send password reset email
  Future<Either<Exception, void>> sendPasswordResetEmail({
    required String email,
  });

  /// Update user profile (display name, photo URL)
  Future<Either<Exception, void>> updateProfile({
    String? displayName,
    String? photoURL,
  });

  /// Delete current user account
  Future<Either<Exception, void>> deleteAccount();

  /// Reload current user data from Firebase
  Future<Either<Exception, void>> reloadUser();
}
