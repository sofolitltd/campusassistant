// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Course {

 String get id; String get courseCode; String get courseTitle; String get universityId; String get departmentId; List<Batch> get batches; double get totalCredits; int get totalMarks; String get thumbnailURL; String? get courseCategoryId; CourseCategory? get courseCategory; String? get semesterId; String? get semesterName;
/// Create a copy of Course
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseCopyWith<Course> get copyWith => _$CourseCopyWithImpl<Course>(this as Course, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Course&&(identical(other.id, id) || other.id == id)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&const DeepCollectionEquality().equals(other.batches, batches)&&(identical(other.totalCredits, totalCredits) || other.totalCredits == totalCredits)&&(identical(other.totalMarks, totalMarks) || other.totalMarks == totalMarks)&&(identical(other.thumbnailURL, thumbnailURL) || other.thumbnailURL == thumbnailURL)&&(identical(other.courseCategoryId, courseCategoryId) || other.courseCategoryId == courseCategoryId)&&(identical(other.courseCategory, courseCategory) || other.courseCategory == courseCategory)&&(identical(other.semesterId, semesterId) || other.semesterId == semesterId)&&(identical(other.semesterName, semesterName) || other.semesterName == semesterName));
}


@override
int get hashCode => Object.hash(runtimeType,id,courseCode,courseTitle,universityId,departmentId,const DeepCollectionEquality().hash(batches),totalCredits,totalMarks,thumbnailURL,courseCategoryId,courseCategory,semesterId,semesterName);

@override
String toString() {
  return 'Course(id: $id, courseCode: $courseCode, courseTitle: $courseTitle, universityId: $universityId, departmentId: $departmentId, batches: $batches, totalCredits: $totalCredits, totalMarks: $totalMarks, thumbnailURL: $thumbnailURL, courseCategoryId: $courseCategoryId, courseCategory: $courseCategory, semesterId: $semesterId, semesterName: $semesterName)';
}


}

/// @nodoc
abstract mixin class $CourseCopyWith<$Res>  {
  factory $CourseCopyWith(Course value, $Res Function(Course) _then) = _$CourseCopyWithImpl;
@useResult
$Res call({
 String id, String courseCode, String courseTitle, String universityId, String departmentId, List<Batch> batches, double totalCredits, int totalMarks, String thumbnailURL, String? courseCategoryId, CourseCategory? courseCategory, String? semesterId, String? semesterName
});


$CourseCategoryCopyWith<$Res>? get courseCategory;

}
/// @nodoc
class _$CourseCopyWithImpl<$Res>
    implements $CourseCopyWith<$Res> {
  _$CourseCopyWithImpl(this._self, this._then);

  final Course _self;
  final $Res Function(Course) _then;

/// Create a copy of Course
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? courseCode = null,Object? courseTitle = null,Object? universityId = null,Object? departmentId = null,Object? batches = null,Object? totalCredits = null,Object? totalMarks = null,Object? thumbnailURL = null,Object? courseCategoryId = freezed,Object? courseCategory = freezed,Object? semesterId = freezed,Object? semesterName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,courseCode: null == courseCode ? _self.courseCode : courseCode // ignore: cast_nullable_to_non_nullable
as String,courseTitle: null == courseTitle ? _self.courseTitle : courseTitle // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,batches: null == batches ? _self.batches : batches // ignore: cast_nullable_to_non_nullable
as List<Batch>,totalCredits: null == totalCredits ? _self.totalCredits : totalCredits // ignore: cast_nullable_to_non_nullable
as double,totalMarks: null == totalMarks ? _self.totalMarks : totalMarks // ignore: cast_nullable_to_non_nullable
as int,thumbnailURL: null == thumbnailURL ? _self.thumbnailURL : thumbnailURL // ignore: cast_nullable_to_non_nullable
as String,courseCategoryId: freezed == courseCategoryId ? _self.courseCategoryId : courseCategoryId // ignore: cast_nullable_to_non_nullable
as String?,courseCategory: freezed == courseCategory ? _self.courseCategory : courseCategory // ignore: cast_nullable_to_non_nullable
as CourseCategory?,semesterId: freezed == semesterId ? _self.semesterId : semesterId // ignore: cast_nullable_to_non_nullable
as String?,semesterName: freezed == semesterName ? _self.semesterName : semesterName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Course
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CourseCategoryCopyWith<$Res>? get courseCategory {
    if (_self.courseCategory == null) {
    return null;
  }

  return $CourseCategoryCopyWith<$Res>(_self.courseCategory!, (value) {
    return _then(_self.copyWith(courseCategory: value));
  });
}
}


/// Adds pattern-matching-related methods to [Course].
extension CoursePatterns on Course {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Course value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Course() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Course value)  $default,){
final _that = this;
switch (_that) {
case _Course():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Course value)?  $default,){
final _that = this;
switch (_that) {
case _Course() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String courseCode,  String courseTitle,  String universityId,  String departmentId,  List<Batch> batches,  double totalCredits,  int totalMarks,  String thumbnailURL,  String? courseCategoryId,  CourseCategory? courseCategory,  String? semesterId,  String? semesterName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Course() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String courseCode,  String courseTitle,  String universityId,  String departmentId,  List<Batch> batches,  double totalCredits,  int totalMarks,  String thumbnailURL,  String? courseCategoryId,  CourseCategory? courseCategory,  String? semesterId,  String? semesterName)  $default,) {final _that = this;
switch (_that) {
case _Course():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String courseCode,  String courseTitle,  String universityId,  String departmentId,  List<Batch> batches,  double totalCredits,  int totalMarks,  String thumbnailURL,  String? courseCategoryId,  CourseCategory? courseCategory,  String? semesterId,  String? semesterName)?  $default,) {final _that = this;
switch (_that) {
case _Course() when $default != null:
return $default(_that.id,_that.courseCode,_that.courseTitle,_that.universityId,_that.departmentId,_that.batches,_that.totalCredits,_that.totalMarks,_that.thumbnailURL,_that.courseCategoryId,_that.courseCategory,_that.semesterId,_that.semesterName);case _:
  return null;

}
}

}

