// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'semester.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Semester {

 String get id; String get name; int get order; String get status; String get universityId; String get departmentId; int get totalCourses; double get totalCredits; int get totalMarks; List<String> get batches; String? get createdById; String? get updatedById;
/// Create a copy of Semester
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SemesterCopyWith<Semester> get copyWith => _$SemesterCopyWithImpl<Semester>(this as Semester, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Semester&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.order, order) || other.order == order)&&(identical(other.status, status) || other.status == status)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.totalCourses, totalCourses) || other.totalCourses == totalCourses)&&(identical(other.totalCredits, totalCredits) || other.totalCredits == totalCredits)&&(identical(other.totalMarks, totalMarks) || other.totalMarks == totalMarks)&&const DeepCollectionEquality().equals(other.batches, batches)&&(identical(other.createdById, createdById) || other.createdById == createdById)&&(identical(other.updatedById, updatedById) || other.updatedById == updatedById));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,order,status,universityId,departmentId,totalCourses,totalCredits,totalMarks,const DeepCollectionEquality().hash(batches),createdById,updatedById);

@override
String toString() {
  return 'Semester(id: $id, name: $name, order: $order, status: $status, universityId: $universityId, departmentId: $departmentId, totalCourses: $totalCourses, totalCredits: $totalCredits, totalMarks: $totalMarks, batches: $batches, createdById: $createdById, updatedById: $updatedById)';
}


}

/// @nodoc
abstract mixin class $SemesterCopyWith<$Res>  {
  factory $SemesterCopyWith(Semester value, $Res Function(Semester) _then) = _$SemesterCopyWithImpl;
@useResult
$Res call({
 String id, String name, int order, String status, String universityId, String departmentId, int totalCourses, double totalCredits, int totalMarks, List<String> batches, String? createdById, String? updatedById
});




}
/// @nodoc
class _$SemesterCopyWithImpl<$Res>
    implements $SemesterCopyWith<$Res> {
  _$SemesterCopyWithImpl(this._self, this._then);

  final Semester _self;
  final $Res Function(Semester) _then;

/// Create a copy of Semester
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? order = null,Object? status = null,Object? universityId = null,Object? departmentId = null,Object? totalCourses = null,Object? totalCredits = null,Object? totalMarks = null,Object? batches = null,Object? createdById = freezed,Object? updatedById = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,totalCourses: null == totalCourses ? _self.totalCourses : totalCourses // ignore: cast_nullable_to_non_nullable
as int,totalCredits: null == totalCredits ? _self.totalCredits : totalCredits // ignore: cast_nullable_to_non_nullable
as double,totalMarks: null == totalMarks ? _self.totalMarks : totalMarks // ignore: cast_nullable_to_non_nullable
as int,batches: null == batches ? _self.batches : batches // ignore: cast_nullable_to_non_nullable
as List<String>,createdById: freezed == createdById ? _self.createdById : createdById // ignore: cast_nullable_to_non_nullable
as String?,updatedById: freezed == updatedById ? _self.updatedById : updatedById // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Semester].
extension SemesterPatterns on Semester {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Semester value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Semester() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Semester value)  $default,){
final _that = this;
switch (_that) {
case _Semester():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Semester value)?  $default,){
final _that = this;
switch (_that) {
case _Semester() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int order,  String status,  String universityId,  String departmentId,  int totalCourses,  double totalCredits,  int totalMarks,  List<String> batches,  String? createdById,  String? updatedById)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Semester() when $default != null:
return $default(_that.id,_that.name,_that.order,_that.status,_that.universityId,_that.departmentId,_that.totalCourses,_that.totalCredits,_that.totalMarks,_that.batches,_that.createdById,_that.updatedById);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int order,  String status,  String universityId,  String departmentId,  int totalCourses,  double totalCredits,  int totalMarks,  List<String> batches,  String? createdById,  String? updatedById)  $default,) {final _that = this;
switch (_that) {
case _Semester():
return $default(_that.id,_that.name,_that.order,_that.status,_that.universityId,_that.departmentId,_that.totalCourses,_that.totalCredits,_that.totalMarks,_that.batches,_that.createdById,_that.updatedById);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int order,  String status,  String universityId,  String departmentId,  int totalCourses,  double totalCredits,  int totalMarks,  List<String> batches,  String? createdById,  String? updatedById)?  $default,) {final _that = this;
switch (_that) {
case _Semester() when $default != null:
return $default(_that.id,_that.name,_that.order,_that.status,_that.universityId,_that.departmentId,_that.totalCourses,_that.totalCredits,_that.totalMarks,_that.batches,_that.createdById,_that.updatedById);case _:
  return null;

}
}

}

