// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Student {

 String get id; String get studentId; String get universityId; String get departmentId; String get batchId; String get sessionId; String? get hallId; String get bloodGroup; String get verificationCode; bool get isClaimed; String? get studentName; String? get email; String? get phone; bool get isRegular; bool get isCR; String? get userId; User? get user; String? get hallName; String? get batchName; String? get departmentName; String? get universityName; String? get sessionName; StudentAddress? get presentAddress; StudentAddress? get permanentAddress;
/// Create a copy of Student
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentCopyWith<Student> get copyWith => _$StudentCopyWithImpl<Student>(this as Student, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Student;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Student&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.studentId, _this.studentId) || other.studentId == _this.studentId)&&(identical(other.universityId, _this.universityId) || other.universityId == _this.universityId)&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.batchId, _this.batchId) || other.batchId == _this.batchId)&&(identical(other.sessionId, _this.sessionId) || other.sessionId == _this.sessionId)&&(identical(other.hallId, _this.hallId) || other.hallId == _this.hallId)&&(identical(other.bloodGroup, _this.bloodGroup) || other.bloodGroup == _this.bloodGroup)&&(identical(other.verificationCode, _this.verificationCode) || other.verificationCode == _this.verificationCode)&&(identical(other.isClaimed, _this.isClaimed) || other.isClaimed == _this.isClaimed)&&(identical(other.studentName, _this.studentName) || other.studentName == _this.studentName)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.isRegular, _this.isRegular) || other.isRegular == _this.isRegular)&&(identical(other.isCR, _this.isCR) || other.isCR == _this.isCR)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.user, _this.user) || other.user == _this.user)&&(identical(other.hallName, _this.hallName) || other.hallName == _this.hallName)&&(identical(other.batchName, _this.batchName) || other.batchName == _this.batchName)&&(identical(other.departmentName, _this.departmentName) || other.departmentName == _this.departmentName)&&(identical(other.universityName, _this.universityName) || other.universityName == _this.universityName)&&(identical(other.sessionName, _this.sessionName) || other.sessionName == _this.sessionName)&&(identical(other.presentAddress, _this.presentAddress) || other.presentAddress == _this.presentAddress)&&(identical(other.permanentAddress, _this.permanentAddress) || other.permanentAddress == _this.permanentAddress));
}


@override
int get hashCode {
  final _this = this as Student;
  return Object.hashAll([runtimeType,_this.id,_this.studentId,_this.universityId,_this.departmentId,_this.batchId,_this.sessionId,_this.hallId,_this.bloodGroup,_this.verificationCode,_this.isClaimed,_this.studentName,_this.email,_this.phone,_this.isRegular,_this.isCR,_this.userId,_this.user,_this.hallName,_this.batchName,_this.departmentName,_this.universityName,_this.sessionName,_this.presentAddress,_this.permanentAddress]);
}

@override
String toString() {
  final _this = this as Student;
  return 'Student(id: ${_this.id}, studentId: ${_this.studentId}, universityId: ${_this.universityId}, departmentId: ${_this.departmentId}, batchId: ${_this.batchId}, sessionId: ${_this.sessionId}, hallId: ${_this.hallId}, bloodGroup: ${_this.bloodGroup}, verificationCode: ${_this.verificationCode}, isClaimed: ${_this.isClaimed}, studentName: ${_this.studentName}, email: ${_this.email}, phone: ${_this.phone}, isRegular: ${_this.isRegular}, isCR: ${_this.isCR}, userId: ${_this.userId}, user: ${_this.user}, hallName: ${_this.hallName}, batchName: ${_this.batchName}, departmentName: ${_this.departmentName}, universityName: ${_this.universityName}, sessionName: ${_this.sessionName}, presentAddress: ${_this.presentAddress}, permanentAddress: ${_this.permanentAddress})';
}


}

