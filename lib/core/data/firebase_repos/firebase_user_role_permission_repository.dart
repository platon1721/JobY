import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:joby/core/data/models/permission_model.dart';
import 'package:joby/core/data/models/user_role_model.dart';
import 'package:joby/core/data/models/user_role_permission_model.dart';
import 'package:joby/core/domain/entities/permission_entity.dart';
import 'package:joby/core/domain/entities/user_role_entity.dart';
import 'package:joby/core/domain/entities/user_role_permission_entity.dart';
import 'package:joby/core/domain/repos/user_role_permission_repository.dart';
import 'package:joby/core/errors/exceptions.dart';
import 'package:joby/core/utils/typedef/permission_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/core/utils/typedef/user_role_id.dart';
import 'package:joby/core/utils/typedef/user_role_permission_id.dart';

/// Firebase implementation of UserRolePermissionRepository
class FirebaseUserRolePermissionRepository implements UserRolePermissionRepository {
  final FirebaseFirestore _firestore;
  static const String _collectionName = 'user_role_permissions';

  FirebaseUserRolePermissionRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _collection =>
      _firestore.collection(_collectionName);

  @override
  Future<Either<Exception, List<UserRolePermissionEntity>>> getAllRolePermissions() async {
    try {
      final snapshot = await _collection
          .where('active_till', isNull: true)
          .get();

      final rolePermissions = snapshot.docs
          .map((doc) => UserRolePermissionModel.fromFirestore(doc))
          .toList();

      return Right(rolePermissions);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, UserRolePermissionEntity>> getRolePermissionById(
    UserRolePermissionId id,
  ) async {
    try {
      final doc = await _collection.doc(id).get();

      if (!doc.exists) {
        return Left(NotFoundException('RolePermission with id $id not found'));
      }

      final rolePermission = UserRolePermissionModel.fromFirestore(doc);
      return Right(rolePermission);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, List<PermissionEntity>>> getPermissionsForRole(
    UserRoleId roleId,
  ) async {
    try {
      // Get role-permission mappings
      final rolePermissionsSnapshot = await _collection
          .where('role_id', isEqualTo: roleId)
          .where('active_till', isNull: true)
          .get();

      if (rolePermissionsSnapshot.docs.isEmpty) {
        return const Right([]);
      }

      final permissionIds = rolePermissionsSnapshot.docs
          .map((doc) => UserRolePermissionModel.fromFirestore(doc).permissionId)
          .toSet()
          .toList();

      // Get actual permissions (in batches of 10)
      final permissions = <PermissionEntity>[];
      for (var i = 0; i < permissionIds.length; i += 10) {
        final batch = permissionIds.skip(i).take(10).toList();
        final snapshot = await _firestore
            .collection('permissions')
            .where(FieldPath.documentId, whereIn: batch)
            .where('active_till', isNull: true)
            .get();

        permissions.addAll(
          snapshot.docs.map((doc) => PermissionModel.fromFirestore(doc)),
        );
      }

      return Right(permissions);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, List<UserRoleEntity>>> getRolesWithPermission(
    PermissionId permissionId,
  ) async {
    try {
      // Get role-permission mappings
      final rolePermissionsSnapshot = await _collection
          .where('permission_id', isEqualTo: permissionId)
          .where('active_till', isNull: true)
          .get();

      if (rolePermissionsSnapshot.docs.isEmpty) {
        return const Right([]);
      }

      final roleIds = rolePermissionsSnapshot.docs
          .map((doc) => UserRolePermissionModel.fromFirestore(doc).roleId)
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
  Future<Either<Exception, UserRolePermissionEntity>> assignPermissionToRole({
    required UserRoleId roleId,
    required PermissionId permissionId,
    required UserId createdBy,
  }) async {
    try {
      // Check if assignment already exists
      final existingSnapshot = await _collection
          .where('role_id', isEqualTo: roleId)
          .where('permission_id', isEqualTo: permissionId)
          .where('active_till', isNull: true)
          .limit(1)
          .get();

      if (existingSnapshot.docs.isNotEmpty) {
        return Left(
          ValidationException('Permission already assigned to this role'),
        );
      }

      // Verify role exists
      final roleDoc = await _firestore.collection('user_roles').doc(roleId).get();
      if (!roleDoc.exists) {
        return Left(NotFoundException('Role with id $roleId not found'));
      }

      // Verify permission exists
      final permDoc = await _firestore.collection('permissions').doc(permissionId).get();
      if (!permDoc.exists) {
        return Left(NotFoundException('Permission with id $permissionId not found'));
      }

      // Create assignment
      final docRef = _collection.doc();
      final assignment = UserRolePermissionModel(
        id: docRef.id,
        roleId: roleId,
        permissionId: permissionId,
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
  Future<Either<Exception, void>> removePermissionFromRole({
    required UserRoleId roleId,
    required PermissionId permissionId,
  }) async {
    try {
      // Find the assignment
      final snapshot = await _collection
          .where('role_id', isEqualTo: roleId)
          .where('permission_id', isEqualTo: permissionId)
          .where('active_till', isNull: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return Left(
          NotFoundException('Permission assignment not found for this role'),
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
  Future<Either<Exception, bool>> roleHasPermission({
    required UserRoleId roleId,
    required PermissionId permissionId,
  }) async {
    try {
      final snapshot = await _collection
          .where('role_id', isEqualTo: roleId)
          .where('permission_id', isEqualTo: permissionId)
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
  Future<Either<Exception, List<UserRolePermissionEntity>>> assignPermissionsToRole({
    required UserRoleId roleId,
    required List<PermissionId> permissionIds,
    required UserId createdBy,
  }) async {
    try {
      final assignments = <UserRolePermissionEntity>[];

      for (final permissionId in permissionIds) {
        final result = await assignPermissionToRole(
          roleId: roleId,
          permissionId: permissionId,
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
  Future<Either<Exception, void>> removeAllPermissionsFromRole({
    required UserRoleId roleId,
    required DateTime deactivationDate,
  }) async {
    try {
      final snapshot = await _collection
          .where('role_id', isEqualTo: roleId)
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
