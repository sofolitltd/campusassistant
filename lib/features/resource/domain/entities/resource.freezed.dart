// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resource.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Resource {

 String get id; String get type; String get title; String get description; String get courseCode; String get fileUrl; String get thumbnailUrl; int get lessonNo; String get status; String get accessLevel; String get rejectedNote; String get reviewedBy; DateTime? get reviewedAt; String get uploaderId; String get uploaderUid; String get uploaderName; String get universityId; String get departmentId; int get fileSizeBytes; int get pageCount; int get downloadCount; int get viewCount; double get ratingAvg; int get ratingCount; bool get isVerified; List<String> get tags; bool get isPublic; Map<String, dynamic> get metadata; String get courseTitle; List<String> get years; List<String> get batches; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of Resource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResourceCopyWith<Resource> get copyWith => _$ResourceCopyWithImpl<Resource>(this as Resource, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Resource&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.lessonNo, lessonNo) || other.lessonNo == lessonNo)&&(identical(other.status, status) || other.status == status)&&(identical(other.accessLevel, accessLevel) || other.accessLevel == accessLevel)&&(identical(other.rejectedNote, rejectedNote) || other.rejectedNote == rejectedNote)&&(identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt)&&(identical(other.uploaderId, uploaderId) || other.uploaderId == uploaderId)&&(identical(other.uploaderUid, uploaderUid) || other.uploaderUid == uploaderUid)&&(identical(other.uploaderName, uploaderName) || other.uploaderName == uploaderName)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.downloadCount, downloadCount) || other.downloadCount == downloadCount)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.ratingAvg, ratingAvg) || other.ratingAvg == ratingAvg)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&const DeepCollectionEquality().equals(other.years, years)&&const DeepCollectionEquality().equals(other.batches, batches)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,type,title,description,courseCode,fileUrl,thumbnailUrl,lessonNo,status,accessLevel,rejectedNote,reviewedBy,reviewedAt,uploaderId,uploaderUid,uploaderName,universityId,departmentId,fileSizeBytes,pageCount,downloadCount,viewCount,ratingAvg,ratingCount,isVerified,const DeepCollectionEquality().hash(tags),isPublic,const DeepCollectionEquality().hash(metadata),courseTitle,const DeepCollectionEquality().hash(years),const DeepCollectionEquality().hash(batches),createdAt,updatedAt]);

