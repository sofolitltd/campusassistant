// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alumni.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Alumni {

 String get id; String get fullName; String get studentId; String get email; String get phone; String get batch; String get passingYear; String get currentStatus; String get organization; String get designation; String get location; String get bio; String get profileImage; Map<String, dynamic>? get socialLinks; String get createdBy; String get universityId; String get departmentId; String? get organizationId; AlumniOrganization? get organizationRef;
/// Create a copy of Alumni
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlumniCopyWith<Alumni> get copyWith => _$AlumniCopyWithImpl<Alumni>(this as Alumni, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Alumni;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Alumni&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.studentId, _this.studentId) || other.studentId == _this.studentId)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.batch, _this.batch) || other.batch == _this.batch)&&(identical(other.passingYear, _this.passingYear) || other.passingYear == _this.passingYear)&&(identical(other.currentStatus, _this.currentStatus) || other.currentStatus == _this.currentStatus)&&(identical(other.organization, _this.organization) || other.organization == _this.organization)&&(identical(other.designation, _this.designation) || other.designation == _this.designation)&&(identical(other.location, _this.location) || other.location == _this.location)&&(identical(other.bio, _this.bio) || other.bio == _this.bio)&&(identical(other.profileImage, _this.profileImage) || other.profileImage == _this.profileImage)&&const DeepCollectionEquality().equals(other.socialLinks, _this.socialLinks)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.universityId, _this.universityId) || other.universityId == _this.universityId)&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.organizationId, _this.organizationId) || other.organizationId == _this.organizationId)&&(identical(other.organizationRef, _this.organizationRef) || other.organizationRef == _this.organizationRef));
}


@override
int get hashCode {
  final _this = this as Alumni;
  return Object.hashAll([runtimeType,_this.id,_this.fullName,_this.studentId,_this.email,_this.phone,_this.batch,_this.passingYear,_this.currentStatus,_this.organization,_this.designation,_this.location,_this.bio,_this.profileImage,const DeepCollectionEquality().hash(_this.socialLinks),_this.createdBy,_this.universityId,_this.departmentId,_this.organizationId,_this.organizationRef]);
}

@override
String toString() {
  final _this = this as Alumni;
  return 'Alumni(id: ${_this.id}, fullName: ${_this.fullName}, studentId: ${_this.studentId}, email: ${_this.email}, phone: ${_this.phone}, batch: ${_this.batch}, passingYear: ${_this.passingYear}, currentStatus: ${_this.currentStatus}, organization: ${_this.organization}, designation: ${_this.designation}, location: ${_this.location}, bio: ${_this.bio}, profileImage: ${_this.profileImage}, socialLinks: ${_this.socialLinks}, createdBy: ${_this.createdBy}, universityId: ${_this.universityId}, departmentId: ${_this.departmentId}, organizationId: ${_this.organizationId}, organizationRef: ${_this.organizationRef})';
}


}

/// @nodoc
abstract mixin class $AlumniCopyWith<$Res>  {
  factory $AlumniCopyWith(Alumni value, $Res Function(Alumni) _then) = _$AlumniCopyWithImpl;
@useResult
$Res call({
 String id, String fullName, String studentId, String email, String phone, String batch, String passingYear, String currentStatus, String organization, String designation, String location, String bio, String profileImage, Map<String, dynamic>? socialLinks, String createdBy, String universityId, String departmentId, String? organizationId, AlumniOrganization? organizationRef
});


$AlumniOrganizationCopyWith<$Res>? get organizationRef;

}
/// @nodoc
class _$AlumniCopyWithImpl<$Res>
    implements $AlumniCopyWith<$Res> {
  _$AlumniCopyWithImpl(this._self, this._then);

  final Alumni _self;
  final $Res Function(Alumni) _then;

/// Create a copy of Alumni
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = null,Object? studentId = null,Object? email = null,Object? phone = null,Object? batch = null,Object? passingYear = null,Object? currentStatus = null,Object? organization = null,Object? designation = null,Object? location = null,Object? bio = null,Object? profileImage = null,Object? socialLinks = freezed,Object? createdBy = null,Object? universityId = null,Object? departmentId = null,Object? organizationId = freezed,Object? organizationRef = freezed,}) {
  return _then(Alumni(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,batch: null == batch ? _self.batch : batch // ignore: cast_nullable_to_non_nullable
as String,passingYear: null == passingYear ? _self.passingYear : passingYear // ignore: cast_nullable_to_non_nullable
as String,currentStatus: null == currentStatus ? _self.currentStatus : currentStatus // ignore: cast_nullable_to_non_nullable
as String,organization: null == organization ? _self.organization : organization // ignore: cast_nullable_to_non_nullable
as String,designation: null == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,profileImage: null == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String,socialLinks: freezed == socialLinks ? _self.socialLinks : socialLinks // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,organizationId: freezed == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String?,organizationRef: freezed == organizationRef ? _self.organizationRef : organizationRef // ignore: cast_nullable_to_non_nullable
as AlumniOrganization?,
  ));
}
/// Create a copy of Alumni
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AlumniOrganizationCopyWith<$Res>? get organizationRef {
    if (_self.organizationRef == null) {
    return null;
  }

  return $AlumniOrganizationCopyWith<$Res>(_self.organizationRef!, (value) {
    return _then(_self.copyWith(organizationRef: value));
  });
}
}


