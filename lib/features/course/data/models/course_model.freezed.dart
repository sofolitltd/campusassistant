// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CourseModel {

 String get id;@JsonKey(name: 'course_code') String get courseCode;@JsonKey(name: 'course_title') String get courseTitle;@JsonKey(name: 'university_id') String get universityId;@JsonKey(name: 'department_id') String get departmentId; List<BatchModel> get batches;@JsonKey(name: 'total_credits') double get totalCredits;@JsonKey(name: 'total_marks') int get totalMarks;@JsonKey(name: 'thumbnail_url') String get thumbnailURL;@JsonKey(name: 'course_category_id') String? get courseCategoryId;@JsonKey(name: 'course_category') CourseCategoryModel? get courseCategory;@JsonKey(name: 'semester_id') String? get semesterId;@JsonKey(name: 'semester_name') String? get semesterName;
/// Create a copy of CourseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseModelCopyWith<CourseModel> get copyWith => _$CourseModelCopyWithImpl<CourseModel>(this as CourseModel, _$identity);

  /// Serializes this CourseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&const DeepCollectionEquality().equals(other.batches, batches)&&(identical(other.totalCredits, totalCredits) || other.totalCredits == totalCredits)&&(identical(other.totalMarks, totalMarks) || other.totalMarks == totalMarks)&&(identical(other.thumbnailURL, thumbnailURL) || other.thumbnailURL == thumbnailURL)&&(identical(other.courseCategoryId, courseCategoryId) || other.courseCategoryId == courseCategoryId)&&(identical(other.courseCategory, courseCategory) || other.courseCategory == courseCategory)&&(identical(other.semesterId, semesterId) || other.semesterId == semesterId)&&(identical(other.semesterName, semesterName) || other.semesterName == semesterName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseCode,courseTitle,universityId,departmentId,const DeepCollectionEquality().hash(batches),totalCredits,totalMarks,thumbnailURL,courseCategoryId,courseCategory,semesterId,semesterName);

@override
String toString() {
  return 'CourseModel(id: $id, courseCode: $courseCode, courseTitle: $courseTitle, universityId: $universityId, departmentId: $departmentId, batches: $batches, totalCredits: $totalCredits, totalMarks: $totalMarks, thumbnailURL: $thumbnailURL, courseCategoryId: $courseCategoryId, courseCategory: $courseCategory, semesterId: $semesterId, semesterName: $semesterName)';
}


}

/// @nodoc
abstract mixin class $CourseModelCopyWith<$Res>  {
  factory $CourseModelCopyWith(CourseModel value, $Res Function(CourseModel) _then) = _$CourseModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'course_code') String courseCode,@JsonKey(name: 'course_title') String courseTitle,@JsonKey(name: 'university_id') String universityId,@JsonKey(name: 'department_id') String departmentId, List<BatchModel> batches,@JsonKey(name: 'total_credits') double totalCredits,@JsonKey(name: 'total_marks') int totalMarks,@JsonKey(name: 'thumbnail_url') String thumbnailURL,@JsonKey(name: 'course_category_id') String? courseCategoryId,@JsonKey(name: 'course_category') CourseCategoryModel? courseCategory,@JsonKey(name: 'semester_id') String? semesterId,@JsonKey(name: 'semester_name') String? semesterName
});


