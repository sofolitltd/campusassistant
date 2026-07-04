// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Teacher {

 String get id; String get universityId; String get departmentId; bool get present; bool get chairman; int get serial; String get name; String get post; String get phd; String get mobile; String get email; String get imageUrl; String get interests; String get publications; String get token;
/// Create a copy of Teacher
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherCopyWith<Teacher> get copyWith => _$TeacherCopyWithImpl<Teacher>(this as Teacher, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Teacher&&(identical(other.id, id) || other.id == id)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.present, present) || other.present == present)&&(identical(other.chairman, chairman) || other.chairman == chairman)&&(identical(other.serial, serial) || other.serial == serial)&&(identical(other.name, name) || other.name == name)&&(identical(other.post, post) || other.post == post)&&(identical(other.phd, phd) || other.phd == phd)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.email, email) || other.email == email)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.interests, interests) || other.interests == interests)&&(identical(other.publications, publications) || other.publications == publications)&&(identical(other.token, token) || other.token == token));
}


@override
int get hashCode => Object.hash(runtimeType,id,universityId,departmentId,present,chairman,serial,name,post,phd,mobile,email,imageUrl,interests,publications,token);

@override
String toString() {
  return 'Teacher(id: $id, universityId: $universityId, departmentId: $departmentId, present: $present, chairman: $chairman, serial: $serial, name: $name, post: $post, phd: $phd, mobile: $mobile, email: $email, imageUrl: $imageUrl, interests: $interests, publications: $publications, token: $token)';
}


}

/// @nodoc
abstract mixin class $TeacherCopyWith<$Res>  {
  factory $TeacherCopyWith(Teacher value, $Res Function(Teacher) _then) = _$TeacherCopyWithImpl;
@useResult
$Res call({
 String id, String universityId, String departmentId, bool present, bool chairman, int serial, String name, String post, String phd, String mobile, String email, String imageUrl, String interests, String publications, String token
});




}
/// @nodoc
class _$TeacherCopyWithImpl<$Res>
    implements $TeacherCopyWith<$Res> {
  _$TeacherCopyWithImpl(this._self, this._then);

  final Teacher _self;
  final $Res Function(Teacher) _then;

/// Create a copy of Teacher
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? universityId = null,Object? departmentId = null,Object? present = null,Object? chairman = null,Object? serial = null,Object? name = null,Object? post = null,Object? phd = null,Object? mobile = null,Object? email = null,Object? imageUrl = null,Object? interests = null,Object? publications = null,Object? token = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,present: null == present ? _self.present : present // ignore: cast_nullable_to_non_nullable
as bool,chairman: null == chairman ? _self.chairman : chairman // ignore: cast_nullable_to_non_nullable
as bool,serial: null == serial ? _self.serial : serial // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,post: null == post ? _self.post : post // ignore: cast_nullable_to_non_nullable
as String,phd: null == phd ? _self.phd : phd // ignore: cast_nullable_to_non_nullable
as String,mobile: null == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,interests: null == interests ? _self.interests : interests // ignore: cast_nullable_to_non_nullable
as String,publications: null == publications ? _self.publications : publications // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Teacher].
extension TeacherPatterns on Teacher {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Teacher value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Teacher() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Teacher value)  $default,){
final _that = this;
switch (_that) {
case _Teacher():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Teacher value)?  $default,){
final _that = this;
switch (_that) {
case _Teacher() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String universityId,  String departmentId,  bool present,  bool chairman,  int serial,  String name,  String post,  String phd,  String mobile,  String email,  String imageUrl,  String interests,  String publications,  String token)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Teacher() when $default != null:
return $default(_that.id,_that.universityId,_that.departmentId,_that.present,_that.chairman,_that.serial,_that.name,_that.post,_that.phd,_that.mobile,_that.email,_that.imageUrl,_that.interests,_that.publications,_that.token);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String universityId,  String departmentId,  bool present,  bool chairman,  int serial,  String name,  String post,  String phd,  String mobile,  String email,  String imageUrl,  String interests,  String publications,  String token)  $default,) {final _that = this;
switch (_that) {
case _Teacher():
return $default(_that.id,_that.universityId,_that.departmentId,_that.present,_that.chairman,_that.serial,_that.name,_that.post,_that.phd,_that.mobile,_that.email,_that.imageUrl,_that.interests,_that.publications,_that.token);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String universityId,  String departmentId,  bool present,  bool chairman,  int serial,  String name,  String post,  String phd,  String mobile,  String email,  String imageUrl,  String interests,  String publications,  String token)?  $default,) {final _that = this;
switch (_that) {
case _Teacher() when $default != null:
return $default(_that.id,_that.universityId,_that.departmentId,_that.present,_that.chairman,_that.serial,_that.name,_that.post,_that.phd,_that.mobile,_that.email,_that.imageUrl,_that.interests,_that.publications,_that.token);case _:
  return null;

}
}

}