/// @nodoc
abstract mixin class $StudentCopyWith<$Res>  {
  factory $StudentCopyWith(Student value, $Res Function(Student) _then) = _$StudentCopyWithImpl;
@useResult
$Res call({
 String id, String studentId, String universityId, String departmentId, String batchId, String sessionId, String? hallId, String bloodGroup, String verificationCode, bool isClaimed, String? studentName, String? email, String? phone, bool isRegular, bool isCR, String? userId, User? user, String? hallName, String? batchName, String? departmentName, String? universityName, String? sessionName, StudentAddress? presentAddress, StudentAddress? permanentAddress
});


$UserCopyWith<$Res>? get user;

}
/// @nodoc
class _$StudentCopyWithImpl<$Res>
    implements $StudentCopyWith<$Res> {
  _$StudentCopyWithImpl(this._self, this._then);

  final Student _self;
  final $Res Function(Student) _then;

/// Create a copy of Student
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? studentId = null,Object? universityId = null,Object? departmentId = null,Object? batchId = null,Object? sessionId = null,Object? hallId = freezed,Object? bloodGroup = null,Object? verificationCode = null,Object? isClaimed = null,Object? studentName = freezed,Object? email = freezed,Object? phone = freezed,Object? isRegular = null,Object? isCR = null,Object? userId = freezed,Object? user = freezed,Object? hallName = freezed,Object? batchName = freezed,Object? departmentName = freezed,Object? universityName = freezed,Object? sessionName = freezed,Object? presentAddress = freezed,Object? permanentAddress = freezed,}) {
  return _then(Student(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,batchId: null == batchId ? _self.batchId : batchId // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,hallId: freezed == hallId ? _self.hallId : hallId // ignore: cast_nullable_to_non_nullable
as String?,bloodGroup: null == bloodGroup ? _self.bloodGroup : bloodGroup // ignore: cast_nullable_to_non_nullable
as String,verificationCode: null == verificationCode ? _self.verificationCode : verificationCode // ignore: cast_nullable_to_non_nullable
as String,isClaimed: null == isClaimed ? _self.isClaimed : isClaimed // ignore: cast_nullable_to_non_nullable
as bool,studentName: freezed == studentName ? _self.studentName : studentName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,isRegular: null == isRegular ? _self.isRegular : isRegular // ignore: cast_nullable_to_non_nullable
as bool,isCR: null == isCR ? _self.isCR : isCR // ignore: cast_nullable_to_non_nullable
as bool,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,hallName: freezed == hallName ? _self.hallName : hallName // ignore: cast_nullable_to_non_nullable
as String?,batchName: freezed == batchName ? _self.batchName : batchName // ignore: cast_nullable_to_non_nullable
as String?,departmentName: freezed == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String?,universityName: freezed == universityName ? _self.universityName : universityName // ignore: cast_nullable_to_non_nullable
as String?,sessionName: freezed == sessionName ? _self.sessionName : sessionName // ignore: cast_nullable_to_non_nullable
as String?,presentAddress: freezed == presentAddress ? _self.presentAddress : presentAddress // ignore: cast_nullable_to_non_nullable
as StudentAddress?,permanentAddress: freezed == permanentAddress ? _self.permanentAddress : permanentAddress // ignore: cast_nullable_to_non_nullable
as StudentAddress?,
  ));
}
/// Create a copy of Student
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [Student].
extension StudentPatterns on Student {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Student value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Student() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Student value)  $default,){
final _that = this;
switch (_that) {
case _Student():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Student value)?  $default,){
final _that = this;
switch (_that) {
case _Student() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String studentId,  String universityId,  String departmentId,  String batchId,  String sessionId,  String? hallId,  String bloodGroup,  String verificationCode,  bool isClaimed,  String? studentName,  String? email,  String? phone,  bool isRegular,  bool isCR,  String? userId,  User? user,  String? hallName,  String? batchName,  String? departmentName,  String? universityName,  String? sessionName,  StudentAddress? presentAddress,  StudentAddress? permanentAddress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Student() when $default != null:
return $default(_that.id,_that.studentId,_that.universityId,_that.departmentId,_that.batchId,_that.sessionId,_that.hallId,_that.bloodGroup,_that.verificationCode,_that.isClaimed,_that.studentName,_that.email,_that.phone,_that.isRegular,_that.isCR,_that.userId,_that.user,_that.hallName,_that.batchName,_that.departmentName,_that.universityName,_that.sessionName,_that.presentAddress,_that.permanentAddress);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String studentId,  String universityId,  String departmentId,  String batchId,  String sessionId,  String? hallId,  String bloodGroup,  String verificationCode,  bool isClaimed,  String? studentName,  String? email,  String? phone,  bool isRegular,  bool isCR,  String? userId,  User? user,  String? hallName,  String? batchName,  String? departmentName,  String? universityName,  String? sessionName,  StudentAddress? presentAddress,  StudentAddress? permanentAddress)  $default,) {final _that = this;
switch (_that) {
case _Student():
return $default(_that.id,_that.studentId,_that.universityId,_that.departmentId,_that.batchId,_that.sessionId,_that.hallId,_that.bloodGroup,_that.verificationCode,_that.isClaimed,_that.studentName,_that.email,_that.phone,_that.isRegular,_that.isCR,_that.userId,_that.user,_that.hallName,_that.batchName,_that.departmentName,_that.universityName,_that.sessionName,_that.presentAddress,_that.permanentAddress);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String studentId,  String universityId,  String departmentId,  String batchId,  String sessionId,  String? hallId,  String bloodGroup,  String verificationCode,  bool isClaimed,  String? studentName,  String? email,  String? phone,  bool isRegular,  bool isCR,  String? userId,  User? user,  String? hallName,  String? batchName,  String? departmentName,  String? universityName,  String? sessionName,  StudentAddress? presentAddress,  StudentAddress? permanentAddress)?  $default,) {final _that = this;
switch (_that) {
case _Student() when $default != null:
return $default(_that.id,_that.studentId,_that.universityId,_that.departmentId,_that.batchId,_that.sessionId,_that.hallId,_that.bloodGroup,_that.verificationCode,_that.isClaimed,_that.studentName,_that.email,_that.phone,_that.isRegular,_that.isCR,_that.userId,_that.user,_that.hallName,_that.batchName,_that.departmentName,_that.universityName,_that.sessionName,_that.presentAddress,_that.permanentAddress);case _:
  return null;

}
}

}