$CourseCategoryModelCopyWith<$Res>? get courseCategory;

}
/// @nodoc
class _$CourseModelCopyWithImpl<$Res>
    implements $CourseModelCopyWith<$Res> {
  _$CourseModelCopyWithImpl(this._self, this._then);

  final CourseModel _self;
  final $Res Function(CourseModel) _then;

/// Create a copy of CourseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? courseCode = null,Object? courseTitle = null,Object? universityId = null,Object? departmentId = null,Object? batches = null,Object? totalCredits = null,Object? totalMarks = null,Object? thumbnailURL = null,Object? courseCategoryId = freezed,Object? courseCategory = freezed,Object? semesterId = freezed,Object? semesterName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,courseCode: null == courseCode ? _self.courseCode : courseCode // ignore: cast_nullable_to_non_nullable
as String,courseTitle: null == courseTitle ? _self.courseTitle : courseTitle // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,batches: null == batches ? _self.batches : batches // ignore: cast_nullable_to_non_nullable
as List<BatchModel>,totalCredits: null == totalCredits ? _self.totalCredits : totalCredits // ignore: cast_nullable_to_non_nullable
as double,totalMarks: null == totalMarks ? _self.totalMarks : totalMarks // ignore: cast_nullable_to_non_nullable
as int,thumbnailURL: null == thumbnailURL ? _self.thumbnailURL : thumbnailURL // ignore: cast_nullable_to_non_nullable
as String,courseCategoryId: freezed == courseCategoryId ? _self.courseCategoryId : courseCategoryId // ignore: cast_nullable_to_non_nullable
as String?,courseCategory: freezed == courseCategory ? _self.courseCategory : courseCategory // ignore: cast_nullable_to_non_nullable
as CourseCategoryModel?,semesterId: freezed == semesterId ? _self.semesterId : semesterId // ignore: cast_nullable_to_non_nullable
as String?,semesterName: freezed == semesterName ? _self.semesterName : semesterName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of CourseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CourseCategoryModelCopyWith<$Res>? get courseCategory {
    if (_self.courseCategory == null) {
    return null;
  }

  return $CourseCategoryModelCopyWith<$Res>(_self.courseCategory!, (value) {
    return _then(_self.copyWith(courseCategory: value));
  });
}
}


