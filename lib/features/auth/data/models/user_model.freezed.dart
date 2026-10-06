// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserModel {

 String get id; String get email; String get firstName; String get lastName; String get role;@JsonKey(name: 'avatar_url') String? get profileImage; String? get phone; String? get gender; String? get batch;@JsonKey(readValue: _readBatchId) String? get batchId; String? get profession; String? get session; String? get hall; String? get blood; bool get isActive; bool get isVerified; bool get isPhonePublic; bool get isEmailPublic; String? get subscriptionStatus; bool get isModerator; bool get isAdmin; bool get isCr; String? get universityId; String? get departmentId; DateTime? get createdAt;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.lastName, _this.lastName) || other.lastName == _this.lastName)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.profileImage, _this.profileImage) || other.profileImage == _this.profileImage)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.gender, _this.gender) || other.gender == _this.gender)&&(identical(other.batch, _this.batch) || other.batch == _this.batch)&&(identical(other.batchId, _this.batchId) || other.batchId == _this.batchId)&&(identical(other.profession, _this.profession) || other.profession == _this.profession)&&(identical(other.session, _this.session) || other.session == _this.session)&&(identical(other.hall, _this.hall) || other.hall == _this.hall)&&(identical(other.blood, _this.blood) || other.blood == _this.blood)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.isVerified, _this.isVerified) || other.isVerified == _this.isVerified)&&(identical(other.isPhonePublic, _this.isPhonePublic) || other.isPhonePublic == _this.isPhonePublic)&&(identical(other.isEmailPublic, _this.isEmailPublic) || other.isEmailPublic == _this.isEmailPublic)&&(identical(other.subscriptionStatus, _this.subscriptionStatus) || other.subscriptionStatus == _this.subscriptionStatus)&&(identical(other.isModerator, _this.isModerator) || other.isModerator == _this.isModerator)&&(identical(other.isAdmin, _this.isAdmin) || other.isAdmin == _this.isAdmin)&&(identical(other.isCr, _this.isCr) || other.isCr == _this.isCr)&&(identical(other.universityId, _this.universityId) || other.universityId == _this.universityId)&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserModel;
  return Object.hashAll([runtimeType,_this.id,_this.email,_this.firstName,_this.lastName,_this.role,_this.profileImage,_this.phone,_this.gender,_this.batch,_this.batchId,_this.profession,_this.session,_this.hall,_this.blood,_this.isActive,_this.isVerified,_this.isPhonePublic,_this.isEmailPublic,_this.subscriptionStatus,_this.isModerator,_this.isAdmin,_this.isCr,_this.universityId,_this.departmentId,_this.createdAt]);
}

