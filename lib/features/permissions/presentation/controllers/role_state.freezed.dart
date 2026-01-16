// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'role_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RoleState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoleState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RoleState()';
}


}

/// @nodoc
class $RoleStateCopyWith<$Res>  {
$RoleStateCopyWith(RoleState _, $Res Function(RoleState) __);
}


/// Adds pattern-matching-related methods to [RoleState].
extension RoleStatePatterns on RoleState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RoleStateInitial value)?  initial,TResult Function( RoleStateLoading value)?  loading,TResult Function( RoleStateLoaded value)?  loaded,TResult Function( RoleStateDetail value)?  detail,TResult Function( RoleStateSuccess value)?  success,TResult Function( RoleStateError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RoleStateInitial() when initial != null:
return initial(_that);case RoleStateLoading() when loading != null:
return loading(_that);case RoleStateLoaded() when loaded != null:
return loaded(_that);case RoleStateDetail() when detail != null:
return detail(_that);case RoleStateSuccess() when success != null:
return success(_that);case RoleStateError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RoleStateInitial value)  initial,required TResult Function( RoleStateLoading value)  loading,required TResult Function( RoleStateLoaded value)  loaded,required TResult Function( RoleStateDetail value)  detail,required TResult Function( RoleStateSuccess value)  success,required TResult Function( RoleStateError value)  error,}){
final _that = this;
switch (_that) {
case RoleStateInitial():
return initial(_that);case RoleStateLoading():
return loading(_that);case RoleStateLoaded():
return loaded(_that);case RoleStateDetail():
return detail(_that);case RoleStateSuccess():
return success(_that);case RoleStateError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RoleStateInitial value)?  initial,TResult? Function( RoleStateLoading value)?  loading,TResult? Function( RoleStateLoaded value)?  loaded,TResult? Function( RoleStateDetail value)?  detail,TResult? Function( RoleStateSuccess value)?  success,TResult? Function( RoleStateError value)?  error,}){
final _that = this;
switch (_that) {
case RoleStateInitial() when initial != null:
return initial(_that);case RoleStateLoading() when loading != null:
return loading(_that);case RoleStateLoaded() when loaded != null:
return loaded(_that);case RoleStateDetail() when detail != null:
return detail(_that);case RoleStateSuccess() when success != null:
return success(_that);case RoleStateError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<UserRoleEntity> roles)?  loaded,TResult Function( UserRoleEntity role,  List<PermissionEntity> permissions)?  detail,TResult Function( String message)?  success,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RoleStateInitial() when initial != null:
return initial();case RoleStateLoading() when loading != null:
return loading();case RoleStateLoaded() when loaded != null:
return loaded(_that.roles);case RoleStateDetail() when detail != null:
return detail(_that.role,_that.permissions);case RoleStateSuccess() when success != null:
return success(_that.message);case RoleStateError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<UserRoleEntity> roles)  loaded,required TResult Function( UserRoleEntity role,  List<PermissionEntity> permissions)  detail,required TResult Function( String message)  success,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case RoleStateInitial():
return initial();case RoleStateLoading():
return loading();case RoleStateLoaded():
return loaded(_that.roles);case RoleStateDetail():
return detail(_that.role,_that.permissions);case RoleStateSuccess():
return success(_that.message);case RoleStateError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<UserRoleEntity> roles)?  loaded,TResult? Function( UserRoleEntity role,  List<PermissionEntity> permissions)?  detail,TResult? Function( String message)?  success,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case RoleStateInitial() when initial != null:
return initial();case RoleStateLoading() when loading != null:
return loading();case RoleStateLoaded() when loaded != null:
return loaded(_that.roles);case RoleStateDetail() when detail != null:
return detail(_that.role,_that.permissions);case RoleStateSuccess() when success != null:
return success(_that.message);case RoleStateError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class RoleStateInitial implements RoleState {
  const RoleStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoleStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RoleState.initial()';
}


}




/// @nodoc


class RoleStateLoading implements RoleState {
  const RoleStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoleStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RoleState.loading()';
}


}




/// @nodoc


class RoleStateLoaded implements RoleState {
  const RoleStateLoaded(final  List<UserRoleEntity> roles): _roles = roles;
  

 final  List<UserRoleEntity> _roles;
 List<UserRoleEntity> get roles {
  if (_roles is EqualUnmodifiableListView) return _roles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roles);
}


/// Create a copy of RoleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoleStateLoadedCopyWith<RoleStateLoaded> get copyWith => _$RoleStateLoadedCopyWithImpl<RoleStateLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoleStateLoaded&&const DeepCollectionEquality().equals(other._roles, _roles));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_roles));

@override
String toString() {
  return 'RoleState.loaded(roles: $roles)';
}


}

