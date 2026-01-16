// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'department_hierarchy_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DepartmentHierarchyState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepartmentHierarchyState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DepartmentHierarchyState()';
}


}

/// @nodoc
class $DepartmentHierarchyStateCopyWith<$Res>  {
$DepartmentHierarchyStateCopyWith(DepartmentHierarchyState _, $Res Function(DepartmentHierarchyState) __);
}


/// Adds pattern-matching-related methods to [DepartmentHierarchyState].
extension DepartmentHierarchyStatePatterns on DepartmentHierarchyState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DepartmentHierarchyStateInitial value)?  initial,TResult Function( DepartmentHierarchyStateLoading value)?  loading,TResult Function( DepartmentHierarchyStateLoaded value)?  loaded,TResult Function( DepartmentHierarchyStateSuccess value)?  success,TResult Function( DepartmentHierarchyStateError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DepartmentHierarchyStateInitial() when initial != null:
return initial(_that);case DepartmentHierarchyStateLoading() when loading != null:
return loading(_that);case DepartmentHierarchyStateLoaded() when loaded != null:
return loaded(_that);case DepartmentHierarchyStateSuccess() when success != null:
return success(_that);case DepartmentHierarchyStateError() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DepartmentHierarchyStateInitial value)  initial,required TResult Function( DepartmentHierarchyStateLoading value)  loading,required TResult Function( DepartmentHierarchyStateLoaded value)  loaded,required TResult Function( DepartmentHierarchyStateSuccess value)  success,required TResult Function( DepartmentHierarchyStateError value)  error,}){
final _that = this;
switch (_that) {
case DepartmentHierarchyStateInitial():
return initial(_that);case DepartmentHierarchyStateLoading():
return loading(_that);case DepartmentHierarchyStateLoaded():
return loaded(_that);case DepartmentHierarchyStateSuccess():
return success(_that);case DepartmentHierarchyStateError():
return error(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DepartmentHierarchyStateInitial value)?  initial,TResult? Function( DepartmentHierarchyStateLoading value)?  loading,TResult? Function( DepartmentHierarchyStateLoaded value)?  loaded,TResult? Function( DepartmentHierarchyStateSuccess value)?  success,TResult? Function( DepartmentHierarchyStateError value)?  error,}){
final _that = this;
switch (_that) {
case DepartmentHierarchyStateInitial() when initial != null:
return initial(_that);case DepartmentHierarchyStateLoading() when loading != null:
return loading(_that);case DepartmentHierarchyStateLoaded() when loaded != null:
return loaded(_that);case DepartmentHierarchyStateSuccess() when success != null:
return success(_that);case DepartmentHierarchyStateError() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<DepartmentEntity> rootDepartments,  Map<String, List<DepartmentEntity>> childrenMap,  DepartmentEntity? selectedDepartment,  List<DepartmentEntity>? ancestryPath)?  loaded,TResult Function( String message)?  success,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DepartmentHierarchyStateInitial() when initial != null:
return initial();case DepartmentHierarchyStateLoading() when loading != null:
return loading();case DepartmentHierarchyStateLoaded() when loaded != null:
return loaded(_that.rootDepartments,_that.childrenMap,_that.selectedDepartment,_that.ancestryPath);case DepartmentHierarchyStateSuccess() when success != null:
return success(_that.message);case DepartmentHierarchyStateError() when error != null:
return error(_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<DepartmentEntity> rootDepartments,  Map<String, List<DepartmentEntity>> childrenMap,  DepartmentEntity? selectedDepartment,  List<DepartmentEntity>? ancestryPath)  loaded,required TResult Function( String message)  success,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case DepartmentHierarchyStateInitial():
return initial();case DepartmentHierarchyStateLoading():
return loading();case DepartmentHierarchyStateLoaded():
return loaded(_that.rootDepartments,_that.childrenMap,_that.selectedDepartment,_that.ancestryPath);case DepartmentHierarchyStateSuccess():
return success(_that.message);case DepartmentHierarchyStateError():
return error(_that.message);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<DepartmentEntity> rootDepartments,  Map<String, List<DepartmentEntity>> childrenMap,  DepartmentEntity? selectedDepartment,  List<DepartmentEntity>? ancestryPath)?  loaded,TResult? Function( String message)?  success,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case DepartmentHierarchyStateInitial() when initial != null:
return initial();case DepartmentHierarchyStateLoading() when loading != null:
return loading();case DepartmentHierarchyStateLoaded() when loaded != null:
return loaded(_that.rootDepartments,_that.childrenMap,_that.selectedDepartment,_that.ancestryPath);case DepartmentHierarchyStateSuccess() when success != null:
return success(_that.message);case DepartmentHierarchyStateError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class DepartmentHierarchyStateInitial implements DepartmentHierarchyState {
  const DepartmentHierarchyStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepartmentHierarchyStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DepartmentHierarchyState.initial()';
}


}




