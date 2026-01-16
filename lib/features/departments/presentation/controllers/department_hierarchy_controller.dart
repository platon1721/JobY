import 'package:joby/core/domain/repos/shared/department_in_department_repository.dart';
import 'package:joby/core/providers/shared_repositories_provider.dart';
import 'package:joby/core/utils/typedef/department_id.dart';
import 'package:joby/features/auth/presentation/controllers/auth_controller.dart';
import 'package:joby/features/auth/presentation/controllers/auth_state.dart';
import 'package:joby/features/departments/domain/entities/department_entity.dart';
import 'package:joby/features/departments/presentation/controllers/department_hierarchy_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'department_hierarchy_controller.g.dart';

/// Controller for managing department hierarchy (parent-child relationships)
@riverpod
class DepartmentHierarchyController extends _$DepartmentHierarchyController {
  DepartmentInDepartmentRepository get _repository =>
      ref.read(departmentInDepartmentRepositoryProvider);

  @override
  DepartmentHierarchyState build() {
    return const DepartmentHierarchyState.initial();
  }

  /// Load the full department hierarchy tree
  Future<void> loadHierarchy() async {
    state = const DepartmentHierarchyState.loading();

    try {
      // Get root departments (those without parents)
      final rootsResult = await _repository.getRootDepartments();

      if (rootsResult.isLeft()) {
        state = DepartmentHierarchyState.error(
          rootsResult.fold((l) => l.toString(), (r) => ''),
        );
        return;
      }

      final roots = rootsResult.fold((l) => <DepartmentEntity>[], (r) => r);

      // Build children map for each root
      final childrenMap = <String, List<DepartmentEntity>>{};

      for (final root in roots) {
        await _loadChildrenRecursively(root.id, childrenMap);
      }

      state = DepartmentHierarchyState.loaded(
        rootDepartments: roots,
        childrenMap: childrenMap,
      );
    } catch (e) {
      state = DepartmentHierarchyState.error('Failed to load hierarchy: $e');
    }
  }

  /// Recursively load children for a department
  Future<void> _loadChildrenRecursively(
    DepartmentId parentId,
    Map<String, List<DepartmentEntity>> childrenMap,
  ) async {
    final childrenResult = await _repository.getChildDepartments(parentId);

    if (childrenResult.isRight()) {
      final children = childrenResult.fold((l) => <DepartmentEntity>[], (r) => r);
      childrenMap[parentId] = children;

      // Recursively load children of children
      for (final child in children) {
        await _loadChildrenRecursively(child.id, childrenMap);
      }
    }
  }

  /// Get children for a specific department
  Future<List<DepartmentEntity>> getChildDepartments(DepartmentId parentId) async {
    final result = await _repository.getChildDepartments(parentId);
    return result.fold((l) => [], (r) => r);
  }

  /// Get parent department
  Future<DepartmentEntity?> getParentDepartment(DepartmentId childId) async {
    final result = await _repository.getParentDepartment(childId);
    return result.fold((l) => null, (r) => r);
  }

  /// Load ancestry path for a department (breadcrumb)
  Future<void> loadAncestryPath(DepartmentId departmentId) async {
    final currentState = state;
    if (currentState is! DepartmentHierarchyStateLoaded) return;

    final result = await _repository.getAncestryPath(departmentId);

    result.fold(
      (error) {
        // Keep current state but show error
      },
      (path) {
        state = currentState.copyWith(ancestryPath: path);
      },
    );
  }

  /// Select a department and load its details
  Future<void> selectDepartment(DepartmentEntity department) async {
    final currentState = state;
    if (currentState is! DepartmentHierarchyStateLoaded) return;

    state = currentState.copyWith(selectedDepartment: department);
    await loadAncestryPath(department.id);
  }

