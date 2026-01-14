// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permissions_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Permission repository - handles permission CRUD

@ProviderFor(permissionRepository)
final permissionRepositoryProvider = PermissionRepositoryProvider._();

/// Permission repository - handles permission CRUD

final class PermissionRepositoryProvider
    extends
        $FunctionalProvider<
          PermissionRepository,
          PermissionRepository,
          PermissionRepository
        >
    with $Provider<PermissionRepository> {
  /// Permission repository - handles permission CRUD
  PermissionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'permissionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$permissionRepositoryHash();

  @$internal
  @override
  $ProviderElement<PermissionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PermissionRepository create(Ref ref) {
    return permissionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PermissionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PermissionRepository>(value),
    );
  }
}

String _$permissionRepositoryHash() =>
    r'9c4e2a4421ce2ed803b73fb136e1d2aed2c17e68';

/// User role repository - handles role CRUD

@ProviderFor(userRoleRepository)
final userRoleRepositoryProvider = UserRoleRepositoryProvider._();

/// User role repository - handles role CRUD

final class UserRoleRepositoryProvider
    extends
        $FunctionalProvider<
          UserRoleRepository,
          UserRoleRepository,
          UserRoleRepository
        >
    with $Provider<UserRoleRepository> {
  /// User role repository - handles role CRUD
  UserRoleRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userRoleRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userRoleRepositoryHash();

  @$internal
  @override
  $ProviderElement<UserRoleRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UserRoleRepository create(Ref ref) {
    return userRoleRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserRoleRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserRoleRepository>(value),
    );
  }
}

String _$userRoleRepositoryHash() =>
    r'7a583fcdf3149a9fcd6fb1d2f7dc032bc22e8229';