/// @nodoc


class _Student extends Student {
  const _Student({required this.id, required this.studentId, required this.universityId, required this.departmentId, required this.batchId, required this.sessionId, this.hallId, required this.bloodGroup, required this.verificationCode, required this.isClaimed, this.studentName, this.email, this.phone, this.isRegular = true, this.isCR = false, this.userId, this.user, this.hallName, this.batchName, this.departmentName, this.universityName, this.sessionName, this.presentAddress, this.permanentAddress}): super._();
  

@override final  String id;
@override final  String studentId;
@override final  String universityId;
@override final  String departmentId;
@override final  String batchId;
@override final  String sessionId;
@override final  String? hallId;
@override final  String bloodGroup;
@override final  String verificationCode;
@override final  bool isClaimed;
@override final  String? studentName;
@override final  String? email;
@override final  String? phone;
@override@JsonKey() final  bool isRegular;
@override@JsonKey() final  bool isCR;
@override final  String? userId;
@override final  User? user;
@override final  String? hallName;
@override final  String? batchName;
@override final  String? departmentName;
@override final  String? universityName;
@override final  String? sessionName;
@override final  StudentAddress? presentAddress;
@override final  StudentAddress? permanentAddress;

/// Create a copy of Student
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentCopyWith<_Student> get copyWith => __$StudentCopyWithImpl<_Student>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Student&&(identical(other.id, id) || other.id == id)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.batchId, batchId) || other.batchId == batchId)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.hallId, hallId) || other.hallId == hallId)&&(identical(other.bloodGroup, bloodGroup) || other.bloodGroup == bloodGroup)&&(identical(other.verificationCode, verificationCode) || other.verificationCode == verificationCode)&&(identical(other.isClaimed, isClaimed) || other.isClaimed == isClaimed)&&(identical(other.studentName, studentName) || other.studentName == studentName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.isRegular, isRegular) || other.isRegular == isRegular)&&(identical(other.isCR, isCR) || other.isCR == isCR)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.user, user) || other.user == user)&&(identical(other.hallName, hallName) || other.hallName == hallName)&&(identical(other.batchName, batchName) || other.batchName == batchName)&&(identical(other.departmentName, departmentName) || other.departmentName == departmentName)&&(identical(other.universityName, universityName) || other.universityName == universityName)&&(identical(other.sessionName, sessionName) || other.sessionName == sessionName)&&(identical(other.presentAddress, presentAddress) || other.presentAddress == presentAddress)&&(identical(other.permanentAddress, permanentAddress) || other.permanentAddress == permanentAddress));
}


