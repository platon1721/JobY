import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:joby/core/data/models/user_model.dart';
import 'package:joby/core/data/models/user_role_model.dart';
import 'package:joby/core/data/models/user_user_role_model.dart';
import 'package:joby/core/domain/entities/user_entity.dart';
import 'package:joby/core/domain/entities/user_role_entity.dart';
import 'package:joby/core/domain/entities/user_user_role_entity.dart';
import 'package:joby/core/domain/repos/user_user_role_repository.dart';
import 'package:joby/core/errors/exceptions.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/core/utils/typedef/user_role_id.dart';
import 'package:joby/core/utils/typedef/user_user_role_id.dart';

/// Firebase implementation of UserUserRoleRepository
class FirebaseUserUserRoleRepository implements UserUserRoleRepository {
  final FirebaseFirestore _firestore;
  static const String _collectionName = 'user_user_roles';

  FirebaseUserUserRoleRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _collection => 
      _firestore.collection(_collectionName);

  @override
  Future<Either<Exception, List<UserUserRoleEntity>>> getAllUserRoles() async {
    try {
      final snapshot = await _collection
          .where('active_till', isNull: true)
          .get();

      final userRoles = snapshot.docs
          .map((doc) => UserUserRoleModel.fromFirestore(doc))
          .toList();

      return Right(userRoles);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, UserUserRoleEntity>> getUserRoleById(
    UserUserRoleId id,
  ) async {
    try {
      final doc = await _collection.doc(id).get();
      
      if (!doc.exists) {
        return Left(NotFoundException('UserRole with id $id not found'));
      }

      final userRole = UserUserRoleModel.fromFirestore(doc);
      return Right(userRole);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, List<UserRoleEntity>>> getRolesForUser(
    UserId userId,
  ) async {
    try {
      // Get user-role mappings
      final userRolesSnapshot = await _collection
          .where('user_id', isEqualTo: userId)
          .where('active_till', isNull: true)
          .get();

      if (userRolesSnapshot.docs.isEmpty) {
        return const Right([]);
      }

      final roleIds = userRolesSnapshot.docs
          .map((doc) => UserUserRoleModel.fromFirestore(doc).roleId)
          .toSet()
          .toList();

      // Get actual roles (in batches of 10)
      final roles = <UserRoleEntity>[];
      for (var i = 0; i < roleIds.length; i += 10) {
        final batch = roleIds.skip(i).take(10).toList();
        final snapshot = await _firestore
            .collection('user_roles')
            .where(FieldPath.documentId, whereIn: batch)
            .where('active_till', isNull: true)
            .get();
        
        roles.addAll(
          snapshot.docs.map((doc) => UserRoleModel.fromFirestore(doc)),
        );
      }

      return Right(roles);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, List<UserEntity>>> getUsersWithRole(
    UserRoleId roleId,
  ) async {
    try {
      // Get user-role mappings
      final userRolesSnapshot = await _collection
          .where('role_id', isEqualTo: roleId)
          .where('active_till', isNull: true)
          .get();

      if (userRolesSnapshot.docs.isEmpty) {
        return const Right([]);
      }

      final userIds = userRolesSnapshot.docs
          .map((doc) => UserUserRoleModel.fromFirestore(doc).userId)
          .toSet()
          .toList();

      // Get actual users (in batches of 10)
      final users = <UserEntity>[];
      for (var i = 0; i < userIds.length; i += 10) {
        final batch = userIds.skip(i).take(10).toList();
        final snapshot = await _firestore
            .collection('users')
            .where(FieldPath.documentId, whereIn: batch)
            .where('active_till', isNull: true)
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

  @override
  Future<Either<Exception, UserUserRoleEntity>> assignRoleToUser({
    required UserId userId,
    required UserRoleId roleId,
    required UserId createdBy,
  }) async {
    try {
      // Check if assignment already exists
      final existingSnapshot = await _collection
          .where('user_id', isEqualTo: userId)
          .where('role_id', isEqualTo: roleId)
          .where('active_till', isNull: true)
          .limit(1)
          .get();

      if (existingSnapshot.docs.isNotEmpty) {
        return Left(
          ValidationException('Role already assigned to this user'),
        );
      }

      // Verify user exists
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        return Left(NotFoundException('User with id $userId not found'));
      }

      // Verify role exists
      final roleDoc = await _firestore.collection('user_roles').doc(roleId).get();
      if (!roleDoc.exists) {
        return Left(NotFoundException('Role with id $roleId not found'));
      }

      // Create new assignment
      final docRef = _collection.doc();
      final assignment = UserUserRoleModel(
        id: docRef.id,
        userId: userId,
        roleId: roleId,
        createdAt: DateTime.now(),
        createdBy: createdBy,
      );

      await docRef.set(assignment.toFirestore());
      return Right(assignment);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> removeRoleFromUser({
    required UserId userId,
    required UserRoleId roleId,
  }) async {
    try {
      // Find the assignment
      final snapshot = await _collection
          .where('user_id', isEqualTo: userId)
          .where('role_id', isEqualTo: roleId)
          .where('active_till', isNull: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return Left(
          NotFoundException('Role assignment not found for this user'),
        );
      }

      // Set activeTill to now
      await snapshot.docs.first.reference.update({
        'active_till': Timestamp.now(),
      });

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> userHasRole({
    required UserId userId,
    required UserRoleId roleId,
  }) async {
    try {
      final snapshot = await _collection
          .where('user_id', isEqualTo: userId)
          .where('role_id', isEqualTo: roleId)
          .where('active_till', isNull: true)
          .limit(1)
          .get();

      return Right(snapshot.docs.isNotEmpty);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, List<UserUserRoleEntity>>> assignRolesToUser({
    required UserId userId,
    required List<UserRoleId> roleIds,
    required UserId createdBy,
  }) async {
    try {
      final assignments = <UserUserRoleEntity>[];

      for (final roleId in roleIds) {
        final result = await assignRoleToUser(
          userId: userId,
          roleId: roleId,
          createdBy: createdBy,
        );

        if (result.isRight()) {
          assignments.add((result as Right).value);
        }
        // Ignore if already assigned or error
      }

      return Right(assignments);
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> removeAllRolesFromUser({
    required UserId userId,
    required DateTime deactivationDate,
  }) async {
    try {
      final snapshot = await _collection
          .where('user_id', isEqualTo: userId)
          .where('active_till', isNull: true)
          .get();

      if (snapshot.docs.isEmpty) {
        return const Right(null);
      }

      // Batch update all assignments
      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {
          'active_till': Timestamp.fromDate(deactivationDate),
        });
      }

      await batch.commit();
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }
}
