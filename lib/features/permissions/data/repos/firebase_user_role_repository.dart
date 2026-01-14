import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:joby/core/errors/exceptions.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/core/utils/typedef/user_role_id.dart';
import 'package:joby/features/permissions/data/models/user_role_model.dart';
import 'package:joby/features/permissions/domain/entities/user_role_entity.dart';
import 'package:joby/features/permissions/domain/repos/user_role_repository.dart';

/// Firebase implementation of UserRoleRepository
class FirebaseUserRoleRepository implements UserRoleRepository {
  final FirebaseFirestore _firestore;
  static const String _collectionName = 'user_roles';

  FirebaseUserRoleRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _collection => 
      _firestore.collection(_collectionName);

  @override
  Future<Either<Exception, UserRoleEntity>> getRoleById(
    UserRoleId roleId,
  ) async {
    try {
      final doc = await _collection.doc(roleId).get();
      
      if (!doc.exists) {
        return Left(NotFoundException('Role with id $roleId not found'));
      }

      final role = UserRoleModel.fromFirestore(doc);
      return Right(role);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, List<UserRoleEntity>>> getAllRoles() async {
    try {
      final snapshot = await _collection
          .where('active_till', isNull: true)
          .get();

      final roles = snapshot.docs
          .map((doc) => UserRoleModel.fromFirestore(doc))
          .toList();

      return Right(roles);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, List<UserRoleEntity>>> getRolesByName(
    String name,
  ) async {
    try {
      final snapshot = await _collection
          .where('name', isGreaterThanOrEqualTo: name)
          .where('name', isLessThan: '${name}z')
          .get();

      final roles = snapshot.docs
          .map((doc) => UserRoleModel.fromFirestore(doc))
          .where((role) => role.isActive)
          .toList();

      return Right(roles);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, UserRoleEntity>> createRole({
    required String name,
    required String description,
    required UserId createdBy,
  }) async {
    try {
      // Check if role with this name already exists
      final existingRoles = await _collection
          .where('name', isEqualTo: name)
          .where('active_till', isNull: true)
          .limit(1)
          .get();

      if (existingRoles.docs.isNotEmpty) {
        return Left(ValidationException('Role with name "$name" already exists'));
      }

      // Create new role document
      final docRef = _collection.doc();
      final now = DateTime.now();

      final role = UserRoleModel(
        id: docRef.id,
        name: name,
        description: description,
        createdAt: now,
        createdBy: createdBy,
      );

      await docRef.set(role.toFirestore());

      return Right(role);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, UserRoleEntity>> updateRole({
    required UserRoleId roleId,
    String? name,
    String? description,
  }) async {
    try {
      final docRef = _collection.doc(roleId);
      final doc = await docRef.get();

      if (!doc.exists) {
        return Left(NotFoundException('Role with id $roleId not found'));
      }

      // Build update map
      final updateData = <String, dynamic>{};
      
      if (name != null) {
        // Check if new name is already taken
        final existingRoles = await _collection
            .where('name', isEqualTo: name)
            .where('active_till', isNull: true)
            .limit(1)
            .get();
        
        if (existingRoles.docs.isNotEmpty && 
            existingRoles.docs.first.id != roleId) {
          return Left(ValidationException('Role name "$name" is already taken'));
        }
        updateData['name'] = name;
      }
      
      if (description != null) {
        updateData['description'] = description;
      }

      if (updateData.isEmpty) {
        return Right(UserRoleModel.fromFirestore(doc));
      }

      await docRef.update(updateData);

      // Fetch updated role
      final updatedDoc = await docRef.get();
      final updatedRole = UserRoleModel.fromFirestore(updatedDoc);

      return Right(updatedRole);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> deactivateRole({
    required UserRoleId roleId,
    required DateTime deactivationDate,
  }) async {
    try {
      final docRef = _collection.doc(roleId);
      final doc = await docRef.get();

      if (!doc.exists) {
        return Left(NotFoundException('Role with id $roleId not found'));
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
  Future<Either<Exception, bool>> roleExists(UserRoleId roleId) async {
    try {
      final doc = await _collection.doc(roleId).get();
      return Right(doc.exists);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> roleNameExists(String name) async {
    try {
      final snapshot = await _collection
          .where('name', isEqualTo: name)
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
}
