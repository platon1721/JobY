// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'department_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DepartmentState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepartmentState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DepartmentState()';
}


}

/// @nodoc
class $DepartmentStateCopyWith<$Res>  {
$DepartmentStateCopyWith(DepartmentState _, $Res Function(DepartmentState) __);
}


/// Adds pattern-matching-related methods to [DepartmentState].
extension DepartmentStatePatterns on DepartmentState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DepartmentStateInitial value)?  initial,TResult Function( DepartmentStateLoading value)?  loading,TResult Function( DepartmentStateLoaded value)?  loaded,TResult Function( DepartmentStateDetail value)?  detail,TResult Function( DepartmentStateSuccess value)?  success,TResult Function( DepartmentStateError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DepartmentStateInitial() when initial != null:
return initial(_that);case DepartmentStateLoading() when loading != null:
return loading(_that);case DepartmentStateLoaded() when loaded != null:
return loaded(_that);case DepartmentStateDetail() when detail != null:
return detail(_that);case DepartmentStateSuccess() when success != null:
return success(_that);case DepartmentStateError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DepartmentStateInitial value)  initial,required TResult Function( DepartmentStateLoading value)  loading,required TResult Function( DepartmentStateLoaded value)  loaded,required TResult Function( DepartmentStateDetail value)  detail,required TResult Function( DepartmentStateSuccess value)  success,required TResult Function( DepartmentStateError value)  error,}){
final _that = this;
switch (_that) {
case DepartmentStateInitial():
return initial(_that);case DepartmentStateLoading():
return loading(_that);case DepartmentStateLoaded():
return loaded(_that);case DepartmentStateDetail():
return detail(_that);case DepartmentStateSuccess():
return success(_that);case DepartmentStateError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DepartmentStateInitial value)?  initial,TResult? Function( DepartmentStateLoading value)?  loading,TResult? Function( DepartmentStateLoaded value)?  loaded,TResult? Function( DepartmentStateDetail value)?  detail,TResult? Function( DepartmentStateSuccess value)?  success,TResult? Function( DepartmentStateError value)?  error,}){
final _that = this;
switch (_that) {
case DepartmentStateInitial() when initial != null:
return initial(_that);case DepartmentStateLoading() when loading != null:
return loading(_that);case DepartmentStateLoaded() when loaded != null:
return loaded(_that);case DepartmentStateDetail() when detail != null:
return detail(_that);case DepartmentStateSuccess() when success != null:
return success(_that);case DepartmentStateError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<DepartmentEntity> departments)?  loaded,TResult Function( DepartmentEntity department)?  detail,TResult Function( String message)?  success,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DepartmentStateInitial() when initial != null:
return initial();case DepartmentStateLoading() when loading != null:
return loading();case DepartmentStateLoaded() when loaded != null:
return loaded(_that.departments);case DepartmentStateDetail() when detail != null:
return detail(_that.department);case DepartmentStateSuccess() when success != null:
return success(_that.message);case DepartmentStateError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<DepartmentEntity> departments)  loaded,required TResult Function( DepartmentEntity department)  detail,required TResult Function( String message)  success,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case DepartmentStateInitial():
return initial();case DepartmentStateLoading():
return loading();case DepartmentStateLoaded():
return loaded(_that.departments);case DepartmentStateDetail():
return detail(_that.department);case DepartmentStateSuccess():
return success(_that.message);case DepartmentStateError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<DepartmentEntity> departments)?  loaded,TResult? Function( DepartmentEntity department)?  detail,TResult? Function( String message)?  success,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case DepartmentStateInitial() when initial != null:
return initial();case DepartmentStateLoading() when loading != null:
return loading();case DepartmentStateLoaded() when loaded != null:
return loaded(_that.departments);case DepartmentStateDetail() when detail != null:
return detail(_that.department);case DepartmentStateSuccess() when success != null:
return success(_that.message);case DepartmentStateError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class DepartmentStateInitial implements DepartmentState {
  const DepartmentStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepartmentStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DepartmentState.initial()';
}


}




/// @nodoc


class DepartmentStateLoading implements DepartmentState {
  const DepartmentStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepartmentStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DepartmentState.loading()';
}


}




/// @nodoc


class DepartmentStateLoaded implements DepartmentState {
  const DepartmentStateLoaded(final  List<DepartmentEntity> departments): _departments = departments;
  

 final  List<DepartmentEntity> _departments;
 List<DepartmentEntity> get departments {
  if (_departments is EqualUnmodifiableListView) return _departments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_departments);
}


/// Create a copy of DepartmentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DepartmentStateLoadedCopyWith<DepartmentStateLoaded> get copyWith => _$DepartmentStateLoadedCopyWithImpl<DepartmentStateLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepartmentStateLoaded&&const DeepCollectionEquality().equals(other._departments, _departments));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_departments));

