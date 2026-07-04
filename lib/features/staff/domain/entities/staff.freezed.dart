// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'staff.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Staff {

 String get id; String get universityId; String get departmentId; String get name; String get post; String get mobile; String get imageUrl; int get serial; String get verificationCode; bool get isClaimed;
/// Create a copy of Staff
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StaffCopyWith<Staff> get copyWith => _$StaffCopyWithImpl<Staff>(this as Staff, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Staff&&(identical(other.id, id) || other.id == id)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.name, name) || other.name == name)&&(identical(other.post, post) || other.post == post)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.serial, serial) || other.serial == serial)&&(identical(other.verificationCode, verificationCode) || other.verificationCode == verificationCode)&&(identical(other.isClaimed, isClaimed) || other.isClaimed == isClaimed));
}


@override
int get hashCode => Object.hash(runtimeType,id,universityId,departmentId,name,post,mobile,imageUrl,serial,verificationCode,isClaimed);

@override
String toString() {
  return 'Staff(id: $id, universityId: $universityId, departmentId: $departmentId, name: $name, post: $post, mobile: $mobile, imageUrl: $imageUrl, serial: $serial, verificationCode: $verificationCode, isClaimed: $isClaimed)';
}


}

/// @nodoc
abstract mixin class $StaffCopyWith<$Res>  {
  factory $StaffCopyWith(Staff value, $Res Function(Staff) _then) = _$StaffCopyWithImpl;
@useResult
$Res call({
 String id, String universityId, String departmentId, String name, String post, String mobile, String imageUrl, int serial, String verificationCode, bool isClaimed
});




}
/// @nodoc
class _$StaffCopyWithImpl<$Res>
    implements $StaffCopyWith<$Res> {
  _$StaffCopyWithImpl(this._self, this._then);

  final Staff _self;
  final $Res Function(Staff) _then;

/// Create a copy of Staff
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


/// Adds pattern-matching-related methods to [Staff].
extension StaffPatterns on Staff {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Staff value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Staff() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Staff value)  $default,){
final _that = this;
switch (_that) {
case _Staff():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Staff value)?  $default,){
final _that = this;
switch (_that) {
case _Staff() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String universityId,  String departmentId,  String name,  String post,  String mobile,  String imageUrl,  int serial,  String verificationCode,  bool isClaimed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Staff() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String universityId,  String departmentId,  String name,  String post,  String mobile,  String imageUrl,  int serial,  String verificationCode,  bool isClaimed)  $default,) {final _that = this;
switch (_that) {
case _Staff():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String universityId,  String departmentId,  String name,  String post,  String mobile,  String imageUrl,  int serial,  String verificationCode,  bool isClaimed)?  $default,) {final _that = this;
switch (_that) {
case _Staff() when $default != null:
return $default(_that.id,_that.universityId,_that.departmentId,_that.name,_that.post,_that.mobile,_that.imageUrl,_that.serial,_that.verificationCode,_that.isClaimed);case _:
  return null;

}
}

}

/// @nodoc


class _Staff extends Staff {
  const _Staff({required this.id, required this.universityId, required this.departmentId, required this.name, required this.post, required this.mobile, required this.imageUrl, required this.serial, this.verificationCode = '', this.isClaimed = false}): super._();
  

@override final  String id;
@override final  String universityId;
@override final  String departmentId;
@override final  String name;
@override final  String post;
@override final  String mobile;
@override final  String imageUrl;
@override final  int serial;
@override@JsonKey() final  String verificationCode;
@override@JsonKey() final  bool isClaimed;

/// Create a copy of Staff
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StaffCopyWith<_Staff> get copyWith => __$StaffCopyWithImpl<_Staff>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Staff&&(identical(other.id, id) || other.id == id)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.name, name) || other.name == name)&&(identical(other.post, post) || other.post == post)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.serial, serial) || other.serial == serial)&&(identical(other.verificationCode, verificationCode) || other.verificationCode == verificationCode)&&(identical(other.isClaimed, isClaimed) || other.isClaimed == isClaimed));
}


@override
int get hashCode => Object.hash(runtimeType,id,universityId,departmentId,name,post,mobile,imageUrl,serial,verificationCode,isClaimed);

@override
String toString() {
  return 'Staff(id: $id, universityId: $universityId, departmentId: $departmentId, name: $name, post: $post, mobile: $mobile, imageUrl: $imageUrl, serial: $serial, verificationCode: $verificationCode, isClaimed: $isClaimed)';
}


}

/// @nodoc
abstract mixin class _$StaffCopyWith<$Res> implements $StaffCopyWith<$Res> {
  factory _$StaffCopyWith(_Staff value, $Res Function(_Staff) _then) = __$StaffCopyWithImpl;
@override @useResult
$Res call({
 String id, String universityId, String departmentId, String name, String post, String mobile, String imageUrl, int serial, String verificationCode, bool isClaimed
});




}
/// @nodoc
class __$StaffCopyWithImpl<$Res>
    implements _$StaffCopyWith<$Res> {
  __$StaffCopyWithImpl(this._self, this._then);

  final _Staff _self;
  final $Res Function(_Staff) _then;

/// Create a copy of Staff
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? universityId = null,Object? departmentId = null,Object? name = null,Object? post = null,Object? mobile = null,Object? imageUrl = null,Object? serial = null,Object? verificationCode = null,Object? isClaimed = null,}) {
  return _then(_Staff(
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
