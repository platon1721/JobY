import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:joby/core/data/models/user_model.dart';
import 'package:joby/core/domain/entities/user_entity.dart';
import 'package:joby/core/domain/repos/user_repository.dart';
import 'package:joby/core/errors/exceptions.dart';
import 'package:joby/core/utils/typedef/user_id.dart';

/// Firebase implementation of UserRepository
class FirebaseUserRepository implements UserRepository {
  final FirebaseFirestore _firestore;
  static const String _collectionName = 'users';

  FirebaseUserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Helper to get collection reference
  CollectionReference get _collection =>
      _firestore.collection(_collectionName);

  @override
  Future<Either<Exception, UserEntity>> getUserById(UserId userId) async {
    try {
      final doc = await _collection.doc(userId).get();

      if (!doc.exists) {
        return Left(NotFoundException('User with id $userId not found'));
      }

      final user = UserModel.fromFirestore(doc);
      return Right(user);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, List<UserEntity>>> getAllUsers() async {
    try {
      final snapshot = await _collection
          .where('active_till', isNull: true)
          .get();

      final users = snapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();

      return Right(users);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, List<UserEntity>>> getUsersByEmail(
      String email,
      ) async {
    try {
      final snapshot = await _collection
          .where('email', isGreaterThanOrEqualTo: email)
          .where('email', isLessThan: email + 'z')
          .get();

      final users = snapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .where((user) => user.isActive)
          .toList();

      return Right(users);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, UserEntity>> createUser({
    required String firstName,
    required String surName,
    required String email,
    String? phoneNumber,
    required UserId createdBy,
  }) async {
    try {
      // Check if user with this email already exists
      final existingUsers = await _collection
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (existingUsers.docs.isNotEmpty) {
        return Left(ValidationException('User with email $email already exists'));
      }

      // Create new user document
      final docRef = _collection.doc();
      final now = DateTime.now();

      final user = UserModel(
        userId: docRef.id,
        firstName: firstName,
        surName: surName,
        email: email,
        phoneNumber: phoneNumber,
        createdAt: now,
        createdBy: createdBy,
      );

      await docRef.set(user.toFirestore());

      return Right(user);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, UserEntity>> updateUser({
    required UserId userId,
    String? firstName,
    String? surName,
    String? email,
    String? phoneNumber,
  }) async {
    try {
      final docRef = _collection.doc(userId);
      final doc = await docRef.get();

      if (!doc.exists) {
        return Left(NotFoundException('User with id $userId not found'));
      }

      final currentUser = UserModel.fromFirestore(doc);

      // Build update map with only provided fields
      final updateData = <String, dynamic>{};
      if (firstName != null) updateData['first_name'] = firstName;
      if (surName != null) updateData['sur_name'] = surName;
      if (email != null) {
        // Check if email is already taken by another user
        final existingUsers = await _collection
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (existingUsers.docs.isNotEmpty &&
            existingUsers.docs.first.id != userId) {
          return Left(ValidationException('Email $email is already taken'));
        }
        updateData['email'] = email;
      }
      if (phoneNumber != null) updateData['phone_number'] = phoneNumber;

      await docRef.update(updateData);

      // Fetch updated user
      final updatedDoc = await docRef.get();
      final updatedUser = UserModel.fromFirestore(updatedDoc);

      return Right(updatedUser);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> deactivateUser({
    required UserId userId,
    required DateTime deactivationDate,
  }) async {
    try {
      final docRef = _collection.doc(userId);
      final doc = await docRef.get();

      if (!doc.exists) {
        return Left(NotFoundException('User with id $userId not found'));
      }

      await docRef.update({
        'active_till': Timestamp.fromDate(deactivationDate),
      });

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> userExists(UserId userId) async {
    try {
      final doc = await _collection.doc(userId).get();
      return Right(doc.exists);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, List<UserEntity>>> getUsersByDepartment(
      String departmentId,
      ) async {
    try {
      // Get department_users where department_id matches
      final departmentUsersSnapshot = await _firestore
          .collection('department_users')
          .where('department_id', isEqualTo: departmentId)
          .where('active_till', isNull: true)
          .get();

      if (departmentUsersSnapshot.docs.isEmpty) {
        return const Right([]);
      }

      // Get user IDs
      final userIds = departmentUsersSnapshot.docs
          .map((doc) => doc.data()['user_id'] as String)
          .toSet()
          .toList();

      // Fetch users (in batches if more than 10)
      final users = <UserEntity>[];
      for (var i = 0; i < userIds.length; i += 10) {
        final batch = userIds.skip(i).take(10).toList();
        final snapshot = await _collection
            .where(FieldPath.documentId, whereIn: batch)
            .get();

        users.addAll(
          snapshot.docs.map((doc) => UserModel.fromFirestore(doc)),
        );
      }

      return Right(users);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }
}