@override
String toString() {
  final _this = this as UserModel;
  return 'UserModel(id: ${_this.id}, email: ${_this.email}, firstName: ${_this.firstName}, lastName: ${_this.lastName}, role: ${_this.role}, profileImage: ${_this.profileImage}, phone: ${_this.phone}, gender: ${_this.gender}, batch: ${_this.batch}, batchId: ${_this.batchId}, profession: ${_this.profession}, session: ${_this.session}, hall: ${_this.hall}, blood: ${_this.blood}, isActive: ${_this.isActive}, isVerified: ${_this.isVerified}, isPhonePublic: ${_this.isPhonePublic}, isEmailPublic: ${_this.isEmailPublic}, subscriptionStatus: ${_this.subscriptionStatus}, isModerator: ${_this.isModerator}, isAdmin: ${_this.isAdmin}, isCr: ${_this.isCr}, universityId: ${_this.universityId}, departmentId: ${_this.departmentId}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
 String id, String email, String firstName, String lastName, String role,@JsonKey(name: 'avatar_url') String? profileImage, String? phone, String? gender, String? batch,@JsonKey(readValue: _readBatchId) String? batchId, String? profession, String? session, String? hall, String? blood, bool isActive, bool isVerified, bool isPhonePublic, bool isEmailPublic, String? subscriptionStatus, bool isModerator, bool isAdmin, bool isCr, String? universityId, String? departmentId, DateTime? createdAt
});




}
/// @nodoc
class _$UserModelCopyWithImpl<$Res>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? firstName = null,Object? lastName = null,Object? role = null,Object? profileImage = freezed,Object? phone = freezed,Object? gender = freezed,Object? batch = freezed,Object? batchId = freezed,Object? profession = freezed,Object? session = freezed,Object? hall = freezed,Object? blood = freezed,Object? isActive = null,Object? isVerified = null,Object? isPhonePublic = null,Object? isEmailPublic = null,Object? subscriptionStatus = freezed,Object? isModerator = null,Object? isAdmin = null,Object? isCr = null,Object? universityId = freezed,Object? departmentId = freezed,Object? createdAt = freezed,}) {
  return _then(UserModel(
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
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserModel].
extension UserModelPatterns on UserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserModel value)  $default,){
final _that = this;
switch (_that) {
case _UserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String firstName,  String lastName,  String role, @JsonKey(name: 'avatar_url')  String? profileImage,  String? phone,  String? gender,  String? batch, @JsonKey(readValue: _readBatchId)  String? batchId,  String? profession,  String? session,  String? hall,  String? blood,  bool isActive,  bool isVerified,  bool isPhonePublic,  bool isEmailPublic,  String? subscriptionStatus,  bool isModerator,  bool isAdmin,  bool isCr,  String? universityId,  String? departmentId,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.email,_that.firstName,_that.lastName,_that.role,_that.profileImage,_that.phone,_that.gender,_that.batch,_that.batchId,_that.profession,_that.session,_that.hall,_that.blood,_that.isActive,_that.isVerified,_that.isPhonePublic,_that.isEmailPublic,_that.subscriptionStatus,_that.isModerator,_that.isAdmin,_that.isCr,_that.universityId,_that.departmentId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String firstName,  String lastName,  String role, @JsonKey(name: 'avatar_url')  String? profileImage,  String? phone,  String? gender,  String? batch, @JsonKey(readValue: _readBatchId)  String? batchId,  String? profession,  String? session,  String? hall,  String? blood,  bool isActive,  bool isVerified,  bool isPhonePublic,  bool isEmailPublic,  String? subscriptionStatus,  bool isModerator,  bool isAdmin,  bool isCr,  String? universityId,  String? departmentId,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _UserModel():
return $default(_that.id,_that.email,_that.firstName,_that.lastName,_that.role,_that.profileImage,_that.phone,_that.gender,_that.batch,_that.batchId,_that.profession,_that.session,_that.hall,_that.blood,_that.isActive,_that.isVerified,_that.isPhonePublic,_that.isEmailPublic,_that.subscriptionStatus,_that.isModerator,_that.isAdmin,_that.isCr,_that.universityId,_that.departmentId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String firstName,  String lastName,  String role, @JsonKey(name: 'avatar_url')  String? profileImage,  String? phone,  String? gender,  String? batch, @JsonKey(readValue: _readBatchId)  String? batchId,  String? profession,  String? session,  String? hall,  String? blood,  bool isActive,  bool isVerified,  bool isPhonePublic,  bool isEmailPublic,  String? subscriptionStatus,  bool isModerator,  bool isAdmin,  bool isCr,  String? universityId,  String? departmentId,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.email,_that.firstName,_that.lastName,_that.role,_that.profileImage,_that.phone,_that.gender,_that.batch,_that.batchId,_that.profession,_that.session,_that.hall,_that.blood,_that.isActive,_that.isVerified,_that.isPhonePublic,_that.isEmailPublic,_that.subscriptionStatus,_that.isModerator,_that.isAdmin,_that.isCr,_that.universityId,_that.departmentId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserModel extends UserModel {
  const _UserModel({required this.id, required this.email, required this.firstName, required this.lastName, required this.role, @JsonKey(name: 'avatar_url') this.profileImage, this.phone, this.gender, this.batch, @JsonKey(readValue: _readBatchId) this.batchId, this.profession, this.session, this.hall, this.blood, this.isActive = true, this.isVerified = false, this.isPhonePublic = false, this.isEmailPublic = false, this.subscriptionStatus = 'basic', this.isModerator = false, this.isAdmin = false, this.isCr = false, this.universityId, this.departmentId, this.createdAt}): super._();
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override final  String id;
@override final  String email;
@override final  String firstName;
@override final  String lastName;
@override final  String role;
@override@JsonKey(name: 'avatar_url') final  String? profileImage;
@override final  String? phone;
@override final  String? gender;
@override final  String? batch;
@override@JsonKey(readValue: _readBatchId) final  String? batchId;
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
@override final  DateTime? createdAt;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserModelCopyWith<_UserModel> get copyWith => __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.role, role) || other.role == role)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.batch, batch) || other.batch == batch)&&(identical(other.batchId, batchId) || other.batchId == batchId)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.session, session) || other.session == session)&&(identical(other.hall, hall) || other.hall == hall)&&(identical(other.blood, blood) || other.blood == blood)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.isPhonePublic, isPhonePublic) || other.isPhonePublic == isPhonePublic)&&(identical(other.isEmailPublic, isEmailPublic) || other.isEmailPublic == isEmailPublic)&&(identical(other.subscriptionStatus, subscriptionStatus) || other.subscriptionStatus == subscriptionStatus)&&(identical(other.isModerator, isModerator) || other.isModerator == isModerator)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.isCr, isCr) || other.isCr == isCr)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,email,firstName,lastName,role,profileImage,phone,gender,batch,batchId,profession,session,hall,blood,isActive,isVerified,isPhonePublic,isEmailPublic,subscriptionStatus,isModerator,isAdmin,isCr,universityId,departmentId,createdAt]);
}

@override
String toString() {
    return 'UserModel(id: $id, email: $email, firstName: $firstName, lastName: $lastName, role: $role, profileImage: $profileImage, phone: $phone, gender: $gender, batch: $batch, batchId: $batchId, profession: $profession, session: $session, hall: $hall, blood: $blood, isActive: $isActive, isVerified: $isVerified, isPhonePublic: $isPhonePublic, isEmailPublic: $isEmailPublic, subscriptionStatus: $subscriptionStatus, isModerator: $isModerator, isAdmin: $isAdmin, isCr: $isCr, universityId: $universityId, departmentId: $departmentId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String firstName, String lastName, String role,@JsonKey(name: 'avatar_url') String? profileImage, String? phone, String? gender, String? batch,@JsonKey(readValue: _readBatchId) String? batchId, String? profession, String? session, String? hall, String? blood, bool isActive, bool isVerified, bool isPhonePublic, bool isEmailPublic, String? subscriptionStatus, bool isModerator, bool isAdmin, bool isCr, String? universityId, String? departmentId, DateTime? createdAt
});




}
/// @nodoc
class __$UserModelCopyWithImpl<$Res>
    implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? firstName = null,Object? lastName = null,Object? role = null,Object? profileImage = freezed,Object? phone = freezed,Object? gender = freezed,Object? batch = freezed,Object? batchId = freezed,Object? profession = freezed,Object? session = freezed,Object? hall = freezed,Object? blood = freezed,Object? isActive = null,Object? isVerified = null,Object? isPhonePublic = null,Object? isEmailPublic = null,Object? subscriptionStatus = freezed,Object? isModerator = null,Object? isAdmin = null,Object? isCr = null,Object? universityId = freezed,Object? departmentId = freezed,Object? createdAt = freezed,}) {
  return _then(_UserModel(
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
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
