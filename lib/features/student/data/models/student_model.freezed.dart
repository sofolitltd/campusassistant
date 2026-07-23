// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StudentModel {

 String get id; String get studentId; String get universityId; String get departmentId; String get batchId; String get sessionId; String? get hallId; String get bloodGroup; String get verificationCode; bool get isClaimed;@JsonKey(name: 'name') String? get studentName; String? get email; String? get phone; bool get isRegular; bool get isCR; String? get userId; UserModel? get user; String? get hallName;@JsonKey(readValue: _readBatchName) String? get batchName;@JsonKey(readValue: _readDepartmentName) String? get departmentName;@JsonKey(readValue: _readUniversityName) String? get universityName;@JsonKey(readValue: _readSessionName) String? get sessionName;@JsonKey(name: 'present_address', readValue: _readStudentAddress, toJson: _writeStudentAddress) StudentAddress? get presentAddress;@JsonKey(name: 'permanent_address', readValue: _readStudentAddress, toJson: _writeStudentAddress) StudentAddress? get permanentAddress;
/// Create a copy of StudentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentModelCopyWith<StudentModel> get copyWith => _$StudentModelCopyWithImpl<StudentModel>(this as StudentModel, _$identity);

  /// Serializes this StudentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.batchId, batchId) || other.batchId == batchId)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.hallId, hallId) || other.hallId == hallId)&&(identical(other.bloodGroup, bloodGroup) || other.bloodGroup == bloodGroup)&&(identical(other.verificationCode, verificationCode) || other.verificationCode == verificationCode)&&(identical(other.isClaimed, isClaimed) || other.isClaimed == isClaimed)&&(identical(other.studentName, studentName) || other.studentName == studentName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.isRegular, isRegular) || other.isRegular == isRegular)&&(identical(other.isCR, isCR) || other.isCR == isCR)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.user, user) || other.user == user)&&(identical(other.hallName, hallName) || other.hallName == hallName)&&(identical(other.batchName, batchName) || other.batchName == batchName)&&(identical(other.departmentName, departmentName) || other.departmentName == departmentName)&&(identical(other.universityName, universityName) || other.universityName == universityName)&&(identical(other.sessionName, sessionName) || other.sessionName == sessionName)&&(identical(other.presentAddress, presentAddress) || other.presentAddress == presentAddress)&&(identical(other.permanentAddress, permanentAddress) || other.permanentAddress == permanentAddress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,studentId,universityId,departmentId,batchId,sessionId,hallId,bloodGroup,verificationCode,isClaimed,studentName,email,phone,isRegular,isCR,userId,user,hallName,batchName,departmentName,universityName,sessionName,presentAddress,permanentAddress]);

@override
String toString() {
  return 'StudentModel(id: $id, studentId: $studentId, universityId: $universityId, departmentId: $departmentId, batchId: $batchId, sessionId: $sessionId, hallId: $hallId, bloodGroup: $bloodGroup, verificationCode: $verificationCode, isClaimed: $isClaimed, studentName: $studentName, email: $email, phone: $phone, isRegular: $isRegular, isCR: $isCR, userId: $userId, user: $user, hallName: $hallName, batchName: $batchName, departmentName: $departmentName, universityName: $universityName, sessionName: $sessionName, presentAddress: $presentAddress, permanentAddress: $permanentAddress)';
}


}

