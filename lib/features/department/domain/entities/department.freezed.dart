// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'department.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Department {

 String get id; String get name; String get acronym; String get slug; String get universityId; int get establishedYear; String get about; String get logoUrl; String get websiteUrl; List<String> get images;
/// Create a copy of Department
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DepartmentCopyWith<Department> get copyWith => _$DepartmentCopyWithImpl<Department>(this as Department, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Department&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.acronym, acronym) || other.acronym == acronym)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.establishedYear, establishedYear) || other.establishedYear == establishedYear)&&(identical(other.about, about) || other.about == about)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.websiteUrl, websiteUrl) || other.websiteUrl == websiteUrl)&&const DeepCollectionEquality().equals(other.images, images));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,acronym,slug,universityId,establishedYear,about,logoUrl,websiteUrl,const DeepCollectionEquality().hash(images));

@override
String toString() {
  return 'Department(id: $id, name: $name, acronym: $acronym, slug: $slug, universityId: $universityId, establishedYear: $establishedYear, about: $about, logoUrl: $logoUrl, websiteUrl: $websiteUrl, images: $images)';
}


}

/// @nodoc
abstract mixin class $DepartmentCopyWith<$Res>  {
  factory $DepartmentCopyWith(Department value, $Res Function(Department) _then) = _$DepartmentCopyWithImpl;
@useResult
$Res call({
 String id, String name, String acronym, String slug, String universityId, int establishedYear, String about, String logoUrl, String websiteUrl, List<String> images
});




}
/// @nodoc
class _$DepartmentCopyWithImpl<$Res>
    implements $DepartmentCopyWith<$Res> {
  _$DepartmentCopyWithImpl(this._self, this._then);

  final Department _self;
  final $Res Function(Department) _then;

/// Create a copy of Department
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? acronym = null,Object? slug = null,Object? universityId = null,Object? establishedYear = null,Object? about = null,Object? logoUrl = null,Object? websiteUrl = null,Object? images = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,acronym: null == acronym ? _self.acronym : acronym // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,establishedYear: null == establishedYear ? _self.establishedYear : establishedYear // ignore: cast_nullable_to_non_nullable
as int,about: null == about ? _self.about : about // ignore: cast_nullable_to_non_nullable
as String,logoUrl: null == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String,websiteUrl: null == websiteUrl ? _self.websiteUrl : websiteUrl // ignore: cast_nullable_to_non_nullable
as String,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Department].
extension DepartmentPatterns on Department {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Department value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Department() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Department value)  $default,){
final _that = this;
switch (_that) {
case _Department():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Department value)?  $default,){
final _that = this;
switch (_that) {
case _Department() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String acronym,  String slug,  String universityId,  int establishedYear,  String about,  String logoUrl,  String websiteUrl,  List<String> images)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Department() when $default != null:
return $default(_that.id,_that.name,_that.acronym,_that.slug,_that.universityId,_that.establishedYear,_that.about,_that.logoUrl,_that.websiteUrl,_that.images);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String acronym,  String slug,  String universityId,  int establishedYear,  String about,  String logoUrl,  String websiteUrl,  List<String> images)  $default,) {final _that = this;
switch (_that) {
case _Department():
return $default(_that.id,_that.name,_that.acronym,_that.slug,_that.universityId,_that.establishedYear,_that.about,_that.logoUrl,_that.websiteUrl,_that.images);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String acronym,  String slug,  String universityId,  int establishedYear,  String about,  String logoUrl,  String websiteUrl,  List<String> images)?  $default,) {final _that = this;
switch (_that) {
case _Department() when $default != null:
return $default(_that.id,_that.name,_that.acronym,_that.slug,_that.universityId,_that.establishedYear,_that.about,_that.logoUrl,_that.websiteUrl,_that.images);case _:
  return null;

}
}

}

/// @nodoc


class _Department implements Department {
  const _Department({required this.id, required this.name, required this.acronym, required this.slug, required this.universityId, required this.establishedYear, required this.about, this.logoUrl = '', this.websiteUrl = '', final  List<String> images = const []}): _images = images;
  

@override final  String id;
@override final  String name;
@override final  String acronym;
@override final  String slug;
@override final  String universityId;
@override final  int establishedYear;
@override final  String about;
@override@JsonKey() final  String logoUrl;
@override@JsonKey() final  String websiteUrl;
 final  List<String> _images;
@override@JsonKey() List<String> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}


/// Create a copy of Department
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DepartmentCopyWith<_Department> get copyWith => __$DepartmentCopyWithImpl<_Department>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Department&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.acronym, acronym) || other.acronym == acronym)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.establishedYear, establishedYear) || other.establishedYear == establishedYear)&&(identical(other.about, about) || other.about == about)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.websiteUrl, websiteUrl) || other.websiteUrl == websiteUrl)&&const DeepCollectionEquality().equals(other._images, _images));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,acronym,slug,universityId,establishedYear,about,logoUrl,websiteUrl,const DeepCollectionEquality().hash(_images));

@override
String toString() {
  return 'Department(id: $id, name: $name, acronym: $acronym, slug: $slug, universityId: $universityId, establishedYear: $establishedYear, about: $about, logoUrl: $logoUrl, websiteUrl: $websiteUrl, images: $images)';
}


}

/// @nodoc
abstract mixin class _$DepartmentCopyWith<$Res> implements $DepartmentCopyWith<$Res> {
  factory _$DepartmentCopyWith(_Department value, $Res Function(_Department) _then) = __$DepartmentCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String acronym, String slug, String universityId, int establishedYear, String about, String logoUrl, String websiteUrl, List<String> images
});




}
/// @nodoc
class __$DepartmentCopyWithImpl<$Res>
    implements _$DepartmentCopyWith<$Res> {
  __$DepartmentCopyWithImpl(this._self, this._then);

  final _Department _self;
  final $Res Function(_Department) _then;

/// Create a copy of Department
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? acronym = null,Object? slug = null,Object? universityId = null,Object? establishedYear = null,Object? about = null,Object? logoUrl = null,Object? websiteUrl = null,Object? images = null,}) {
  return _then(_Department(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,acronym: null == acronym ? _self.acronym : acronym // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,establishedYear: null == establishedYear ? _self.establishedYear : establishedYear // ignore: cast_nullable_to_non_nullable
as int,about: null == about ? _self.about : about // ignore: cast_nullable_to_non_nullable
as String,logoUrl: null == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String,websiteUrl: null == websiteUrl ? _self.websiteUrl : websiteUrl // ignore: cast_nullable_to_non_nullable
as String,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
