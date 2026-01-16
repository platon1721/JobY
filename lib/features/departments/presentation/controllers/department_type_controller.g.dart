// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_type_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DepartmentTypeController)
final departmentTypeControllerProvider = DepartmentTypeControllerProvider._();

final class DepartmentTypeControllerProvider
    extends $NotifierProvider<DepartmentTypeController, DepartmentTypeState> {
  DepartmentTypeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'departmentTypeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$departmentTypeControllerHash();

  @$internal
  @override
  DepartmentTypeController create() => DepartmentTypeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DepartmentTypeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DepartmentTypeState>(value),
    );
  }
}

String _$departmentTypeControllerHash() =>
    r'23f00b67c5ab44e24a3ac6ca61360d1961a00ee5';

abstract class _$DepartmentTypeController
    extends $Notifier<DepartmentTypeState> {
  DepartmentTypeState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DepartmentTypeState, DepartmentTypeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DepartmentTypeState, DepartmentTypeState>,
              DepartmentTypeState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
