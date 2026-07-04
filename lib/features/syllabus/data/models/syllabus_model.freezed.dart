// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'syllabus_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SyllabusModel {

 String get id; String get title;@JsonKey(name: 'course_code') String get courseCode;@JsonKey(name: 'course_title') String get courseTitle; String get description;@JsonKey(name: 'file_url') String get fileUrl;@JsonKey(name: 'uploader_name') String get uploaderName;@JsonKey(name: 'created_at') DateTime? get createdAt; List<String> get batches; List<dynamic> get years;@JsonKey(name: 'university_id') String get universityId;@JsonKey(name: 'department_id') String get departmentId;
/// Create a copy of SyllabusModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyllabusModelCopyWith<SyllabusModel> get copyWith => _$SyllabusModelCopyWithImpl<SyllabusModel>(this as SyllabusModel, _$identity);

  /// Serializes this SyllabusModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyllabusModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&(identical(other.description, description) || other.description == description)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&(identical(other.uploaderName, uploaderName) || other.uploaderName == uploaderName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.batches, batches)&&const DeepCollectionEquality().equals(other.years, years)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,courseCode,courseTitle,description,fileUrl,uploaderName,createdAt,const DeepCollectionEquality().hash(batches),const DeepCollectionEquality().hash(years),universityId,departmentId);

@override
String toString() {
  return 'SyllabusModel(id: $id, title: $title, courseCode: $courseCode, courseTitle: $courseTitle, description: $description, fileUrl: $fileUrl, uploaderName: $uploaderName, createdAt: $createdAt, batches: $batches, years: $years, universityId: $universityId, departmentId: $departmentId)';
}


}