/// @nodoc


class DepartmentHierarchyStateLoading implements DepartmentHierarchyState {
  const DepartmentHierarchyStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepartmentHierarchyStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DepartmentHierarchyState.loading()';
}


}




/// @nodoc


class DepartmentHierarchyStateLoaded implements DepartmentHierarchyState {
  const DepartmentHierarchyStateLoaded({required final  List<DepartmentEntity> rootDepartments, required final  Map<String, List<DepartmentEntity>> childrenMap, this.selectedDepartment, final  List<DepartmentEntity>? ancestryPath}): _rootDepartments = rootDepartments,_childrenMap = childrenMap,_ancestryPath = ancestryPath;
  

 final  List<DepartmentEntity> _rootDepartments;
 List<DepartmentEntity> get rootDepartments {
  if (_rootDepartments is EqualUnmodifiableListView) return _rootDepartments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rootDepartments);
}

 final  Map<String, List<DepartmentEntity>> _childrenMap;
 Map<String, List<DepartmentEntity>> get childrenMap {
  if (_childrenMap is EqualUnmodifiableMapView) return _childrenMap;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_childrenMap);
}

 final  DepartmentEntity? selectedDepartment;
 final  List<DepartmentEntity>? _ancestryPath;
 List<DepartmentEntity>? get ancestryPath {
  final value = _ancestryPath;
  if (value == null) return null;
  if (_ancestryPath is EqualUnmodifiableListView) return _ancestryPath;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of DepartmentHierarchyState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DepartmentHierarchyStateLoadedCopyWith<DepartmentHierarchyStateLoaded> get copyWith => _$DepartmentHierarchyStateLoadedCopyWithImpl<DepartmentHierarchyStateLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepartmentHierarchyStateLoaded&&const DeepCollectionEquality().equals(other._rootDepartments, _rootDepartments)&&const DeepCollectionEquality().equals(other._childrenMap, _childrenMap)&&(identical(other.selectedDepartment, selectedDepartment) || other.selectedDepartment == selectedDepartment)&&const DeepCollectionEquality().equals(other._ancestryPath, _ancestryPath));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_rootDepartments),const DeepCollectionEquality().hash(_childrenMap),selectedDepartment,const DeepCollectionEquality().hash(_ancestryPath));

@override
String toString() {
  return 'DepartmentHierarchyState.loaded(rootDepartments: $rootDepartments, childrenMap: $childrenMap, selectedDepartment: $selectedDepartment, ancestryPath: $ancestryPath)';
}


}

