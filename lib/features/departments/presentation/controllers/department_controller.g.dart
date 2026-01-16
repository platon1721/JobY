// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DepartmentController - haldab osakondade olekut ja operatsioone

@ProviderFor(DepartmentController)
final departmentControllerProvider = DepartmentControllerProvider._();

/// DepartmentController - haldab osakondade olekut ja operatsioone
final class DepartmentControllerProvider
    extends $NotifierProvider<DepartmentController, DepartmentState> {
  /// DepartmentController - haldab osakondade olekut ja operatsioone
  DepartmentControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'departmentControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$departmentControllerHash();

  @$internal
  @override
  DepartmentController create() => DepartmentController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DepartmentState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DepartmentState>(value),
    );
  }
}

String _$departmentControllerHash() =>
    r'31677b57b2c4711bfacf9395ddcf97670c78009f';

/// DepartmentController - haldab osakondade olekut ja operatsioone

abstract class _$DepartmentController extends $Notifier<DepartmentState> {
  DepartmentState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DepartmentState, DepartmentState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DepartmentState, DepartmentState>,
              DepartmentState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
