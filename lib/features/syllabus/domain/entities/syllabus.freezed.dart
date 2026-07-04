// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'syllabus.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Syllabus {

 String get id; String get title; String get courseCode; String get courseTitle; String get description; String get fileUrl; String get uploaderName; DateTime? get createdAt; List<String> get batches; List<String> get years; String get universityId; String get departmentId;
/// Create a copy of Syllabus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyllabusCopyWith<Syllabus> get copyWith => _$SyllabusCopyWithImpl<Syllabus>(this as Syllabus, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Syllabus&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&(identical(other.description, description) || other.description == description)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&(identical(other.uploaderName, uploaderName) || other.uploaderName == uploaderName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.batches, batches)&&const DeepCollectionEquality().equals(other.years, years)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,courseCode,courseTitle,description,fileUrl,uploaderName,createdAt,const DeepCollectionEquality().hash(batches),const DeepCollectionEquality().hash(years),universityId,departmentId);

@override
String toString() {
  return 'Syllabus(id: $id, title: $title, courseCode: $courseCode, courseTitle: $courseTitle, description: $description, fileUrl: $fileUrl, uploaderName: $uploaderName, createdAt: $createdAt, batches: $batches, years: $years, universityId: $universityId, departmentId: $departmentId)';
}


}

/// @nodoc
abstract mixin class $SyllabusCopyWith<$Res>  {
  factory $SyllabusCopyWith(Syllabus value, $Res Function(Syllabus) _then) = _$SyllabusCopyWithImpl;
@useResult
$Res call({
 String id, String title, String courseCode, String courseTitle, String description, String fileUrl, String uploaderName, DateTime? createdAt, List<String> batches, List<String> years, String universityId, String departmentId
});




}
/// @nodoc
class _$SyllabusCopyWithImpl<$Res>
    implements $SyllabusCopyWith<$Res> {
  _$SyllabusCopyWithImpl(this._self, this._then);

  final Syllabus _self;
  final $Res Function(Syllabus) _then;

/// Create a copy of Syllabus
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
as List<String>,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Syllabus].
extension SyllabusPatterns on Syllabus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Syllabus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Syllabus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Syllabus value)  $default,){
final _that = this;
switch (_that) {
case _Syllabus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Syllabus value)?  $default,){
final _that = this;
switch (_that) {
case _Syllabus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String courseCode,  String courseTitle,  String description,  String fileUrl,  String uploaderName,  DateTime? createdAt,  List<String> batches,  List<String> years,  String universityId,  String departmentId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Syllabus() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String courseCode,  String courseTitle,  String description,  String fileUrl,  String uploaderName,  DateTime? createdAt,  List<String> batches,  List<String> years,  String universityId,  String departmentId)  $default,) {final _that = this;
switch (_that) {
case _Syllabus():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String courseCode,  String courseTitle,  String description,  String fileUrl,  String uploaderName,  DateTime? createdAt,  List<String> batches,  List<String> years,  String universityId,  String departmentId)?  $default,) {final _that = this;
switch (_that) {
case _Syllabus() when $default != null:
return $default(_that.id,_that.title,_that.courseCode,_that.courseTitle,_that.description,_that.fileUrl,_that.uploaderName,_that.createdAt,_that.batches,_that.years,_that.universityId,_that.departmentId);case _:
  return null;

}
}

}

/// @nodoc


class _Syllabus implements Syllabus {
  const _Syllabus({required this.id, required this.title, required this.courseCode, required this.courseTitle, required this.description, required this.fileUrl, required this.uploaderName, this.createdAt, required final  List<String> batches, required final  List<String> years, required this.universityId, required this.departmentId}): _batches = batches,_years = years;
  

@override final  String id;
@override final  String title;
@override final  String courseCode;
@override final  String courseTitle;
@override final  String description;
@override final  String fileUrl;
@override final  String uploaderName;
@override final  DateTime? createdAt;
 final  List<String> _batches;
@override List<String> get batches {
  if (_batches is EqualUnmodifiableListView) return _batches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_batches);
}

 final  List<String> _years;
@override List<String> get years {
  if (_years is EqualUnmodifiableListView) return _years;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_years);
}

@override final  String universityId;
@override final  String departmentId;

/// Create a copy of Syllabus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyllabusCopyWith<_Syllabus> get copyWith => __$SyllabusCopyWithImpl<_Syllabus>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Syllabus&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&(identical(other.description, description) || other.description == description)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&(identical(other.uploaderName, uploaderName) || other.uploaderName == uploaderName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._batches, _batches)&&const DeepCollectionEquality().equals(other._years, _years)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,courseCode,courseTitle,description,fileUrl,uploaderName,createdAt,const DeepCollectionEquality().hash(_batches),const DeepCollectionEquality().hash(_years),universityId,departmentId);

@override
String toString() {
  return 'Syllabus(id: $id, title: $title, courseCode: $courseCode, courseTitle: $courseTitle, description: $description, fileUrl: $fileUrl, uploaderName: $uploaderName, createdAt: $createdAt, batches: $batches, years: $years, universityId: $universityId, departmentId: $departmentId)';
}


}

/// @nodoc
abstract mixin class _$SyllabusCopyWith<$Res> implements $SyllabusCopyWith<$Res> {
  factory _$SyllabusCopyWith(_Syllabus value, $Res Function(_Syllabus) _then) = __$SyllabusCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String courseCode, String courseTitle, String description, String fileUrl, String uploaderName, DateTime? createdAt, List<String> batches, List<String> years, String universityId, String departmentId
});




}
/// @nodoc
class __$SyllabusCopyWithImpl<$Res>
    implements _$SyllabusCopyWith<$Res> {
  __$SyllabusCopyWithImpl(this._self, this._then);

  final _Syllabus _self;
  final $Res Function(_Syllabus) _then;

/// Create a copy of Syllabus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? courseCode = null,Object? courseTitle = null,Object? description = null,Object? fileUrl = null,Object? uploaderName = null,Object? createdAt = freezed,Object? batches = null,Object? years = null,Object? universityId = null,Object? departmentId = null,}) {
  return _then(_Syllabus(
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
as List<String>,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
