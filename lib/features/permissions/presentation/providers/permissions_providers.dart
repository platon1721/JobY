import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// DATA LAYER
import 'package:joby/features/permissions/data/repos/firebase_permission_repository.dart';
import 'package:joby/features/permissions/data/repos/firebase_user_role_repository.dart';

// DOMAIN LAYER
import 'package:joby/features/permissions/domain/repos/permission_repository.dart';
import 'package:joby/features/permissions/domain/repos/user_role_repository.dart';

// PROVIDERS
import 'package:joby/core/providers/firebase_provider.dart';

part 'permissions_providers.g.dart';

// ============================================================================
// REPOSITORIES
// ============================================================================

/// Permission repository - handles permission CRUD
@riverpod
PermissionRepository permissionRepository(Ref ref) {
  return FirebasePermissionRepository(
    firestore: ref.watch(firebaseFirestoreProvider),
  );
}

/// User role repository - handles role CRUD
@riverpod
UserRoleRepository userRoleRepository(Ref ref) {
  return FirebaseUserRoleRepository(
    firestore: ref.watch(firebaseFirestoreProvider),
  );
}