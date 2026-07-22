// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'club_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ClubModel {

 String get id; String get name; String get description; String get clubType; String get universityId; String? get departmentId; String? get logoUrl; String? get bannerUrl; int? get foundedYear; bool get isActive; Map<String, dynamic>? get socialLinks; String? get contactEmail; String? get contactPhone; int get followersCount; bool get isFollowing; String? get category; bool get isVerified; int get membersCount; bool get isMember;
/// Create a copy of ClubModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClubModelCopyWith<ClubModel> get copyWith => _$ClubModelCopyWithImpl<ClubModel>(this as ClubModel, _$identity);

  /// Serializes this ClubModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClubModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.clubType, clubType) || other.clubType == clubType)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.bannerUrl, bannerUrl) || other.bannerUrl == bannerUrl)&&(identical(other.foundedYear, foundedYear) || other.foundedYear == foundedYear)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other.socialLinks, socialLinks)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.followersCount, followersCount) || other.followersCount == followersCount)&&(identical(other.isFollowing, isFollowing) || other.isFollowing == isFollowing)&&(identical(other.category, category) || other.category == category)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.membersCount, membersCount) || other.membersCount == membersCount)&&(identical(other.isMember, isMember) || other.isMember == isMember));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,description,clubType,universityId,departmentId,logoUrl,bannerUrl,foundedYear,isActive,const DeepCollectionEquality().hash(socialLinks),contactEmail,contactPhone,followersCount,isFollowing,category,isVerified,membersCount,isMember]);

@override
String toString() {
  return 'ClubModel(id: $id, name: $name, description: $description, clubType: $clubType, universityId: $universityId, departmentId: $departmentId, logoUrl: $logoUrl, bannerUrl: $bannerUrl, foundedYear: $foundedYear, isActive: $isActive, socialLinks: $socialLinks, contactEmail: $contactEmail, contactPhone: $contactPhone, followersCount: $followersCount, isFollowing: $isFollowing, category: $category, isVerified: $isVerified, membersCount: $membersCount, isMember: $isMember)';
}


}