/// Adds pattern-matching-related methods to [Alumni].
extension AlumniPatterns on Alumni {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Alumni value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Alumni() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Alumni value)  $default,){
final _that = this;
switch (_that) {
case _Alumni():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Alumni value)?  $default,){
final _that = this;
switch (_that) {
case _Alumni() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fullName,  String studentId,  String email,  String phone,  String batch,  String passingYear,  String currentStatus,  String organization,  String designation,  String location,  String bio,  String profileImage,  Map<String, dynamic>? socialLinks,  String createdBy,  String universityId,  String departmentId,  String? organizationId,  AlumniOrganization? organizationRef)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Alumni() when $default != null:
return $default(_that.id,_that.fullName,_that.studentId,_that.email,_that.phone,_that.batch,_that.passingYear,_that.currentStatus,_that.organization,_that.designation,_that.location,_that.bio,_that.profileImage,_that.socialLinks,_that.createdBy,_that.universityId,_that.departmentId,_that.organizationId,_that.organizationRef);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fullName,  String studentId,  String email,  String phone,  String batch,  String passingYear,  String currentStatus,  String organization,  String designation,  String location,  String bio,  String profileImage,  Map<String, dynamic>? socialLinks,  String createdBy,  String universityId,  String departmentId,  String? organizationId,  AlumniOrganization? organizationRef)  $default,) {final _that = this;
switch (_that) {
case _Alumni():
return $default(_that.id,_that.fullName,_that.studentId,_that.email,_that.phone,_that.batch,_that.passingYear,_that.currentStatus,_that.organization,_that.designation,_that.location,_that.bio,_that.profileImage,_that.socialLinks,_that.createdBy,_that.universityId,_that.departmentId,_that.organizationId,_that.organizationRef);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fullName,  String studentId,  String email,  String phone,  String batch,  String passingYear,  String currentStatus,  String organization,  String designation,  String location,  String bio,  String profileImage,  Map<String, dynamic>? socialLinks,  String createdBy,  String universityId,  String departmentId,  String? organizationId,  AlumniOrganization? organizationRef)?  $default,) {final _that = this;
switch (_that) {
case _Alumni() when $default != null:
return $default(_that.id,_that.fullName,_that.studentId,_that.email,_that.phone,_that.batch,_that.passingYear,_that.currentStatus,_that.organization,_that.designation,_that.location,_that.bio,_that.profileImage,_that.socialLinks,_that.createdBy,_that.universityId,_that.departmentId,_that.organizationId,_that.organizationRef);case _:
  return null;

}
}

}

/// @nodoc