/// @nodoc


class _Teacher implements Teacher {
  const _Teacher({required this.id, required this.universityId, required this.departmentId, required this.present, required this.chairman, required this.serial, required this.name, required this.post, required this.phd, required this.mobile, required this.email, required this.imageUrl, required this.interests, required this.publications, required this.token});
  

@override final  String id;
@override final  String universityId;
@override final  String departmentId;
@override final  bool present;
@override final  bool chairman;
@override final  int serial;
@override final  String name;
@override final  String post;
@override final  String phd;
@override final  String mobile;
@override final  String email;
@override final  String imageUrl;
@override final  String interests;
@override final  String publications;
@override final  String token;

/// Create a copy of Teacher
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeacherCopyWith<_Teacher> get copyWith => __$TeacherCopyWithImpl<_Teacher>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Teacher&&(identical(other.id, id) || other.id == id)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.present, present) || other.present == present)&&(identical(other.chairman, chairman) || other.chairman == chairman)&&(identical(other.serial, serial) || other.serial == serial)&&(identical(other.name, name) || other.name == name)&&(identical(other.post, post) || other.post == post)&&(identical(other.phd, phd) || other.phd == phd)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.email, email) || other.email == email)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.interests, interests) || other.interests == interests)&&(identical(other.publications, publications) || other.publications == publications)&&(identical(other.token, token) || other.token == token));
}


@override
int get hashCode => Object.hash(runtimeType,id,universityId,departmentId,present,chairman,serial,name,post,phd,mobile,email,imageUrl,interests,publications,token);

@override
String toString() {
  return 'Teacher(id: $id, universityId: $universityId, departmentId: $departmentId, present: $present, chairman: $chairman, serial: $serial, name: $name, post: $post, phd: $phd, mobile: $mobile, email: $email, imageUrl: $imageUrl, interests: $interests, publications: $publications, token: $token)';
}


}

/// @nodoc
abstract mixin class _$TeacherCopyWith<$Res> implements $TeacherCopyWith<$Res> {
  factory _$TeacherCopyWith(_Teacher value, $Res Function(_Teacher) _then) = __$TeacherCopyWithImpl;
@override @useResult
$Res call({
 String id, String universityId, String departmentId, bool present, bool chairman, int serial, String name, String post, String phd, String mobile, String email, String imageUrl, String interests, String publications, String token
});




}
/// @nodoc
class __$TeacherCopyWithImpl<$Res>
    implements _$TeacherCopyWith<$Res> {
  __$TeacherCopyWithImpl(this._self, this._then);

  final _Teacher _self;
  final $Res Function(_Teacher) _then;

/// Create a copy of Teacher
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? universityId = null,Object? departmentId = null,Object? present = null,Object? chairman = null,Object? serial = null,Object? name = null,Object? post = null,Object? phd = null,Object? mobile = null,Object? email = null,Object? imageUrl = null,Object? interests = null,Object? publications = null,Object? token = null,}) {
  return _then(_Teacher(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,present: null == present ? _self.present : present // ignore: cast_nullable_to_non_nullable
as bool,chairman: null == chairman ? _self.chairman : chairman // ignore: cast_nullable_to_non_nullable
as bool,serial: null == serial ? _self.serial : serial // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,post: null == post ? _self.post : post // ignore: cast_nullable_to_non_nullable
as String,phd: null == phd ? _self.phd : phd // ignore: cast_nullable_to_non_nullable
as String,mobile: null == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,interests: null == interests ? _self.interests : interests // ignore: cast_nullable_to_non_nullable
as String,publications: null == publications ? _self.publications : publications // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
