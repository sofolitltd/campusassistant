// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chapter_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChapterModel {

 String get id;@JsonKey(name: 'course_code') String get courseCode;@JsonKey(name: 'chapter_no') int get chapterNo;@JsonKey(name: 'chapter_title') String get chapterTitle;@JsonKey(name: 'university_id') String get universityId;@JsonKey(name: 'department_id') String get departmentId; List<dynamic> get batches;
/// Create a copy of ChapterModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChapterModelCopyWith<ChapterModel> get copyWith => _$ChapterModelCopyWithImpl<ChapterModel>(this as ChapterModel, _$identity);

  /// Serializes this ChapterModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChapterModel&&(identical(other.id, id) || other.id == id)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.chapterNo, chapterNo) || other.chapterNo == chapterNo)&&(identical(other.chapterTitle, chapterTitle) || other.chapterTitle == chapterTitle)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&const DeepCollectionEquality().equals(other.batches, batches));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseCode,chapterNo,chapterTitle,universityId,departmentId,const DeepCollectionEquality().hash(batches));

@override
String toString() {
  return 'ChapterModel(id: $id, courseCode: $courseCode, chapterNo: $chapterNo, chapterTitle: $chapterTitle, universityId: $universityId, departmentId: $departmentId, batches: $batches)';
}


}

/// @nodoc
abstract mixin class $ChapterModelCopyWith<$Res>  {
  factory $ChapterModelCopyWith(ChapterModel value, $Res Function(ChapterModel) _then) = _$ChapterModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'course_code') String courseCode,@JsonKey(name: 'chapter_no') int chapterNo,@JsonKey(name: 'chapter_title') String chapterTitle,@JsonKey(name: 'university_id') String universityId,@JsonKey(name: 'department_id') String departmentId, List<dynamic> batches
});




}
/// @nodoc
class _$ChapterModelCopyWithImpl<$Res>
    implements $ChapterModelCopyWith<$Res> {
  _$ChapterModelCopyWithImpl(this._self, this._then);

  final ChapterModel _self;
  final $Res Function(ChapterModel) _then;

/// Create a copy of ChapterModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? courseCode = null,Object? chapterNo = null,Object? chapterTitle = null,Object? universityId = null,Object? departmentId = null,Object? batches = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,courseCode: null == courseCode ? _self.courseCode : courseCode // ignore: cast_nullable_to_non_nullable
as String,chapterNo: null == chapterNo ? _self.chapterNo : chapterNo // ignore: cast_nullable_to_non_nullable
as int,chapterTitle: null == chapterTitle ? _self.chapterTitle : chapterTitle // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,batches: null == batches ? _self.batches : batches // ignore: cast_nullable_to_non_nullable
as List<dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [ChapterModel].
extension ChapterModelPatterns on ChapterModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChapterModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChapterModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChapterModel value)  $default,){
final _that = this;
switch (_that) {
case _ChapterModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChapterModel value)?  $default,){
final _that = this;
switch (_that) {
case _ChapterModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'course_code')  String courseCode, @JsonKey(name: 'chapter_no')  int chapterNo, @JsonKey(name: 'chapter_title')  String chapterTitle, @JsonKey(name: 'university_id')  String universityId, @JsonKey(name: 'department_id')  String departmentId,  List<dynamic> batches)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChapterModel() when $default != null:
return $default(_that.id,_that.courseCode,_that.chapterNo,_that.chapterTitle,_that.universityId,_that.departmentId,_that.batches);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'course_code')  String courseCode, @JsonKey(name: 'chapter_no')  int chapterNo, @JsonKey(name: 'chapter_title')  String chapterTitle, @JsonKey(name: 'university_id')  String universityId, @JsonKey(name: 'department_id')  String departmentId,  List<dynamic> batches)  $default,) {final _that = this;
switch (_that) {
case _ChapterModel():
return $default(_that.id,_that.courseCode,_that.chapterNo,_that.chapterTitle,_that.universityId,_that.departmentId,_that.batches);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'course_code')  String courseCode, @JsonKey(name: 'chapter_no')  int chapterNo, @JsonKey(name: 'chapter_title')  String chapterTitle, @JsonKey(name: 'university_id')  String universityId, @JsonKey(name: 'department_id')  String departmentId,  List<dynamic> batches)?  $default,) {final _that = this;
switch (_that) {
case _ChapterModel() when $default != null:
return $default(_that.id,_that.courseCode,_that.chapterNo,_that.chapterTitle,_that.universityId,_that.departmentId,_that.batches);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChapterModel extends ChapterModel {
  const _ChapterModel({required this.id, @JsonKey(name: 'course_code') required this.courseCode, @JsonKey(name: 'chapter_no') required this.chapterNo, @JsonKey(name: 'chapter_title') required this.chapterTitle, @JsonKey(name: 'university_id') required this.universityId, @JsonKey(name: 'department_id') required this.departmentId, required final  List<dynamic> batches}): _batches = batches,super._();
  factory _ChapterModel.fromJson(Map<String, dynamic> json) => _$ChapterModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'course_code') final  String courseCode;
@override@JsonKey(name: 'chapter_no') final  int chapterNo;
@override@JsonKey(name: 'chapter_title') final  String chapterTitle;
@override@JsonKey(name: 'university_id') final  String universityId;
@override@JsonKey(name: 'department_id') final  String departmentId;
 final  List<dynamic> _batches;
@override List<dynamic> get batches {
  if (_batches is EqualUnmodifiableListView) return _batches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_batches);
}


/// Create a copy of ChapterModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChapterModelCopyWith<_ChapterModel> get copyWith => __$ChapterModelCopyWithImpl<_ChapterModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChapterModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChapterModel&&(identical(other.id, id) || other.id == id)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.chapterNo, chapterNo) || other.chapterNo == chapterNo)&&(identical(other.chapterTitle, chapterTitle) || other.chapterTitle == chapterTitle)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&const DeepCollectionEquality().equals(other._batches, _batches));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseCode,chapterNo,chapterTitle,universityId,departmentId,const DeepCollectionEquality().hash(_batches));

@override
String toString() {
  return 'ChapterModel(id: $id, courseCode: $courseCode, chapterNo: $chapterNo, chapterTitle: $chapterTitle, universityId: $universityId, departmentId: $departmentId, batches: $batches)';
}


}

