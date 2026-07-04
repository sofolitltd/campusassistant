// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alumni_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AlumniModel {

 String get id;@JsonKey(name: 'full_name') String get fullName;@JsonKey(name: 'student_id') String get studentId; String get email; String get phone; String get batch;@JsonKey(name: 'passing_year') String get passingYear;@JsonKey(name: 'current_status') String get currentStatus; String get organization; String get designation; String get location; String get bio;@JsonKey(name: 'profile_image') String get profileImage;@JsonKey(name: 'social_links') Map<String, dynamic>? get socialLinks;@JsonKey(name: 'created_by') String get createdBy;@JsonKey(name: 'university_id') String get universityId;@JsonKey(name: 'department_id') String get departmentId;@JsonKey(name: 'organization_id') String? get organizationId;@JsonKey(name: 'organization_ref') AlumniOrganizationModel? get organizationRef;
/// Create a copy of AlumniModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlumniModelCopyWith<AlumniModel> get copyWith => _$AlumniModelCopyWithImpl<AlumniModel>(this as AlumniModel, _$identity);

  /// Serializes this AlumniModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlumniModel&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.batch, batch) || other.batch == batch)&&(identical(other.passingYear, passingYear) || other.passingYear == passingYear)&&(identical(other.currentStatus, currentStatus) || other.currentStatus == currentStatus)&&(identical(other.organization, organization) || other.organization == organization)&&(identical(other.designation, designation) || other.designation == designation)&&(identical(other.location, location) || other.location == location)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage)&&const DeepCollectionEquality().equals(other.socialLinks, socialLinks)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.organizationRef, organizationRef) || other.organizationRef == organizationRef));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,fullName,studentId,email,phone,batch,passingYear,currentStatus,organization,designation,location,bio,profileImage,const DeepCollectionEquality().hash(socialLinks),createdBy,universityId,departmentId,organizationId,organizationRef]);

@override
String toString() {
  return 'AlumniModel(id: $id, fullName: $fullName, studentId: $studentId, email: $email, phone: $phone, batch: $batch, passingYear: $passingYear, currentStatus: $currentStatus, organization: $organization, designation: $designation, location: $location, bio: $bio, profileImage: $profileImage, socialLinks: $socialLinks, createdBy: $createdBy, universityId: $universityId, departmentId: $departmentId, organizationId: $organizationId, organizationRef: $organizationRef)';
}


}

/// @nodoc
abstract mixin class $AlumniModelCopyWith<$Res>  {
  factory $AlumniModelCopyWith(AlumniModel value, $Res Function(AlumniModel) _then) = _$AlumniModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'full_name') String fullName,@JsonKey(name: 'student_id') String studentId, String email, String phone, String batch,@JsonKey(name: 'passing_year') String passingYear,@JsonKey(name: 'current_status') String currentStatus, String organization, String designation, String location, String bio,@JsonKey(name: 'profile_image') String profileImage,@JsonKey(name: 'social_links') Map<String, dynamic>? socialLinks,@JsonKey(name: 'created_by') String createdBy,@JsonKey(name: 'university_id') String universityId,@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'organization_id') String? organizationId,@JsonKey(name: 'organization_ref') AlumniOrganizationModel? organizationRef
});


$AlumniOrganizationModelCopyWith<$Res>? get organizationRef;

}
/// @nodoc
class _$AlumniModelCopyWithImpl<$Res>
    implements $AlumniModelCopyWith<$Res> {
  _$AlumniModelCopyWithImpl(this._self, this._then);

  final AlumniModel _self;
  final $Res Function(AlumniModel) _then;

/// Create a copy of AlumniModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = null,Object? studentId = null,Object? email = null,Object? phone = null,Object? batch = null,Object? passingYear = null,Object? currentStatus = null,Object? organization = null,Object? designation = null,Object? location = null,Object? bio = null,Object? profileImage = null,Object? socialLinks = freezed,Object? createdBy = null,Object? universityId = null,Object? departmentId = null,Object? organizationId = freezed,Object? organizationRef = freezed,}) {
  return _then(_self.copyWith(
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
as AlumniOrganizationModel?,
  ));
}
/// Create a copy of AlumniModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AlumniOrganizationModelCopyWith<$Res>? get organizationRef {
    if (_self.organizationRef == null) {
    return null;
  }

  return $AlumniOrganizationModelCopyWith<$Res>(_self.organizationRef!, (value) {
    return _then(_self.copyWith(organizationRef: value));
  });
}
}