/// @nodoc


class _Course implements Course {
  const _Course({required this.id, required this.courseCode, required this.courseTitle, required this.universityId, required this.departmentId, final  List<Batch> batches = const [], this.totalCredits = 0.0, this.totalMarks = 0, this.thumbnailURL = '', this.courseCategoryId, this.courseCategory, this.semesterId, this.semesterName}): _batches = batches;
  

@override final  String id;
@override final  String courseCode;
@override final  String courseTitle;
@override final  String universityId;
@override final  String departmentId;
 final  List<Batch> _batches;
@override@JsonKey() List<Batch> get batches {
  if (_batches is EqualUnmodifiableListView) return _batches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_batches);
}

@override@JsonKey() final  double totalCredits;
@override@JsonKey() final  int totalMarks;
@override@JsonKey() final  String thumbnailURL;
@override final  String? courseCategoryId;
@override final  CourseCategory? courseCategory;
@override final  String? semesterId;
@override final  String? semesterName;

/// Create a copy of Course
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseCopyWith<_Course> get copyWith => __$CourseCopyWithImpl<_Course>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Course&&(identical(other.id, id) || other.id == id)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&const DeepCollectionEquality().equals(other._batches, _batches)&&(identical(other.totalCredits, totalCredits) || other.totalCredits == totalCredits)&&(identical(other.totalMarks, totalMarks) || other.totalMarks == totalMarks)&&(identical(other.thumbnailURL, thumbnailURL) || other.thumbnailURL == thumbnailURL)&&(identical(other.courseCategoryId, courseCategoryId) || other.courseCategoryId == courseCategoryId)&&(identical(other.courseCategory, courseCategory) || other.courseCategory == courseCategory)&&(identical(other.semesterId, semesterId) || other.semesterId == semesterId)&&(identical(other.semesterName, semesterName) || other.semesterName == semesterName));
}


@override
int get hashCode => Object.hash(runtimeType,id,courseCode,courseTitle,universityId,departmentId,const DeepCollectionEquality().hash(_batches),totalCredits,totalMarks,thumbnailURL,courseCategoryId,courseCategory,semesterId,semesterName);

@override
String toString() {
  return 'Course(id: $id, courseCode: $courseCode, courseTitle: $courseTitle, universityId: $universityId, departmentId: $departmentId, batches: $batches, totalCredits: $totalCredits, totalMarks: $totalMarks, thumbnailURL: $thumbnailURL, courseCategoryId: $courseCategoryId, courseCategory: $courseCategory, semesterId: $semesterId, semesterName: $semesterName)';
}


}

/// @nodoc
abstract mixin class _$CourseCopyWith<$Res> implements $CourseCopyWith<$Res> {
  factory _$CourseCopyWith(_Course value, $Res Function(_Course) _then) = __$CourseCopyWithImpl;
@override @useResult
$Res call({
 String id, String courseCode, String courseTitle, String universityId, String departmentId, List<Batch> batches, double totalCredits, int totalMarks, String thumbnailURL, String? courseCategoryId, CourseCategory? courseCategory, String? semesterId, String? semesterName
});


@override $CourseCategoryCopyWith<$Res>? get courseCategory;

}
/// @nodoc
class __$CourseCopyWithImpl<$Res>
    implements _$CourseCopyWith<$Res> {
  __$CourseCopyWithImpl(this._self, this._then);

  final _Course _self;
  final $Res Function(_Course) _then;

/// Create a copy of Course
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? courseCode = null,Object? courseTitle = null,Object? universityId = null,Object? departmentId = null,Object? batches = null,Object? totalCredits = null,Object? totalMarks = null,Object? thumbnailURL = null,Object? courseCategoryId = freezed,Object? courseCategory = freezed,Object? semesterId = freezed,Object? semesterName = freezed,}) {
  return _then(_Course(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,courseCode: null == courseCode ? _self.courseCode : courseCode // ignore: cast_nullable_to_non_nullable
as String,courseTitle: null == courseTitle ? _self.courseTitle : courseTitle // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,batches: null == batches ? _self._batches : batches // ignore: cast_nullable_to_non_nullable
as List<Batch>,totalCredits: null == totalCredits ? _self.totalCredits : totalCredits // ignore: cast_nullable_to_non_nullable
as double,totalMarks: null == totalMarks ? _self.totalMarks : totalMarks // ignore: cast_nullable_to_non_nullable
as int,thumbnailURL: null == thumbnailURL ? _self.thumbnailURL : thumbnailURL // ignore: cast_nullable_to_non_nullable
as String,courseCategoryId: freezed == courseCategoryId ? _self.courseCategoryId : courseCategoryId // ignore: cast_nullable_to_non_nullable
as String?,courseCategory: freezed == courseCategory ? _self.courseCategory : courseCategory // ignore: cast_nullable_to_non_nullable
as CourseCategory?,semesterId: freezed == semesterId ? _self.semesterId : semesterId // ignore: cast_nullable_to_non_nullable
as String?,semesterName: freezed == semesterName ? _self.semesterName : semesterName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Course
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CourseCategoryCopyWith<$Res>? get courseCategory {
    if (_self.courseCategory == null) {
    return null;
  }

  return $CourseCategoryCopyWith<$Res>(_self.courseCategory!, (value) {
    return _then(_self.copyWith(courseCategory: value));
  });
}
}

// dart format on
