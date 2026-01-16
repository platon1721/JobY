// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// RoleController - haldab rollide olekut ja operatsioone

@ProviderFor(RoleController)
final roleControllerProvider = RoleControllerProvider._();

/// RoleController - haldab rollide olekut ja operatsioone
final class RoleControllerProvider
    extends $NotifierProvider<RoleController, RoleState> {
  /// RoleController - haldab rollide olekut ja operatsioone
  RoleControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roleControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roleControllerHash();

  @$internal
  @override
  RoleController create() => RoleController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RoleState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RoleState>(value),
    );
  }
}

String _$roleControllerHash() => r'd5e1e0ee5052c4964b9112680c025bcd4aa84b2f';

/// RoleController - haldab rollide olekut ja operatsioone

abstract class _$RoleController extends $Notifier<RoleState> {
  RoleState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<RoleState, RoleState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RoleState, RoleState>,
              RoleState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
