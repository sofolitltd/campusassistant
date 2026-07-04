// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alumni_organization_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AlumniOrganizationModel {

 String get id; String get name;@JsonKey(name: 'logo_url') String get logoUrl; String get website;
/// Create a copy of AlumniOrganizationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlumniOrganizationModelCopyWith<AlumniOrganizationModel> get copyWith => _$AlumniOrganizationModelCopyWithImpl<AlumniOrganizationModel>(this as AlumniOrganizationModel, _$identity);

  /// Serializes this AlumniOrganizationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlumniOrganizationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.website, website) || other.website == website));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,logoUrl,website);

@override
String toString() {
  return 'AlumniOrganizationModel(id: $id, name: $name, logoUrl: $logoUrl, website: $website)';
}


}

/// @nodoc
abstract mixin class $AlumniOrganizationModelCopyWith<$Res>  {
  factory $AlumniOrganizationModelCopyWith(AlumniOrganizationModel value, $Res Function(AlumniOrganizationModel) _then) = _$AlumniOrganizationModelCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(name: 'logo_url') String logoUrl, String website
});




}
/// @nodoc
class _$AlumniOrganizationModelCopyWithImpl<$Res>
    implements $AlumniOrganizationModelCopyWith<$Res> {
  _$AlumniOrganizationModelCopyWithImpl(this._self, this._then);

  final AlumniOrganizationModel _self;
  final $Res Function(AlumniOrganizationModel) _then;

/// Create a copy of AlumniOrganizationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? logoUrl = null,Object? website = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,logoUrl: null == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String,website: null == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AlumniOrganizationModel].
extension AlumniOrganizationModelPatterns on AlumniOrganizationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlumniOrganizationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlumniOrganizationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlumniOrganizationModel value)  $default,){
final _that = this;
switch (_that) {
case _AlumniOrganizationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlumniOrganizationModel value)?  $default,){
final _that = this;
switch (_that) {
case _AlumniOrganizationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'logo_url')  String logoUrl,  String website)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlumniOrganizationModel() when $default != null:
return $default(_that.id,_that.name,_that.logoUrl,_that.website);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'logo_url')  String logoUrl,  String website)  $default,) {final _that = this;
switch (_that) {
case _AlumniOrganizationModel():
return $default(_that.id,_that.name,_that.logoUrl,_that.website);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(name: 'logo_url')  String logoUrl,  String website)?  $default,) {final _that = this;
switch (_that) {
case _AlumniOrganizationModel() when $default != null:
return $default(_that.id,_that.name,_that.logoUrl,_that.website);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AlumniOrganizationModel extends AlumniOrganizationModel {
  const _AlumniOrganizationModel({required this.id, required this.name, @JsonKey(name: 'logo_url') this.logoUrl = '', this.website = ''}): super._();
  factory _AlumniOrganizationModel.fromJson(Map<String, dynamic> json) => _$AlumniOrganizationModelFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey(name: 'logo_url') final  String logoUrl;
@override@JsonKey() final  String website;

/// Create a copy of AlumniOrganizationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlumniOrganizationModelCopyWith<_AlumniOrganizationModel> get copyWith => __$AlumniOrganizationModelCopyWithImpl<_AlumniOrganizationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlumniOrganizationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlumniOrganizationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.website, website) || other.website == website));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,logoUrl,website);

@override
String toString() {
  return 'AlumniOrganizationModel(id: $id, name: $name, logoUrl: $logoUrl, website: $website)';
}


}

/// @nodoc
abstract mixin class _$AlumniOrganizationModelCopyWith<$Res> implements $AlumniOrganizationModelCopyWith<$Res> {
  factory _$AlumniOrganizationModelCopyWith(_AlumniOrganizationModel value, $Res Function(_AlumniOrganizationModel) _then) = __$AlumniOrganizationModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(name: 'logo_url') String logoUrl, String website
});




}
/// @nodoc
class __$AlumniOrganizationModelCopyWithImpl<$Res>
    implements _$AlumniOrganizationModelCopyWith<$Res> {
  __$AlumniOrganizationModelCopyWithImpl(this._self, this._then);

  final _AlumniOrganizationModel _self;
  final $Res Function(_AlumniOrganizationModel) _then;

/// Create a copy of AlumniOrganizationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? logoUrl = null,Object? website = null,}) {
  return _then(_AlumniOrganizationModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,logoUrl: null == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String,website: null == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