/// @nodoc
abstract mixin class $SyllabusModelCopyWith<$Res>  {
  factory $SyllabusModelCopyWith(SyllabusModel value, $Res Function(SyllabusModel) _then) = _$SyllabusModelCopyWithImpl;
@useResult
$Res call({
 String id, String title,@JsonKey(name: 'course_code') String courseCode,@JsonKey(name: 'course_title') String courseTitle, String description,@JsonKey(name: 'file_url') String fileUrl,@JsonKey(name: 'uploader_name') String uploaderName,@JsonKey(name: 'created_at') DateTime? createdAt, List<String> batches, List<dynamic> years,@JsonKey(name: 'university_id') String universityId,@JsonKey(name: 'department_id') String departmentId
});




}
/// @nodoc
class _$SyllabusModelCopyWithImpl<$Res>
    implements $SyllabusModelCopyWith<$Res> {
  _$SyllabusModelCopyWithImpl(this._self, this._then);

  final SyllabusModel _self;
  final $Res Function(SyllabusModel) _then;

/// Create a copy of SyllabusModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? courseCode = null,Object? courseTitle = null,Object? description = null,Object? fileUrl = null,Object? uploaderName = null,Object? createdAt = freezed,Object? batches = null,Object? years = null,Object? universityId = null,Object? departmentId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,courseCode: null == courseCode ? _self.courseCode : courseCode // ignore: cast_nullable_to_non_nullable
as String,courseTitle: null == courseTitle ? _self.courseTitle : courseTitle // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,fileUrl: null == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String,uploaderName: null == uploaderName ? _self.uploaderName : uploaderName // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,batches: null == batches ? _self.batches : batches // ignore: cast_nullable_to_non_nullable
as List<String>,years: null == years ? _self.years : years // ignore: cast_nullable_to_non_nullable
as List<dynamic>,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SyllabusModel].
extension SyllabusModelPatterns on SyllabusModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyllabusModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyllabusModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyllabusModel value)  $default,){
final _that = this;
switch (_that) {
case _SyllabusModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyllabusModel value)?  $default,){
final _that = this;
switch (_that) {
case _SyllabusModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title, @JsonKey(name: 'course_code')  String courseCode, @JsonKey(name: 'course_title')  String courseTitle,  String description, @JsonKey(name: 'file_url')  String fileUrl, @JsonKey(name: 'uploader_name')  String uploaderName, @JsonKey(name: 'created_at')  DateTime? createdAt,  List<String> batches,  List<dynamic> years, @JsonKey(name: 'university_id')  String universityId, @JsonKey(name: 'department_id')  String departmentId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyllabusModel() when $default != null:
return $default(_that.id,_that.title,_that.courseCode,_that.courseTitle,_that.description,_that.fileUrl,_that.uploaderName,_that.createdAt,_that.batches,_that.years,_that.universityId,_that.departmentId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title, @JsonKey(name: 'course_code')  String courseCode, @JsonKey(name: 'course_title')  String courseTitle,  String description, @JsonKey(name: 'file_url')  String fileUrl, @JsonKey(name: 'uploader_name')  String uploaderName, @JsonKey(name: 'created_at')  DateTime? createdAt,  List<String> batches,  List<dynamic> years, @JsonKey(name: 'university_id')  String universityId, @JsonKey(name: 'department_id')  String departmentId)  $default,) {final _that = this;
switch (_that) {
case _SyllabusModel():
return $default(_that.id,_that.title,_that.courseCode,_that.courseTitle,_that.description,_that.fileUrl,_that.uploaderName,_that.createdAt,_that.batches,_that.years,_that.universityId,_that.departmentId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title, @JsonKey(name: 'course_code')  String courseCode, @JsonKey(name: 'course_title')  String courseTitle,  String description, @JsonKey(name: 'file_url')  String fileUrl, @JsonKey(name: 'uploader_name')  String uploaderName, @JsonKey(name: 'created_at')  DateTime? createdAt,  List<String> batches,  List<dynamic> years, @JsonKey(name: 'university_id')  String universityId, @JsonKey(name: 'department_id')  String departmentId)?  $default,) {final _that = this;
switch (_that) {
case _SyllabusModel() when $default != null:
return $default(_that.id,_that.title,_that.courseCode,_that.courseTitle,_that.description,_that.fileUrl,_that.uploaderName,_that.createdAt,_that.batches,_that.years,_that.universityId,_that.departmentId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyllabusModel extends SyllabusModel {
  const _SyllabusModel({required this.id, required this.title, @JsonKey(name: 'course_code') required this.courseCode, @JsonKey(name: 'course_title') required this.courseTitle, required this.description, @JsonKey(name: 'file_url') required this.fileUrl, @JsonKey(name: 'uploader_name') required this.uploaderName, @JsonKey(name: 'created_at') this.createdAt, required final  List<String> batches, required final  List<dynamic> years, @JsonKey(name: 'university_id') required this.universityId, @JsonKey(name: 'department_id') required this.departmentId}): _batches = batches,_years = years,super._();
  factory _SyllabusModel.fromJson(Map<String, dynamic> json) => _$SyllabusModelFromJson(json);

@override final  String id;
@override final  String title;
@override@JsonKey(name: 'course_code') final  String courseCode;
@override@JsonKey(name: 'course_title') final  String courseTitle;
@override final  String description;
@override@JsonKey(name: 'file_url') final  String fileUrl;
@override@JsonKey(name: 'uploader_name') final  String uploaderName;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
 final  List<String> _batches;
@override List<String> get batches {
  if (_batches is EqualUnmodifiableListView) return _batches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_batches);
}

 final  List<dynamic> _years;
@override List<dynamic> get years {
  if (_years is EqualUnmodifiableListView) return _years;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_years);
}

@override@JsonKey(name: 'university_id') final  String universityId;
@override@JsonKey(name: 'department_id') final  String departmentId;

/// Create a copy of SyllabusModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyllabusModelCopyWith<_SyllabusModel> get copyWith => __$SyllabusModelCopyWithImpl<_SyllabusModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyllabusModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyllabusModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&(identical(other.description, description) || other.description == description)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&(identical(other.uploaderName, uploaderName) || other.uploaderName == uploaderName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._batches, _batches)&&const DeepCollectionEquality().equals(other._years, _years)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,courseCode,courseTitle,description,fileUrl,uploaderName,createdAt,const DeepCollectionEquality().hash(_batches),const DeepCollectionEquality().hash(_years),universityId,departmentId);

@override
String toString() {
  return 'SyllabusModel(id: $id, title: $title, courseCode: $courseCode, courseTitle: $courseTitle, description: $description, fileUrl: $fileUrl, uploaderName: $uploaderName, createdAt: $createdAt, batches: $batches, years: $years, universityId: $universityId, departmentId: $departmentId)';
}


}

/// @nodoc
abstract mixin class _$SyllabusModelCopyWith<$Res> implements $SyllabusModelCopyWith<$Res> {
  factory _$SyllabusModelCopyWith(_SyllabusModel value, $Res Function(_SyllabusModel) _then) = __$SyllabusModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title,@JsonKey(name: 'course_code') String courseCode,@JsonKey(name: 'course_title') String courseTitle, String description,@JsonKey(name: 'file_url') String fileUrl,@JsonKey(name: 'uploader_name') String uploaderName,@JsonKey(name: 'created_at') DateTime? createdAt, List<String> batches, List<dynamic> years,@JsonKey(name: 'university_id') String universityId,@JsonKey(name: 'department_id') String departmentId
});




}
/// @nodoc
class __$SyllabusModelCopyWithImpl<$Res>
    implements _$SyllabusModelCopyWith<$Res> {
  __$SyllabusModelCopyWithImpl(this._self, this._then);

  final _SyllabusModel _self;
  final $Res Function(_SyllabusModel) _then;

/// Create a copy of SyllabusModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? courseCode = null,Object? courseTitle = null,Object? description = null,Object? fileUrl = null,Object? uploaderName = null,Object? createdAt = freezed,Object? batches = null,Object? years = null,Object? universityId = null,Object? departmentId = null,}) {
  return _then(_SyllabusModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,courseCode: null == courseCode ? _self.courseCode : courseCode // ignore: cast_nullable_to_non_nullable
as String,courseTitle: null == courseTitle ? _self.courseTitle : courseTitle // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,fileUrl: null == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String,uploaderName: null == uploaderName ? _self.uploaderName : uploaderName // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,batches: null == batches ? _self._batches : batches // ignore: cast_nullable_to_non_nullable
as List<String>,years: null == years ? _self._years : years // ignore: cast_nullable_to_non_nullable
as List<dynamic>,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
