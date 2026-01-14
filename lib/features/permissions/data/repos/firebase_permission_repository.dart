import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:joby/core/errors/exceptions.dart';
import 'package:joby/core/utils/typedef/permission_id.dart';
import 'package:joby/features/permissions/data/models/permission_model.dart';
import 'package:joby/features/permissions/domain/entities/permission_entity.dart';
import 'package:joby/features/permissions/domain/repos/permission_repository.dart';

/// Firebase implementation of PermissionRepository
class FirebasePermissionRepository implements PermissionRepository {
  final FirebaseFirestore _firestore;
  static const String _collectionName = 'permissions';

  FirebasePermissionRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _collection => 
      _firestore.collection(_collectionName);

  @override
  Future<Either<Exception, List<PermissionEntity>>> getAllPermissions() async {
    try {
      final snapshot = await _collection
          .where('active_till', isNull: true)
          .get();

      final permissions = snapshot.docs
          .map((doc) => PermissionModel.fromFirestore(doc))
          .toList();

      return Right(permissions);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, PermissionEntity>> getPermissionById(
    PermissionId permissionId,
  ) async {
    try {
      final doc = await _collection.doc(permissionId).get();
      
      if (!doc.exists) {
        return Left(
          NotFoundException('Permission with id $permissionId not found'),
        );
      }

      final permission = PermissionModel.fromFirestore(doc);
      return Right(permission);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, PermissionEntity>> getPermissionByCode(
    String code,
  ) async {
    try {
      final snapshot = await _collection
          .where('code', isEqualTo: code)
          .where('active_till', isNull: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return Left(
          NotFoundException('Permission with code "$code" not found'),
        );
      }

      final permission = PermissionModel.fromFirestore(snapshot.docs.first);
      return Right(permission);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, List<PermissionEntity>>> getPermissionsByCategory(
    String category,
  ) async {
    try {
      // Get all permissions and filter by category prefix
      // e.g., category "user" matches "user.create", "user.read", etc.
      final snapshot = await _collection
          .where('active_till', isNull: true)
          .get();

      final permissions = snapshot.docs
          .map((doc) => PermissionModel.fromFirestore(doc))
          .where((perm) => perm.code.startsWith('$category.'))
          .toList();

      return Right(permissions);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> permissionExists(
    PermissionId permissionId,
  ) async {
    try {
      final doc = await _collection.doc(permissionId).get();
      return Right(doc.exists);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> permissionCodeExists(String code) async {
    try {
      final snapshot = await _collection
          .where('code', isEqualTo: code)
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
