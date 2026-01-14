import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:joby/core/data/models/department_type_model.dart';
import 'package:joby/core/domain/entities/department_type_entity.dart';
import 'package:joby/core/domain/repos/department_type_repository.dart';
import 'package:joby/core/errors/exceptions.dart';
import 'package:joby/core/utils/typedef/department_type_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';

/// Firebase implementation of DepartmentTypeRepository
class FirebaseDepartmentTypeRepository implements DepartmentTypeRepository {
  final FirebaseFirestore _firestore;
  static const String _collectionName = 'department_types';

  FirebaseDepartmentTypeRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _collection =>
      _firestore.collection(_collectionName);

  @override
  Future<Either<Exception, DepartmentTypeEntity>> getDepartmentTypeById(
    DepartmentTypeId typeId,
  ) async {
    try {
      final doc = await _collection.doc(typeId).get();

      if (!doc.exists) {
        return Left(NotFoundException('DepartmentType with id $typeId not found'));
      }

      final departmentType = DepartmentTypeModel.fromFirestore(doc);
      return Right(departmentType);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, List<DepartmentTypeEntity>>> getAllDepartmentTypes() async {
    try {
      final snapshot = await _collection
          .where('active_till', isNull: true)
          .get();

      final departmentTypes = snapshot.docs
          .map((doc) => DepartmentTypeModel.fromFirestore(doc))
          .toList();

      return Right(departmentTypes);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, List<DepartmentTypeEntity>>> getDepartmentTypesByName(
    String name,
  ) async {
    try {
      final snapshot = await _collection
          .where('name', isGreaterThanOrEqualTo: name)
          .where('name', isLessThan: name + 'z')
          .where('active_till', isNull: true)
          .get();

      final departmentTypes = snapshot.docs
          .map((doc) => DepartmentTypeModel.fromFirestore(doc))
          .toList();

      return Right(departmentTypes);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, DepartmentTypeEntity>> createDepartmentType({
    required String name,
    String? description,
    required UserId createdBy,
  }) async {
    try {
      // Check if type with this name already exists
      final existingTypes = await _collection
          .where('name', isEqualTo: name)
          .where('active_till', isNull: true)
          .limit(1)
          .get();

      if (existingTypes.docs.isNotEmpty) {
        return Left(
          ValidationException('DepartmentType with name "$name" already exists'),
        );
      }

      // Create new department type document
      final docRef = _collection.doc();
      final now = DateTime.now();

      final departmentType = DepartmentTypeModel(
        id: docRef.id,
        name: name,
        description: description,
        createdAt: now,
        createdBy: createdBy,
      );

      await docRef.set(departmentType.toFirestore());

      return Right(departmentType);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, DepartmentTypeEntity>> updateDepartmentType({
    required DepartmentTypeId typeId,
    String? name,
    String? description,
  }) async {
    try {
      final docRef = _collection.doc(typeId);
      final doc = await docRef.get();

      if (!doc.exists) {
        return Left(NotFoundException('DepartmentType with id $typeId not found'));
      }

      // Build update map
      final updateData = <String, dynamic>{};

      if (name != null) {
        // Check if new name is already taken
        final existingTypes = await _collection
            .where('name', isEqualTo: name)
            .where('active_till', isNull: true)
            .limit(1)
            .get();

        if (existingTypes.docs.isNotEmpty &&
            existingTypes.docs.first.id != typeId) {
          return Left(
            ValidationException('DepartmentType name "$name" is already taken'),
          );
        }
        updateData['name'] = name;
      }

      if (description != null) {
        updateData['description'] = description;
      }

      if (updateData.isEmpty) {
        return Right(DepartmentTypeModel.fromFirestore(doc));
      }

      await docRef.update(updateData);

      // Fetch updated department type
      final updatedDoc = await docRef.get();
      final updatedType = DepartmentTypeModel.fromFirestore(updatedDoc);

      return Right(updatedType);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> deactivateDepartmentType({
    required DepartmentTypeId typeId,
    required DateTime deactivationDate,
  }) async {
    try {
      final docRef = _collection.doc(typeId);
      final doc = await docRef.get();

      if (!doc.exists) {
        return Left(NotFoundException('DepartmentType with id $typeId not found'));
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
  Future<Either<Exception, bool>> departmentTypeExists(
    DepartmentTypeId typeId,
  ) async {
    try {
      final doc = await _collection.doc(typeId).get();
      return Right(doc.exists);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> departmentTypeNameExists(String name) async {
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

  @override
  Future<Either<Exception, int>> getDepartmentCountForType(
    DepartmentTypeId typeId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('departments')
          .where('type_id', isEqualTo: typeId)
          .where('active_till', isNull: true)
          .get();

      return Right(snapshot.docs.length);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }
}
