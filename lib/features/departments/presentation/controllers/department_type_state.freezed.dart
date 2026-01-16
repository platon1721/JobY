// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'department_type_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DepartmentTypeState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepartmentTypeState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DepartmentTypeState()';
}


}

/// @nodoc
class $DepartmentTypeStateCopyWith<$Res>  {
$DepartmentTypeStateCopyWith(DepartmentTypeState _, $Res Function(DepartmentTypeState) __);
}


/// Adds pattern-matching-related methods to [DepartmentTypeState].
extension DepartmentTypeStatePatterns on DepartmentTypeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DepartmentTypeStateInitial value)?  initial,TResult Function( DepartmentTypeStateLoading value)?  loading,TResult Function( DepartmentTypeStateLoaded value)?  loaded,TResult Function( DepartmentTypeStateSuccess value)?  success,TResult Function( DepartmentTypeStateError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DepartmentTypeStateInitial() when initial != null:
return initial(_that);case DepartmentTypeStateLoading() when loading != null:
return loading(_that);case DepartmentTypeStateLoaded() when loaded != null:
return loaded(_that);case DepartmentTypeStateSuccess() when success != null:
return success(_that);case DepartmentTypeStateError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DepartmentTypeStateInitial value)  initial,required TResult Function( DepartmentTypeStateLoading value)  loading,required TResult Function( DepartmentTypeStateLoaded value)  loaded,required TResult Function( DepartmentTypeStateSuccess value)  success,required TResult Function( DepartmentTypeStateError value)  error,}){
final _that = this;
switch (_that) {
case DepartmentTypeStateInitial():
return initial(_that);case DepartmentTypeStateLoading():
return loading(_that);case DepartmentTypeStateLoaded():
return loaded(_that);case DepartmentTypeStateSuccess():
return success(_that);case DepartmentTypeStateError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DepartmentTypeStateInitial value)?  initial,TResult? Function( DepartmentTypeStateLoading value)?  loading,TResult? Function( DepartmentTypeStateLoaded value)?  loaded,TResult? Function( DepartmentTypeStateSuccess value)?  success,TResult? Function( DepartmentTypeStateError value)?  error,}){
final _that = this;
switch (_that) {
case DepartmentTypeStateInitial() when initial != null:
return initial(_that);case DepartmentTypeStateLoading() when loading != null:
return loading(_that);case DepartmentTypeStateLoaded() when loaded != null:
return loaded(_that);case DepartmentTypeStateSuccess() when success != null:
return success(_that);case DepartmentTypeStateError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<DepartmentTypeEntity> types)?  loaded,TResult Function( String message)?  success,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DepartmentTypeStateInitial() when initial != null:
return initial();case DepartmentTypeStateLoading() when loading != null:
return loading();case DepartmentTypeStateLoaded() when loaded != null:
return loaded(_that.types);case DepartmentTypeStateSuccess() when success != null:
return success(_that.message);case DepartmentTypeStateError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<DepartmentTypeEntity> types)  loaded,required TResult Function( String message)  success,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case DepartmentTypeStateInitial():
return initial();case DepartmentTypeStateLoading():
return loading();case DepartmentTypeStateLoaded():
return loaded(_that.types);case DepartmentTypeStateSuccess():
return success(_that.message);case DepartmentTypeStateError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<DepartmentTypeEntity> types)?  loaded,TResult? Function( String message)?  success,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case DepartmentTypeStateInitial() when initial != null:
return initial();case DepartmentTypeStateLoading() when loading != null:
return loading();case DepartmentTypeStateLoaded() when loaded != null:
return loaded(_that.types);case DepartmentTypeStateSuccess() when success != null:
return success(_that.message);case DepartmentTypeStateError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class DepartmentTypeStateInitial implements DepartmentTypeState {
  const DepartmentTypeStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepartmentTypeStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DepartmentTypeState.initial()';
}


}




/// @nodoc


class DepartmentTypeStateLoading implements DepartmentTypeState {
  const DepartmentTypeStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepartmentTypeStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DepartmentTypeState.loading()';
}


}




/// @nodoc


class DepartmentTypeStateLoaded implements DepartmentTypeState {
  const DepartmentTypeStateLoaded(final  List<DepartmentTypeEntity> types): _types = types;
  

