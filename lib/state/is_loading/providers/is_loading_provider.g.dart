// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'is_loading_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(isLoading)
final isLoadingProvider = IsLoadingProvider._();

final class IsLoadingProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  IsLoadingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isLoadingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isLoadingHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isLoading(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isLoadingHash() => r'a9ac2a316a51164a0992914ed190900fb917bf78';