/// @nodoc
abstract mixin class $ClubModelCopyWith<$Res>  {
  factory $ClubModelCopyWith(ClubModel value, $Res Function(ClubModel) _then) = _$ClubModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, String clubType, String universityId, String? departmentId, String? logoUrl, String? bannerUrl, int? foundedYear, bool isActive, Map<String, dynamic>? socialLinks, String? contactEmail, String? contactPhone, int followersCount, bool isFollowing, String? category, bool isVerified, int membersCount, bool isMember
});




}
/// @nodoc
class _$ClubModelCopyWithImpl<$Res>
    implements $ClubModelCopyWith<$Res> {
  _$ClubModelCopyWithImpl(this._self, this._then);

  final ClubModel _self;
  final $Res Function(ClubModel) _then;

/// Create a copy of ClubModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? clubType = null,Object? universityId = null,Object? departmentId = freezed,Object? logoUrl = freezed,Object? bannerUrl = freezed,Object? foundedYear = freezed,Object? isActive = null,Object? socialLinks = freezed,Object? contactEmail = freezed,Object? contactPhone = freezed,Object? followersCount = null,Object? isFollowing = null,Object? category = freezed,Object? isVerified = null,Object? membersCount = null,Object? isMember = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,clubType: null == clubType ? _self.clubType : clubType // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,bannerUrl: freezed == bannerUrl ? _self.bannerUrl : bannerUrl // ignore: cast_nullable_to_non_nullable
as String?,foundedYear: freezed == foundedYear ? _self.foundedYear : foundedYear // ignore: cast_nullable_to_non_nullable
as int?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,socialLinks: freezed == socialLinks ? _self.socialLinks : socialLinks // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,contactEmail: freezed == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String?,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,followersCount: null == followersCount ? _self.followersCount : followersCount // ignore: cast_nullable_to_non_nullable
as int,isFollowing: null == isFollowing ? _self.isFollowing : isFollowing // ignore: cast_nullable_to_non_nullable
as bool,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,membersCount: null == membersCount ? _self.membersCount : membersCount // ignore: cast_nullable_to_non_nullable
as int,isMember: null == isMember ? _self.isMember : isMember // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ClubModel].
extension ClubModelPatterns on ClubModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClubModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClubModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClubModel value)  $default,){
final _that = this;
switch (_that) {
case _ClubModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClubModel value)?  $default,){
final _that = this;
switch (_that) {
case _ClubModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String clubType,  String universityId,  String? departmentId,  String? logoUrl,  String? bannerUrl,  int? foundedYear,  bool isActive,  Map<String, dynamic>? socialLinks,  String? contactEmail,  String? contactPhone,  int followersCount,  bool isFollowing,  String? category,  bool isVerified,  int membersCount,  bool isMember)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClubModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.clubType,_that.universityId,_that.departmentId,_that.logoUrl,_that.bannerUrl,_that.foundedYear,_that.isActive,_that.socialLinks,_that.contactEmail,_that.contactPhone,_that.followersCount,_that.isFollowing,_that.category,_that.isVerified,_that.membersCount,_that.isMember);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String clubType,  String universityId,  String? departmentId,  String? logoUrl,  String? bannerUrl,  int? foundedYear,  bool isActive,  Map<String, dynamic>? socialLinks,  String? contactEmail,  String? contactPhone,  int followersCount,  bool isFollowing,  String? category,  bool isVerified,  int membersCount,  bool isMember)  $default,) {final _that = this;
switch (_that) {
case _ClubModel():
return $default(_that.id,_that.name,_that.description,_that.clubType,_that.universityId,_that.departmentId,_that.logoUrl,_that.bannerUrl,_that.foundedYear,_that.isActive,_that.socialLinks,_that.contactEmail,_that.contactPhone,_that.followersCount,_that.isFollowing,_that.category,_that.isVerified,_that.membersCount,_that.isMember);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  String clubType,  String universityId,  String? departmentId,  String? logoUrl,  String? bannerUrl,  int? foundedYear,  bool isActive,  Map<String, dynamic>? socialLinks,  String? contactEmail,  String? contactPhone,  int followersCount,  bool isFollowing,  String? category,  bool isVerified,  int membersCount,  bool isMember)?  $default,) {final _that = this;
switch (_that) {
case _ClubModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.clubType,_that.universityId,_that.departmentId,_that.logoUrl,_that.bannerUrl,_that.foundedYear,_that.isActive,_that.socialLinks,_that.contactEmail,_that.contactPhone,_that.followersCount,_that.isFollowing,_that.category,_that.isVerified,_that.membersCount,_that.isMember);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClubModel extends ClubModel {
  const _ClubModel({required this.id, required this.name, required this.description, required this.clubType, required this.universityId, this.departmentId, this.logoUrl, this.bannerUrl, this.foundedYear, this.isActive = true, final  Map<String, dynamic>? socialLinks, this.contactEmail, this.contactPhone, this.followersCount = 0, this.isFollowing = false, this.category, this.isVerified = false, this.membersCount = 0, this.isMember = false}): _socialLinks = socialLinks,super._();
  factory _ClubModel.fromJson(Map<String, dynamic> json) => _$ClubModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String description;
@override final  String clubType;
@override final  String universityId;
@override final  String? departmentId;
@override final  String? logoUrl;
@override final  String? bannerUrl;
@override final  int? foundedYear;
@override@JsonKey() final  bool isActive;
 final  Map<String, dynamic>? _socialLinks;
@override Map<String, dynamic>? get socialLinks {
  final value = _socialLinks;
  if (value == null) return null;
  if (_socialLinks is EqualUnmodifiableMapView) return _socialLinks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? contactEmail;
@override final  String? contactPhone;
@override@JsonKey() final  int followersCount;
@override@JsonKey() final  bool isFollowing;
@override final  String? category;
@override@JsonKey() final  bool isVerified;
@override@JsonKey() final  int membersCount;
@override@JsonKey() final  bool isMember;

/// Create a copy of ClubModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClubModelCopyWith<_ClubModel> get copyWith => __$ClubModelCopyWithImpl<_ClubModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClubModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClubModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.clubType, clubType) || other.clubType == clubType)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.bannerUrl, bannerUrl) || other.bannerUrl == bannerUrl)&&(identical(other.foundedYear, foundedYear) || other.foundedYear == foundedYear)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other._socialLinks, _socialLinks)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.followersCount, followersCount) || other.followersCount == followersCount)&&(identical(other.isFollowing, isFollowing) || other.isFollowing == isFollowing)&&(identical(other.category, category) || other.category == category)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.membersCount, membersCount) || other.membersCount == membersCount)&&(identical(other.isMember, isMember) || other.isMember == isMember));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,description,clubType,universityId,departmentId,logoUrl,bannerUrl,foundedYear,isActive,const DeepCollectionEquality().hash(_socialLinks),contactEmail,contactPhone,followersCount,isFollowing,category,isVerified,membersCount,isMember]);

@override
String toString() {
  return 'ClubModel(id: $id, name: $name, description: $description, clubType: $clubType, universityId: $universityId, departmentId: $departmentId, logoUrl: $logoUrl, bannerUrl: $bannerUrl, foundedYear: $foundedYear, isActive: $isActive, socialLinks: $socialLinks, contactEmail: $contactEmail, contactPhone: $contactPhone, followersCount: $followersCount, isFollowing: $isFollowing, category: $category, isVerified: $isVerified, membersCount: $membersCount, isMember: $isMember)';
}


}

/// @nodoc
abstract mixin class _$ClubModelCopyWith<$Res> implements $ClubModelCopyWith<$Res> {
  factory _$ClubModelCopyWith(_ClubModel value, $Res Function(_ClubModel) _then) = __$ClubModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, String clubType, String universityId, String? departmentId, String? logoUrl, String? bannerUrl, int? foundedYear, bool isActive, Map<String, dynamic>? socialLinks, String? contactEmail, String? contactPhone, int followersCount, bool isFollowing, String? category, bool isVerified, int membersCount, bool isMember
});




}
/// @nodoc
class __$ClubModelCopyWithImpl<$Res>
    implements _$ClubModelCopyWith<$Res> {
  __$ClubModelCopyWithImpl(this._self, this._then);

  final _ClubModel _self;
  final $Res Function(_ClubModel) _then;

/// Create a copy of ClubModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? clubType = null,Object? universityId = null,Object? departmentId = freezed,Object? logoUrl = freezed,Object? bannerUrl = freezed,Object? foundedYear = freezed,Object? isActive = null,Object? socialLinks = freezed,Object? contactEmail = freezed,Object? contactPhone = freezed,Object? followersCount = null,Object? isFollowing = null,Object? category = freezed,Object? isVerified = null,Object? membersCount = null,Object? isMember = null,}) {
  return _then(_ClubModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,clubType: null == clubType ? _self.clubType : clubType // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,bannerUrl: freezed == bannerUrl ? _self.bannerUrl : bannerUrl // ignore: cast_nullable_to_non_nullable
as String?,foundedYear: freezed == foundedYear ? _self.foundedYear : foundedYear // ignore: cast_nullable_to_non_nullable
as int?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,socialLinks: freezed == socialLinks ? _self._socialLinks : socialLinks // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,contactEmail: freezed == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String?,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,followersCount: null == followersCount ? _self.followersCount : followersCount // ignore: cast_nullable_to_non_nullable
as int,isFollowing: null == isFollowing ? _self.isFollowing : isFollowing // ignore: cast_nullable_to_non_nullable
as bool,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,membersCount: null == membersCount ? _self.membersCount : membersCount // ignore: cast_nullable_to_non_nullable
as int,isMember: null == isMember ? _self.isMember : isMember // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
