// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$User {

 String get id; String get email; String get firstName; String get lastName; String get role; String? get profileImage; String? get phone; String? get gender; String? get batch; String? get batchId; String? get profession; String? get session; String? get hall; String? get blood; bool get isActive; bool get isVerified; bool get isPhonePublic; bool get isEmailPublic; String? get subscriptionStatus; bool get isModerator; bool get isAdmin; bool get isCr; String? get universityId; String? get departmentId;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.role, role) || other.role == role)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.batch, batch) || other.batch == batch)&&(identical(other.batchId, batchId) || other.batchId == batchId)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.session, session) || other.session == session)&&(identical(other.hall, hall) || other.hall == hall)&&(identical(other.blood, blood) || other.blood == blood)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.isPhonePublic, isPhonePublic) || other.isPhonePublic == isPhonePublic)&&(identical(other.isEmailPublic, isEmailPublic) || other.isEmailPublic == isEmailPublic)&&(identical(other.subscriptionStatus, subscriptionStatus) || other.subscriptionStatus == subscriptionStatus)&&(identical(other.isModerator, isModerator) || other.isModerator == isModerator)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.isCr, isCr) || other.isCr == isCr)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,email,firstName,lastName,role,profileImage,phone,gender,batch,batchId,profession,session,hall,blood,isActive,isVerified,isPhonePublic,isEmailPublic,subscriptionStatus,isModerator,isAdmin,isCr,universityId,departmentId]);