/// @nodoc


class _Semester implements Semester {
  const _Semester({required this.id, required this.name, required this.order, required this.status, required this.universityId, required this.departmentId, required this.totalCourses, required this.totalCredits, required this.totalMarks, required final  List<String> batches, this.createdById, this.updatedById}): _batches = batches;
  

@override final  String id;
@override final  String name;
@override final  int order;
@override final  String status;
@override final  String universityId;
@override final  String departmentId;
@override final  int totalCourses;
@override final  double totalCredits;
@override final  int totalMarks;
 final  List<String> _batches;
@override List<String> get batches {
  if (_batches is EqualUnmodifiableListView) return _batches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_batches);
}

@override final  String? createdById;
@override final  String? updatedById;

/// Create a copy of Semester
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SemesterCopyWith<_Semester> get copyWith => __$SemesterCopyWithImpl<_Semester>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Semester&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.order, order) || other.order == order)&&(identical(other.status, status) || other.status == status)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.totalCourses, totalCourses) || other.totalCourses == totalCourses)&&(identical(other.totalCredits, totalCredits) || other.totalCredits == totalCredits)&&(identical(other.totalMarks, totalMarks) || other.totalMarks == totalMarks)&&const DeepCollectionEquality().equals(other._batches, _batches)&&(identical(other.createdById, createdById) || other.createdById == createdById)&&(identical(other.updatedById, updatedById) || other.updatedById == updatedById));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,order,status,universityId,departmentId,totalCourses,totalCredits,totalMarks,const DeepCollectionEquality().hash(_batches),createdById,updatedById);

@override
String toString() {
  return 'Semester(id: $id, name: $name, order: $order, status: $status, universityId: $universityId, departmentId: $departmentId, totalCourses: $totalCourses, totalCredits: $totalCredits, totalMarks: $totalMarks, batches: $batches, createdById: $createdById, updatedById: $updatedById)';
}


}

/// @nodoc
abstract mixin class _$SemesterCopyWith<$Res> implements $SemesterCopyWith<$Res> {
  factory _$SemesterCopyWith(_Semester value, $Res Function(_Semester) _then) = __$SemesterCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int order, String status, String universityId, String departmentId, int totalCourses, double totalCredits, int totalMarks, List<String> batches, String? createdById, String? updatedById
});




}
/// @nodoc
class __$SemesterCopyWithImpl<$Res>
    implements _$SemesterCopyWith<$Res> {
  __$SemesterCopyWithImpl(this._self, this._then);

  final _Semester _self;
  final $Res Function(_Semester) _then;

/// Create a copy of Semester
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? order = null,Object? status = null,Object? universityId = null,Object? departmentId = null,Object? totalCourses = null,Object? totalCredits = null,Object? totalMarks = null,Object? batches = null,Object? createdById = freezed,Object? updatedById = freezed,}) {
  return _then(_Semester(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,totalCourses: null == totalCourses ? _self.totalCourses : totalCourses // ignore: cast_nullable_to_non_nullable
as int,totalCredits: null == totalCredits ? _self.totalCredits : totalCredits // ignore: cast_nullable_to_non_nullable
as double,totalMarks: null == totalMarks ? _self.totalMarks : totalMarks // ignore: cast_nullable_to_non_nullable
as int,batches: null == batches ? _self._batches : batches // ignore: cast_nullable_to_non_nullable
as List<String>,createdById: freezed == createdById ? _self.createdById : createdById // ignore: cast_nullable_to_non_nullable
as String?,updatedById: freezed == updatedById ? _self.updatedById : updatedById // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