@override
String toString() {
  return 'Resource(id: $id, type: $type, title: $title, description: $description, courseCode: $courseCode, fileUrl: $fileUrl, thumbnailUrl: $thumbnailUrl, lessonNo: $lessonNo, status: $status, accessLevel: $accessLevel, rejectedNote: $rejectedNote, reviewedBy: $reviewedBy, reviewedAt: $reviewedAt, uploaderId: $uploaderId, uploaderUid: $uploaderUid, uploaderName: $uploaderName, universityId: $universityId, departmentId: $departmentId, fileSizeBytes: $fileSizeBytes, pageCount: $pageCount, downloadCount: $downloadCount, viewCount: $viewCount, ratingAvg: $ratingAvg, ratingCount: $ratingCount, isVerified: $isVerified, tags: $tags, isPublic: $isPublic, metadata: $metadata, courseTitle: $courseTitle, years: $years, batches: $batches, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ResourceCopyWith<$Res>  {
  factory $ResourceCopyWith(Resource value, $Res Function(Resource) _then) = _$ResourceCopyWithImpl;
@useResult
$Res call({
 String id, String type, String title, String description, String courseCode, String fileUrl, String thumbnailUrl, int lessonNo, String status, String accessLevel, String rejectedNote, String reviewedBy, DateTime? reviewedAt, String uploaderId, String uploaderUid, String uploaderName, String universityId, String departmentId, int fileSizeBytes, int pageCount, int downloadCount, int viewCount, double ratingAvg, int ratingCount, bool isVerified, List<String> tags, bool isPublic, Map<String, dynamic> metadata, String courseTitle, List<String> years, List<String> batches, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$ResourceCopyWithImpl<$Res>
    implements $ResourceCopyWith<$Res> {
  _$ResourceCopyWithImpl(this._self, this._then);

  final Resource _self;
  final $Res Function(Resource) _then;

/// Create a copy of Resource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? title = null,Object? description = null,Object? courseCode = null,Object? fileUrl = null,Object? thumbnailUrl = null,Object? lessonNo = null,Object? status = null,Object? accessLevel = null,Object? rejectedNote = null,Object? reviewedBy = null,Object? reviewedAt = freezed,Object? uploaderId = null,Object? uploaderUid = null,Object? uploaderName = null,Object? universityId = null,Object? departmentId = null,Object? fileSizeBytes = null,Object? pageCount = null,Object? downloadCount = null,Object? viewCount = null,Object? ratingAvg = null,Object? ratingCount = null,Object? isVerified = null,Object? tags = null,Object? isPublic = null,Object? metadata = null,Object? courseTitle = null,Object? years = null,Object? batches = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,courseCode: null == courseCode ? _self.courseCode : courseCode // ignore: cast_nullable_to_non_nullable
as String,fileUrl: null == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,lessonNo: null == lessonNo ? _self.lessonNo : lessonNo // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,accessLevel: null == accessLevel ? _self.accessLevel : accessLevel // ignore: cast_nullable_to_non_nullable
as String,rejectedNote: null == rejectedNote ? _self.rejectedNote : rejectedNote // ignore: cast_nullable_to_non_nullable
as String,reviewedBy: null == reviewedBy ? _self.reviewedBy : reviewedBy // ignore: cast_nullable_to_non_nullable
as String,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,uploaderId: null == uploaderId ? _self.uploaderId : uploaderId // ignore: cast_nullable_to_non_nullable
as String,uploaderUid: null == uploaderUid ? _self.uploaderUid : uploaderUid // ignore: cast_nullable_to_non_nullable
as String,uploaderName: null == uploaderName ? _self.uploaderName : uploaderName // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,downloadCount: null == downloadCount ? _self.downloadCount : downloadCount // ignore: cast_nullable_to_non_nullable
as int,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,ratingAvg: null == ratingAvg ? _self.ratingAvg : ratingAvg // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,courseTitle: null == courseTitle ? _self.courseTitle : courseTitle // ignore: cast_nullable_to_non_nullable
as String,years: null == years ? _self.years : years // ignore: cast_nullable_to_non_nullable
as List<String>,batches: null == batches ? _self.batches : batches // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Resource].
extension ResourcePatterns on Resource {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Resource value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Resource() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Resource value)  $default,){
final _that = this;
switch (_that) {
case _Resource():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Resource value)?  $default,){
final _that = this;
switch (_that) {
case _Resource() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  String title,  String description,  String courseCode,  String fileUrl,  String thumbnailUrl,  int lessonNo,  String status,  String accessLevel,  String rejectedNote,  String reviewedBy,  DateTime? reviewedAt,  String uploaderId,  String uploaderUid,  String uploaderName,  String universityId,  String departmentId,  int fileSizeBytes,  int pageCount,  int downloadCount,  int viewCount,  double ratingAvg,  int ratingCount,  bool isVerified,  List<String> tags,  bool isPublic,  Map<String, dynamic> metadata,  String courseTitle,  List<String> years,  List<String> batches,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Resource() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.description,_that.courseCode,_that.fileUrl,_that.thumbnailUrl,_that.lessonNo,_that.status,_that.accessLevel,_that.rejectedNote,_that.reviewedBy,_that.reviewedAt,_that.uploaderId,_that.uploaderUid,_that.uploaderName,_that.universityId,_that.departmentId,_that.fileSizeBytes,_that.pageCount,_that.downloadCount,_that.viewCount,_that.ratingAvg,_that.ratingCount,_that.isVerified,_that.tags,_that.isPublic,_that.metadata,_that.courseTitle,_that.years,_that.batches,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  String title,  String description,  String courseCode,  String fileUrl,  String thumbnailUrl,  int lessonNo,  String status,  String accessLevel,  String rejectedNote,  String reviewedBy,  DateTime? reviewedAt,  String uploaderId,  String uploaderUid,  String uploaderName,  String universityId,  String departmentId,  int fileSizeBytes,  int pageCount,  int downloadCount,  int viewCount,  double ratingAvg,  int ratingCount,  bool isVerified,  List<String> tags,  bool isPublic,  Map<String, dynamic> metadata,  String courseTitle,  List<String> years,  List<String> batches,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Resource():
return $default(_that.id,_that.type,_that.title,_that.description,_that.courseCode,_that.fileUrl,_that.thumbnailUrl,_that.lessonNo,_that.status,_that.accessLevel,_that.rejectedNote,_that.reviewedBy,_that.reviewedAt,_that.uploaderId,_that.uploaderUid,_that.uploaderName,_that.universityId,_that.departmentId,_that.fileSizeBytes,_that.pageCount,_that.downloadCount,_that.viewCount,_that.ratingAvg,_that.ratingCount,_that.isVerified,_that.tags,_that.isPublic,_that.metadata,_that.courseTitle,_that.years,_that.batches,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  String title,  String description,  String courseCode,  String fileUrl,  String thumbnailUrl,  int lessonNo,  String status,  String accessLevel,  String rejectedNote,  String reviewedBy,  DateTime? reviewedAt,  String uploaderId,  String uploaderUid,  String uploaderName,  String universityId,  String departmentId,  int fileSizeBytes,  int pageCount,  int downloadCount,  int viewCount,  double ratingAvg,  int ratingCount,  bool isVerified,  List<String> tags,  bool isPublic,  Map<String, dynamic> metadata,  String courseTitle,  List<String> years,  List<String> batches,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Resource() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.description,_that.courseCode,_that.fileUrl,_that.thumbnailUrl,_that.lessonNo,_that.status,_that.accessLevel,_that.rejectedNote,_that.reviewedBy,_that.reviewedAt,_that.uploaderId,_that.uploaderUid,_that.uploaderName,_that.universityId,_that.departmentId,_that.fileSizeBytes,_that.pageCount,_that.downloadCount,_that.viewCount,_that.ratingAvg,_that.ratingCount,_that.isVerified,_that.tags,_that.isPublic,_that.metadata,_that.courseTitle,_that.years,_that.batches,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Resource implements Resource {
  const _Resource({required this.id, required this.type, required this.title, required this.description, required this.courseCode, required this.fileUrl, required this.thumbnailUrl, required this.lessonNo, required this.status, required this.accessLevel, required this.rejectedNote, required this.reviewedBy, this.reviewedAt, required this.uploaderId, required this.uploaderUid, required this.uploaderName, required this.universityId, required this.departmentId, required this.fileSizeBytes, required this.pageCount, required this.downloadCount, required this.viewCount, required this.ratingAvg, required this.ratingCount, required this.isVerified, required final  List<String> tags, required this.isPublic, required final  Map<String, dynamic> metadata, required this.courseTitle, required final  List<String> years, required final  List<String> batches, this.createdAt, this.updatedAt}): _tags = tags,_metadata = metadata,_years = years,_batches = batches;
  

@override final  String id;
@override final  String type;
@override final  String title;
@override final  String description;
@override final  String courseCode;
@override final  String fileUrl;
@override final  String thumbnailUrl;
@override final  int lessonNo;
@override final  String status;
@override final  String accessLevel;
@override final  String rejectedNote;
@override final  String reviewedBy;
@override final  DateTime? reviewedAt;
@override final  String uploaderId;
@override final  String uploaderUid;
@override final  String uploaderName;
@override final  String universityId;
@override final  String departmentId;
@override final  int fileSizeBytes;
@override final  int pageCount;
@override final  int downloadCount;
@override final  int viewCount;
@override final  double ratingAvg;
@override final  int ratingCount;
@override final  bool isVerified;
 final  List<String> _tags;
@override List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  bool isPublic;
 final  Map<String, dynamic> _metadata;
@override Map<String, dynamic> get metadata {
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadata);
}

@override final  String courseTitle;
 final  List<String> _years;
@override List<String> get years {
  if (_years is EqualUnmodifiableListView) return _years;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_years);
}

 final  List<String> _batches;
@override List<String> get batches {
  if (_batches is EqualUnmodifiableListView) return _batches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_batches);
}

@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of Resource
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResourceCopyWith<_Resource> get copyWith => __$ResourceCopyWithImpl<_Resource>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Resource&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.lessonNo, lessonNo) || other.lessonNo == lessonNo)&&(identical(other.status, status) || other.status == status)&&(identical(other.accessLevel, accessLevel) || other.accessLevel == accessLevel)&&(identical(other.rejectedNote, rejectedNote) || other.rejectedNote == rejectedNote)&&(identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt)&&(identical(other.uploaderId, uploaderId) || other.uploaderId == uploaderId)&&(identical(other.uploaderUid, uploaderUid) || other.uploaderUid == uploaderUid)&&(identical(other.uploaderName, uploaderName) || other.uploaderName == uploaderName)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.downloadCount, downloadCount) || other.downloadCount == downloadCount)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.ratingAvg, ratingAvg) || other.ratingAvg == ratingAvg)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&const DeepCollectionEquality().equals(other._years, _years)&&const DeepCollectionEquality().equals(other._batches, _batches)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,type,title,description,courseCode,fileUrl,thumbnailUrl,lessonNo,status,accessLevel,rejectedNote,reviewedBy,reviewedAt,uploaderId,uploaderUid,uploaderName,universityId,departmentId,fileSizeBytes,pageCount,downloadCount,viewCount,ratingAvg,ratingCount,isVerified,const DeepCollectionEquality().hash(_tags),isPublic,const DeepCollectionEquality().hash(_metadata),courseTitle,const DeepCollectionEquality().hash(_years),const DeepCollectionEquality().hash(_batches),createdAt,updatedAt]);