class _Alumni implements Alumni {
  const _Alumni({required this.id, required this.fullName, required this.studentId, required this.email, required this.phone, required this.batch, required this.passingYear, required this.currentStatus, required this.organization, required this.designation, required this.location, required this.bio, required this.profileImage,  Map<String, dynamic>? socialLinks, required this.createdBy, required this.universityId, required this.departmentId, this.organizationId, this.organizationRef}): _socialLinks = socialLinks;
  

@override final  String id;
@override final  String fullName;
@override final  String studentId;
@override final  String email;
@override final  String phone;
@override final  String batch;
@override final  String passingYear;
@override final  String currentStatus;
@override final  String organization;
@override final  String designation;
@override final  String location;
@override final  String bio;
@override final  String profileImage;
 final  Map<String, dynamic>? _socialLinks;
@override Map<String, dynamic>? get socialLinks {
  final value = _socialLinks;
  if (value == null) return null;
  if (_socialLinks is EqualUnmodifiableMapView) return _socialLinks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String createdBy;
@override final  String universityId;
@override final  String departmentId;
@override final  String? organizationId;
@override final  AlumniOrganization? organizationRef;

/// Create a copy of Alumni
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlumniCopyWith<_Alumni> get copyWith => __$AlumniCopyWithImpl<_Alumni>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Alumni&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.batch, batch) || other.batch == batch)&&(identical(other.passingYear, passingYear) || other.passingYear == passingYear)&&(identical(other.currentStatus, currentStatus) || other.currentStatus == currentStatus)&&(identical(other.organization, organization) || other.organization == organization)&&(identical(other.designation, designation) || other.designation == designation)&&(identical(other.location, location) || other.location == location)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage)&&const DeepCollectionEquality().equals(other.socialLinks, _socialLinks)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.organizationRef, organizationRef) || other.organizationRef == organizationRef));
}


@override
int get hashCode {
    return Object.hashAll([runtimeType,id,fullName,studentId,email,phone,batch,passingYear,currentStatus,organization,designation,location,bio,profileImage,const DeepCollectionEquality().hash(_socialLinks),createdBy,universityId,departmentId,organizationId,organizationRef]);
}

@override
String toString() {
    return 'Alumni(id: $id, fullName: $fullName, studentId: $studentId, email: $email, phone: $phone, batch: $batch, passingYear: $passingYear, currentStatus: $currentStatus, organization: $organization, designation: $designation, location: $location, bio: $bio, profileImage: $profileImage, socialLinks: $socialLinks, createdBy: $createdBy, universityId: $universityId, departmentId: $departmentId, organizationId: $organizationId, organizationRef: $organizationRef)';
}


}

/// @nodoc
abstract mixin class _$AlumniCopyWith<$Res> implements $AlumniCopyWith<$Res> {
  factory _$AlumniCopyWith(_Alumni value, $Res Function(_Alumni) _then) = __$AlumniCopyWithImpl;
@override @useResult
$Res call({
 String id, String fullName, String studentId, String email, String phone, String batch, String passingYear, String currentStatus, String organization, String designation, String location, String bio, String profileImage, Map<String, dynamic>? socialLinks, String createdBy, String universityId, String departmentId, String? organizationId, AlumniOrganization? organizationRef
});


@override $AlumniOrganizationCopyWith<$Res>? get organizationRef;

}
/// @nodoc
class __$AlumniCopyWithImpl<$Res>
    implements _$AlumniCopyWith<$Res> {
  __$AlumniCopyWithImpl(this._self, this._then);

  final _Alumni _self;
  final $Res Function(_Alumni) _then;

/// Create a copy of Alumni
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? studentId = null,Object? email = null,Object? phone = null,Object? batch = null,Object? passingYear = null,Object? currentStatus = null,Object? organization = null,Object? designation = null,Object? location = null,Object? bio = null,Object? profileImage = null,Object? socialLinks = freezed,Object? createdBy = null,Object? universityId = null,Object? departmentId = null,Object? organizationId = freezed,Object? organizationRef = freezed,}) {
  return _then(_Alumni(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,batch: null == batch ? _self.batch : batch // ignore: cast_nullable_to_non_nullable
as String,passingYear: null == passingYear ? _self.passingYear : passingYear // ignore: cast_nullable_to_non_nullable
as String,currentStatus: null == currentStatus ? _self.currentStatus : currentStatus // ignore: cast_nullable_to_non_nullable
as String,organization: null == organization ? _self.organization : organization // ignore: cast_nullable_to_non_nullable
as String,designation: null == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,profileImage: null == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String,socialLinks: freezed == socialLinks ? _self._socialLinks : socialLinks // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,organizationId: freezed == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String?,organizationRef: freezed == organizationRef ? _self.organizationRef : organizationRef // ignore: cast_nullable_to_non_nullable
as AlumniOrganization?,
  ));
}

/// Create a copy of Alumni
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AlumniOrganizationCopyWith<$Res>? get organizationRef {
    if (_self.organizationRef == null) {
    return null;
  }

  return $AlumniOrganizationCopyWith<$Res>(_self.organizationRef!, (value) {
    return _then(_self.copyWith(organizationRef: value));
  });
}
}

// dart format on