@override
String toString() {
  return 'User(id: $id, email: $email, firstName: $firstName, lastName: $lastName, role: $role, profileImage: $profileImage, phone: $phone, gender: $gender, batch: $batch, batchId: $batchId, profession: $profession, session: $session, hall: $hall, blood: $blood, isActive: $isActive, isVerified: $isVerified, isPhonePublic: $isPhonePublic, isEmailPublic: $isEmailPublic, subscriptionStatus: $subscriptionStatus, isModerator: $isModerator, isAdmin: $isAdmin, isCr: $isCr, universityId: $universityId, departmentId: $departmentId)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 String id, String email, String firstName, String lastName, String role, String? profileImage, String? phone, String? gender, String? batch, String? batchId, String? profession, String? session, String? hall, String? blood, bool isActive, bool isVerified, bool isPhonePublic, bool isEmailPublic, String? subscriptionStatus, bool isModerator, bool isAdmin, bool isCr, String? universityId, String? departmentId
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? firstName = null,Object? lastName = null,Object? role = null,Object? profileImage = freezed,Object? phone = freezed,Object? gender = freezed,Object? batch = freezed,Object? batchId = freezed,Object? profession = freezed,Object? session = freezed,Object? hall = freezed,Object? blood = freezed,Object? isActive = null,Object? isVerified = null,Object? isPhonePublic = null,Object? isEmailPublic = null,Object? subscriptionStatus = freezed,Object? isModerator = null,Object? isAdmin = null,Object? isCr = null,Object? universityId = freezed,Object? departmentId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,profileImage: freezed == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,batch: freezed == batch ? _self.batch : batch // ignore: cast_nullable_to_non_nullable
as String?,batchId: freezed == batchId ? _self.batchId : batchId // ignore: cast_nullable_to_non_nullable
as String?,profession: freezed == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String?,session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as String?,hall: freezed == hall ? _self.hall : hall // ignore: cast_nullable_to_non_nullable
as String?,blood: freezed == blood ? _self.blood : blood // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,isPhonePublic: null == isPhonePublic ? _self.isPhonePublic : isPhonePublic // ignore: cast_nullable_to_non_nullable
as bool,isEmailPublic: null == isEmailPublic ? _self.isEmailPublic : isEmailPublic // ignore: cast_nullable_to_non_nullable
as bool,subscriptionStatus: freezed == subscriptionStatus ? _self.subscriptionStatus : subscriptionStatus // ignore: cast_nullable_to_non_nullable
as String?,isModerator: null == isModerator ? _self.isModerator : isModerator // ignore: cast_nullable_to_non_nullable
as bool,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,isCr: null == isCr ? _self.isCr : isCr // ignore: cast_nullable_to_non_nullable
as bool,universityId: freezed == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String?,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String firstName,  String lastName,  String role,  String? profileImage,  String? phone,  String? gender,  String? batch,  String? batchId,  String? profession,  String? session,  String? hall,  String? blood,  bool isActive,  bool isVerified,  bool isPhonePublic,  bool isEmailPublic,  String? subscriptionStatus,  bool isModerator,  bool isAdmin,  bool isCr,  String? universityId,  String? departmentId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.email,_that.firstName,_that.lastName,_that.role,_that.profileImage,_that.phone,_that.gender,_that.batch,_that.batchId,_that.profession,_that.session,_that.hall,_that.blood,_that.isActive,_that.isVerified,_that.isPhonePublic,_that.isEmailPublic,_that.subscriptionStatus,_that.isModerator,_that.isAdmin,_that.isCr,_that.universityId,_that.departmentId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String firstName,  String lastName,  String role,  String? profileImage,  String? phone,  String? gender,  String? batch,  String? batchId,  String? profession,  String? session,  String? hall,  String? blood,  bool isActive,  bool isVerified,  bool isPhonePublic,  bool isEmailPublic,  String? subscriptionStatus,  bool isModerator,  bool isAdmin,  bool isCr,  String? universityId,  String? departmentId)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.email,_that.firstName,_that.lastName,_that.role,_that.profileImage,_that.phone,_that.gender,_that.batch,_that.batchId,_that.profession,_that.session,_that.hall,_that.blood,_that.isActive,_that.isVerified,_that.isPhonePublic,_that.isEmailPublic,_that.subscriptionStatus,_that.isModerator,_that.isAdmin,_that.isCr,_that.universityId,_that.departmentId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String firstName,  String lastName,  String role,  String? profileImage,  String? phone,  String? gender,  String? batch,  String? batchId,  String? profession,  String? session,  String? hall,  String? blood,  bool isActive,  bool isVerified,  bool isPhonePublic,  bool isEmailPublic,  String? subscriptionStatus,  bool isModerator,  bool isAdmin,  bool isCr,  String? universityId,  String? departmentId)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.email,_that.firstName,_that.lastName,_that.role,_that.profileImage,_that.phone,_that.gender,_that.batch,_that.batchId,_that.profession,_that.session,_that.hall,_that.blood,_that.isActive,_that.isVerified,_that.isPhonePublic,_that.isEmailPublic,_that.subscriptionStatus,_that.isModerator,_that.isAdmin,_that.isCr,_that.universityId,_that.departmentId);case _:
  return null;

}
}

}

/// @nodoc


class _User extends User {
  const _User({required this.id, required this.email, required this.firstName, required this.lastName, required this.role, this.profileImage, this.phone, this.gender, this.batch, this.batchId, this.profession, this.session, this.hall, this.blood, this.isActive = true, this.isVerified = false, this.isPhonePublic = false, this.isEmailPublic = false, this.subscriptionStatus = 'basic', this.isModerator = false, this.isAdmin = false, this.isCr = false, this.universityId, this.departmentId}): super._();
  

@override final  String id;
@override final  String email;
@override final  String firstName;
@override final  String lastName;
@override final  String role;
@override final  String? profileImage;
@override final  String? phone;
@override final  String? gender;
@override final  String? batch;
@override final  String? batchId;
@override final  String? profession;
@override final  String? session;
@override final  String? hall;
@override final  String? blood;
@override@JsonKey() final  bool isActive;
@override@JsonKey() final  bool isVerified;
@override@JsonKey() final  bool isPhonePublic;
@override@JsonKey() final  bool isEmailPublic;
@override@JsonKey() final  String? subscriptionStatus;
@override@JsonKey() final  bool isModerator;
@override@JsonKey() final  bool isAdmin;
@override@JsonKey() final  bool isCr;
@override final  String? universityId;
@override final  String? departmentId;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.role, role) || other.role == role)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.batch, batch) || other.batch == batch)&&(identical(other.batchId, batchId) || other.batchId == batchId)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.session, session) || other.session == session)&&(identical(other.hall, hall) || other.hall == hall)&&(identical(other.blood, blood) || other.blood == blood)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.isPhonePublic, isPhonePublic) || other.isPhonePublic == isPhonePublic)&&(identical(other.isEmailPublic, isEmailPublic) || other.isEmailPublic == isEmailPublic)&&(identical(other.subscriptionStatus, subscriptionStatus) || other.subscriptionStatus == subscriptionStatus)&&(identical(other.isModerator, isModerator) || other.isModerator == isModerator)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.isCr, isCr) || other.isCr == isCr)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,email,firstName,lastName,role,profileImage,phone,gender,batch,batchId,profession,session,hall,blood,isActive,isVerified,isPhonePublic,isEmailPublic,subscriptionStatus,isModerator,isAdmin,isCr,universityId,departmentId]);