 final  List<DepartmentTypeEntity> _types;
 List<DepartmentTypeEntity> get types {
  if (_types is EqualUnmodifiableListView) return _types;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_types);
}


/// Create a copy of DepartmentTypeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DepartmentTypeStateLoadedCopyWith<DepartmentTypeStateLoaded> get copyWith => _$DepartmentTypeStateLoadedCopyWithImpl<DepartmentTypeStateLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepartmentTypeStateLoaded&&const DeepCollectionEquality().equals(other._types, _types));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_types));

@override
String toString() {
  return 'DepartmentTypeState.loaded(types: $types)';
}


}

/// @nodoc
abstract mixin class $DepartmentTypeStateLoadedCopyWith<$Res> implements $DepartmentTypeStateCopyWith<$Res> {
  factory $DepartmentTypeStateLoadedCopyWith(DepartmentTypeStateLoaded value, $Res Function(DepartmentTypeStateLoaded) _then) = _$DepartmentTypeStateLoadedCopyWithImpl;
@useResult
$Res call({
 List<DepartmentTypeEntity> types
});




}
/// @nodoc
class _$DepartmentTypeStateLoadedCopyWithImpl<$Res>
    implements $DepartmentTypeStateLoadedCopyWith<$Res> {
  _$DepartmentTypeStateLoadedCopyWithImpl(this._self, this._then);

  final DepartmentTypeStateLoaded _self;
  final $Res Function(DepartmentTypeStateLoaded) _then;

/// Create a copy of DepartmentTypeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? types = null,}) {
  return _then(DepartmentTypeStateLoaded(
null == types ? _self._types : types // ignore: cast_nullable_to_non_nullable
as List<DepartmentTypeEntity>,
  ));
}


}

/// @nodoc


class DepartmentTypeStateSuccess implements DepartmentTypeState {
  const DepartmentTypeStateSuccess(this.message);
  

 final  String message;

/// Create a copy of DepartmentTypeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DepartmentTypeStateSuccessCopyWith<DepartmentTypeStateSuccess> get copyWith => _$DepartmentTypeStateSuccessCopyWithImpl<DepartmentTypeStateSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepartmentTypeStateSuccess&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'DepartmentTypeState.success(message: $message)';
}


}

/// @nodoc
abstract mixin class $DepartmentTypeStateSuccessCopyWith<$Res> implements $DepartmentTypeStateCopyWith<$Res> {
  factory $DepartmentTypeStateSuccessCopyWith(DepartmentTypeStateSuccess value, $Res Function(DepartmentTypeStateSuccess) _then) = _$DepartmentTypeStateSuccessCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$DepartmentTypeStateSuccessCopyWithImpl<$Res>
    implements $DepartmentTypeStateSuccessCopyWith<$Res> {
  _$DepartmentTypeStateSuccessCopyWithImpl(this._self, this._then);

  final DepartmentTypeStateSuccess _self;
  final $Res Function(DepartmentTypeStateSuccess) _then;

/// Create a copy of DepartmentTypeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(DepartmentTypeStateSuccess(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class DepartmentTypeStateError implements DepartmentTypeState {
  const DepartmentTypeStateError(this.message);
  

 final  String message;

/// Create a copy of DepartmentTypeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DepartmentTypeStateErrorCopyWith<DepartmentTypeStateError> get copyWith => _$DepartmentTypeStateErrorCopyWithImpl<DepartmentTypeStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepartmentTypeStateError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'DepartmentTypeState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $DepartmentTypeStateErrorCopyWith<$Res> implements $DepartmentTypeStateCopyWith<$Res> {
  factory $DepartmentTypeStateErrorCopyWith(DepartmentTypeStateError value, $Res Function(DepartmentTypeStateError) _then) = _$DepartmentTypeStateErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$DepartmentTypeStateErrorCopyWithImpl<$Res>
    implements $DepartmentTypeStateErrorCopyWith<$Res> {
  _$DepartmentTypeStateErrorCopyWithImpl(this._self, this._then);

  final DepartmentTypeStateError _self;
  final $Res Function(DepartmentTypeStateError) _then;

/// Create a copy of DepartmentTypeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(DepartmentTypeStateError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