@override
int get hashCode {
    return Object.hashAll([runtimeType,id,studentId,universityId,departmentId,batchId,sessionId,hallId,bloodGroup,verificationCode,isClaimed,studentName,email,phone,isRegular,isCR,userId,user,hallName,batchName,departmentName,universityName,sessionName,presentAddress,permanentAddress]);
}

@override
String toString() {
    return 'Student(id: $id, studentId: $studentId, universityId: $universityId, departmentId: $departmentId, batchId: $batchId, sessionId: $sessionId, hallId: $hallId, bloodGroup: $bloodGroup, verificationCode: $verificationCode, isClaimed: $isClaimed, studentName: $studentName, email: $email, phone: $phone, isRegular: $isRegular, isCR: $isCR, userId: $userId, user: $user, hallName: $hallName, batchName: $batchName, departmentName: $departmentName, universityName: $universityName, sessionName: $sessionName, presentAddress: $presentAddress, permanentAddress: $permanentAddress)';
}


}

/// @nodoc
abstract mixin class _$StudentCopyWith<$Res> implements $StudentCopyWith<$Res> {
  factory _$StudentCopyWith(_Student value, $Res Function(_Student) _then) = __$StudentCopyWithImpl;
@override @useResult
$Res call({
 String id, String studentId, String universityId, String departmentId, String batchId, String sessionId, String? hallId, String bloodGroup, String verificationCode, bool isClaimed, String? studentName, String? email, String? phone, bool isRegular, bool isCR, String? userId, User? user, String? hallName, String? batchName, String? departmentName, String? universityName, String? sessionName, StudentAddress? presentAddress, StudentAddress? permanentAddress
});


@override $UserCopyWith<$Res>? get user;

}
/// @nodoc
class __$StudentCopyWithImpl<$Res>
    implements _$StudentCopyWith<$Res> {
  __$StudentCopyWithImpl(this._self, this._then);

  final _Student _self;
  final $Res Function(_Student) _then;

/// Create a copy of Student
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? studentId = null,Object? universityId = null,Object? departmentId = null,Object? batchId = null,Object? sessionId = null,Object? hallId = freezed,Object? bloodGroup = null,Object? verificationCode = null,Object? isClaimed = null,Object? studentName = freezed,Object? email = freezed,Object? phone = freezed,Object? isRegular = null,Object? isCR = null,Object? userId = freezed,Object? user = freezed,Object? hallName = freezed,Object? batchName = freezed,Object? departmentName = freezed,Object? universityName = freezed,Object? sessionName = freezed,Object? presentAddress = freezed,Object? permanentAddress = freezed,}) {
  return _then(_Student(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,batchId: null == batchId ? _self.batchId : batchId // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,hallId: freezed == hallId ? _self.hallId : hallId // ignore: cast_nullable_to_non_nullable
as String?,bloodGroup: null == bloodGroup ? _self.bloodGroup : bloodGroup // ignore: cast_nullable_to_non_nullable
as String,verificationCode: null == verificationCode ? _self.verificationCode : verificationCode // ignore: cast_nullable_to_non_nullable
as String,isClaimed: null == isClaimed ? _self.isClaimed : isClaimed // ignore: cast_nullable_to_non_nullable
as bool,studentName: freezed == studentName ? _self.studentName : studentName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,isRegular: null == isRegular ? _self.isRegular : isRegular // ignore: cast_nullable_to_non_nullable
as bool,isCR: null == isCR ? _self.isCR : isCR // ignore: cast_nullable_to_non_nullable
as bool,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,hallName: freezed == hallName ? _self.hallName : hallName // ignore: cast_nullable_to_non_nullable
as String?,batchName: freezed == batchName ? _self.batchName : batchName // ignore: cast_nullable_to_non_nullable
as String?,departmentName: freezed == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String?,universityName: freezed == universityName ? _self.universityName : universityName // ignore: cast_nullable_to_non_nullable
as String?,sessionName: freezed == sessionName ? _self.sessionName : sessionName // ignore: cast_nullable_to_non_nullable
as String?,presentAddress: freezed == presentAddress ? _self.presentAddress : presentAddress // ignore: cast_nullable_to_non_nullable
as StudentAddress?,permanentAddress: freezed == permanentAddress ? _self.permanentAddress : permanentAddress // ignore: cast_nullable_to_non_nullable
as StudentAddress?,
  ));
}

/// Create a copy of Student
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