/// @nodoc
abstract mixin class $DepartmentHierarchyStateLoadedCopyWith<$Res> implements $DepartmentHierarchyStateCopyWith<$Res> {
  factory $DepartmentHierarchyStateLoadedCopyWith(DepartmentHierarchyStateLoaded value, $Res Function(DepartmentHierarchyStateLoaded) _then) = _$DepartmentHierarchyStateLoadedCopyWithImpl;
@useResult
$Res call({
 List<DepartmentEntity> rootDepartments, Map<String, List<DepartmentEntity>> childrenMap, DepartmentEntity? selectedDepartment, List<DepartmentEntity>? ancestryPath
});




}
/// @nodoc
class _$DepartmentHierarchyStateLoadedCopyWithImpl<$Res>
    implements $DepartmentHierarchyStateLoadedCopyWith<$Res> {
  _$DepartmentHierarchyStateLoadedCopyWithImpl(this._self, this._then);

  final DepartmentHierarchyStateLoaded _self;
  final $Res Function(DepartmentHierarchyStateLoaded) _then;

/// Create a copy of DepartmentHierarchyState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? rootDepartments = null,Object? childrenMap = null,Object? selectedDepartment = freezed,Object? ancestryPath = freezed,}) {
  return _then(DepartmentHierarchyStateLoaded(
rootDepartments: null == rootDepartments ? _self._rootDepartments : rootDepartments // ignore: cast_nullable_to_non_nullable
as List<DepartmentEntity>,childrenMap: null == childrenMap ? _self._childrenMap : childrenMap // ignore: cast_nullable_to_non_nullable
as Map<String, List<DepartmentEntity>>,selectedDepartment: freezed == selectedDepartment ? _self.selectedDepartment : selectedDepartment // ignore: cast_nullable_to_non_nullable
as DepartmentEntity?,ancestryPath: freezed == ancestryPath ? _self._ancestryPath : ancestryPath // ignore: cast_nullable_to_non_nullable
as List<DepartmentEntity>?,
  ));
}


}

/// @nodoc


class DepartmentHierarchyStateSuccess implements DepartmentHierarchyState {
  const DepartmentHierarchyStateSuccess(this.message);
  

 final  String message;

/// Create a copy of DepartmentHierarchyState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DepartmentHierarchyStateSuccessCopyWith<DepartmentHierarchyStateSuccess> get copyWith => _$DepartmentHierarchyStateSuccessCopyWithImpl<DepartmentHierarchyStateSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepartmentHierarchyStateSuccess&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'DepartmentHierarchyState.success(message: $message)';
}


}

/// @nodoc
abstract mixin class $DepartmentHierarchyStateSuccessCopyWith<$Res> implements $DepartmentHierarchyStateCopyWith<$Res> {
  factory $DepartmentHierarchyStateSuccessCopyWith(DepartmentHierarchyStateSuccess value, $Res Function(DepartmentHierarchyStateSuccess) _then) = _$DepartmentHierarchyStateSuccessCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$DepartmentHierarchyStateSuccessCopyWithImpl<$Res>
    implements $DepartmentHierarchyStateSuccessCopyWith<$Res> {
  _$DepartmentHierarchyStateSuccessCopyWithImpl(this._self, this._then);

  final DepartmentHierarchyStateSuccess _self;
  final $Res Function(DepartmentHierarchyStateSuccess) _then;

/// Create a copy of DepartmentHierarchyState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(DepartmentHierarchyStateSuccess(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class DepartmentHierarchyStateError implements DepartmentHierarchyState {
  const DepartmentHierarchyStateError(this.message);
  

 final  String message;

/// Create a copy of DepartmentHierarchyState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DepartmentHierarchyStateErrorCopyWith<DepartmentHierarchyStateError> get copyWith => _$DepartmentHierarchyStateErrorCopyWithImpl<DepartmentHierarchyStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepartmentHierarchyStateError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'DepartmentHierarchyState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $DepartmentHierarchyStateErrorCopyWith<$Res> implements $DepartmentHierarchyStateCopyWith<$Res> {
  factory $DepartmentHierarchyStateErrorCopyWith(DepartmentHierarchyStateError value, $Res Function(DepartmentHierarchyStateError) _then) = _$DepartmentHierarchyStateErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$DepartmentHierarchyStateErrorCopyWithImpl<$Res>
    implements $DepartmentHierarchyStateErrorCopyWith<$Res> {
  _$DepartmentHierarchyStateErrorCopyWithImpl(this._self, this._then);

  final DepartmentHierarchyStateError _self;
  final $Res Function(DepartmentHierarchyStateError) _then;

/// Create a copy of DepartmentHierarchyState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(DepartmentHierarchyStateError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
