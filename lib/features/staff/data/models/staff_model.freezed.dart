// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'staff_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StaffModel {

 String get id;@JsonKey(name: 'university_id') String get universityId;@JsonKey(name: 'department_id') String get departmentId; String get name; String get post; String get mobile;@JsonKey(name: 'image_url') String get imageUrl; int get serial;@JsonKey(name: 'verification_code') String get verificationCode;@JsonKey(name: 'is_claimed') bool get isClaimed;
/// Create a copy of StaffModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StaffModelCopyWith<StaffModel> get copyWith => _$StaffModelCopyWithImpl<StaffModel>(this as StaffModel, _$identity);

  /// Serializes this StaffModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StaffModel&&(identical(other.id, id) || other.id == id)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.name, name) || other.name == name)&&(identical(other.post, post) || other.post == post)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.serial, serial) || other.serial == serial)&&(identical(other.verificationCode, verificationCode) || other.verificationCode == verificationCode)&&(identical(other.isClaimed, isClaimed) || other.isClaimed == isClaimed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,universityId,departmentId,name,post,mobile,imageUrl,serial,verificationCode,isClaimed);

@override
String toString() {
  return 'StaffModel(id: $id, universityId: $universityId, departmentId: $departmentId, name: $name, post: $post, mobile: $mobile, imageUrl: $imageUrl, serial: $serial, verificationCode: $verificationCode, isClaimed: $isClaimed)';
}


}

