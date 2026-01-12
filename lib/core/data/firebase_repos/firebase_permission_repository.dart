import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:joby/core/data/models/permission_model.dart';
import 'package:joby/core/data/models/user_role_model.dart';
import 'package:joby/core/data/models/user_role_permission_model.dart';
import 'package:joby/core/data/models/user_user_role_model.dart';
import 'package:joby/core/domain/entities/permission_entity.dart';
import 'package:joby/core/domain/entities/user_role_entity.dart';
import 'package:joby/core/domain/entities/user_role_permission_entity.dart';
import 'package:joby/core/domain/entities/user_user_role_entity.dart';
import 'package:joby/core/domain/enums/permission.dart';
import 'package:joby/core/domain/repos/permission_repository.dart';
import 'package:joby/core/errors/exceptions.dart';
import 'package:joby/core/utils/typedef/permission_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/core/utils/typedef/user_role_id.dart';

/// Firebase implementation of PermissionRepository
/// NOTE: This is a partial implementation showing the complex methods
class FirebasePermissionRepository implements PermissionRepository {
  final FirebaseFirestore _firestore;

  FirebasePermissionRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Either<Exception, Set<Permission>>> getUserPermissions(
      UserId userId,
      ) async {
    try {
      // 1. Get all active roles for this user
      final userRolesSnapshot = await _firestore
          .collection('user_user_roles')
          .where('user_id', isEqualTo: userId)
          .where('active_till', isNull: true)
          .get();

      if (userRolesSnapshot.docs.isEmpty) {
        return const Right({});
      }

      final roleIds = userRolesSnapshot.docs
          .map((doc) => UserUserRoleModel.fromFirestore(doc).roleId)
          .toSet();

      // 2. Get all permissions for these roles
      final rolePermissionsSnapshot = await _firestore
          .collection('user_role_permissions')
          .where('role_id', whereIn: roleIds.toList())
          .where('active_till', isNull: true)
          .get();

      final permissionIds = rolePermissionsSnapshot.docs
          .map((doc) => UserRolePermissionModel.fromFirestore(doc).permissionId)
          .toSet();

      if (permissionIds.isEmpty) {
        return const Right({});
      }

      // 3. Get actual permission entities (in batches of 10)
      final permissions = <Permission>{};
      final permissionIdsList = permissionIds.toList();

      for (var i = 0; i < permissionIdsList.length; i += 10) {
        final batch = permissionIdsList.skip(i).take(10).toList();
        final permissionsSnapshot = await _firestore
            .collection('permissions')
            .where(FieldPath.documentId, whereIn: batch)
            .where('active_till', isNull: true)
            .get();

        for (final doc in permissionsSnapshot.docs) {
          final permEntity = PermissionModel.fromFirestore(doc);
          final perm = Permission.fromCode(permEntity.code);
          if (perm != null) {
            permissions.add(perm);
          }
        }
      }

      return Right(permissions);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> userHasPermission({
    required UserId userId,
    required Permission permission,
  }) async {
    try {
      final result = await getUserPermissions(userId);

      return result.fold(
            (error) => Left(error),
            (permissions) => Right(permissions.contains(permission)),
      );
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> userHasAnyPermission({
    required UserId userId,
    required List<Permission> permissions,
  }) async {
    try {
      final result = await getUserPermissions(userId);

      return result.fold(
            (error) => Left(error),
            (userPermissions) {
          final hasAny = permissions.any((p) => userPermissions.contains(p));
          return Right(hasAny);
        },
      );
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> userHasAllPermissions({
    required UserId userId,
    required List<Permission> permissions,
  }) async {
    try {
      final result = await getUserPermissions(userId);

      return result.fold(
            (error) => Left(error),
            (userPermissions) {
          final hasAll = permissions.every((p) => userPermissions.contains(p));
          return Right(hasAll);
        },
      );
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
      final rolePermissionsSnapshot = await _firestore
          .collection('user_role_permissions')
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
  Future<Either<Exception, List<UserRoleEntity>>> getRolesForUser(
      UserId userId,
      ) async {
    try {
      // Get user-role mappings
      final userRolesSnapshot = await _firestore
          .collection('user_user_roles')
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
  Future<Either<Exception, void>> assignPermissionToRole({
    required UserRoleId roleId,
    required PermissionId permissionId,
    required UserId createdBy,
  }) async {
    try {
      // Check if assignment already exists
      final existingSnapshot = await _firestore
          .collection('user_role_permissions')
          .where('role_id', isEqualTo: roleId)
          .where('permission_id', isEqualTo: permissionId)
          .limit(1)
          .get();

      if (existingSnapshot.docs.isNotEmpty) {
        return Left(
          ValidationException('Permission already assigned to this role'),
        );
      }

      // Create new assignment
      final docRef = _firestore.collection('user_role_permissions').doc();
      final assignment = UserRolePermissionModel(
        id: docRef.id,
        roleId: roleId,
        permissionId: permissionId,
        createdAt: DateTime.now(),
        createdBy: createdBy,
      );

      await docRef.set(assignment.toFirestore());
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  // TODO: Implement remaining methods:
  // - getAllPermissions
  // - getPermissionById
  // - getPermissionByCode
  // - getAllRoles
  // - getRoleById
  // - createRole
  // - updateRole
  // - removePermissionFromRole
  // - assignRoleToUser
  // - removeRoleFromUser
  // - deactivateRole
  // - getAllUserRoles
  // - getAllRolePermissions

  @override
  Future<Either<Exception, List<PermissionEntity>>> getAllPermissions() {
    // TODO: implement getAllPermissions
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, PermissionEntity>> getPermissionById(PermissionId permissionId) {
    // TODO: implement getPermissionById
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, PermissionEntity>> getPermissionByCode(String code) {
    // TODO: implement getPermissionByCode
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, List<UserRoleEntity>>> getAllRoles() {
    // TODO: implement getAllRoles
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, UserRoleEntity>> getRoleById(UserRoleId roleId) {
    // TODO: implement getRoleById
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, UserRoleEntity>> createRole({
    required String name,
    required String description,
    required UserId createdBy,
  }) {
    // TODO: implement createRole
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, UserRoleEntity>> updateRole({
    required UserRoleId roleId,
    String? name,
    String? description,
  }) {
    // TODO: implement updateRole
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, void>> removePermissionFromRole({
    required UserRoleId roleId,
    required PermissionId permissionId,
  }) {
    // TODO: implement removePermissionFromRole
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, void>> assignRoleToUser({
    required UserId userId,
    required UserRoleId roleId,
    required UserId createdBy,
  }) {
    // TODO: implement assignRoleToUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, void>> removeRoleFromUser({
    required UserId userId,
    required UserRoleId roleId,
  }) {
    // TODO: implement removeRoleFromUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, void>> deactivateRole({
    required UserRoleId roleId,
    required DateTime deactivationDate,
  }) {
    // TODO: implement deactivateRole
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, List<UserUserRoleEntity>>> getAllUserRoles() {
    // TODO: implement getAllUserRoles
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, List<UserRolePermissionEntity>>> getAllRolePermissions() {
    // TODO: implement getAllRolePermissions
    throw UnimplementedError();
  }
}