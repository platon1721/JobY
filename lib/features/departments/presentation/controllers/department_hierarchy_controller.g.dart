// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_hierarchy_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller for managing department hierarchy (parent-child relationships)

@ProviderFor(DepartmentHierarchyController)
final departmentHierarchyControllerProvider =
    DepartmentHierarchyControllerProvider._();

/// Controller for managing department hierarchy (parent-child relationships)
final class DepartmentHierarchyControllerProvider
    extends
        $NotifierProvider<
          DepartmentHierarchyController,
          DepartmentHierarchyState
        > {
  /// Controller for managing department hierarchy (parent-child relationships)
  DepartmentHierarchyControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'departmentHierarchyControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$departmentHierarchyControllerHash();

  @$internal
  @override
  DepartmentHierarchyController create() => DepartmentHierarchyController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DepartmentHierarchyState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DepartmentHierarchyState>(value),
    );
  }
}

String _$departmentHierarchyControllerHash() =>
    r'3fc2bf6dc27459181523ed93e98e7f34c407befd';

/// Controller for managing department hierarchy (parent-child relationships)

abstract class _$DepartmentHierarchyController
    extends $Notifier<DepartmentHierarchyState> {
  DepartmentHierarchyState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<DepartmentHierarchyState, DepartmentHierarchyState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DepartmentHierarchyState, DepartmentHierarchyState>,
              DepartmentHierarchyState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
