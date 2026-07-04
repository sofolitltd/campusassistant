// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeacherModel {

 String get id;@JsonKey(name: 'university_id') String get universityId;@JsonKey(name: 'department_id') String get departmentId; bool get present; bool get chairman; int get serial; String get name; String get post; String get phd; String get mobile; String get email;@JsonKey(name: 'image_url') String get imageUrl; String get interests; String get publications; String get token;
/// Create a copy of TeacherModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherModelCopyWith<TeacherModel> get copyWith => _$TeacherModelCopyWithImpl<TeacherModel>(this as TeacherModel, _$identity);

  /// Serializes this TeacherModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherModel&&(identical(other.id, id) || other.id == id)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.present, present) || other.present == present)&&(identical(other.chairman, chairman) || other.chairman == chairman)&&(identical(other.serial, serial) || other.serial == serial)&&(identical(other.name, name) || other.name == name)&&(identical(other.post, post) || other.post == post)&&(identical(other.phd, phd) || other.phd == phd)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.email, email) || other.email == email)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.interests, interests) || other.interests == interests)&&(identical(other.publications, publications) || other.publications == publications)&&(identical(other.token, token) || other.token == token));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,universityId,departmentId,present,chairman,serial,name,post,phd,mobile,email,imageUrl,interests,publications,token);

@override
String toString() {
  return 'TeacherModel(id: $id, universityId: $universityId, departmentId: $departmentId, present: $present, chairman: $chairman, serial: $serial, name: $name, post: $post, phd: $phd, mobile: $mobile, email: $email, imageUrl: $imageUrl, interests: $interests, publications: $publications, token: $token)';
}


}

/// @nodoc
abstract mixin class $TeacherModelCopyWith<$Res>  {
  factory $TeacherModelCopyWith(TeacherModel value, $Res Function(TeacherModel) _then) = _$TeacherModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'university_id') String universityId,@JsonKey(name: 'department_id') String departmentId, bool present, bool chairman, int serial, String name, String post, String phd, String mobile, String email,@JsonKey(name: 'image_url') String imageUrl, String interests, String publications, String token
});




}
/// @nodoc
class _$TeacherModelCopyWithImpl<$Res>
    implements $TeacherModelCopyWith<$Res> {
  _$TeacherModelCopyWithImpl(this._self, this._then);

  final TeacherModel _self;
  final $Res Function(TeacherModel) _then;

/// Create a copy of TeacherModel
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


/// Adds pattern-matching-related methods to [TeacherModel].
extension TeacherModelPatterns on TeacherModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeacherModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeacherModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeacherModel value)  $default,){
final _that = this;
switch (_that) {
case _TeacherModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeacherModel value)?  $default,){
final _that = this;
switch (_that) {
case _TeacherModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'university_id')  String universityId, @JsonKey(name: 'department_id')  String departmentId,  bool present,  bool chairman,  int serial,  String name,  String post,  String phd,  String mobile,  String email, @JsonKey(name: 'image_url')  String imageUrl,  String interests,  String publications,  String token)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeacherModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'university_id')  String universityId, @JsonKey(name: 'department_id')  String departmentId,  bool present,  bool chairman,  int serial,  String name,  String post,  String phd,  String mobile,  String email, @JsonKey(name: 'image_url')  String imageUrl,  String interests,  String publications,  String token)  $default,) {final _that = this;
switch (_that) {
case _TeacherModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'university_id')  String universityId, @JsonKey(name: 'department_id')  String departmentId,  bool present,  bool chairman,  int serial,  String name,  String post,  String phd,  String mobile,  String email, @JsonKey(name: 'image_url')  String imageUrl,  String interests,  String publications,  String token)?  $default,) {final _that = this;
switch (_that) {
case _TeacherModel() when $default != null:
return $default(_that.id,_that.universityId,_that.departmentId,_that.present,_that.chairman,_that.serial,_that.name,_that.post,_that.phd,_that.mobile,_that.email,_that.imageUrl,_that.interests,_that.publications,_that.token);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeacherModel extends TeacherModel {
  const _TeacherModel({required this.id, @JsonKey(name: 'university_id') required this.universityId, @JsonKey(name: 'department_id') required this.departmentId, required this.present, required this.chairman, required this.serial, required this.name, required this.post, required this.phd, required this.mobile, required this.email, @JsonKey(name: 'image_url') required this.imageUrl, required this.interests, required this.publications, required this.token}): super._();
  factory _TeacherModel.fromJson(Map<String, dynamic> json) => _$TeacherModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'university_id') final  String universityId;
@override@JsonKey(name: 'department_id') final  String departmentId;
@override final  bool present;
@override final  bool chairman;
@override final  int serial;
@override final  String name;
@override final  String post;
@override final  String phd;
@override final  String mobile;
@override final  String email;
@override@JsonKey(name: 'image_url') final  String imageUrl;
@override final  String interests;
@override final  String publications;
@override final  String token;

/// Create a copy of TeacherModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeacherModelCopyWith<_TeacherModel> get copyWith => __$TeacherModelCopyWithImpl<_TeacherModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeacherModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeacherModel&&(identical(other.id, id) || other.id == id)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.present, present) || other.present == present)&&(identical(other.chairman, chairman) || other.chairman == chairman)&&(identical(other.serial, serial) || other.serial == serial)&&(identical(other.name, name) || other.name == name)&&(identical(other.post, post) || other.post == post)&&(identical(other.phd, phd) || other.phd == phd)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.email, email) || other.email == email)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.interests, interests) || other.interests == interests)&&(identical(other.publications, publications) || other.publications == publications)&&(identical(other.token, token) || other.token == token));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,universityId,departmentId,present,chairman,serial,name,post,phd,mobile,email,imageUrl,interests,publications,token);

@override
String toString() {
  return 'TeacherModel(id: $id, universityId: $universityId, departmentId: $departmentId, present: $present, chairman: $chairman, serial: $serial, name: $name, post: $post, phd: $phd, mobile: $mobile, email: $email, imageUrl: $imageUrl, interests: $interests, publications: $publications, token: $token)';
}


}

/// @nodoc
abstract mixin class _$TeacherModelCopyWith<$Res> implements $TeacherModelCopyWith<$Res> {
  factory _$TeacherModelCopyWith(_TeacherModel value, $Res Function(_TeacherModel) _then) = __$TeacherModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'university_id') String universityId,@JsonKey(name: 'department_id') String departmentId, bool present, bool chairman, int serial, String name, String post, String phd, String mobile, String email,@JsonKey(name: 'image_url') String imageUrl, String interests, String publications, String token
});




}
/// @nodoc
class __$TeacherModelCopyWithImpl<$Res>
    implements _$TeacherModelCopyWith<$Res> {
  __$TeacherModelCopyWithImpl(this._self, this._then);

  final _TeacherModel _self;
  final $Res Function(_TeacherModel) _then;

/// Create a copy of TeacherModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? universityId = null,Object? departmentId = null,Object? present = null,Object? chairman = null,Object? serial = null,Object? name = null,Object? post = null,Object? phd = null,Object? mobile = null,Object? email = null,Object? imageUrl = null,Object? interests = null,Object? publications = null,Object? token = null,}) {
  return _then(_TeacherModel(
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
