// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_id_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userId)
final userIdProvider = UserIdProvider._();

final class UserIdProvider
    extends $FunctionalProvider<UserId?, UserId?, UserId?>
    with $Provider<UserId?> {
  UserIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userIdHash();

  @$internal
  @override
  $ProviderElement<UserId?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UserId? create(Ref ref) {
    return userId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserId? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserId?>(value),
    );
  }
}

String _$userIdHash() => r'3cde11bb51a011e681f7367fa85f77167a93545a';
