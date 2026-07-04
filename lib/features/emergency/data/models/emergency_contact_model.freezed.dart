// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'emergency_contact_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EmergencyContactModel {

 String get id; String get title; String? get designation; String? get description; String get phone; String? get email; String? get category;@JsonKey(name: 'target_scope') String get scope;@JsonKey(name: 'university_id') String? get universityId;@JsonKey(name: 'department_id') String? get departmentId;@JsonKey(name: 'is_verified') bool get isVerified;@JsonKey(name: 'logo_url') String? get logoUrl;
/// Create a copy of EmergencyContactModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmergencyContactModelCopyWith<EmergencyContactModel> get copyWith => _$EmergencyContactModelCopyWithImpl<EmergencyContactModel>(this as EmergencyContactModel, _$identity);

  /// Serializes this EmergencyContactModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmergencyContactModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.designation, designation) || other.designation == designation)&&(identical(other.description, description) || other.description == description)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.category, category) || other.category == category)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,designation,description,phone,email,category,scope,universityId,departmentId,isVerified,logoUrl);

@override
String toString() {
  return 'EmergencyContactModel(id: $id, title: $title, designation: $designation, description: $description, phone: $phone, email: $email, category: $category, scope: $scope, universityId: $universityId, departmentId: $departmentId, isVerified: $isVerified, logoUrl: $logoUrl)';
}


}

