// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hall_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HallModel {

 String get id; String get name; String get slug; String get universityId;
/// Create a copy of HallModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HallModelCopyWith<HallModel> get copyWith => _$HallModelCopyWithImpl<HallModel>(this as HallModel, _$identity);

  /// Serializes this HallModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HallModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.universityId, universityId) || other.universityId == universityId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,slug,universityId);

@override
String toString() {
  return 'HallModel(id: $id, name: $name, slug: $slug, universityId: $universityId)';
}


}

/// @nodoc
abstract mixin class $HallModelCopyWith<$Res>  {
  factory $HallModelCopyWith(HallModel value, $Res Function(HallModel) _then) = _$HallModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String slug, String universityId
});




}
/// @nodoc
class _$HallModelCopyWithImpl<$Res>
    implements $HallModelCopyWith<$Res> {
  _$HallModelCopyWithImpl(this._self, this._then);

  final HallModel _self;
  final $Res Function(HallModel) _then;

/// Create a copy of HallModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? universityId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HallModel].
extension HallModelPatterns on HallModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HallModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HallModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HallModel value)  $default,){
final _that = this;
switch (_that) {
case _HallModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HallModel value)?  $default,){
final _that = this;
switch (_that) {
case _HallModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String slug,  String universityId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HallModel() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.universityId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String slug,  String universityId)  $default,) {final _that = this;
switch (_that) {
case _HallModel():
return $default(_that.id,_that.name,_that.slug,_that.universityId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String slug,  String universityId)?  $default,) {final _that = this;
switch (_that) {
case _HallModel() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.universityId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HallModel extends HallModel {
  const _HallModel({required this.id, required this.name, required this.slug, required this.universityId}): super._();
  factory _HallModel.fromJson(Map<String, dynamic> json) => _$HallModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String slug;
@override final  String universityId;

/// Create a copy of HallModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HallModelCopyWith<_HallModel> get copyWith => __$HallModelCopyWithImpl<_HallModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HallModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HallModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.universityId, universityId) || other.universityId == universityId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,slug,universityId);

@override
String toString() {
  return 'HallModel(id: $id, name: $name, slug: $slug, universityId: $universityId)';
}


}

/// @nodoc
abstract mixin class _$HallModelCopyWith<$Res> implements $HallModelCopyWith<$Res> {
  factory _$HallModelCopyWith(_HallModel value, $Res Function(_HallModel) _then) = __$HallModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String slug, String universityId
});




}
/// @nodoc
class __$HallModelCopyWithImpl<$Res>
    implements _$HallModelCopyWith<$Res> {
  __$HallModelCopyWithImpl(this._self, this._then);

  final _HallModel _self;
  final $Res Function(_HallModel) _then;

/// Create a copy of HallModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? universityId = null,}) {
  return _then(_HallModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