@override
String toString() {
  return 'Resource(id: $id, type: $type, title: $title, description: $description, courseCode: $courseCode, fileUrl: $fileUrl, thumbnailUrl: $thumbnailUrl, lessonNo: $lessonNo, status: $status, accessLevel: $accessLevel, rejectedNote: $rejectedNote, reviewedBy: $reviewedBy, reviewedAt: $reviewedAt, uploaderId: $uploaderId, uploaderUid: $uploaderUid, uploaderName: $uploaderName, universityId: $universityId, departmentId: $departmentId, fileSizeBytes: $fileSizeBytes, pageCount: $pageCount, downloadCount: $downloadCount, viewCount: $viewCount, ratingAvg: $ratingAvg, ratingCount: $ratingCount, isVerified: $isVerified, tags: $tags, isPublic: $isPublic, metadata: $metadata, courseTitle: $courseTitle, years: $years, batches: $batches, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ResourceCopyWith<$Res> implements $ResourceCopyWith<$Res> {
  factory _$ResourceCopyWith(_Resource value, $Res Function(_Resource) _then) = __$ResourceCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, String title, String description, String courseCode, String fileUrl, String thumbnailUrl, int lessonNo, String status, String accessLevel, String rejectedNote, String reviewedBy, DateTime? reviewedAt, String uploaderId, String uploaderUid, String uploaderName, String universityId, String departmentId, int fileSizeBytes, int pageCount, int downloadCount, int viewCount, double ratingAvg, int ratingCount, bool isVerified, List<String> tags, bool isPublic, Map<String, dynamic> metadata, String courseTitle, List<String> years, List<String> batches, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$ResourceCopyWithImpl<$Res>
    implements _$ResourceCopyWith<$Res> {
  __$ResourceCopyWithImpl(this._self, this._then);

  final _Resource _self;
  final $Res Function(_Resource) _then;

/// Create a copy of Resource
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? title = null,Object? description = null,Object? courseCode = null,Object? fileUrl = null,Object? thumbnailUrl = null,Object? lessonNo = null,Object? status = null,Object? accessLevel = null,Object? rejectedNote = null,Object? reviewedBy = null,Object? reviewedAt = freezed,Object? uploaderId = null,Object? uploaderUid = null,Object? uploaderName = null,Object? universityId = null,Object? departmentId = null,Object? fileSizeBytes = null,Object? pageCount = null,Object? downloadCount = null,Object? viewCount = null,Object? ratingAvg = null,Object? ratingCount = null,Object? isVerified = null,Object? tags = null,Object? isPublic = null,Object? metadata = null,Object? courseTitle = null,Object? years = null,Object? batches = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Resource(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,courseCode: null == courseCode ? _self.courseCode : courseCode // ignore: cast_nullable_to_non_nullable
as String,fileUrl: null == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,lessonNo: null == lessonNo ? _self.lessonNo : lessonNo // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,accessLevel: null == accessLevel ? _self.accessLevel : accessLevel // ignore: cast_nullable_to_non_nullable
as String,rejectedNote: null == rejectedNote ? _self.rejectedNote : rejectedNote // ignore: cast_nullable_to_non_nullable
as String,reviewedBy: null == reviewedBy ? _self.reviewedBy : reviewedBy // ignore: cast_nullable_to_non_nullable
as String,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,uploaderId: null == uploaderId ? _self.uploaderId : uploaderId // ignore: cast_nullable_to_non_nullable
as String,uploaderUid: null == uploaderUid ? _self.uploaderUid : uploaderUid // ignore: cast_nullable_to_non_nullable
as String,uploaderName: null == uploaderName ? _self.uploaderName : uploaderName // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,downloadCount: null == downloadCount ? _self.downloadCount : downloadCount // ignore: cast_nullable_to_non_nullable
as int,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,ratingAvg: null == ratingAvg ? _self.ratingAvg : ratingAvg // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,metadata: null == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,courseTitle: null == courseTitle ? _self.courseTitle : courseTitle // ignore: cast_nullable_to_non_nullable
as String,years: null == years ? _self._years : years // ignore: cast_nullable_to_non_nullable
as List<String>,batches: null == batches ? _self._batches : batches // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
