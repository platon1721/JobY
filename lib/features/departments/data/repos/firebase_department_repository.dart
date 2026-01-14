import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:joby/core/errors/exceptions.dart';
import 'package:joby/core/utils/typedef/department_id.dart';
import 'package:joby/core/utils/typedef/department_type_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/features/departments/data/models/department_model.dart';
import 'package:joby/features/departments/domain/entities/department_entity.dart';
import 'package:joby/features/departments/domain/repos/department_repository.dart';

/// Firebase implementation of DepartmentRepository
/// Handles basic CRUD for departments (hierarchy is in DepartmentInDepartmentRepository)
class FirebaseDepartmentRepository implements DepartmentRepository {
  final FirebaseFirestore _firestore;
  static const String _collectionName = 'departments';

  FirebaseDepartmentRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _collection =>
      _firestore.collection(_collectionName);

  @override
  Future<Either<Exception, DepartmentEntity>> getDepartmentById(
    DepartmentId departmentId,
  ) async {
    try {
      final doc = await _collection.doc(departmentId).get();

      if (!doc.exists) {
        return Left(NotFoundException('Department with id $departmentId not found'));
      }

      final department = DepartmentModel.fromFirestore(doc);
      return Right(department);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, List<DepartmentEntity>>> getAllDepartments() async {
    try {
      final snapshot = await _collection
          .where('active_till', isNull: true)
          .get();

      final departments = snapshot.docs
          .map((doc) => DepartmentModel.fromFirestore(doc))
          .toList();

      return Right(departments);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, List<DepartmentEntity>>> getDepartmentsByType(
    DepartmentTypeId typeId,
  ) async {
    try {
      final snapshot = await _collection
          .where('type_id', isEqualTo: typeId)
          .where('active_till', isNull: true)
          .get();

      final departments = snapshot.docs
          .map((doc) => DepartmentModel.fromFirestore(doc))
          .toList();

      return Right(departments);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, List<DepartmentEntity>>> getDepartmentsByName(
    String name,
  ) async {
    try {
      final snapshot = await _collection
          .where('name', isGreaterThanOrEqualTo: name)
          .where('name', isLessThan: '${name}z')
          .where('active_till', isNull: true)
          .get();

      final departments = snapshot.docs
          .map((doc) => DepartmentModel.fromFirestore(doc))
          .toList();

      return Right(departments);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, List<DepartmentEntity>>> getDepartmentsByHierarchyLevel(
    int hierarchyLevel,
  ) async {
    try {
      final snapshot = await _collection
          .where('hierarchy_level', isEqualTo: hierarchyLevel)
          .where('active_till', isNull: true)
          .get();

      final departments = snapshot.docs
          .map((doc) => DepartmentModel.fromFirestore(doc))
          .toList();

      return Right(departments);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, DepartmentEntity>> createDepartment({
    required String name,
    required DepartmentTypeId typeId,
    required int hierarchyLevel,
    required UserId createdBy,
  }) async {
    try {
      // Check if department with this name already exists
      final existingDepts = await _collection
          .where('name', isEqualTo: name)
          .where('active_till', isNull: true)
          .limit(1)
          .get();

      if (existingDepts.docs.isNotEmpty) {
        return Left(ValidationException('Department with name "$name" already exists'));
      }

      // Create new department document
      final docRef = _collection.doc();
      final now = DateTime.now();

      final department = DepartmentModel(
        id: docRef.id,
        name: name,
        typeId: typeId,
        hierarchyLevel: hierarchyLevel,
        createdAt: now,
        createdBy: createdBy,
      );

      await docRef.set(department.toFirestore());

      return Right(department);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, DepartmentEntity>> updateDepartment({
    required DepartmentId departmentId,
    String? name,
    DepartmentTypeId? typeId,
  }) async {
    try {
      final docRef = _collection.doc(departmentId);
      final doc = await docRef.get();

      if (!doc.exists) {
        return Left(NotFoundException('Department with id $departmentId not found'));
      }

      // Build update map
      final updateData = <String, dynamic>{};

      if (name != null) {
        // Check if new name is already taken
        final existingDepts = await _collection
            .where('name', isEqualTo: name)
            .where('active_till', isNull: true)
            .limit(1)
            .get();

        if (existingDepts.docs.isNotEmpty &&
            existingDepts.docs.first.id != departmentId) {
          return Left(ValidationException('Department name "$name" is already taken'));
        }
        updateData['name'] = name;
      }

      if (typeId != null) {
        updateData['type_id'] = typeId;
      }

      if (updateData.isEmpty) {
        return Right(DepartmentModel.fromFirestore(doc));
      }

      await docRef.update(updateData);

      // Fetch updated department
      final updatedDoc = await docRef.get();
      final updatedDepartment = DepartmentModel.fromFirestore(updatedDoc);

      return Right(updatedDepartment);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, DepartmentEntity>> updateDepartmentHierarchyLevel({
    required DepartmentId departmentId,
    required int newHierarchyLevel,
  }) async {
    try {
      final docRef = _collection.doc(departmentId);
      final doc = await docRef.get();

      if (!doc.exists) {
        return Left(NotFoundException('Department with id $departmentId not found'));
      }

      await docRef.update({'hierarchy_level': newHierarchyLevel});

      // Fetch updated department
      final updatedDoc = await docRef.get();
      final updatedDepartment = DepartmentModel.fromFirestore(updatedDoc);

      return Right(updatedDepartment);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> deactivateDepartment({
    required DepartmentId departmentId,
    required DateTime deactivationDate,
  }) async {
    try {
      final docRef = _collection.doc(departmentId);
      final doc = await docRef.get();

      if (!doc.exists) {
        return Left(NotFoundException('Department with id $departmentId not found'));
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
  Future<Either<Exception, bool>> departmentExists(
    DepartmentId departmentId,
  ) async {
    try {
      final doc = await _collection.doc(departmentId).get();
      return Right(doc.exists);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> departmentNameExists(String name) async {
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
  Future<Either<Exception, int>> getDepartmentCountByType(
    DepartmentTypeId typeId,
  ) async {
    try {
      final snapshot = await _collection
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

  @override
  Future<Either<Exception, int>> getDepartmentCountByHierarchyLevel(
    int hierarchyLevel,
  ) async {
    try {
      final snapshot = await _collection
          .where('hierarchy_level', isEqualTo: hierarchyLevel)
          .where('active_till', isNull: true)
          .get();

      return Right(snapshot.docs.length);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, List<DepartmentEntity>>> bulkCreateDepartments({
    required List<DepartmentEntity> departments,
    required UserId createdBy,
  }) async {
    try {
      final batch = _firestore.batch();
      final createdDepartments = <DepartmentEntity>[];

      for (final dept in departments) {
        final docRef = _collection.doc();
        final model = DepartmentModel(
          id: docRef.id,
          name: dept.name,
          typeId: dept.typeId,
          hierarchyLevel: dept.hierarchyLevel,
          createdAt: DateTime.now(),
          createdBy: createdBy,
        );

        batch.set(docRef, model.toFirestore());
        createdDepartments.add(model);
      }

      await batch.commit();
      return Right(createdDepartments);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }
}
