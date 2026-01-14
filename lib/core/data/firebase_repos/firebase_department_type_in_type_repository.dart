import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:joby/core/data/models/department_type_model.dart';
import 'package:joby/core/data/models/department_type_in_type_model.dart';
import 'package:joby/core/domain/entities/department_type_entity.dart';
import 'package:joby/core/domain/entities/department_type_in_type_entity.dart';
import 'package:joby/core/domain/repos/department_type_in_type_repository.dart';
import 'package:joby/core/errors/exceptions.dart';
import 'package:joby/core/utils/typedef/department_type_id.dart';
import 'package:joby/core/utils/typedef/department_type_in_type_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';

class FirebaseDepartmentTypeInTypeRepository implements DepartmentTypeInTypeRepository {
  final FirebaseFirestore _firestore;
  static const String _collectionName = 'department_type_in_type';

  FirebaseDepartmentTypeInTypeRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _collection => _firestore.collection(_collectionName);

  @override
  Future<Either<Exception, DepartmentTypeInTypeEntity>> getRelationshipById(
    DepartmentTypeInTypeId id,
  ) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) {
        return Left(NotFoundException('Relationship not found'));
      }
      return Right(DepartmentTypeInTypeModel.fromFirestore(doc));
    } catch (e) {
      return Left(ServerException('Error: $e'));
    }
  }

  @override
  Future<Either<Exception, List<DepartmentTypeInTypeEntity>>> getAllRelationships() async {
    try {
      final snapshot = await _collection.where('active_till', isNull: true).get();
      return Right(snapshot.docs.map((doc) => DepartmentTypeInTypeModel.fromFirestore(doc)).toList());
    } catch (e) {
      return Left(ServerException('Error: $e'));
    }
  }

  @override
  Future<Either<Exception, List<DepartmentTypeEntity>>> getAllowedChildTypes(
    DepartmentTypeId parentTypeId,
  ) async {
    try {
      final relationships = await _collection
          .where('parent_type_id', isEqualTo: parentTypeId)
          .where('active_till', isNull: true)
          .get();

      if (relationships.docs.isEmpty) return const Right([]);

      final childTypeIds = relationships.docs
          .map((doc) => DepartmentTypeInTypeModel.fromFirestore(doc).childTypeId)
          .toSet()
          .toList();

      final types = <DepartmentTypeEntity>[];
      for (var i = 0; i < childTypeIds.length; i += 10) {
        final batch = childTypeIds.skip(i).take(10).toList();
        final snapshot = await _firestore
            .collection('department_types')
            .where(FieldPath.documentId, whereIn: batch)
            .get();
        types.addAll(snapshot.docs.map((doc) => DepartmentTypeModel.fromFirestore(doc)));
      }

      return Right(types);
    } catch (e) {
      return Left(ServerException('Error: $e'));
    }
  }

  @override
  Future<Either<Exception, List<DepartmentTypeEntity>>> getAllowedParentTypes(
    DepartmentTypeId childTypeId,
  ) async {
    try {
      final relationships = await _collection
          .where('child_type_id', isEqualTo: childTypeId)
          .where('active_till', isNull: true)
          .get();

      if (relationships.docs.isEmpty) return const Right([]);

      final parentTypeIds = relationships.docs
          .map((doc) => DepartmentTypeInTypeModel.fromFirestore(doc).parentTypeId)
          .toSet()
          .toList();

      final types = <DepartmentTypeEntity>[];
      for (var i = 0; i < parentTypeIds.length; i += 10) {
        final batch = parentTypeIds.skip(i).take(10).toList();
        final snapshot = await _firestore
            .collection('department_types')
            .where(FieldPath.documentId, whereIn: batch)
            .get();
        types.addAll(snapshot.docs.map((doc) => DepartmentTypeModel.fromFirestore(doc)));
      }

      return Right(types);
    } catch (e) {
      return Left(ServerException('Error: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> canHaveChildType({
    required DepartmentTypeId parentTypeId,
    required DepartmentTypeId childTypeId,
  }) async {
    try {
      final snapshot = await _collection
          .where('parent_type_id', isEqualTo: parentTypeId)
          .where('child_type_id', isEqualTo: childTypeId)
          .where('active_till', isNull: true)
          .limit(1)
          .get();

      return Right(snapshot.docs.isNotEmpty);
    } catch (e) {
      return Left(ServerException('Error: $e'));
    }
  }

  @override
  Future<Either<Exception, DepartmentTypeInTypeEntity>> createRelationship({
    required DepartmentTypeId parentTypeId,
    required DepartmentTypeId childTypeId,
    required UserId createdBy,
  }) async {
    try {
      final existing = await _collection
          .where('parent_type_id', isEqualTo: parentTypeId)
          .where('child_type_id', isEqualTo: childTypeId)
          .where('active_till', isNull: true)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        return Left(ValidationException('Relationship already exists'));
      }

      final docRef = _collection.doc();
      final relationship = DepartmentTypeInTypeModel(
        id: docRef.id,
        parentTypeId: parentTypeId,
        childTypeId: childTypeId,
        createdAt: DateTime.now(),
        createdBy: createdBy,
      );

      await docRef.set(relationship.toFirestore());
      return Right(relationship);
    } catch (e) {
      return Left(ServerException('Error: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> removeRelationship({
    required DepartmentTypeId parentTypeId,
    required DepartmentTypeId childTypeId,
  }) async {
    try {
      final snapshot = await _collection
          .where('parent_type_id', isEqualTo: parentTypeId)
          .where('child_type_id', isEqualTo: childTypeId)
          .where('active_till', isNull: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return Left(NotFoundException('Relationship not found'));
      }

      await snapshot.docs.first.reference.update({'active_till': Timestamp.now()});
      return const Right(null);
    } catch (e) {
      return Left(ServerException('Error: $e'));
    }
  }
}
