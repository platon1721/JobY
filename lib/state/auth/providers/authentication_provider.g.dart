// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Authentication)
final authenticationProvider = AuthenticationProvider._();

final class AuthenticationProvider
    extends $NotifierProvider<Authentication, AuthState> {
  AuthenticationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authenticationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authenticationHash();

  @$internal
  @override
  Authentication create() => Authentication();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthState>(value),
    );
  }
}

String _$authenticationHash() => r'46a910e95209597015114d8e3086a78aca9d67e8';

abstract class _$Authentication extends $Notifier<AuthState> {
  AuthState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AuthState, AuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthState, AuthState>,
              AuthState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
