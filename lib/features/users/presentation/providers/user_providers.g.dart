// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Kasutaja repository - Firebase teostus

@ProviderFor(userRepository)
final userRepositoryProvider = UserRepositoryProvider._();

/// Kasutaja repository - Firebase teostus

final class UserRepositoryProvider
    extends $FunctionalProvider<UserRepository, UserRepository, UserRepository>
    with $Provider<UserRepository> {
  /// Kasutaja repository - Firebase teostus
  UserRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userRepositoryHash();

  @$internal
  @override
  $ProviderElement<UserRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UserRepository create(Ref ref) {
    return userRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserRepository>(value),
    );
  }
}

String _$userRepositoryHash() => r'a5b1ff9d985fb84de878f20d9072cb4f090e65af';

/// Get user by ID use case

@ProviderFor(getUserByIdUseCase)
final getUserByIdUseCaseProvider = GetUserByIdUseCaseProvider._();

/// Get user by ID use case

final class GetUserByIdUseCaseProvider
    extends
        $FunctionalProvider<
          GetUserByIdUseCase,
          GetUserByIdUseCase,
          GetUserByIdUseCase
        >
    with $Provider<GetUserByIdUseCase> {
  /// Get user by ID use case
  GetUserByIdUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getUserByIdUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getUserByIdUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetUserByIdUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetUserByIdUseCase create(Ref ref) {
    return getUserByIdUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetUserByIdUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetUserByIdUseCase>(value),
    );
  }
}

String _$getUserByIdUseCaseHash() =>
    r'38772e00c1de0f5ea5dbdb6e4c8f7ec9ccba1b7c';

/// Get all users use case

@ProviderFor(getAllUsersUseCase)
final getAllUsersUseCaseProvider = GetAllUsersUseCaseProvider._();

/// Get all users use case

final class GetAllUsersUseCaseProvider
    extends
        $FunctionalProvider<
          GetAllUsersUseCase,
          GetAllUsersUseCase,
          GetAllUsersUseCase
        >
    with $Provider<GetAllUsersUseCase> {
  /// Get all users use case
  GetAllUsersUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getAllUsersUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getAllUsersUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetAllUsersUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetAllUsersUseCase create(Ref ref) {
    return getAllUsersUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetAllUsersUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetAllUsersUseCase>(value),
    );
  }
}

String _$getAllUsersUseCaseHash() =>
    r'9dd618a196d7caaca5a4a8663a436a920326d4d8';

/// Create user use case

@ProviderFor(createUserUseCase)
final createUserUseCaseProvider = CreateUserUseCaseProvider._();

/// Create user use case

final class CreateUserUseCaseProvider
    extends
        $FunctionalProvider<
          CreateUserUseCase,
          CreateUserUseCase,
          CreateUserUseCase
        >
    with $Provider<CreateUserUseCase> {
  /// Create user use case
  CreateUserUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createUserUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createUserUseCaseHash();

  @$internal
  @override
  $ProviderElement<CreateUserUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CreateUserUseCase create(Ref ref) {
    return createUserUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateUserUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateUserUseCase>(value),
    );
  }
}

String _$createUserUseCaseHash() => r'a7da3515ec524ed4a8d2c17b8f90b29d6d2317b5';

/// Update user use case

@ProviderFor(updateUserUseCase)
final updateUserUseCaseProvider = UpdateUserUseCaseProvider._();

/// Update user use case

final class UpdateUserUseCaseProvider
    extends
        $FunctionalProvider<
          UpdateUserUseCase,
          UpdateUserUseCase,
          UpdateUserUseCase
        >
    with $Provider<UpdateUserUseCase> {
  /// Update user use case
  UpdateUserUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateUserUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateUserUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateUserUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateUserUseCase create(Ref ref) {
    return updateUserUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateUserUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateUserUseCase>(value),
    );
  }
}

String _$updateUserUseCaseHash() => r'6724f271250fc20e9b729b8640eb9f496683ed12';

/// Deactivate user use case

@ProviderFor(deactivateUserUseCase)
final deactivateUserUseCaseProvider = DeactivateUserUseCaseProvider._();

/// Deactivate user use case

final class DeactivateUserUseCaseProvider
    extends
        $FunctionalProvider<
          DeactivateUserUseCase,
          DeactivateUserUseCase,
          DeactivateUserUseCase
        >
    with $Provider<DeactivateUserUseCase> {
  /// Deactivate user use case
  DeactivateUserUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deactivateUserUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deactivateUserUseCaseHash();

  @$internal
  @override
  $ProviderElement<DeactivateUserUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeactivateUserUseCase create(Ref ref) {
    return deactivateUserUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeactivateUserUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeactivateUserUseCase>(value),
    );
  }
}

String _$deactivateUserUseCaseHash() =>
    r'52c19e96d6d41f41d8c93f187a3e11d32c6eb4eb';

/// Get users by department use case

@ProviderFor(getUsersByDepartmentUseCase)
final getUsersByDepartmentUseCaseProvider =
    GetUsersByDepartmentUseCaseProvider._();

/// Get users by department use case

final class GetUsersByDepartmentUseCaseProvider
    extends
        $FunctionalProvider<
          GetUsersByDepartmentUseCase,
          GetUsersByDepartmentUseCase,
          GetUsersByDepartmentUseCase
        >
    with $Provider<GetUsersByDepartmentUseCase> {
  /// Get users by department use case
  GetUsersByDepartmentUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getUsersByDepartmentUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getUsersByDepartmentUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetUsersByDepartmentUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetUsersByDepartmentUseCase create(Ref ref) {
    return getUsersByDepartmentUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetUsersByDepartmentUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetUsersByDepartmentUseCase>(value),
    );
  }
}

String _$getUsersByDepartmentUseCaseHash() =>
    r'3f13672567c42595995550edb08963a4a82348c2';