/// @nodoc
abstract mixin class _$ChapterModelCopyWith<$Res> implements $ChapterModelCopyWith<$Res> {
  factory _$ChapterModelCopyWith(_ChapterModel value, $Res Function(_ChapterModel) _then) = __$ChapterModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'course_code') String courseCode,@JsonKey(name: 'chapter_no') int chapterNo,@JsonKey(name: 'chapter_title') String chapterTitle,@JsonKey(name: 'university_id') String universityId,@JsonKey(name: 'department_id') String departmentId, List<dynamic> batches
});




}
/// @nodoc
class __$ChapterModelCopyWithImpl<$Res>
    implements _$ChapterModelCopyWith<$Res> {
  __$ChapterModelCopyWithImpl(this._self, this._then);

  final _ChapterModel _self;
  final $Res Function(_ChapterModel) _then;

/// Create a copy of ChapterModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? courseCode = null,Object? chapterNo = null,Object? chapterTitle = null,Object? universityId = null,Object? departmentId = null,Object? batches = null,}) {
  return _then(_ChapterModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,courseCode: null == courseCode ? _self.courseCode : courseCode // ignore: cast_nullable_to_non_nullable
as String,chapterNo: null == chapterNo ? _self.chapterNo : chapterNo // ignore: cast_nullable_to_non_nullable
as int,chapterTitle: null == chapterTitle ? _self.chapterTitle : chapterTitle // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,batches: null == batches ? _self._batches : batches // ignore: cast_nullable_to_non_nullable
as List<dynamic>,
  ));
}


}

// dart format on