/// Adds pattern-matching-related methods to [AlumniModel].
extension AlumniModelPatterns on AlumniModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlumniModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlumniModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlumniModel value)  $default,){
final _that = this;
switch (_that) {
case _AlumniModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlumniModel value)?  $default,){
final _that = this;
switch (_that) {
case _AlumniModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'full_name')  String fullName, @JsonKey(name: 'student_id')  String studentId,  String email,  String phone,  String batch, @JsonKey(name: 'passing_year')  String passingYear, @JsonKey(name: 'current_status')  String currentStatus,  String organization,  String designation,  String location,  String bio, @JsonKey(name: 'profile_image')  String profileImage, @JsonKey(name: 'social_links')  Map<String, dynamic>? socialLinks, @JsonKey(name: 'created_by')  String createdBy, @JsonKey(name: 'university_id')  String universityId, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'organization_id')  String? organizationId, @JsonKey(name: 'organization_ref')  AlumniOrganizationModel? organizationRef)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlumniModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'full_name')  String fullName, @JsonKey(name: 'student_id')  String studentId,  String email,  String phone,  String batch, @JsonKey(name: 'passing_year')  String passingYear, @JsonKey(name: 'current_status')  String currentStatus,  String organization,  String designation,  String location,  String bio, @JsonKey(name: 'profile_image')  String profileImage, @JsonKey(name: 'social_links')  Map<String, dynamic>? socialLinks, @JsonKey(name: 'created_by')  String createdBy, @JsonKey(name: 'university_id')  String universityId, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'organization_id')  String? organizationId, @JsonKey(name: 'organization_ref')  AlumniOrganizationModel? organizationRef)  $default,) {final _that = this;
switch (_that) {
case _AlumniModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'full_name')  String fullName, @JsonKey(name: 'student_id')  String studentId,  String email,  String phone,  String batch, @JsonKey(name: 'passing_year')  String passingYear, @JsonKey(name: 'current_status')  String currentStatus,  String organization,  String designation,  String location,  String bio, @JsonKey(name: 'profile_image')  String profileImage, @JsonKey(name: 'social_links')  Map<String, dynamic>? socialLinks, @JsonKey(name: 'created_by')  String createdBy, @JsonKey(name: 'university_id')  String universityId, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'organization_id')  String? organizationId, @JsonKey(name: 'organization_ref')  AlumniOrganizationModel? organizationRef)?  $default,) {final _that = this;
switch (_that) {
case _AlumniModel() when $default != null:
return $default(_that.id,_that.fullName,_that.studentId,_that.email,_that.phone,_that.batch,_that.passingYear,_that.currentStatus,_that.organization,_that.designation,_that.location,_that.bio,_that.profileImage,_that.socialLinks,_that.createdBy,_that.universityId,_that.departmentId,_that.organizationId,_that.organizationRef);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AlumniModel extends AlumniModel {
  const _AlumniModel({required this.id, @JsonKey(name: 'full_name') required this.fullName, @JsonKey(name: 'student_id') required this.studentId, required this.email, required this.phone, required this.batch, @JsonKey(name: 'passing_year') required this.passingYear, @JsonKey(name: 'current_status') required this.currentStatus, this.organization = '', this.designation = '', this.location = '', this.bio = '', @JsonKey(name: 'profile_image') this.profileImage = '', @JsonKey(name: 'social_links') final  Map<String, dynamic>? socialLinks, @JsonKey(name: 'created_by') this.createdBy = '', @JsonKey(name: 'university_id') required this.universityId, @JsonKey(name: 'department_id') required this.departmentId, @JsonKey(name: 'organization_id') this.organizationId, @JsonKey(name: 'organization_ref') this.organizationRef}): _socialLinks = socialLinks,super._();
  factory _AlumniModel.fromJson(Map<String, dynamic> json) => _$AlumniModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'full_name') final  String fullName;
@override@JsonKey(name: 'student_id') final  String studentId;
@override final  String email;
@override final  String phone;
@override final  String batch;
@override@JsonKey(name: 'passing_year') final  String passingYear;
@override@JsonKey(name: 'current_status') final  String currentStatus;
@override@JsonKey() final  String organization;
@override@JsonKey() final  String designation;
@override@JsonKey() final  String location;
@override@JsonKey() final  String bio;
@override@JsonKey(name: 'profile_image') final  String profileImage;
 final  Map<String, dynamic>? _socialLinks;
@override@JsonKey(name: 'social_links') Map<String, dynamic>? get socialLinks {
  final value = _socialLinks;
  if (value == null) return null;
  if (_socialLinks is EqualUnmodifiableMapView) return _socialLinks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey(name: 'created_by') final  String createdBy;
@override@JsonKey(name: 'university_id') final  String universityId;
@override@JsonKey(name: 'department_id') final  String departmentId;
@override@JsonKey(name: 'organization_id') final  String? organizationId;
@override@JsonKey(name: 'organization_ref') final  AlumniOrganizationModel? organizationRef;

/// Create a copy of AlumniModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlumniModelCopyWith<_AlumniModel> get copyWith => __$AlumniModelCopyWithImpl<_AlumniModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlumniModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlumniModel&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.batch, batch) || other.batch == batch)&&(identical(other.passingYear, passingYear) || other.passingYear == passingYear)&&(identical(other.currentStatus, currentStatus) || other.currentStatus == currentStatus)&&(identical(other.organization, organization) || other.organization == organization)&&(identical(other.designation, designation) || other.designation == designation)&&(identical(other.location, location) || other.location == location)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage)&&const DeepCollectionEquality().equals(other._socialLinks, _socialLinks)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.organizationRef, organizationRef) || other.organizationRef == organizationRef));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,fullName,studentId,email,phone,batch,passingYear,currentStatus,organization,designation,location,bio,profileImage,const DeepCollectionEquality().hash(_socialLinks),createdBy,universityId,departmentId,organizationId,organizationRef]);

@override
String toString() {
  return 'AlumniModel(id: $id, fullName: $fullName, studentId: $studentId, email: $email, phone: $phone, batch: $batch, passingYear: $passingYear, currentStatus: $currentStatus, organization: $organization, designation: $designation, location: $location, bio: $bio, profileImage: $profileImage, socialLinks: $socialLinks, createdBy: $createdBy, universityId: $universityId, departmentId: $departmentId, organizationId: $organizationId, organizationRef: $organizationRef)';
}


}

/// @nodoc
abstract mixin class _$AlumniModelCopyWith<$Res> implements $AlumniModelCopyWith<$Res> {
  factory _$AlumniModelCopyWith(_AlumniModel value, $Res Function(_AlumniModel) _then) = __$AlumniModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'full_name') String fullName,@JsonKey(name: 'student_id') String studentId, String email, String phone, String batch,@JsonKey(name: 'passing_year') String passingYear,@JsonKey(name: 'current_status') String currentStatus, String organization, String designation, String location, String bio,@JsonKey(name: 'profile_image') String profileImage,@JsonKey(name: 'social_links') Map<String, dynamic>? socialLinks,@JsonKey(name: 'created_by') String createdBy,@JsonKey(name: 'university_id') String universityId,@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'organization_id') String? organizationId,@JsonKey(name: 'organization_ref') AlumniOrganizationModel? organizationRef
});


@override $AlumniOrganizationModelCopyWith<$Res>? get organizationRef;

}
/// @nodoc
class __$AlumniModelCopyWithImpl<$Res>
    implements _$AlumniModelCopyWith<$Res> {
  __$AlumniModelCopyWithImpl(this._self, this._then);

  final _AlumniModel _self;
  final $Res Function(_AlumniModel) _then;

/// Create a copy of AlumniModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? studentId = null,Object? email = null,Object? phone = null,Object? batch = null,Object? passingYear = null,Object? currentStatus = null,Object? organization = null,Object? designation = null,Object? location = null,Object? bio = null,Object? profileImage = null,Object? socialLinks = freezed,Object? createdBy = null,Object? universityId = null,Object? departmentId = null,Object? organizationId = freezed,Object? organizationRef = freezed,}) {
  return _then(_AlumniModel(
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
as AlumniOrganizationModel?,
  ));
}

/// Create a copy of AlumniModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AlumniOrganizationModelCopyWith<$Res>? get organizationRef {
    if (_self.organizationRef == null) {
    return null;
  }

  return $AlumniOrganizationModelCopyWith<$Res>(_self.organizationRef!, (value) {
    return _then(_self.copyWith(organizationRef: value));
  });
}
}

// dart format on