/// @nodoc
abstract mixin class $StudentModelCopyWith<$Res>  {
  factory $StudentModelCopyWith(StudentModel value, $Res Function(StudentModel) _then) = _$StudentModelCopyWithImpl;
@useResult
$Res call({
 String id, String studentId, String universityId, String departmentId, String batchId, String sessionId, String? hallId, String bloodGroup, String verificationCode, bool isClaimed,@JsonKey(name: 'name') String? studentName, String? email, String? phone, bool isRegular, bool isCR, String? userId, UserModel? user, String? hallName,@JsonKey(readValue: _readBatchName) String? batchName,@JsonKey(readValue: _readDepartmentName) String? departmentName,@JsonKey(readValue: _readUniversityName) String? universityName,@JsonKey(readValue: _readSessionName) String? sessionName,@JsonKey(name: 'present_address', readValue: _readStudentAddress, toJson: _writeStudentAddress) StudentAddress? presentAddress,@JsonKey(name: 'permanent_address', readValue: _readStudentAddress, toJson: _writeStudentAddress) StudentAddress? permanentAddress
});


$UserModelCopyWith<$Res>? get user;

}
/// @nodoc
class _$StudentModelCopyWithImpl<$Res>
    implements $StudentModelCopyWith<$Res> {
  _$StudentModelCopyWithImpl(this._self, this._then);

  final StudentModel _self;
  final $Res Function(StudentModel) _then;

/// Create a copy of StudentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? studentId = null,Object? universityId = null,Object? departmentId = null,Object? batchId = null,Object? sessionId = null,Object? hallId = freezed,Object? bloodGroup = null,Object? verificationCode = null,Object? isClaimed = null,Object? studentName = freezed,Object? email = freezed,Object? phone = freezed,Object? isRegular = null,Object? isCR = null,Object? userId = freezed,Object? user = freezed,Object? hallName = freezed,Object? batchName = freezed,Object? departmentName = freezed,Object? universityName = freezed,Object? sessionName = freezed,Object? presentAddress = freezed,Object? permanentAddress = freezed,}) {
  return _then(_self.copyWith(
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
as UserModel?,hallName: freezed == hallName ? _self.hallName : hallName // ignore: cast_nullable_to_non_nullable
as String?,batchName: freezed == batchName ? _self.batchName : batchName // ignore: cast_nullable_to_non_nullable
as String?,departmentName: freezed == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String?,universityName: freezed == universityName ? _self.universityName : universityName // ignore: cast_nullable_to_non_nullable
as String?,sessionName: freezed == sessionName ? _self.sessionName : sessionName // ignore: cast_nullable_to_non_nullable
as String?,presentAddress: freezed == presentAddress ? _self.presentAddress : presentAddress // ignore: cast_nullable_to_non_nullable
as StudentAddress?,permanentAddress: freezed == permanentAddress ? _self.permanentAddress : permanentAddress // ignore: cast_nullable_to_non_nullable
as StudentAddress?,
  ));
}
/// Create a copy of StudentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserModelCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [StudentModel].
extension StudentModelPatterns on StudentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentModel value)  $default,){
final _that = this;
switch (_that) {
case _StudentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentModel value)?  $default,){
final _that = this;
switch (_that) {
case _StudentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String studentId,  String universityId,  String departmentId,  String batchId,  String sessionId,  String? hallId,  String bloodGroup,  String verificationCode,  bool isClaimed, @JsonKey(name: 'name')  String? studentName,  String? email,  String? phone,  bool isRegular,  bool isCR,  String? userId,  UserModel? user,  String? hallName, @JsonKey(readValue: _readBatchName)  String? batchName, @JsonKey(readValue: _readDepartmentName)  String? departmentName, @JsonKey(readValue: _readUniversityName)  String? universityName, @JsonKey(readValue: _readSessionName)  String? sessionName, @JsonKey(name: 'present_address', readValue: _readStudentAddress, toJson: _writeStudentAddress)  StudentAddress? presentAddress, @JsonKey(name: 'permanent_address', readValue: _readStudentAddress, toJson: _writeStudentAddress)  StudentAddress? permanentAddress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String studentId,  String universityId,  String departmentId,  String batchId,  String sessionId,  String? hallId,  String bloodGroup,  String verificationCode,  bool isClaimed, @JsonKey(name: 'name')  String? studentName,  String? email,  String? phone,  bool isRegular,  bool isCR,  String? userId,  UserModel? user,  String? hallName, @JsonKey(readValue: _readBatchName)  String? batchName, @JsonKey(readValue: _readDepartmentName)  String? departmentName, @JsonKey(readValue: _readUniversityName)  String? universityName, @JsonKey(readValue: _readSessionName)  String? sessionName, @JsonKey(name: 'present_address', readValue: _readStudentAddress, toJson: _writeStudentAddress)  StudentAddress? presentAddress, @JsonKey(name: 'permanent_address', readValue: _readStudentAddress, toJson: _writeStudentAddress)  StudentAddress? permanentAddress)  $default,) {final _that = this;
switch (_that) {
case _StudentModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String studentId,  String universityId,  String departmentId,  String batchId,  String sessionId,  String? hallId,  String bloodGroup,  String verificationCode,  bool isClaimed, @JsonKey(name: 'name')  String? studentName,  String? email,  String? phone,  bool isRegular,  bool isCR,  String? userId,  UserModel? user,  String? hallName, @JsonKey(readValue: _readBatchName)  String? batchName, @JsonKey(readValue: _readDepartmentName)  String? departmentName, @JsonKey(readValue: _readUniversityName)  String? universityName, @JsonKey(readValue: _readSessionName)  String? sessionName, @JsonKey(name: 'present_address', readValue: _readStudentAddress, toJson: _writeStudentAddress)  StudentAddress? presentAddress, @JsonKey(name: 'permanent_address', readValue: _readStudentAddress, toJson: _writeStudentAddress)  StudentAddress? permanentAddress)?  $default,) {final _that = this;
switch (_that) {
case _StudentModel() when $default != null:
return $default(_that.id,_that.studentId,_that.universityId,_that.departmentId,_that.batchId,_that.sessionId,_that.hallId,_that.bloodGroup,_that.verificationCode,_that.isClaimed,_that.studentName,_that.email,_that.phone,_that.isRegular,_that.isCR,_that.userId,_that.user,_that.hallName,_that.batchName,_that.departmentName,_that.universityName,_that.sessionName,_that.presentAddress,_that.permanentAddress);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudentModel extends StudentModel {
  const _StudentModel({required this.id, required this.studentId, required this.universityId, required this.departmentId, required this.batchId, required this.sessionId, this.hallId, required this.bloodGroup, required this.verificationCode, this.isClaimed = false, @JsonKey(name: 'name') this.studentName, this.email, this.phone, this.isRegular = true, this.isCR = false, this.userId, this.user, this.hallName, @JsonKey(readValue: _readBatchName) this.batchName, @JsonKey(readValue: _readDepartmentName) this.departmentName, @JsonKey(readValue: _readUniversityName) this.universityName, @JsonKey(readValue: _readSessionName) this.sessionName, @JsonKey(name: 'present_address', readValue: _readStudentAddress, toJson: _writeStudentAddress) this.presentAddress, @JsonKey(name: 'permanent_address', readValue: _readStudentAddress, toJson: _writeStudentAddress) this.permanentAddress}): super._();
  factory _StudentModel.fromJson(Map<String, dynamic> json) => _$StudentModelFromJson(json);

@override final  String id;
@override final  String studentId;
@override final  String universityId;
@override final  String departmentId;
@override final  String batchId;
@override final  String sessionId;
@override final  String? hallId;
@override final  String bloodGroup;
@override final  String verificationCode;
@override@JsonKey() final  bool isClaimed;
@override@JsonKey(name: 'name') final  String? studentName;
@override final  String? email;
@override final  String? phone;
@override@JsonKey() final  bool isRegular;
@override@JsonKey() final  bool isCR;
@override final  String? userId;
@override final  UserModel? user;
@override final  String? hallName;
@override@JsonKey(readValue: _readBatchName) final  String? batchName;
@override@JsonKey(readValue: _readDepartmentName) final  String? departmentName;
@override@JsonKey(readValue: _readUniversityName) final  String? universityName;
@override@JsonKey(readValue: _readSessionName) final  String? sessionName;
@override@JsonKey(name: 'present_address', readValue: _readStudentAddress, toJson: _writeStudentAddress) final  StudentAddress? presentAddress;
@override@JsonKey(name: 'permanent_address', readValue: _readStudentAddress, toJson: _writeStudentAddress) final  StudentAddress? permanentAddress;

/// Create a copy of StudentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentModelCopyWith<_StudentModel> get copyWith => __$StudentModelCopyWithImpl<_StudentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.batchId, batchId) || other.batchId == batchId)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.hallId, hallId) || other.hallId == hallId)&&(identical(other.bloodGroup, bloodGroup) || other.bloodGroup == bloodGroup)&&(identical(other.verificationCode, verificationCode) || other.verificationCode == verificationCode)&&(identical(other.isClaimed, isClaimed) || other.isClaimed == isClaimed)&&(identical(other.studentName, studentName) || other.studentName == studentName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.isRegular, isRegular) || other.isRegular == isRegular)&&(identical(other.isCR, isCR) || other.isCR == isCR)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.user, user) || other.user == user)&&(identical(other.hallName, hallName) || other.hallName == hallName)&&(identical(other.batchName, batchName) || other.batchName == batchName)&&(identical(other.departmentName, departmentName) || other.departmentName == departmentName)&&(identical(other.universityName, universityName) || other.universityName == universityName)&&(identical(other.sessionName, sessionName) || other.sessionName == sessionName)&&(identical(other.presentAddress, presentAddress) || other.presentAddress == presentAddress)&&(identical(other.permanentAddress, permanentAddress) || other.permanentAddress == permanentAddress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,studentId,universityId,departmentId,batchId,sessionId,hallId,bloodGroup,verificationCode,isClaimed,studentName,email,phone,isRegular,isCR,userId,user,hallName,batchName,departmentName,universityName,sessionName,presentAddress,permanentAddress]);

@override
String toString() {
  return 'StudentModel(id: $id, studentId: $studentId, universityId: $universityId, departmentId: $departmentId, batchId: $batchId, sessionId: $sessionId, hallId: $hallId, bloodGroup: $bloodGroup, verificationCode: $verificationCode, isClaimed: $isClaimed, studentName: $studentName, email: $email, phone: $phone, isRegular: $isRegular, isCR: $isCR, userId: $userId, user: $user, hallName: $hallName, batchName: $batchName, departmentName: $departmentName, universityName: $universityName, sessionName: $sessionName, presentAddress: $presentAddress, permanentAddress: $permanentAddress)';
}


}

/// @nodoc
abstract mixin class _$StudentModelCopyWith<$Res> implements $StudentModelCopyWith<$Res> {
  factory _$StudentModelCopyWith(_StudentModel value, $Res Function(_StudentModel) _then) = __$StudentModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String studentId, String universityId, String departmentId, String batchId, String sessionId, String? hallId, String bloodGroup, String verificationCode, bool isClaimed,@JsonKey(name: 'name') String? studentName, String? email, String? phone, bool isRegular, bool isCR, String? userId, UserModel? user, String? hallName,@JsonKey(readValue: _readBatchName) String? batchName,@JsonKey(readValue: _readDepartmentName) String? departmentName,@JsonKey(readValue: _readUniversityName) String? universityName,@JsonKey(readValue: _readSessionName) String? sessionName,@JsonKey(name: 'present_address', readValue: _readStudentAddress, toJson: _writeStudentAddress) StudentAddress? presentAddress,@JsonKey(name: 'permanent_address', readValue: _readStudentAddress, toJson: _writeStudentAddress) StudentAddress? permanentAddress
});


@override $UserModelCopyWith<$Res>? get user;

}
/// @nodoc
class __$StudentModelCopyWithImpl<$Res>
    implements _$StudentModelCopyWith<$Res> {
  __$StudentModelCopyWithImpl(this._self, this._then);

  final _StudentModel _self;
  final $Res Function(_StudentModel) _then;

/// Create a copy of StudentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? studentId = null,Object? universityId = null,Object? departmentId = null,Object? batchId = null,Object? sessionId = null,Object? hallId = freezed,Object? bloodGroup = null,Object? verificationCode = null,Object? isClaimed = null,Object? studentName = freezed,Object? email = freezed,Object? phone = freezed,Object? isRegular = null,Object? isCR = null,Object? userId = freezed,Object? user = freezed,Object? hallName = freezed,Object? batchName = freezed,Object? departmentName = freezed,Object? universityName = freezed,Object? sessionName = freezed,Object? presentAddress = freezed,Object? permanentAddress = freezed,}) {
  return _then(_StudentModel(
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
as UserModel?,hallName: freezed == hallName ? _self.hallName : hallName // ignore: cast_nullable_to_non_nullable
as String?,batchName: freezed == batchName ? _self.batchName : batchName // ignore: cast_nullable_to_non_nullable
as String?,departmentName: freezed == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String?,universityName: freezed == universityName ? _self.universityName : universityName // ignore: cast_nullable_to_non_nullable
as String?,sessionName: freezed == sessionName ? _self.sessionName : sessionName // ignore: cast_nullable_to_non_nullable
as String?,presentAddress: freezed == presentAddress ? _self.presentAddress : presentAddress // ignore: cast_nullable_to_non_nullable
as StudentAddress?,permanentAddress: freezed == permanentAddress ? _self.permanentAddress : permanentAddress // ignore: cast_nullable_to_non_nullable
as StudentAddress?,
  ));
}

/// Create a copy of StudentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserModelCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
