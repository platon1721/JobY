import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:joby/core/data/models/shared/department_in_department_model.dart';
import 'package:joby/core/domain/entities/shared/department_in_department_entity.dart';
import 'package:joby/core/domain/repos/shared/department_in_department_repository.dart';
import 'package:joby/core/errors/exceptions.dart';
import 'package:joby/core/utils/typedef/department_id.dart';
import 'package:joby/core/utils/typedef/department_in_department_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/features/departments/data/models/department_model.dart';
import 'package:joby/features/departments/domain/entities/department_entity.dart';

/// Firebase implementation of DepartmentInDepartmentRepository
class FirebaseDepartmentInDepartmentRepository
    implements DepartmentInDepartmentRepository {
  final FirebaseFirestore _firestore;
  static const String _collectionName = 'department_in_department';
  static const String _departmentsCollection = 'departments';

  FirebaseDepartmentInDepartmentRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _collection =>
      _firestore.collection(_collectionName);

  CollectionReference get _departmentsCol =>
      _firestore.collection(_departmentsCollection);

  @override
  Future<Either<Exception, DepartmentInDepartmentEntity>> getRelationshipById(
    DepartmentInDepartmentId id,
  ) async {
    try {
      final doc = await _collection.doc(id).get();

      if (!doc.exists) {
        return Left(NotFoundException('Relationship with id $id not found'));
      }

      final relationship = DepartmentInDepartmentModel.fromFirestore(doc);
      return Right(relationship);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, List<DepartmentInDepartmentEntity>>>
      getAllRelationships() async {
    try {
      final snapshot = await _collection
          .where('active_till', isNull: true)
          .get();

      final relationships = snapshot.docs
          .map((doc) => DepartmentInDepartmentModel.fromFirestore(doc))
          .toList();

      return Right(relationships);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, DepartmentEntity?>> getParentDepartment(
    DepartmentId childId,
  ) async {
    try {
      // Find parent relationship
      final snapshot = await _collection
          .where('child_id', isEqualTo: childId)
          .where('active_till', isNull: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return const Right(null); // No parent = root department
      }

      final relationship =
          DepartmentInDepartmentModel.fromFirestore(snapshot.docs.first);

      // Get parent department
      final parentDoc = await _departmentsCol.doc(relationship.parentId).get();
      if (!parentDoc.exists) {
        return Left(NotFoundException('Parent department not found'));
      }

      final parent = DepartmentModel.fromFirestore(parentDoc);
      return Right(parent);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, List<DepartmentEntity>>> getChildDepartments(
    DepartmentId parentId,
  ) async {
    try {
      // Find all child relationships
      final snapshot = await _collection
          .where('parent_id', isEqualTo: parentId)
          .where('active_till', isNull: true)
          .get();

      if (snapshot.docs.isEmpty) {
        return const Right([]);
      }

      final childIds = snapshot.docs
          .map((doc) => DepartmentInDepartmentModel.fromFirestore(doc).childId)
          .toSet()
          .toList();

      // Get child departments (in batches of 10)
      final children = <DepartmentEntity>[];
      for (var i = 0; i < childIds.length; i += 10) {
        final batch = childIds.skip(i).take(10).toList();
        final deptSnapshot = await _departmentsCol
            .where(FieldPath.documentId, whereIn: batch)
            .where('active_till', isNull: true)
            .get();

        children.addAll(
          deptSnapshot.docs.map((doc) => DepartmentModel.fromFirestore(doc)),
        );
      }

      return Right(children);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, List<DepartmentInDepartmentEntity>>>
      getRelationshipsForParent(DepartmentId parentId) async {
    try {
      final snapshot = await _collection
          .where('parent_id', isEqualTo: parentId)
          .where('active_till', isNull: true)
          .get();

      final relationships = snapshot.docs
          .map((doc) => DepartmentInDepartmentModel.fromFirestore(doc))
          .toList();

      return Right(relationships);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, List<DepartmentInDepartmentEntity>>>
      getRelationshipsForChild(DepartmentId childId) async {
    try {
      final snapshot = await _collection
          .where('child_id', isEqualTo: childId)
          .where('active_till', isNull: true)
          .get();

      final relationships = snapshot.docs
          .map((doc) => DepartmentInDepartmentModel.fromFirestore(doc))
          .toList();

      return Right(relationships);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, List<DepartmentEntity>>> getAllDescendants(
    DepartmentId parentId,
  ) async {
    try {
      final descendants = <DepartmentEntity>[];
      final toProcess = [parentId];
      final processed = <DepartmentId>{};

      while (toProcess.isNotEmpty) {
        final currentId = toProcess.removeAt(0);
        if (processed.contains(currentId)) continue;
        processed.add(currentId);

        final childrenResult = await getChildDepartments(currentId);
        if (childrenResult.isLeft()) {
          return childrenResult;
        }

        final children = (childrenResult as Right<Exception, List<DepartmentEntity>>).value;
        descendants.addAll(children);
        toProcess.addAll(children.map((d) => d.id));
      }

      return Right(descendants);
    } catch (e) {
      return Left(ServerException('Error getting descendants: $e'));
    }
  }

  @override
  Future<Either<Exception, List<DepartmentEntity>>> getAncestryPath(
    DepartmentId departmentId,
  ) async {
    try {
      final path = <DepartmentEntity>[];
      DepartmentId? currentId = departmentId;

      // Get the starting department
      final startDoc = await _departmentsCol.doc(departmentId).get();
      if (!startDoc.exists) {
        return Left(NotFoundException('Department not found'));
      }
      path.insert(0, DepartmentModel.fromFirestore(startDoc));

      // Walk up the tree
      while (currentId != null) {
        final parentResult = await getParentDepartment(currentId);
        if (parentResult.isLeft()) {
          return Left((parentResult as Left).value);
        }

        final parent = (parentResult as Right<Exception, DepartmentEntity?>).value;
        if (parent == null) break; // Reached root

        path.insert(0, parent);
        currentId = parent.id;
      }

      return Right(path);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, DepartmentInDepartmentEntity>> createRelationship({
    required DepartmentId parentId,
    required DepartmentId childId,
    required UserId createdBy,
  }) async {
    try {
      // Validate departments exist
      final parentDoc = await _departmentsCol.doc(parentId).get();
      if (!parentDoc.exists) {
        return Left(NotFoundException('Parent department not found'));
      }

      final childDoc = await _departmentsCol.doc(childId).get();
      if (!childDoc.exists) {
        return Left(NotFoundException('Child department not found'));
      }

      // Check for circular reference
      final circularCheck = await wouldCreateCircularReference(
        parentId: parentId,
        childId: childId,
      );
      if (circularCheck.isLeft()) return Left((circularCheck as Left).value);
      if ((circularCheck as Right).value) {
        return Left(
          ValidationException('Creating this relationship would create a circular reference'),
        );
      }

      // Check if relationship already exists
      final existingSnapshot = await _collection
          .where('parent_id', isEqualTo: parentId)
          .where('child_id', isEqualTo: childId)
          .where('active_till', isNull: true)
          .limit(1)
          .get();

      if (existingSnapshot.docs.isNotEmpty) {
        return Left(ValidationException('Relationship already exists'));
      }

      // Create relationship
      final docRef = _collection.doc();
      final relationship = DepartmentInDepartmentModel(
        id: docRef.id,
        parentId: parentId,
        childId: childId,
        createdAt: DateTime.now(),
        createdBy: createdBy,
      );

      await docRef.set(relationship.toFirestore());
      return Right(relationship);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> moveDepartment({
    required DepartmentId departmentId,
    required DepartmentId newParentId,
    required UserId movedBy,
  }) async {
    try {
      // Validate move is possible
      final canMove = await canMoveDepartment(
        departmentId: departmentId,
        newParentId: newParentId,
      );
      if (canMove.isLeft()) return Left((canMove as Left).value);
      if (!(canMove as Right).value) {
        return Left(ValidationException('Cannot move department to this parent'));
      }

      // Remove old parent relationship
      final oldRelationships = await _collection
          .where('child_id', isEqualTo: departmentId)
          .where('active_till', isNull: true)
          .get();

      final batch = _firestore.batch();
      for (final doc in oldRelationships.docs) {
        batch.update(doc.reference, {
          'active_till': Timestamp.now(),
        });
      }

      await batch.commit();

      // Create new relationship
      final createResult = await createRelationship(
        parentId: newParentId,
        childId: departmentId,
        createdBy: movedBy,
      );

      if (createResult.isLeft()) return Left((createResult as Left).value);

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> removeRelationship({
    required DepartmentId parentId,
    required DepartmentId childId,
  }) async {
    try {
      final snapshot = await _collection
          .where('parent_id', isEqualTo: parentId)
          .where('child_id', isEqualTo: childId)
          .where('active_till', isNull: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return Left(NotFoundException('Relationship not found'));
      }

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
  Future<Either<Exception, bool>> hasChildren(
    DepartmentId departmentId,
  ) async {
    try {
      final snapshot = await _collection
          .where('parent_id', isEqualTo: departmentId)
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
  Future<Either<Exception, bool>> hasParent(DepartmentId departmentId) async {
    try {
      final snapshot = await _collection
          .where('child_id', isEqualTo: departmentId)
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
  Future<Either<Exception, bool>> wouldCreateCircularReference({
    required DepartmentId parentId,
    required DepartmentId childId,
  }) async {
    try {
      // Check if childId is an ancestor of parentId
      final ancestorsResult = await getAncestryPath(parentId);
      if (ancestorsResult.isLeft()) return Left((ancestorsResult as Left).value);

      final ancestors = (ancestorsResult as Right<Exception, List<DepartmentEntity>>).value;
      final wouldCreateCircle = ancestors.any((dept) => dept.id == childId);

      return Right(wouldCreateCircle);
    } catch (e) {
      return Left(ServerException('Error checking circular reference: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> canMoveDepartment({
    required DepartmentId departmentId,
    required DepartmentId newParentId,
  }) async {
    try {
      // Can't move to itself
      if (departmentId == newParentId) {
        return const Right(false);
      }

      // Check circular reference
      final circularCheck = await wouldCreateCircularReference(
        parentId: newParentId,
        childId: departmentId,
      );
      if (circularCheck.isLeft()) return Left((circularCheck as Left).value);
      if ((circularCheck as Right).value) {
        return const Right(false);
      }

      return const Right(true);
    } catch (e) {
      return Left(ServerException('Error validating move: $e'));
    }
  }

  @override
  Future<Either<Exception, List<DepartmentEntity>>> getRootDepartments() async {
    try {
      // Get all departments
      final allDepartments = await _departmentsCol
          .where('active_till', isNull: true)
          .get();

      // Get all child IDs
      final childRelationships = await _collection
          .where('active_till', isNull: true)
          .get();

      final childIds = childRelationships.docs
          .map((doc) => DepartmentInDepartmentModel.fromFirestore(doc).childId)
          .toSet();

      // Departments that are not children = roots
      final roots = allDepartments.docs
          .map((doc) => DepartmentModel.fromFirestore(doc))
          .where((dept) => !childIds.contains(dept.id))
          .toList();

      return Right(roots);
    } on FirebaseException catch (e) {
      return Left(ServerException('Firebase error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, int>> getDepartmentDepth(
    DepartmentId departmentId,
  ) async {
    try {
      final pathResult = await getAncestryPath(departmentId);
      if (pathResult.isLeft()) return Left((pathResult as Left).value);

      final path = (pathResult as Right<Exception, List<DepartmentEntity>>).value;
      return Right(path.length - 1); // 0-indexed depth
    } catch (e) {
      return Left(ServerException('Error calculating depth: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> deactivateAllRelationships({
    required DepartmentId departmentId,
    required DateTime deactivationDate,
  }) async {
    try {
      // Get all relationships where this department is parent or child
      final parentRelationships = await _collection
          .where('parent_id', isEqualTo: departmentId)
          .where('active_till', isNull: true)
          .get();

      final childRelationships = await _collection
          .where('child_id', isEqualTo: departmentId)
          .where('active_till', isNull: true)
          .get();

      final batch = _firestore.batch();
      final timestamp = Timestamp.fromDate(deactivationDate);

      for (final doc in parentRelationships.docs) {
        batch.update(doc.reference, {'active_till': timestamp});
      }

      for (final doc in childRelationships.docs) {
        batch.update(doc.reference, {'active_till': timestamp});
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