  /// Create a new parent-child relationship
  Future<bool> createRelationship({
    required DepartmentId parentId,
    required DepartmentId childId,
  }) async {
    final authState = ref.read(authControllerProvider);
    String? userId;
    if (authState is AuthStateAuthenticated) {
      userId = authState.user.uid;
    }

    if (userId == null) {
      state = const DepartmentHierarchyState.error('User not authenticated');
      return false;
    }

    try {
      final result = await _repository.createRelationship(
        parentId: parentId,
        childId: childId,
        createdBy: userId,
      );

      return result.fold(
        (error) {
          state = DepartmentHierarchyState.error(error.toString());
          return false;
        },
        (relationship) {
          state = const DepartmentHierarchyState.success(
            'Relationship created successfully',
          );
          // Reload hierarchy
          Future.delayed(const Duration(milliseconds: 500), loadHierarchy);
          return true;
        },
      );
    } catch (e) {
      state = DepartmentHierarchyState.error('Failed to create relationship: $e');
      return false;
    }
  }

  /// Move a department to a new parent
  Future<bool> moveDepartment({
    required DepartmentId departmentId,
    required DepartmentId newParentId,
  }) async {
    final authState = ref.read(authControllerProvider);
    String? userId;
    if (authState is AuthStateAuthenticated) {
      userId = authState.user.uid;
    }

    if (userId == null) {
      state = const DepartmentHierarchyState.error('User not authenticated');
      return false;
    }

    // First check if move is valid
    final canMoveResult = await _repository.canMoveDepartment(
      departmentId: departmentId,
      newParentId: newParentId,
    );

    if (canMoveResult.isLeft()) {
      state = DepartmentHierarchyState.error(
        canMoveResult.fold((l) => l.toString(), (r) => ''),
      );
      return false;
    }

    final canMove = canMoveResult.fold((l) => false, (r) => r);
    if (!canMove) {
      state = const DepartmentHierarchyState.error(
        'Cannot move department: would create circular reference or invalid hierarchy',
      );
      return false;
    }

    try {
      final result = await _repository.moveDepartment(
        departmentId: departmentId,
        newParentId: newParentId,
        movedBy: userId,
      );

      return result.fold(
        (error) {
          state = DepartmentHierarchyState.error(error.toString());
          return false;
        },
        (_) {
          state = const DepartmentHierarchyState.success(
            'Department moved successfully',
          );
          // Reload hierarchy
          Future.delayed(const Duration(milliseconds: 500), loadHierarchy);
          return true;
        },
      );
    } catch (e) {
      state = DepartmentHierarchyState.error('Failed to move department: $e');
      return false;
    }
  }

  /// Remove parent-child relationship
  Future<bool> removeRelationship({
    required DepartmentId parentId,
    required DepartmentId childId,
  }) async {
    try {
      final result = await _repository.removeRelationship(
        parentId: parentId,
        childId: childId,
      );

      return result.fold(
        (error) {
          state = DepartmentHierarchyState.error(error.toString());
          return false;
        },
        (_) {
          state = const DepartmentHierarchyState.success(
            'Relationship removed successfully',
          );
          // Reload hierarchy
          Future.delayed(const Duration(milliseconds: 500), loadHierarchy);
          return true;
        },
      );
    } catch (e) {
      state = DepartmentHierarchyState.error('Failed to remove relationship: $e');
      return false;
    }
  }

  /// Check if department has children
  Future<bool> hasChildren(DepartmentId departmentId) async {
    final result = await _repository.hasChildren(departmentId);
    return result.fold((l) => false, (r) => r);
  }

  /// Check if department has parent
  Future<bool> hasParent(DepartmentId departmentId) async {
    final result = await _repository.hasParent(departmentId);
    return result.fold((l) => false, (r) => r);
  }

  /// Get all descendants of a department
  Future<List<DepartmentEntity>> getAllDescendants(DepartmentId parentId) async {
    final result = await _repository.getAllDescendants(parentId);
    return result.fold((l) => [], (r) => r);
  }

  /// Get department depth in hierarchy
  Future<int> getDepartmentDepth(DepartmentId departmentId) async {
    final result = await _repository.getDepartmentDepth(departmentId);
    return result.fold((l) => 0, (r) => r);
  }

  /// Clear any error state
  void clearError() {
    if (state is DepartmentHierarchyStateError) {
      state = const DepartmentHierarchyState.initial();
    }
  }
}