/// Adds pattern-matching-related methods to [CourseModel].
extension CourseModelPatterns on CourseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseModel value)  $default,){
final _that = this;
switch (_that) {
case _CourseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseModel value)?  $default,){
final _that = this;
switch (_that) {
case _CourseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'course_code')  String courseCode, @JsonKey(name: 'course_title')  String courseTitle, @JsonKey(name: 'university_id')  String universityId, @JsonKey(name: 'department_id')  String departmentId,  List<BatchModel> batches, @JsonKey(name: 'total_credits')  double totalCredits, @JsonKey(name: 'total_marks')  int totalMarks, @JsonKey(name: 'thumbnail_url')  String thumbnailURL, @JsonKey(name: 'course_category_id')  String? courseCategoryId, @JsonKey(name: 'course_category')  CourseCategoryModel? courseCategory, @JsonKey(name: 'semester_id')  String? semesterId, @JsonKey(name: 'semester_name')  String? semesterName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseModel() when $default != null:
return $default(_that.id,_that.courseCode,_that.courseTitle,_that.universityId,_that.departmentId,_that.batches,_that.totalCredits,_that.totalMarks,_that.thumbnailURL,_that.courseCategoryId,_that.courseCategory,_that.semesterId,_that.semesterName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'course_code')  String courseCode, @JsonKey(name: 'course_title')  String courseTitle, @JsonKey(name: 'university_id')  String universityId, @JsonKey(name: 'department_id')  String departmentId,  List<BatchModel> batches, @JsonKey(name: 'total_credits')  double totalCredits, @JsonKey(name: 'total_marks')  int totalMarks, @JsonKey(name: 'thumbnail_url')  String thumbnailURL, @JsonKey(name: 'course_category_id')  String? courseCategoryId, @JsonKey(name: 'course_category')  CourseCategoryModel? courseCategory, @JsonKey(name: 'semester_id')  String? semesterId, @JsonKey(name: 'semester_name')  String? semesterName)  $default,) {final _that = this;
switch (_that) {
case _CourseModel():
return $default(_that.id,_that.courseCode,_that.courseTitle,_that.universityId,_that.departmentId,_that.batches,_that.totalCredits,_that.totalMarks,_that.thumbnailURL,_that.courseCategoryId,_that.courseCategory,_that.semesterId,_that.semesterName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'course_code')  String courseCode, @JsonKey(name: 'course_title')  String courseTitle, @JsonKey(name: 'university_id')  String universityId, @JsonKey(name: 'department_id')  String departmentId,  List<BatchModel> batches, @JsonKey(name: 'total_credits')  double totalCredits, @JsonKey(name: 'total_marks')  int totalMarks, @JsonKey(name: 'thumbnail_url')  String thumbnailURL, @JsonKey(name: 'course_category_id')  String? courseCategoryId, @JsonKey(name: 'course_category')  CourseCategoryModel? courseCategory, @JsonKey(name: 'semester_id')  String? semesterId, @JsonKey(name: 'semester_name')  String? semesterName)?  $default,) {final _that = this;
switch (_that) {
case _CourseModel() when $default != null:
return $default(_that.id,_that.courseCode,_that.courseTitle,_that.universityId,_that.departmentId,_that.batches,_that.totalCredits,_that.totalMarks,_that.thumbnailURL,_that.courseCategoryId,_that.courseCategory,_that.semesterId,_that.semesterName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CourseModel extends CourseModel {
  const _CourseModel({required this.id, @JsonKey(name: 'course_code') required this.courseCode, @JsonKey(name: 'course_title') required this.courseTitle, @JsonKey(name: 'university_id') required this.universityId, @JsonKey(name: 'department_id') required this.departmentId, final  List<BatchModel> batches = const [], @JsonKey(name: 'total_credits') this.totalCredits = 0.0, @JsonKey(name: 'total_marks') this.totalMarks = 0, @JsonKey(name: 'thumbnail_url') this.thumbnailURL = '', @JsonKey(name: 'course_category_id') this.courseCategoryId, @JsonKey(name: 'course_category') this.courseCategory, @JsonKey(name: 'semester_id') this.semesterId, @JsonKey(name: 'semester_name') this.semesterName}): _batches = batches,super._();
  factory _CourseModel.fromJson(Map<String, dynamic> json) => _$CourseModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'course_code') final  String courseCode;
@override@JsonKey(name: 'course_title') final  String courseTitle;
@override@JsonKey(name: 'university_id') final  String universityId;
@override@JsonKey(name: 'department_id') final  String departmentId;
 final  List<BatchModel> _batches;
@override@JsonKey() List<BatchModel> get batches {
  if (_batches is EqualUnmodifiableListView) return _batches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_batches);
}

@override@JsonKey(name: 'total_credits') final  double totalCredits;
@override@JsonKey(name: 'total_marks') final  int totalMarks;
@override@JsonKey(name: 'thumbnail_url') final  String thumbnailURL;
@override@JsonKey(name: 'course_category_id') final  String? courseCategoryId;
@override@JsonKey(name: 'course_category') final  CourseCategoryModel? courseCategory;
@override@JsonKey(name: 'semester_id') final  String? semesterId;
@override@JsonKey(name: 'semester_name') final  String? semesterName;

/// Create a copy of CourseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseModelCopyWith<_CourseModel> get copyWith => __$CourseModelCopyWithImpl<_CourseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CourseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&const DeepCollectionEquality().equals(other._batches, _batches)&&(identical(other.totalCredits, totalCredits) || other.totalCredits == totalCredits)&&(identical(other.totalMarks, totalMarks) || other.totalMarks == totalMarks)&&(identical(other.thumbnailURL, thumbnailURL) || other.thumbnailURL == thumbnailURL)&&(identical(other.courseCategoryId, courseCategoryId) || other.courseCategoryId == courseCategoryId)&&(identical(other.courseCategory, courseCategory) || other.courseCategory == courseCategory)&&(identical(other.semesterId, semesterId) || other.semesterId == semesterId)&&(identical(other.semesterName, semesterName) || other.semesterName == semesterName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseCode,courseTitle,universityId,departmentId,const DeepCollectionEquality().hash(_batches),totalCredits,totalMarks,thumbnailURL,courseCategoryId,courseCategory,semesterId,semesterName);

@override
String toString() {
  return 'CourseModel(id: $id, courseCode: $courseCode, courseTitle: $courseTitle, universityId: $universityId, departmentId: $departmentId, batches: $batches, totalCredits: $totalCredits, totalMarks: $totalMarks, thumbnailURL: $thumbnailURL, courseCategoryId: $courseCategoryId, courseCategory: $courseCategory, semesterId: $semesterId, semesterName: $semesterName)';
}


}

/// @nodoc
abstract mixin class _$CourseModelCopyWith<$Res> implements $CourseModelCopyWith<$Res> {
  factory _$CourseModelCopyWith(_CourseModel value, $Res Function(_CourseModel) _then) = __$CourseModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'course_code') String courseCode,@JsonKey(name: 'course_title') String courseTitle,@JsonKey(name: 'university_id') String universityId,@JsonKey(name: 'department_id') String departmentId, List<BatchModel> batches,@JsonKey(name: 'total_credits') double totalCredits,@JsonKey(name: 'total_marks') int totalMarks,@JsonKey(name: 'thumbnail_url') String thumbnailURL,@JsonKey(name: 'course_category_id') String? courseCategoryId,@JsonKey(name: 'course_category') CourseCategoryModel? courseCategory,@JsonKey(name: 'semester_id') String? semesterId,@JsonKey(name: 'semester_name') String? semesterName
});