/// @nodoc
abstract mixin class $StaffModelCopyWith<$Res>  {
  factory $StaffModelCopyWith(StaffModel value, $Res Function(StaffModel) _then) = _$StaffModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'university_id') String universityId,@JsonKey(name: 'department_id') String departmentId, String name, String post, String mobile,@JsonKey(name: 'image_url') String imageUrl, int serial,@JsonKey(name: 'verification_code') String verificationCode,@JsonKey(name: 'is_claimed') bool isClaimed
});




}
/// @nodoc
class _$StaffModelCopyWithImpl<$Res>
    implements $StaffModelCopyWith<$Res> {
  _$StaffModelCopyWithImpl(this._self, this._then);

  final StaffModel _self;
  final $Res Function(StaffModel) _then;

/// Create a copy of StaffModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? universityId = null,Object? departmentId = null,Object? name = null,Object? post = null,Object? mobile = null,Object? imageUrl = null,Object? serial = null,Object? verificationCode = null,Object? isClaimed = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,post: null == post ? _self.post : post // ignore: cast_nullable_to_non_nullable
as String,mobile: null == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,serial: null == serial ? _self.serial : serial // ignore: cast_nullable_to_non_nullable
as int,verificationCode: null == verificationCode ? _self.verificationCode : verificationCode // ignore: cast_nullable_to_non_nullable
as String,isClaimed: null == isClaimed ? _self.isClaimed : isClaimed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StaffModel].
extension StaffModelPatterns on StaffModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StaffModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StaffModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StaffModel value)  $default,){
final _that = this;
switch (_that) {
case _StaffModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StaffModel value)?  $default,){
final _that = this;
switch (_that) {
case _StaffModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'university_id')  String universityId, @JsonKey(name: 'department_id')  String departmentId,  String name,  String post,  String mobile, @JsonKey(name: 'image_url')  String imageUrl,  int serial, @JsonKey(name: 'verification_code')  String verificationCode, @JsonKey(name: 'is_claimed')  bool isClaimed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StaffModel() when $default != null:
return $default(_that.id,_that.universityId,_that.departmentId,_that.name,_that.post,_that.mobile,_that.imageUrl,_that.serial,_that.verificationCode,_that.isClaimed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'university_id')  String universityId, @JsonKey(name: 'department_id')  String departmentId,  String name,  String post,  String mobile, @JsonKey(name: 'image_url')  String imageUrl,  int serial, @JsonKey(name: 'verification_code')  String verificationCode, @JsonKey(name: 'is_claimed')  bool isClaimed)  $default,) {final _that = this;
switch (_that) {
case _StaffModel():
return $default(_that.id,_that.universityId,_that.departmentId,_that.name,_that.post,_that.mobile,_that.imageUrl,_that.serial,_that.verificationCode,_that.isClaimed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'university_id')  String universityId, @JsonKey(name: 'department_id')  String departmentId,  String name,  String post,  String mobile, @JsonKey(name: 'image_url')  String imageUrl,  int serial, @JsonKey(name: 'verification_code')  String verificationCode, @JsonKey(name: 'is_claimed')  bool isClaimed)?  $default,) {final _that = this;
switch (_that) {
case _StaffModel() when $default != null:
return $default(_that.id,_that.universityId,_that.departmentId,_that.name,_that.post,_that.mobile,_that.imageUrl,_that.serial,_that.verificationCode,_that.isClaimed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StaffModel extends StaffModel {
  const _StaffModel({required this.id, @JsonKey(name: 'university_id') required this.universityId, @JsonKey(name: 'department_id') required this.departmentId, required this.name, required this.post, required this.mobile, @JsonKey(name: 'image_url') required this.imageUrl, required this.serial, @JsonKey(name: 'verification_code') this.verificationCode = '', @JsonKey(name: 'is_claimed') this.isClaimed = false}): super._();
  factory _StaffModel.fromJson(Map<String, dynamic> json) => _$StaffModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'university_id') final  String universityId;
@override@JsonKey(name: 'department_id') final  String departmentId;
@override final  String name;
@override final  String post;
@override final  String mobile;
@override@JsonKey(name: 'image_url') final  String imageUrl;
@override final  int serial;
@override@JsonKey(name: 'verification_code') final  String verificationCode;
@override@JsonKey(name: 'is_claimed') final  bool isClaimed;

/// Create a copy of StaffModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StaffModelCopyWith<_StaffModel> get copyWith => __$StaffModelCopyWithImpl<_StaffModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StaffModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StaffModel&&(identical(other.id, id) || other.id == id)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.name, name) || other.name == name)&&(identical(other.post, post) || other.post == post)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.serial, serial) || other.serial == serial)&&(identical(other.verificationCode, verificationCode) || other.verificationCode == verificationCode)&&(identical(other.isClaimed, isClaimed) || other.isClaimed == isClaimed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,universityId,departmentId,name,post,mobile,imageUrl,serial,verificationCode,isClaimed);

@override
String toString() {
  return 'StaffModel(id: $id, universityId: $universityId, departmentId: $departmentId, name: $name, post: $post, mobile: $mobile, imageUrl: $imageUrl, serial: $serial, verificationCode: $verificationCode, isClaimed: $isClaimed)';
}


}

/// @nodoc
abstract mixin class _$StaffModelCopyWith<$Res> implements $StaffModelCopyWith<$Res> {
  factory _$StaffModelCopyWith(_StaffModel value, $Res Function(_StaffModel) _then) = __$StaffModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'university_id') String universityId,@JsonKey(name: 'department_id') String departmentId, String name, String post, String mobile,@JsonKey(name: 'image_url') String imageUrl, int serial,@JsonKey(name: 'verification_code') String verificationCode,@JsonKey(name: 'is_claimed') bool isClaimed
});




}
/// @nodoc
class __$StaffModelCopyWithImpl<$Res>
    implements _$StaffModelCopyWith<$Res> {
  __$StaffModelCopyWithImpl(this._self, this._then);

  final _StaffModel _self;
  final $Res Function(_StaffModel) _then;

/// Create a copy of StaffModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? universityId = null,Object? departmentId = null,Object? name = null,Object? post = null,Object? mobile = null,Object? imageUrl = null,Object? serial = null,Object? verificationCode = null,Object? isClaimed = null,}) {
  return _then(_StaffModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,post: null == post ? _self.post : post // ignore: cast_nullable_to_non_nullable
as String,mobile: null == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,serial: null == serial ? _self.serial : serial // ignore: cast_nullable_to_non_nullable
as int,verificationCode: null == verificationCode ? _self.verificationCode : verificationCode // ignore: cast_nullable_to_non_nullable
as String,isClaimed: null == isClaimed ? _self.isClaimed : isClaimed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
