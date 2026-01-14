import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:joby/core/errors/exceptions.dart';
import 'package:joby/features/auth/data/models/auth_user_model.dart';
import 'package:joby/features/auth/domain/entities/auth_user_entity.dart';
import 'package:joby/features/auth/domain/repos/auth_repository.dart';

/// Firebase implementation of AuthRepository
class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<Either<Exception, AuthUserEntity?>> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      
      if (user == null) {
        return const Right(null);
      }

      final authUser = AuthUserModel.fromFirebaseUser(user);
      return Right(authUser);
    } on FirebaseAuthException catch (e) {
      return Left(ServerException('Firebase Auth error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Stream<AuthUserEntity?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      return AuthUserModel.fromFirebaseUser(user);
    });
  }

  @override
  Future<Either<Exception, AuthUserEntity>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return Left(ServerException('Login failed: No user returned'));
      }

      final authUser = AuthUserModel.fromFirebaseUser(userCredential.user!);
      return Right(authUser);
    } on FirebaseAuthException catch (e) {
      return Left(_handleFirebaseAuthException(e));
    } catch (e) {
      return Left(ServerException('Unexpected error during login: $e'));
    }
  }

  @override
  Future<Either<Exception, AuthUserEntity>> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return Left(ServerException('Registration failed: No user returned'));
      }

      // Update display name if provided
      if (displayName != null) {
        await userCredential.user!.updateDisplayName(displayName);
        await userCredential.user!.reload();
      }

      final updatedUser = _firebaseAuth.currentUser!;
      final authUser = AuthUserModel.fromFirebaseUser(updatedUser);
      return Right(authUser);
    } on FirebaseAuthException catch (e) {
      return Left(_handleFirebaseAuthException(e));
    } catch (e) {
      return Left(ServerException('Unexpected error during registration: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> logout() async {
    try {
      await _firebaseAuth.signOut();
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(ServerException('Logout error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error during logout: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(_handleFirebaseAuthException(e));
    } catch (e) {
      return Left(ServerException('Unexpected error sending reset email: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      
      if (user == null) {
        return Left(ValidationException('No user is currently signed in'));
      }

      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }

      if (photoURL != null) {
        await user.updatePhotoURL(photoURL);
      }

      await user.reload();
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(ServerException('Profile update error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error updating profile: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      
      if (user == null) {
        return Left(ValidationException('No user is currently signed in'));
      }

      await user.delete();
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return Left(
          ValidationException('Please re-authenticate before deleting account'),
        );
      }
      return Left(ServerException('Account deletion error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error deleting account: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> reloadUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      
      if (user == null) {
        return Left(ValidationException('No user is currently signed in'));
      }

      await user.reload();
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(ServerException('Reload error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error reloading user: $e'));
    }
  }

  /// Handle Firebase Auth exceptions and convert to app exceptions
  Exception _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return ValidationException('No user found with this email');
      case 'wrong-password':
        return ValidationException('Wrong password');
      case 'invalid-email':
        return ValidationException('Invalid email address');
      case 'user-disabled':
        return ValidationException('This account has been disabled');
      case 'email-already-in-use':
        return ValidationException('Email already in use');
      case 'weak-password':
        return ValidationException('Password is too weak');
      case 'operation-not-allowed':
        return ValidationException('Operation not allowed');
      case 'too-many-requests':
        return ValidationException('Too many requests. Try again later');
      case 'network-request-failed':
        return ServerException('Network error. Check your connection');
      default:
        return ServerException('Authentication error: ${e.message}');
    }
  }
}