@override $CourseCategoryModelCopyWith<$Res>? get courseCategory;

}
/// @nodoc
class __$CourseModelCopyWithImpl<$Res>
    implements _$CourseModelCopyWith<$Res> {
  __$CourseModelCopyWithImpl(this._self, this._then);

  final _CourseModel _self;
  final $Res Function(_CourseModel) _then;

/// Create a copy of CourseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? courseCode = null,Object? courseTitle = null,Object? universityId = null,Object? departmentId = null,Object? batches = null,Object? totalCredits = null,Object? totalMarks = null,Object? thumbnailURL = null,Object? courseCategoryId = freezed,Object? courseCategory = freezed,Object? semesterId = freezed,Object? semesterName = freezed,}) {
  return _then(_CourseModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,courseCode: null == courseCode ? _self.courseCode : courseCode // ignore: cast_nullable_to_non_nullable
as String,courseTitle: null == courseTitle ? _self.courseTitle : courseTitle // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,batches: null == batches ? _self._batches : batches // ignore: cast_nullable_to_non_nullable
as List<BatchModel>,totalCredits: null == totalCredits ? _self.totalCredits : totalCredits // ignore: cast_nullable_to_non_nullable
as double,totalMarks: null == totalMarks ? _self.totalMarks : totalMarks // ignore: cast_nullable_to_non_nullable
as int,thumbnailURL: null == thumbnailURL ? _self.thumbnailURL : thumbnailURL // ignore: cast_nullable_to_non_nullable
as String,courseCategoryId: freezed == courseCategoryId ? _self.courseCategoryId : courseCategoryId // ignore: cast_nullable_to_non_nullable
as String?,courseCategory: freezed == courseCategory ? _self.courseCategory : courseCategory // ignore: cast_nullable_to_non_nullable
as CourseCategoryModel?,semesterId: freezed == semesterId ? _self.semesterId : semesterId // ignore: cast_nullable_to_non_nullable
as String?,semesterName: freezed == semesterName ? _self.semesterName : semesterName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of CourseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CourseCategoryModelCopyWith<$Res>? get courseCategory {
    if (_self.courseCategory == null) {
    return null;
  }

  return $CourseCategoryModelCopyWith<$Res>(_self.courseCategory!, (value) {
    return _then(_self.copyWith(courseCategory: value));
  });
}
}

// dart format on