/// @nodoc
abstract mixin class $EmergencyContactModelCopyWith<$Res>  {
  factory $EmergencyContactModelCopyWith(EmergencyContactModel value, $Res Function(EmergencyContactModel) _then) = _$EmergencyContactModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? designation, String? description, String phone, String? email, String? category,@JsonKey(name: 'target_scope') String scope,@JsonKey(name: 'university_id') String? universityId,@JsonKey(name: 'department_id') String? departmentId,@JsonKey(name: 'is_verified') bool isVerified,@JsonKey(name: 'logo_url') String? logoUrl
});




}
/// @nodoc
class _$EmergencyContactModelCopyWithImpl<$Res>
    implements $EmergencyContactModelCopyWith<$Res> {
  _$EmergencyContactModelCopyWithImpl(this._self, this._then);

  final EmergencyContactModel _self;
  final $Res Function(EmergencyContactModel) _then;

/// Create a copy of EmergencyContactModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? designation = freezed,Object? description = freezed,Object? phone = null,Object? email = freezed,Object? category = freezed,Object? scope = null,Object? universityId = freezed,Object? departmentId = freezed,Object? isVerified = null,Object? logoUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,designation: freezed == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as String,universityId: freezed == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String?,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EmergencyContactModel].
extension EmergencyContactModelPatterns on EmergencyContactModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmergencyContactModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmergencyContactModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmergencyContactModel value)  $default,){
final _that = this;
switch (_that) {
case _EmergencyContactModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmergencyContactModel value)?  $default,){
final _that = this;
switch (_that) {
case _EmergencyContactModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? designation,  String? description,  String phone,  String? email,  String? category, @JsonKey(name: 'target_scope')  String scope, @JsonKey(name: 'university_id')  String? universityId, @JsonKey(name: 'department_id')  String? departmentId, @JsonKey(name: 'is_verified')  bool isVerified, @JsonKey(name: 'logo_url')  String? logoUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmergencyContactModel() when $default != null:
return $default(_that.id,_that.title,_that.designation,_that.description,_that.phone,_that.email,_that.category,_that.scope,_that.universityId,_that.departmentId,_that.isVerified,_that.logoUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? designation,  String? description,  String phone,  String? email,  String? category, @JsonKey(name: 'target_scope')  String scope, @JsonKey(name: 'university_id')  String? universityId, @JsonKey(name: 'department_id')  String? departmentId, @JsonKey(name: 'is_verified')  bool isVerified, @JsonKey(name: 'logo_url')  String? logoUrl)  $default,) {final _that = this;
switch (_that) {
case _EmergencyContactModel():
return $default(_that.id,_that.title,_that.designation,_that.description,_that.phone,_that.email,_that.category,_that.scope,_that.universityId,_that.departmentId,_that.isVerified,_that.logoUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? designation,  String? description,  String phone,  String? email,  String? category, @JsonKey(name: 'target_scope')  String scope, @JsonKey(name: 'university_id')  String? universityId, @JsonKey(name: 'department_id')  String? departmentId, @JsonKey(name: 'is_verified')  bool isVerified, @JsonKey(name: 'logo_url')  String? logoUrl)?  $default,) {final _that = this;
switch (_that) {
case _EmergencyContactModel() when $default != null:
return $default(_that.id,_that.title,_that.designation,_that.description,_that.phone,_that.email,_that.category,_that.scope,_that.universityId,_that.departmentId,_that.isVerified,_that.logoUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmergencyContactModel extends EmergencyContactModel {
  const _EmergencyContactModel({required this.id, required this.title, this.designation, this.description, required this.phone, this.email, this.category, @JsonKey(name: 'target_scope') required this.scope, @JsonKey(name: 'university_id') this.universityId, @JsonKey(name: 'department_id') this.departmentId, @JsonKey(name: 'is_verified') this.isVerified = false, @JsonKey(name: 'logo_url') this.logoUrl}): super._();
  factory _EmergencyContactModel.fromJson(Map<String, dynamic> json) => _$EmergencyContactModelFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? designation;
@override final  String? description;
@override final  String phone;
@override final  String? email;
@override final  String? category;
@override@JsonKey(name: 'target_scope') final  String scope;
@override@JsonKey(name: 'university_id') final  String? universityId;
@override@JsonKey(name: 'department_id') final  String? departmentId;
@override@JsonKey(name: 'is_verified') final  bool isVerified;
@override@JsonKey(name: 'logo_url') final  String? logoUrl;

/// Create a copy of EmergencyContactModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmergencyContactModelCopyWith<_EmergencyContactModel> get copyWith => __$EmergencyContactModelCopyWithImpl<_EmergencyContactModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmergencyContactModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmergencyContactModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.designation, designation) || other.designation == designation)&&(identical(other.description, description) || other.description == description)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.category, category) || other.category == category)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,designation,description,phone,email,category,scope,universityId,departmentId,isVerified,logoUrl);

@override
String toString() {
  return 'EmergencyContactModel(id: $id, title: $title, designation: $designation, description: $description, phone: $phone, email: $email, category: $category, scope: $scope, universityId: $universityId, departmentId: $departmentId, isVerified: $isVerified, logoUrl: $logoUrl)';
}


}

/// @nodoc
abstract mixin class _$EmergencyContactModelCopyWith<$Res> implements $EmergencyContactModelCopyWith<$Res> {
  factory _$EmergencyContactModelCopyWith(_EmergencyContactModel value, $Res Function(_EmergencyContactModel) _then) = __$EmergencyContactModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? designation, String? description, String phone, String? email, String? category,@JsonKey(name: 'target_scope') String scope,@JsonKey(name: 'university_id') String? universityId,@JsonKey(name: 'department_id') String? departmentId,@JsonKey(name: 'is_verified') bool isVerified,@JsonKey(name: 'logo_url') String? logoUrl
});




}
/// @nodoc
class __$EmergencyContactModelCopyWithImpl<$Res>
    implements _$EmergencyContactModelCopyWith<$Res> {
  __$EmergencyContactModelCopyWithImpl(this._self, this._then);

  final _EmergencyContactModel _self;
  final $Res Function(_EmergencyContactModel) _then;

/// Create a copy of EmergencyContactModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? designation = freezed,Object? description = freezed,Object? phone = null,Object? email = freezed,Object? category = freezed,Object? scope = null,Object? universityId = freezed,Object? departmentId = freezed,Object? isVerified = null,Object? logoUrl = freezed,}) {
  return _then(_EmergencyContactModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,designation: freezed == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as String,universityId: freezed == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String?,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
