// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// UserController - haldab kasutaja olekut ja operatsioone

@ProviderFor(UserController)
final userControllerProvider = UserControllerProvider._();

/// UserController - haldab kasutaja olekut ja operatsioone
final class UserControllerProvider
    extends $NotifierProvider<UserController, UserState> {
  /// UserController - haldab kasutaja olekut ja operatsioone
  UserControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userControllerHash();

  @$internal
  @override
  UserController create() => UserController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserState>(value),
    );
  }
}

String _$userControllerHash() => r'37be213a902f15461053d0ce718a6bedd43eb935';

/// UserController - haldab kasutaja olekut ja operatsioone

abstract class _$UserController extends $Notifier<UserState> {
  UserState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<UserState, UserState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UserState, UserState>,
              UserState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