@override
String toString() {
  return 'DepartmentState.loaded(departments: $departments)';
}


}

/// @nodoc
abstract mixin class $DepartmentStateLoadedCopyWith<$Res> implements $DepartmentStateCopyWith<$Res> {
  factory $DepartmentStateLoadedCopyWith(DepartmentStateLoaded value, $Res Function(DepartmentStateLoaded) _then) = _$DepartmentStateLoadedCopyWithImpl;
@useResult
$Res call({
 List<DepartmentEntity> departments
});




}
/// @nodoc
class _$DepartmentStateLoadedCopyWithImpl<$Res>
    implements $DepartmentStateLoadedCopyWith<$Res> {
  _$DepartmentStateLoadedCopyWithImpl(this._self, this._then);

  final DepartmentStateLoaded _self;
  final $Res Function(DepartmentStateLoaded) _then;

/// Create a copy of DepartmentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? departments = null,}) {
  return _then(DepartmentStateLoaded(
null == departments ? _self._departments : departments // ignore: cast_nullable_to_non_nullable
as List<DepartmentEntity>,
  ));
}


}

/// @nodoc


class DepartmentStateDetail implements DepartmentState {
  const DepartmentStateDetail(this.department);
  

 final  DepartmentEntity department;

/// Create a copy of DepartmentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DepartmentStateDetailCopyWith<DepartmentStateDetail> get copyWith => _$DepartmentStateDetailCopyWithImpl<DepartmentStateDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepartmentStateDetail&&(identical(other.department, department) || other.department == department));
}


@override
int get hashCode => Object.hash(runtimeType,department);

@override
String toString() {
  return 'DepartmentState.detail(department: $department)';
}


}

/// @nodoc
abstract mixin class $DepartmentStateDetailCopyWith<$Res> implements $DepartmentStateCopyWith<$Res> {
  factory $DepartmentStateDetailCopyWith(DepartmentStateDetail value, $Res Function(DepartmentStateDetail) _then) = _$DepartmentStateDetailCopyWithImpl;
@useResult
$Res call({
 DepartmentEntity department
});




}
/// @nodoc
class _$DepartmentStateDetailCopyWithImpl<$Res>
    implements $DepartmentStateDetailCopyWith<$Res> {
  _$DepartmentStateDetailCopyWithImpl(this._self, this._then);

  final DepartmentStateDetail _self;
  final $Res Function(DepartmentStateDetail) _then;

/// Create a copy of DepartmentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? department = null,}) {
  return _then(DepartmentStateDetail(
null == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as DepartmentEntity,
  ));
}


}

/// @nodoc


class DepartmentStateSuccess implements DepartmentState {
  const DepartmentStateSuccess(this.message);
  

 final  String message;

/// Create a copy of DepartmentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DepartmentStateSuccessCopyWith<DepartmentStateSuccess> get copyWith => _$DepartmentStateSuccessCopyWithImpl<DepartmentStateSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepartmentStateSuccess&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'DepartmentState.success(message: $message)';
}


}

/// @nodoc
abstract mixin class $DepartmentStateSuccessCopyWith<$Res> implements $DepartmentStateCopyWith<$Res> {
  factory $DepartmentStateSuccessCopyWith(DepartmentStateSuccess value, $Res Function(DepartmentStateSuccess) _then) = _$DepartmentStateSuccessCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$DepartmentStateSuccessCopyWithImpl<$Res>
    implements $DepartmentStateSuccessCopyWith<$Res> {
  _$DepartmentStateSuccessCopyWithImpl(this._self, this._then);

  final DepartmentStateSuccess _self;
  final $Res Function(DepartmentStateSuccess) _then;

/// Create a copy of DepartmentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(DepartmentStateSuccess(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class DepartmentStateError implements DepartmentState {
  const DepartmentStateError(this.message);
  

 final  String message;

/// Create a copy of DepartmentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DepartmentStateErrorCopyWith<DepartmentStateError> get copyWith => _$DepartmentStateErrorCopyWithImpl<DepartmentStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepartmentStateError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'DepartmentState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $DepartmentStateErrorCopyWith<$Res> implements $DepartmentStateCopyWith<$Res> {
  factory $DepartmentStateErrorCopyWith(DepartmentStateError value, $Res Function(DepartmentStateError) _then) = _$DepartmentStateErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$DepartmentStateErrorCopyWithImpl<$Res>
    implements $DepartmentStateErrorCopyWith<$Res> {
  _$DepartmentStateErrorCopyWithImpl(this._self, this._then);

  final DepartmentStateError _self;
  final $Res Function(DepartmentStateError) _then;

/// Create a copy of DepartmentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(DepartmentStateError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