@override
String toString() {
  return 'User(id: $id, email: $email, firstName: $firstName, lastName: $lastName, role: $role, profileImage: $profileImage, phone: $phone, gender: $gender, batch: $batch, batchId: $batchId, profession: $profession, session: $session, hall: $hall, blood: $blood, isActive: $isActive, isVerified: $isVerified, isPhonePublic: $isPhonePublic, isEmailPublic: $isEmailPublic, subscriptionStatus: $subscriptionStatus, isModerator: $isModerator, isAdmin: $isAdmin, isCr: $isCr, universityId: $universityId, departmentId: $departmentId)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String firstName, String lastName, String role, String? profileImage, String? phone, String? gender, String? batch, String? batchId, String? profession, String? session, String? hall, String? blood, bool isActive, bool isVerified, bool isPhonePublic, bool isEmailPublic, String? subscriptionStatus, bool isModerator, bool isAdmin, bool isCr, String? universityId, String? departmentId
});




}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? firstName = null,Object? lastName = null,Object? role = null,Object? profileImage = freezed,Object? phone = freezed,Object? gender = freezed,Object? batch = freezed,Object? batchId = freezed,Object? profession = freezed,Object? session = freezed,Object? hall = freezed,Object? blood = freezed,Object? isActive = null,Object? isVerified = null,Object? isPhonePublic = null,Object? isEmailPublic = null,Object? subscriptionStatus = freezed,Object? isModerator = null,Object? isAdmin = null,Object? isCr = null,Object? universityId = freezed,Object? departmentId = freezed,}) {
  return _then(_User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,profileImage: freezed == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,batch: freezed == batch ? _self.batch : batch // ignore: cast_nullable_to_non_nullable
as String?,batchId: freezed == batchId ? _self.batchId : batchId // ignore: cast_nullable_to_non_nullable
as String?,profession: freezed == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String?,session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as String?,hall: freezed == hall ? _self.hall : hall // ignore: cast_nullable_to_non_nullable
as String?,blood: freezed == blood ? _self.blood : blood // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,isPhonePublic: null == isPhonePublic ? _self.isPhonePublic : isPhonePublic // ignore: cast_nullable_to_non_nullable
as bool,isEmailPublic: null == isEmailPublic ? _self.isEmailPublic : isEmailPublic // ignore: cast_nullable_to_non_nullable
as bool,subscriptionStatus: freezed == subscriptionStatus ? _self.subscriptionStatus : subscriptionStatus // ignore: cast_nullable_to_non_nullable
as String?,isModerator: null == isModerator ? _self.isModerator : isModerator // ignore: cast_nullable_to_non_nullable
as bool,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,isCr: null == isCr ? _self.isCr : isCr // ignore: cast_nullable_to_non_nullable
as bool,universityId: freezed == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String?,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
