// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UserState()';
}


}

/// @nodoc
class $UserStateCopyWith<$Res>  {
$UserStateCopyWith(UserState _, $Res Function(UserState) __);
}


/// Adds pattern-matching-related methods to [UserState].
extension UserStatePatterns on UserState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( UserStateInitial value)?  initial,TResult Function( UserStateLoading value)?  loading,TResult Function( UserStateLoaded value)?  loaded,TResult Function( UserStateSuccess value)?  success,TResult Function( UserStateError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case UserStateInitial() when initial != null:
return initial(_that);case UserStateLoading() when loading != null:
return loading(_that);case UserStateLoaded() when loaded != null:
return loaded(_that);case UserStateSuccess() when success != null:
return success(_that);case UserStateError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( UserStateInitial value)  initial,required TResult Function( UserStateLoading value)  loading,required TResult Function( UserStateLoaded value)  loaded,required TResult Function( UserStateSuccess value)  success,required TResult Function( UserStateError value)  error,}){
final _that = this;
switch (_that) {
case UserStateInitial():
return initial(_that);case UserStateLoading():
return loading(_that);case UserStateLoaded():
return loaded(_that);case UserStateSuccess():
return success(_that);case UserStateError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( UserStateInitial value)?  initial,TResult? Function( UserStateLoading value)?  loading,TResult? Function( UserStateLoaded value)?  loaded,TResult? Function( UserStateSuccess value)?  success,TResult? Function( UserStateError value)?  error,}){
final _that = this;
switch (_that) {
case UserStateInitial() when initial != null:
return initial(_that);case UserStateLoading() when loading != null:
return loading(_that);case UserStateLoaded() when loaded != null:
return loaded(_that);case UserStateSuccess() when success != null:
return success(_that);case UserStateError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( UserEntity user)?  loaded,TResult Function( String message)?  success,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case UserStateInitial() when initial != null:
return initial();case UserStateLoading() when loading != null:
return loading();case UserStateLoaded() when loaded != null:
return loaded(_that.user);case UserStateSuccess() when success != null:
return success(_that.message);case UserStateError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( UserEntity user)  loaded,required TResult Function( String message)  success,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case UserStateInitial():
return initial();case UserStateLoading():
return loading();case UserStateLoaded():
return loaded(_that.user);case UserStateSuccess():
return success(_that.message);case UserStateError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( UserEntity user)?  loaded,TResult? Function( String message)?  success,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case UserStateInitial() when initial != null:
return initial();case UserStateLoading() when loading != null:
return loading();case UserStateLoaded() when loaded != null:
return loaded(_that.user);case UserStateSuccess() when success != null:
return success(_that.message);case UserStateError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class UserStateInitial implements UserState {
  const UserStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UserState.initial()';
}


}




/// @nodoc


class UserStateLoading implements UserState {
  const UserStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UserState.loading()';
}


}




/// @nodoc


class UserStateLoaded implements UserState {
  const UserStateLoaded(this.user);
  

 final  UserEntity user;

/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserStateLoadedCopyWith<UserStateLoaded> get copyWith => _$UserStateLoadedCopyWithImpl<UserStateLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserStateLoaded&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'UserState.loaded(user: $user)';
}


}

/// @nodoc
abstract mixin class $UserStateLoadedCopyWith<$Res> implements $UserStateCopyWith<$Res> {
  factory $UserStateLoadedCopyWith(UserStateLoaded value, $Res Function(UserStateLoaded) _then) = _$UserStateLoadedCopyWithImpl;
@useResult
$Res call({
 UserEntity user
});




}
/// @nodoc
class _$UserStateLoadedCopyWithImpl<$Res>
    implements $UserStateLoadedCopyWith<$Res> {
  _$UserStateLoadedCopyWithImpl(this._self, this._then);

  final UserStateLoaded _self;
  final $Res Function(UserStateLoaded) _then;

/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(UserStateLoaded(
null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserEntity,
  ));
}


}

/// @nodoc


class UserStateSuccess implements UserState {
  const UserStateSuccess(this.message);
  

 final  String message;

/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserStateSuccessCopyWith<UserStateSuccess> get copyWith => _$UserStateSuccessCopyWithImpl<UserStateSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserStateSuccess&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'UserState.success(message: $message)';
}


}

/// @nodoc
abstract mixin class $UserStateSuccessCopyWith<$Res> implements $UserStateCopyWith<$Res> {
  factory $UserStateSuccessCopyWith(UserStateSuccess value, $Res Function(UserStateSuccess) _then) = _$UserStateSuccessCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$UserStateSuccessCopyWithImpl<$Res>
    implements $UserStateSuccessCopyWith<$Res> {
  _$UserStateSuccessCopyWithImpl(this._self, this._then);

  final UserStateSuccess _self;
  final $Res Function(UserStateSuccess) _then;

/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(UserStateSuccess(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UserStateError implements UserState {
  const UserStateError(this.message);
  

 final  String message;

/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserStateErrorCopyWith<UserStateError> get copyWith => _$UserStateErrorCopyWithImpl<UserStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserStateError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'UserState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $UserStateErrorCopyWith<$Res> implements $UserStateCopyWith<$Res> {
  factory $UserStateErrorCopyWith(UserStateError value, $Res Function(UserStateError) _then) = _$UserStateErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$UserStateErrorCopyWithImpl<$Res>
    implements $UserStateErrorCopyWith<$Res> {
  _$UserStateErrorCopyWithImpl(this._self, this._then);

  final UserStateError _self;
  final $Res Function(UserStateError) _then;

/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(UserStateError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
