// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'university_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UniversityModel {

 String get id; String get name; String get acronym; String get slug; String get establishedYear; String get address; String get about; double get latitude; double get longitude; String get websiteUrl; String get logoUrl; List<String> get images; String get totalFaculties; String get totalDepartments; String get totalHalls; String get campusArea;
/// Create a copy of UniversityModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UniversityModelCopyWith<UniversityModel> get copyWith => _$UniversityModelCopyWithImpl<UniversityModel>(this as UniversityModel, _$identity);

  /// Serializes this UniversityModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UniversityModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.acronym, acronym) || other.acronym == acronym)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.establishedYear, establishedYear) || other.establishedYear == establishedYear)&&(identical(other.address, address) || other.address == address)&&(identical(other.about, about) || other.about == about)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.websiteUrl, websiteUrl) || other.websiteUrl == websiteUrl)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&const DeepCollectionEquality().equals(other.images, images)&&(identical(other.totalFaculties, totalFaculties) || other.totalFaculties == totalFaculties)&&(identical(other.totalDepartments, totalDepartments) || other.totalDepartments == totalDepartments)&&(identical(other.totalHalls, totalHalls) || other.totalHalls == totalHalls)&&(identical(other.campusArea, campusArea) || other.campusArea == campusArea));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,acronym,slug,establishedYear,address,about,latitude,longitude,websiteUrl,logoUrl,const DeepCollectionEquality().hash(images),totalFaculties,totalDepartments,totalHalls,campusArea);

@override
String toString() {
  return 'UniversityModel(id: $id, name: $name, acronym: $acronym, slug: $slug, establishedYear: $establishedYear, address: $address, about: $about, latitude: $latitude, longitude: $longitude, websiteUrl: $websiteUrl, logoUrl: $logoUrl, images: $images, totalFaculties: $totalFaculties, totalDepartments: $totalDepartments, totalHalls: $totalHalls, campusArea: $campusArea)';
}


}

