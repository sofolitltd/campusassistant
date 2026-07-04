// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_emergency_contacts.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GetEmergencyContactsParams {

 String? get universityId; String? get departmentId; String? get scope; String? get search; int? get limit; int? get offset;
/// Create a copy of GetEmergencyContactsParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetEmergencyContactsParamsCopyWith<GetEmergencyContactsParams> get copyWith => _$GetEmergencyContactsParamsCopyWithImpl<GetEmergencyContactsParams>(this as GetEmergencyContactsParams, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetEmergencyContactsParams&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.search, search) || other.search == search)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset));
}


@override
int get hashCode => Object.hash(runtimeType,universityId,departmentId,scope,search,limit,offset);

@override
String toString() {
  return 'GetEmergencyContactsParams(universityId: $universityId, departmentId: $departmentId, scope: $scope, search: $search, limit: $limit, offset: $offset)';
}


}

/// @nodoc
abstract mixin class $GetEmergencyContactsParamsCopyWith<$Res>  {
  factory $GetEmergencyContactsParamsCopyWith(GetEmergencyContactsParams value, $Res Function(GetEmergencyContactsParams) _then) = _$GetEmergencyContactsParamsCopyWithImpl;
@useResult
$Res call({
 String? universityId, String? departmentId, String? scope, String? search, int? limit, int? offset
});




}
/// @nodoc
class _$GetEmergencyContactsParamsCopyWithImpl<$Res>
    implements $GetEmergencyContactsParamsCopyWith<$Res> {
  _$GetEmergencyContactsParamsCopyWithImpl(this._self, this._then);

  final GetEmergencyContactsParams _self;
  final $Res Function(GetEmergencyContactsParams) _then;

/// Create a copy of GetEmergencyContactsParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? universityId = freezed,Object? departmentId = freezed,Object? scope = freezed,Object? search = freezed,Object? limit = freezed,Object? offset = freezed,}) {
  return _then(_self.copyWith(
universityId: freezed == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String?,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String?,scope: freezed == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as String?,search: freezed == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,offset: freezed == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [GetEmergencyContactsParams].
extension GetEmergencyContactsParamsPatterns on GetEmergencyContactsParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetEmergencyContactsParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetEmergencyContactsParams() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetEmergencyContactsParams value)  $default,){
final _that = this;
switch (_that) {
case _GetEmergencyContactsParams():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetEmergencyContactsParams value)?  $default,){
final _that = this;
switch (_that) {
case _GetEmergencyContactsParams() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? universityId,  String? departmentId,  String? scope,  String? search,  int? limit,  int? offset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetEmergencyContactsParams() when $default != null:
return $default(_that.universityId,_that.departmentId,_that.scope,_that.search,_that.limit,_that.offset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? universityId,  String? departmentId,  String? scope,  String? search,  int? limit,  int? offset)  $default,) {final _that = this;
switch (_that) {
case _GetEmergencyContactsParams():
return $default(_that.universityId,_that.departmentId,_that.scope,_that.search,_that.limit,_that.offset);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? universityId,  String? departmentId,  String? scope,  String? search,  int? limit,  int? offset)?  $default,) {final _that = this;
switch (_that) {
case _GetEmergencyContactsParams() when $default != null:
return $default(_that.universityId,_that.departmentId,_that.scope,_that.search,_that.limit,_that.offset);case _:
  return null;

}
}

}

/// @nodoc


class _GetEmergencyContactsParams implements GetEmergencyContactsParams {
  const _GetEmergencyContactsParams({this.universityId, this.departmentId, this.scope, this.search, this.limit, this.offset});
  

@override final  String? universityId;
@override final  String? departmentId;
@override final  String? scope;
@override final  String? search;
@override final  int? limit;
@override final  int? offset;

/// Create a copy of GetEmergencyContactsParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetEmergencyContactsParamsCopyWith<_GetEmergencyContactsParams> get copyWith => __$GetEmergencyContactsParamsCopyWithImpl<_GetEmergencyContactsParams>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetEmergencyContactsParams&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.search, search) || other.search == search)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset));
}


@override
int get hashCode => Object.hash(runtimeType,universityId,departmentId,scope,search,limit,offset);

@override
String toString() {
  return 'GetEmergencyContactsParams(universityId: $universityId, departmentId: $departmentId, scope: $scope, search: $search, limit: $limit, offset: $offset)';
}


}

/// @nodoc
abstract mixin class _$GetEmergencyContactsParamsCopyWith<$Res> implements $GetEmergencyContactsParamsCopyWith<$Res> {
  factory _$GetEmergencyContactsParamsCopyWith(_GetEmergencyContactsParams value, $Res Function(_GetEmergencyContactsParams) _then) = __$GetEmergencyContactsParamsCopyWithImpl;
@override @useResult
$Res call({
 String? universityId, String? departmentId, String? scope, String? search, int? limit, int? offset
});




}
/// @nodoc
class __$GetEmergencyContactsParamsCopyWithImpl<$Res>
    implements _$GetEmergencyContactsParamsCopyWith<$Res> {
  __$GetEmergencyContactsParamsCopyWithImpl(this._self, this._then);

  final _GetEmergencyContactsParams _self;
  final $Res Function(_GetEmergencyContactsParams) _then;

/// Create a copy of GetEmergencyContactsParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? universityId = freezed,Object? departmentId = freezed,Object? scope = freezed,Object? search = freezed,Object? limit = freezed,Object? offset = freezed,}) {
  return _then(_GetEmergencyContactsParams(
universityId: freezed == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String?,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String?,scope: freezed == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as String?,search: freezed == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,offset: freezed == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
