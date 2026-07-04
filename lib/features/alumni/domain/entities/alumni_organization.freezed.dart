// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alumni_organization.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AlumniOrganization {

 String get id; String get name; String get logoUrl; String get website;
/// Create a copy of AlumniOrganization
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlumniOrganizationCopyWith<AlumniOrganization> get copyWith => _$AlumniOrganizationCopyWithImpl<AlumniOrganization>(this as AlumniOrganization, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlumniOrganization&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.website, website) || other.website == website));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,logoUrl,website);

@override
String toString() {
  return 'AlumniOrganization(id: $id, name: $name, logoUrl: $logoUrl, website: $website)';
}


}

/// @nodoc
abstract mixin class $AlumniOrganizationCopyWith<$Res>  {
  factory $AlumniOrganizationCopyWith(AlumniOrganization value, $Res Function(AlumniOrganization) _then) = _$AlumniOrganizationCopyWithImpl;
@useResult
$Res call({
 String id, String name, String logoUrl, String website
});




}
/// @nodoc
class _$AlumniOrganizationCopyWithImpl<$Res>
    implements $AlumniOrganizationCopyWith<$Res> {
  _$AlumniOrganizationCopyWithImpl(this._self, this._then);

  final AlumniOrganization _self;
  final $Res Function(AlumniOrganization) _then;

/// Create a copy of AlumniOrganization
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


/// Adds pattern-matching-related methods to [AlumniOrganization].
extension AlumniOrganizationPatterns on AlumniOrganization {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlumniOrganization value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlumniOrganization() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlumniOrganization value)  $default,){
final _that = this;
switch (_that) {
case _AlumniOrganization():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlumniOrganization value)?  $default,){
final _that = this;
switch (_that) {
case _AlumniOrganization() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String logoUrl,  String website)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlumniOrganization() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String logoUrl,  String website)  $default,) {final _that = this;
switch (_that) {
case _AlumniOrganization():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String logoUrl,  String website)?  $default,) {final _that = this;
switch (_that) {
case _AlumniOrganization() when $default != null:
return $default(_that.id,_that.name,_that.logoUrl,_that.website);case _:
  return null;

}
}

}

/// @nodoc


class _AlumniOrganization implements AlumniOrganization {
  const _AlumniOrganization({required this.id, required this.name, required this.logoUrl, required this.website});
  

@override final  String id;
@override final  String name;
@override final  String logoUrl;
@override final  String website;

/// Create a copy of AlumniOrganization
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlumniOrganizationCopyWith<_AlumniOrganization> get copyWith => __$AlumniOrganizationCopyWithImpl<_AlumniOrganization>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlumniOrganization&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.website, website) || other.website == website));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,logoUrl,website);

@override
String toString() {
  return 'AlumniOrganization(id: $id, name: $name, logoUrl: $logoUrl, website: $website)';
}


}

/// @nodoc
abstract mixin class _$AlumniOrganizationCopyWith<$Res> implements $AlumniOrganizationCopyWith<$Res> {
  factory _$AlumniOrganizationCopyWith(_AlumniOrganization value, $Res Function(_AlumniOrganization) _then) = __$AlumniOrganizationCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String logoUrl, String website
});




}
/// @nodoc
class __$AlumniOrganizationCopyWithImpl<$Res>
    implements _$AlumniOrganizationCopyWith<$Res> {
  __$AlumniOrganizationCopyWithImpl(this._self, this._then);

  final _AlumniOrganization _self;
  final $Res Function(_AlumniOrganization) _then;

/// Create a copy of AlumniOrganization
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? logoUrl = null,Object? website = null,}) {
  return _then(_AlumniOrganization(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,logoUrl: null == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String,website: null == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