/// @nodoc
abstract mixin class $UniversityModelCopyWith<$Res>  {
  factory $UniversityModelCopyWith(UniversityModel value, $Res Function(UniversityModel) _then) = _$UniversityModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String acronym, String slug, String establishedYear, String address, String about, double latitude, double longitude, String websiteUrl, String logoUrl, List<String> images, String totalFaculties, String totalDepartments, String totalHalls, String campusArea
});




}
/// @nodoc
class _$UniversityModelCopyWithImpl<$Res>
    implements $UniversityModelCopyWith<$Res> {
  _$UniversityModelCopyWithImpl(this._self, this._then);

  final UniversityModel _self;
  final $Res Function(UniversityModel) _then;

/// Create a copy of UniversityModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? acronym = null,Object? slug = null,Object? establishedYear = null,Object? address = null,Object? about = null,Object? latitude = null,Object? longitude = null,Object? websiteUrl = null,Object? logoUrl = null,Object? images = null,Object? totalFaculties = null,Object? totalDepartments = null,Object? totalHalls = null,Object? campusArea = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,acronym: null == acronym ? _self.acronym : acronym // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,establishedYear: null == establishedYear ? _self.establishedYear : establishedYear // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,about: null == about ? _self.about : about // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,websiteUrl: null == websiteUrl ? _self.websiteUrl : websiteUrl // ignore: cast_nullable_to_non_nullable
as String,logoUrl: null == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>,totalFaculties: null == totalFaculties ? _self.totalFaculties : totalFaculties // ignore: cast_nullable_to_non_nullable
as String,totalDepartments: null == totalDepartments ? _self.totalDepartments : totalDepartments // ignore: cast_nullable_to_non_nullable
as String,totalHalls: null == totalHalls ? _self.totalHalls : totalHalls // ignore: cast_nullable_to_non_nullable
as String,campusArea: null == campusArea ? _self.campusArea : campusArea // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UniversityModel].
extension UniversityModelPatterns on UniversityModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UniversityModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UniversityModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UniversityModel value)  $default,){
final _that = this;
switch (_that) {
case _UniversityModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UniversityModel value)?  $default,){
final _that = this;
switch (_that) {
case _UniversityModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String acronym,  String slug,  String establishedYear,  String address,  String about,  double latitude,  double longitude,  String websiteUrl,  String logoUrl,  List<String> images,  String totalFaculties,  String totalDepartments,  String totalHalls,  String campusArea)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UniversityModel() when $default != null:
return $default(_that.id,_that.name,_that.acronym,_that.slug,_that.establishedYear,_that.address,_that.about,_that.latitude,_that.longitude,_that.websiteUrl,_that.logoUrl,_that.images,_that.totalFaculties,_that.totalDepartments,_that.totalHalls,_that.campusArea);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String acronym,  String slug,  String establishedYear,  String address,  String about,  double latitude,  double longitude,  String websiteUrl,  String logoUrl,  List<String> images,  String totalFaculties,  String totalDepartments,  String totalHalls,  String campusArea)  $default,) {final _that = this;
switch (_that) {
case _UniversityModel():
return $default(_that.id,_that.name,_that.acronym,_that.slug,_that.establishedYear,_that.address,_that.about,_that.latitude,_that.longitude,_that.websiteUrl,_that.logoUrl,_that.images,_that.totalFaculties,_that.totalDepartments,_that.totalHalls,_that.campusArea);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String acronym,  String slug,  String establishedYear,  String address,  String about,  double latitude,  double longitude,  String websiteUrl,  String logoUrl,  List<String> images,  String totalFaculties,  String totalDepartments,  String totalHalls,  String campusArea)?  $default,) {final _that = this;
switch (_that) {
case _UniversityModel() when $default != null:
return $default(_that.id,_that.name,_that.acronym,_that.slug,_that.establishedYear,_that.address,_that.about,_that.latitude,_that.longitude,_that.websiteUrl,_that.logoUrl,_that.images,_that.totalFaculties,_that.totalDepartments,_that.totalHalls,_that.campusArea);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UniversityModel extends UniversityModel {
  const _UniversityModel({required this.id, required this.name, required this.acronym, required this.slug, required this.establishedYear, required this.address, required this.about, required this.latitude, required this.longitude, required this.websiteUrl, this.logoUrl = '', final  List<String> images = const [], this.totalFaculties = '0', this.totalDepartments = '0', this.totalHalls = '0', this.campusArea = ''}): _images = images,super._();
  factory _UniversityModel.fromJson(Map<String, dynamic> json) => _$UniversityModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String acronym;
@override final  String slug;
@override final  String establishedYear;
@override final  String address;
@override final  String about;
@override final  double latitude;
@override final  double longitude;
@override final  String websiteUrl;
@override@JsonKey() final  String logoUrl;
 final  List<String> _images;
@override@JsonKey() List<String> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

@override@JsonKey() final  String totalFaculties;
@override@JsonKey() final  String totalDepartments;
@override@JsonKey() final  String totalHalls;
@override@JsonKey() final  String campusArea;

/// Create a copy of UniversityModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UniversityModelCopyWith<_UniversityModel> get copyWith => __$UniversityModelCopyWithImpl<_UniversityModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UniversityModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UniversityModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.acronym, acronym) || other.acronym == acronym)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.establishedYear, establishedYear) || other.establishedYear == establishedYear)&&(identical(other.address, address) || other.address == address)&&(identical(other.about, about) || other.about == about)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.websiteUrl, websiteUrl) || other.websiteUrl == websiteUrl)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&const DeepCollectionEquality().equals(other._images, _images)&&(identical(other.totalFaculties, totalFaculties) || other.totalFaculties == totalFaculties)&&(identical(other.totalDepartments, totalDepartments) || other.totalDepartments == totalDepartments)&&(identical(other.totalHalls, totalHalls) || other.totalHalls == totalHalls)&&(identical(other.campusArea, campusArea) || other.campusArea == campusArea));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,acronym,slug,establishedYear,address,about,latitude,longitude,websiteUrl,logoUrl,const DeepCollectionEquality().hash(_images),totalFaculties,totalDepartments,totalHalls,campusArea);

@override
String toString() {
  return 'UniversityModel(id: $id, name: $name, acronym: $acronym, slug: $slug, establishedYear: $establishedYear, address: $address, about: $about, latitude: $latitude, longitude: $longitude, websiteUrl: $websiteUrl, logoUrl: $logoUrl, images: $images, totalFaculties: $totalFaculties, totalDepartments: $totalDepartments, totalHalls: $totalHalls, campusArea: $campusArea)';
}


}

/// @nodoc
abstract mixin class _$UniversityModelCopyWith<$Res> implements $UniversityModelCopyWith<$Res> {
  factory _$UniversityModelCopyWith(_UniversityModel value, $Res Function(_UniversityModel) _then) = __$UniversityModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String acronym, String slug, String establishedYear, String address, String about, double latitude, double longitude, String websiteUrl, String logoUrl, List<String> images, String totalFaculties, String totalDepartments, String totalHalls, String campusArea
});




}
/// @nodoc
class __$UniversityModelCopyWithImpl<$Res>
    implements _$UniversityModelCopyWith<$Res> {
  __$UniversityModelCopyWithImpl(this._self, this._then);

  final _UniversityModel _self;
  final $Res Function(_UniversityModel) _then;

/// Create a copy of UniversityModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? acronym = null,Object? slug = null,Object? establishedYear = null,Object? address = null,Object? about = null,Object? latitude = null,Object? longitude = null,Object? websiteUrl = null,Object? logoUrl = null,Object? images = null,Object? totalFaculties = null,Object? totalDepartments = null,Object? totalHalls = null,Object? campusArea = null,}) {
  return _then(_UniversityModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,acronym: null == acronym ? _self.acronym : acronym // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,establishedYear: null == establishedYear ? _self.establishedYear : establishedYear // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,about: null == about ? _self.about : about // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,websiteUrl: null == websiteUrl ? _self.websiteUrl : websiteUrl // ignore: cast_nullable_to_non_nullable
as String,logoUrl: null == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>,totalFaculties: null == totalFaculties ? _self.totalFaculties : totalFaculties // ignore: cast_nullable_to_non_nullable
as String,totalDepartments: null == totalDepartments ? _self.totalDepartments : totalDepartments // ignore: cast_nullable_to_non_nullable
as String,totalHalls: null == totalHalls ? _self.totalHalls : totalHalls // ignore: cast_nullable_to_non_nullable
as String,campusArea: null == campusArea ? _self.campusArea : campusArea // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
