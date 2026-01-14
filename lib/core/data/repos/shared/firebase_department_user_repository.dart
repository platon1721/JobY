import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:joby/core/data/models/department_user_model.dart';
import 'package:joby/core/data/models/user_model.dart';
import 'package:joby/core/domain/entities/department_user_entity.dart';
import 'package:joby/core/domain/entities/user_entity.dart';
import 'package:joby/core/domain/repos/department_user_repository.dart';
import 'package:joby/core/errors/exceptions.dart';
import 'package:joby/core/utils/typedef/department_id.dart';
import 'package:joby/core/utils/typedef/department_user_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/core/utils/typedef/user_role_id.dart';

class FirebaseDepartmentUserRepository implements DepartmentUserRepository {
  final FirebaseFirestore _firestore;
  static const String _collectionName = 'department_users';

  FirebaseDepartmentUserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _collection => _firestore.collection(_collectionName);

  @override
  Future<Either<Exception, DepartmentUserEntity>> getDepartmentUserById(
    DepartmentUserId id,
  ) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return Left(NotFoundException('DepartmentUser not found'));
      return Right(DepartmentUserModel.fromFirestore(doc));
    } catch (e) {
      return Left(ServerException('Error: $e'));
    }
  }

  @override
  Future<Either<Exception, List<DepartmentUserEntity>>> getAllDepartmentUsers() async {
    try {
      final snapshot = await _collection.where('active_till', isNull: true).get();
      return Right(snapshot.docs.map((doc) => DepartmentUserModel.fromFirestore(doc)).toList());
    } catch (e) {
      return Left(ServerException('Error: $e'));
    }
  }

  @override
  Future<Either<Exception, List<UserEntity>>> getUsersInDepartment(
    DepartmentId departmentId,
  ) async {
    try {
      final deptUsers = await _collection
          .where('department_id', isEqualTo: departmentId)
          .where('active_till', isNull: true)
          .get();

      if (deptUsers.docs.isEmpty) return const Right([]);

      final userIds = deptUsers.docs
          .map((doc) => DepartmentUserModel.fromFirestore(doc).userId)
          .toSet()
          .toList();

      final users = <UserEntity>[];
      for (var i = 0; i < userIds.length; i += 10) {
        final batch = userIds.skip(i).take(10).toList();
        final snapshot = await _firestore
            .collection('users')
            .where(FieldPath.documentId, whereIn: batch)
            .get();
        users.addAll(snapshot.docs.map((doc) => UserModel.fromFirestore(doc)));
      }

      return Right(users);
    } catch (e) {
      return Left(ServerException('Error: $e'));
    }
  }

  @override
  Future<Either<Exception, List<DepartmentUserEntity>>> getDepartmentsForUser(
    UserId userId,
  ) async {
    try {
      final snapshot = await _collection
          .where('user_id', isEqualTo: userId)
          .where('active_till', isNull: true)
          .get();

      return Right(snapshot.docs.map((doc) => DepartmentUserModel.fromFirestore(doc)).toList());
    } catch (e) {
      return Left(ServerException('Error: $e'));
    }
  }

  @override
  Future<Either<Exception, DepartmentUserEntity>> assignUserToDepartment({
    required DepartmentId departmentId,
    required UserId userId,
    required UserRoleId roleId,
    required UserId createdBy,
  }) async {
    try {
      final existing = await _collection
          .where('department_id', isEqualTo: departmentId)
          .where('user_id', isEqualTo: userId)
          .where('active_till', isNull: true)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        return Left(ValidationException('User already in department'));
      }

      final docRef = _collection.doc();
      final assignment = DepartmentUserModel(
        id: docRef.id,
        departmentId: departmentId,
        userId: userId,
        roleId: roleId,
        createdAt: DateTime.now(),
        createdBy: createdBy,
      );

      await docRef.set(assignment.toFirestore());
      return Right(assignment);
    } catch (e) {
      return Left(ServerException('Error: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> removeUserFromDepartment({
    required DepartmentId departmentId,
    required UserId userId,
  }) async {
    try {
      final snapshot = await _collection
          .where('department_id', isEqualTo: departmentId)
          .where('user_id', isEqualTo: userId)
          .where('active_till', isNull: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return Left(NotFoundException('User not in department'));
      }

      await snapshot.docs.first.reference.update({'active_till': Timestamp.now()});
      return const Right(null);
    } catch (e) {
      return Left(ServerException('Error: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> userIsInDepartment({
    required DepartmentId departmentId,
    required UserId userId,
  }) async {
    try {
      final snapshot = await _collection
          .where('department_id', isEqualTo: departmentId)
          .where('user_id', isEqualTo: userId)
          .where('active_till', isNull: true)
          .limit(1)
          .get();

      return Right(snapshot.docs.isNotEmpty);
    } catch (e) {
      return Left(ServerException('Error: $e'));
    }
  }
}
