// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_students.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GetStudentsParams {

 String? get universityId; String? get departmentId; String? get batch; String? get search; String? get bloodGroup; int? get limit; int? get offset;
/// Create a copy of GetStudentsParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetStudentsParamsCopyWith<GetStudentsParams> get copyWith => _$GetStudentsParamsCopyWithImpl<GetStudentsParams>(this as GetStudentsParams, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetStudentsParams&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.batch, batch) || other.batch == batch)&&(identical(other.search, search) || other.search == search)&&(identical(other.bloodGroup, bloodGroup) || other.bloodGroup == bloodGroup)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset));
}


@override
int get hashCode => Object.hash(runtimeType,universityId,departmentId,batch,search,bloodGroup,limit,offset);

@override
String toString() {
  return 'GetStudentsParams(universityId: $universityId, departmentId: $departmentId, batch: $batch, search: $search, bloodGroup: $bloodGroup, limit: $limit, offset: $offset)';
}


}

/// @nodoc
abstract mixin class $GetStudentsParamsCopyWith<$Res>  {
  factory $GetStudentsParamsCopyWith(GetStudentsParams value, $Res Function(GetStudentsParams) _then) = _$GetStudentsParamsCopyWithImpl;
@useResult
$Res call({
 String? universityId, String? departmentId, String? batch, String? search, String? bloodGroup, int? limit, int? offset
});




}
/// @nodoc
class _$GetStudentsParamsCopyWithImpl<$Res>
    implements $GetStudentsParamsCopyWith<$Res> {
  _$GetStudentsParamsCopyWithImpl(this._self, this._then);

  final GetStudentsParams _self;
  final $Res Function(GetStudentsParams) _then;

/// Create a copy of GetStudentsParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? universityId = freezed,Object? departmentId = freezed,Object? batch = freezed,Object? search = freezed,Object? bloodGroup = freezed,Object? limit = freezed,Object? offset = freezed,}) {
  return _then(_self.copyWith(
universityId: freezed == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String?,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String?,batch: freezed == batch ? _self.batch : batch // ignore: cast_nullable_to_non_nullable
as String?,search: freezed == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String?,bloodGroup: freezed == bloodGroup ? _self.bloodGroup : bloodGroup // ignore: cast_nullable_to_non_nullable
as String?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,offset: freezed == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [GetStudentsParams].
extension GetStudentsParamsPatterns on GetStudentsParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetStudentsParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetStudentsParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetStudentsParams value)  $default,){
final _that = this;
switch (_that) {
case _GetStudentsParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetStudentsParams value)?  $default,){
final _that = this;
switch (_that) {
case _GetStudentsParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? universityId,  String? departmentId,  String? batch,  String? search,  String? bloodGroup,  int? limit,  int? offset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetStudentsParams() when $default != null:
return $default(_that.universityId,_that.departmentId,_that.batch,_that.search,_that.bloodGroup,_that.limit,_that.offset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? universityId,  String? departmentId,  String? batch,  String? search,  String? bloodGroup,  int? limit,  int? offset)  $default,) {final _that = this;
switch (_that) {
case _GetStudentsParams():
return $default(_that.universityId,_that.departmentId,_that.batch,_that.search,_that.bloodGroup,_that.limit,_that.offset);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? universityId,  String? departmentId,  String? batch,  String? search,  String? bloodGroup,  int? limit,  int? offset)?  $default,) {final _that = this;
switch (_that) {
case _GetStudentsParams() when $default != null:
return $default(_that.universityId,_that.departmentId,_that.batch,_that.search,_that.bloodGroup,_that.limit,_that.offset);case _:
  return null;

}
}

}

/// @nodoc


class _GetStudentsParams implements GetStudentsParams {
  const _GetStudentsParams({this.universityId, this.departmentId, this.batch, this.search, this.bloodGroup, this.limit, this.offset});
  

@override final  String? universityId;
@override final  String? departmentId;
@override final  String? batch;
@override final  String? search;
@override final  String? bloodGroup;
@override final  int? limit;
@override final  int? offset;

/// Create a copy of GetStudentsParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetStudentsParamsCopyWith<_GetStudentsParams> get copyWith => __$GetStudentsParamsCopyWithImpl<_GetStudentsParams>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetStudentsParams&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.batch, batch) || other.batch == batch)&&(identical(other.search, search) || other.search == search)&&(identical(other.bloodGroup, bloodGroup) || other.bloodGroup == bloodGroup)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset));
}


@override
int get hashCode => Object.hash(runtimeType,universityId,departmentId,batch,search,bloodGroup,limit,offset);

@override
String toString() {
  return 'GetStudentsParams(universityId: $universityId, departmentId: $departmentId, batch: $batch, search: $search, bloodGroup: $bloodGroup, limit: $limit, offset: $offset)';
}


}

/// @nodoc
abstract mixin class _$GetStudentsParamsCopyWith<$Res> implements $GetStudentsParamsCopyWith<$Res> {
  factory _$GetStudentsParamsCopyWith(_GetStudentsParams value, $Res Function(_GetStudentsParams) _then) = __$GetStudentsParamsCopyWithImpl;
@override @useResult
$Res call({
 String? universityId, String? departmentId, String? batch, String? search, String? bloodGroup, int? limit, int? offset
});




}
/// @nodoc
class __$GetStudentsParamsCopyWithImpl<$Res>
    implements _$GetStudentsParamsCopyWith<$Res> {
  __$GetStudentsParamsCopyWithImpl(this._self, this._then);

  final _GetStudentsParams _self;
  final $Res Function(_GetStudentsParams) _then;

/// Create a copy of GetStudentsParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? universityId = freezed,Object? departmentId = freezed,Object? batch = freezed,Object? search = freezed,Object? bloodGroup = freezed,Object? limit = freezed,Object? offset = freezed,}) {
  return _then(_GetStudentsParams(
universityId: freezed == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String?,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String?,batch: freezed == batch ? _self.batch : batch // ignore: cast_nullable_to_non_nullable
as String?,search: freezed == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String?,bloodGroup: freezed == bloodGroup ? _self.bloodGroup : bloodGroup // ignore: cast_nullable_to_non_nullable
as String?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,offset: freezed == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