/// @nodoc
abstract mixin class $RoleStateLoadedCopyWith<$Res> implements $RoleStateCopyWith<$Res> {
  factory $RoleStateLoadedCopyWith(RoleStateLoaded value, $Res Function(RoleStateLoaded) _then) = _$RoleStateLoadedCopyWithImpl;
@useResult
$Res call({
 List<UserRoleEntity> roles
});




}
/// @nodoc
class _$RoleStateLoadedCopyWithImpl<$Res>
    implements $RoleStateLoadedCopyWith<$Res> {
  _$RoleStateLoadedCopyWithImpl(this._self, this._then);

  final RoleStateLoaded _self;
  final $Res Function(RoleStateLoaded) _then;

/// Create a copy of RoleState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? roles = null,}) {
  return _then(RoleStateLoaded(
null == roles ? _self._roles : roles // ignore: cast_nullable_to_non_nullable
as List<UserRoleEntity>,
  ));
}


}

/// @nodoc


class RoleStateDetail implements RoleState {
  const RoleStateDetail({required this.role, required final  List<PermissionEntity> permissions}): _permissions = permissions;
  

 final  UserRoleEntity role;
 final  List<PermissionEntity> _permissions;
 List<PermissionEntity> get permissions {
  if (_permissions is EqualUnmodifiableListView) return _permissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_permissions);
}


/// Create a copy of RoleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoleStateDetailCopyWith<RoleStateDetail> get copyWith => _$RoleStateDetailCopyWithImpl<RoleStateDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoleStateDetail&&(identical(other.role, role) || other.role == role)&&const DeepCollectionEquality().equals(other._permissions, _permissions));
}


@override
int get hashCode => Object.hash(runtimeType,role,const DeepCollectionEquality().hash(_permissions));

@override
String toString() {
  return 'RoleState.detail(role: $role, permissions: $permissions)';
}


}

/// @nodoc
abstract mixin class $RoleStateDetailCopyWith<$Res> implements $RoleStateCopyWith<$Res> {
  factory $RoleStateDetailCopyWith(RoleStateDetail value, $Res Function(RoleStateDetail) _then) = _$RoleStateDetailCopyWithImpl;
@useResult
$Res call({
 UserRoleEntity role, List<PermissionEntity> permissions
});




}
/// @nodoc
class _$RoleStateDetailCopyWithImpl<$Res>
    implements $RoleStateDetailCopyWith<$Res> {
  _$RoleStateDetailCopyWithImpl(this._self, this._then);

  final RoleStateDetail _self;
  final $Res Function(RoleStateDetail) _then;

/// Create a copy of RoleState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? role = null,Object? permissions = null,}) {
  return _then(RoleStateDetail(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRoleEntity,permissions: null == permissions ? _self._permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<PermissionEntity>,
  ));
}


}

/// @nodoc


class RoleStateSuccess implements RoleState {
  const RoleStateSuccess(this.message);
  

 final  String message;

/// Create a copy of RoleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoleStateSuccessCopyWith<RoleStateSuccess> get copyWith => _$RoleStateSuccessCopyWithImpl<RoleStateSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoleStateSuccess&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'RoleState.success(message: $message)';
}


}

/// @nodoc
abstract mixin class $RoleStateSuccessCopyWith<$Res> implements $RoleStateCopyWith<$Res> {
  factory $RoleStateSuccessCopyWith(RoleStateSuccess value, $Res Function(RoleStateSuccess) _then) = _$RoleStateSuccessCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$RoleStateSuccessCopyWithImpl<$Res>
    implements $RoleStateSuccessCopyWith<$Res> {
  _$RoleStateSuccessCopyWithImpl(this._self, this._then);

  final RoleStateSuccess _self;
  final $Res Function(RoleStateSuccess) _then;

/// Create a copy of RoleState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(RoleStateSuccess(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RoleStateError implements RoleState {
  const RoleStateError(this.message);
  

 final  String message;

/// Create a copy of RoleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoleStateErrorCopyWith<RoleStateError> get copyWith => _$RoleStateErrorCopyWithImpl<RoleStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoleStateError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'RoleState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $RoleStateErrorCopyWith<$Res> implements $RoleStateCopyWith<$Res> {
  factory $RoleStateErrorCopyWith(RoleStateError value, $Res Function(RoleStateError) _then) = _$RoleStateErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$RoleStateErrorCopyWithImpl<$Res>
    implements $RoleStateErrorCopyWith<$Res> {
  _$RoleStateErrorCopyWithImpl(this._self, this._then);

  final RoleStateError _self;
  final $Res Function(RoleStateError) _then;

/// Create a copy of RoleState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(RoleStateError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
