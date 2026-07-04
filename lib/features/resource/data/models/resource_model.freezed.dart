// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resource_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResourceModel {

 String get id; String get type; String get title; String get description;@JsonKey(name: 'course_code') String get courseCode;@JsonKey(name: 'file_url') String get fileUrl;@JsonKey(name: 'thumbnail_url') String get thumbnailUrl;@JsonKey(name: 'lesson_no') int get lessonNo; String get status;@JsonKey(name: 'access_level') String get accessLevel;@JsonKey(name: 'rejected_note') String get rejectedNote;@JsonKey(name: 'reviewed_by_id') String get reviewedBy;@JsonKey(name: 'reviewed_at') DateTime? get reviewedAt;@JsonKey(name: 'uploader_id') String get uploaderId;@JsonKey(name: 'uploader_uid') String get uploaderUid;@JsonKey(name: 'uploader_name') String get uploaderName;@JsonKey(name: 'university_id') String get universityId;@JsonKey(name: 'department_id') String get departmentId;@JsonKey(name: 'file_size_bytes') int get fileSizeBytes;@JsonKey(name: 'page_count') int get pageCount;@JsonKey(name: 'download_count') int get downloadCount;@JsonKey(name: 'view_count') int get viewCount;@JsonKey(name: 'rating_avg') double get ratingAvg;@JsonKey(name: 'rating_count') int get ratingCount;@JsonKey(name: 'is_verified') bool get isVerified; List<String> get tags;@JsonKey(name: 'is_public') bool get isPublic; Map<String, dynamic> get metadata;@JsonKey(name: 'course_title') String get courseTitle; List<String> get years; List<dynamic> get batches;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of ResourceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResourceModelCopyWith<ResourceModel> get copyWith => _$ResourceModelCopyWithImpl<ResourceModel>(this as ResourceModel, _$identity);

  /// Serializes this ResourceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResourceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.lessonNo, lessonNo) || other.lessonNo == lessonNo)&&(identical(other.status, status) || other.status == status)&&(identical(other.accessLevel, accessLevel) || other.accessLevel == accessLevel)&&(identical(other.rejectedNote, rejectedNote) || other.rejectedNote == rejectedNote)&&(identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt)&&(identical(other.uploaderId, uploaderId) || other.uploaderId == uploaderId)&&(identical(other.uploaderUid, uploaderUid) || other.uploaderUid == uploaderUid)&&(identical(other.uploaderName, uploaderName) || other.uploaderName == uploaderName)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.downloadCount, downloadCount) || other.downloadCount == downloadCount)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.ratingAvg, ratingAvg) || other.ratingAvg == ratingAvg)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&const DeepCollectionEquality().equals(other.years, years)&&const DeepCollectionEquality().equals(other.batches, batches)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,type,title,description,courseCode,fileUrl,thumbnailUrl,lessonNo,status,accessLevel,rejectedNote,reviewedBy,reviewedAt,uploaderId,uploaderUid,uploaderName,universityId,departmentId,fileSizeBytes,pageCount,downloadCount,viewCount,ratingAvg,ratingCount,isVerified,const DeepCollectionEquality().hash(tags),isPublic,const DeepCollectionEquality().hash(metadata),courseTitle,const DeepCollectionEquality().hash(years),const DeepCollectionEquality().hash(batches),createdAt,updatedAt]);

@override
String toString() {
  return 'ResourceModel(id: $id, type: $type, title: $title, description: $description, courseCode: $courseCode, fileUrl: $fileUrl, thumbnailUrl: $thumbnailUrl, lessonNo: $lessonNo, status: $status, accessLevel: $accessLevel, rejectedNote: $rejectedNote, reviewedBy: $reviewedBy, reviewedAt: $reviewedAt, uploaderId: $uploaderId, uploaderUid: $uploaderUid, uploaderName: $uploaderName, universityId: $universityId, departmentId: $departmentId, fileSizeBytes: $fileSizeBytes, pageCount: $pageCount, downloadCount: $downloadCount, viewCount: $viewCount, ratingAvg: $ratingAvg, ratingCount: $ratingCount, isVerified: $isVerified, tags: $tags, isPublic: $isPublic, metadata: $metadata, courseTitle: $courseTitle, years: $years, batches: $batches, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ResourceModelCopyWith<$Res>  {
  factory $ResourceModelCopyWith(ResourceModel value, $Res Function(ResourceModel) _then) = _$ResourceModelCopyWithImpl;
@useResult
$Res call({
 String id, String type, String title, String description,@JsonKey(name: 'course_code') String courseCode,@JsonKey(name: 'file_url') String fileUrl,@JsonKey(name: 'thumbnail_url') String thumbnailUrl,@JsonKey(name: 'lesson_no') int lessonNo, String status,@JsonKey(name: 'access_level') String accessLevel,@JsonKey(name: 'rejected_note') String rejectedNote,@JsonKey(name: 'reviewed_by_id') String reviewedBy,@JsonKey(name: 'reviewed_at') DateTime? reviewedAt,@JsonKey(name: 'uploader_id') String uploaderId,@JsonKey(name: 'uploader_uid') String uploaderUid,@JsonKey(name: 'uploader_name') String uploaderName,@JsonKey(name: 'university_id') String universityId,@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'file_size_bytes') int fileSizeBytes,@JsonKey(name: 'page_count') int pageCount,@JsonKey(name: 'download_count') int downloadCount,@JsonKey(name: 'view_count') int viewCount,@JsonKey(name: 'rating_avg') double ratingAvg,@JsonKey(name: 'rating_count') int ratingCount,@JsonKey(name: 'is_verified') bool isVerified, List<String> tags,@JsonKey(name: 'is_public') bool isPublic, Map<String, dynamic> metadata,@JsonKey(name: 'course_title') String courseTitle, List<String> years, List<dynamic> batches,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$ResourceModelCopyWithImpl<$Res>
    implements $ResourceModelCopyWith<$Res> {
  _$ResourceModelCopyWithImpl(this._self, this._then);

  final ResourceModel _self;
  final $Res Function(ResourceModel) _then;

/// Create a copy of ResourceModel
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
as List<dynamic>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ResourceModel].
extension ResourceModelPatterns on ResourceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResourceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResourceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResourceModel value)  $default,){
final _that = this;
switch (_that) {
case _ResourceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResourceModel value)?  $default,){
final _that = this;
switch (_that) {
case _ResourceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  String title,  String description, @JsonKey(name: 'course_code')  String courseCode, @JsonKey(name: 'file_url')  String fileUrl, @JsonKey(name: 'thumbnail_url')  String thumbnailUrl, @JsonKey(name: 'lesson_no')  int lessonNo,  String status, @JsonKey(name: 'access_level')  String accessLevel, @JsonKey(name: 'rejected_note')  String rejectedNote, @JsonKey(name: 'reviewed_by_id')  String reviewedBy, @JsonKey(name: 'reviewed_at')  DateTime? reviewedAt, @JsonKey(name: 'uploader_id')  String uploaderId, @JsonKey(name: 'uploader_uid')  String uploaderUid, @JsonKey(name: 'uploader_name')  String uploaderName, @JsonKey(name: 'university_id')  String universityId, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'file_size_bytes')  int fileSizeBytes, @JsonKey(name: 'page_count')  int pageCount, @JsonKey(name: 'download_count')  int downloadCount, @JsonKey(name: 'view_count')  int viewCount, @JsonKey(name: 'rating_avg')  double ratingAvg, @JsonKey(name: 'rating_count')  int ratingCount, @JsonKey(name: 'is_verified')  bool isVerified,  List<String> tags, @JsonKey(name: 'is_public')  bool isPublic,  Map<String, dynamic> metadata, @JsonKey(name: 'course_title')  String courseTitle,  List<String> years,  List<dynamic> batches, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResourceModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  String title,  String description, @JsonKey(name: 'course_code')  String courseCode, @JsonKey(name: 'file_url')  String fileUrl, @JsonKey(name: 'thumbnail_url')  String thumbnailUrl, @JsonKey(name: 'lesson_no')  int lessonNo,  String status, @JsonKey(name: 'access_level')  String accessLevel, @JsonKey(name: 'rejected_note')  String rejectedNote, @JsonKey(name: 'reviewed_by_id')  String reviewedBy, @JsonKey(name: 'reviewed_at')  DateTime? reviewedAt, @JsonKey(name: 'uploader_id')  String uploaderId, @JsonKey(name: 'uploader_uid')  String uploaderUid, @JsonKey(name: 'uploader_name')  String uploaderName, @JsonKey(name: 'university_id')  String universityId, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'file_size_bytes')  int fileSizeBytes, @JsonKey(name: 'page_count')  int pageCount, @JsonKey(name: 'download_count')  int downloadCount, @JsonKey(name: 'view_count')  int viewCount, @JsonKey(name: 'rating_avg')  double ratingAvg, @JsonKey(name: 'rating_count')  int ratingCount, @JsonKey(name: 'is_verified')  bool isVerified,  List<String> tags, @JsonKey(name: 'is_public')  bool isPublic,  Map<String, dynamic> metadata, @JsonKey(name: 'course_title')  String courseTitle,  List<String> years,  List<dynamic> batches, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ResourceModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  String title,  String description, @JsonKey(name: 'course_code')  String courseCode, @JsonKey(name: 'file_url')  String fileUrl, @JsonKey(name: 'thumbnail_url')  String thumbnailUrl, @JsonKey(name: 'lesson_no')  int lessonNo,  String status, @JsonKey(name: 'access_level')  String accessLevel, @JsonKey(name: 'rejected_note')  String rejectedNote, @JsonKey(name: 'reviewed_by_id')  String reviewedBy, @JsonKey(name: 'reviewed_at')  DateTime? reviewedAt, @JsonKey(name: 'uploader_id')  String uploaderId, @JsonKey(name: 'uploader_uid')  String uploaderUid, @JsonKey(name: 'uploader_name')  String uploaderName, @JsonKey(name: 'university_id')  String universityId, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'file_size_bytes')  int fileSizeBytes, @JsonKey(name: 'page_count')  int pageCount, @JsonKey(name: 'download_count')  int downloadCount, @JsonKey(name: 'view_count')  int viewCount, @JsonKey(name: 'rating_avg')  double ratingAvg, @JsonKey(name: 'rating_count')  int ratingCount, @JsonKey(name: 'is_verified')  bool isVerified,  List<String> tags, @JsonKey(name: 'is_public')  bool isPublic,  Map<String, dynamic> metadata, @JsonKey(name: 'course_title')  String courseTitle,  List<String> years,  List<dynamic> batches, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ResourceModel() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.description,_that.courseCode,_that.fileUrl,_that.thumbnailUrl,_that.lessonNo,_that.status,_that.accessLevel,_that.rejectedNote,_that.reviewedBy,_that.reviewedAt,_that.uploaderId,_that.uploaderUid,_that.uploaderName,_that.universityId,_that.departmentId,_that.fileSizeBytes,_that.pageCount,_that.downloadCount,_that.viewCount,_that.ratingAvg,_that.ratingCount,_that.isVerified,_that.tags,_that.isPublic,_that.metadata,_that.courseTitle,_that.years,_that.batches,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResourceModel extends ResourceModel {
  const _ResourceModel({required this.id, required this.type, required this.title, required this.description, @JsonKey(name: 'course_code') required this.courseCode, @JsonKey(name: 'file_url') required this.fileUrl, @JsonKey(name: 'thumbnail_url') required this.thumbnailUrl, @JsonKey(name: 'lesson_no') required this.lessonNo, required this.status, @JsonKey(name: 'access_level') required this.accessLevel, @JsonKey(name: 'rejected_note') required this.rejectedNote, @JsonKey(name: 'reviewed_by_id') required this.reviewedBy, @JsonKey(name: 'reviewed_at') this.reviewedAt, @JsonKey(name: 'uploader_id') required this.uploaderId, @JsonKey(name: 'uploader_uid') required this.uploaderUid, @JsonKey(name: 'uploader_name') required this.uploaderName, @JsonKey(name: 'university_id') required this.universityId, @JsonKey(name: 'department_id') required this.departmentId, @JsonKey(name: 'file_size_bytes') required this.fileSizeBytes, @JsonKey(name: 'page_count') required this.pageCount, @JsonKey(name: 'download_count') required this.downloadCount, @JsonKey(name: 'view_count') required this.viewCount, @JsonKey(name: 'rating_avg') required this.ratingAvg, @JsonKey(name: 'rating_count') required this.ratingCount, @JsonKey(name: 'is_verified') required this.isVerified, required final  List<String> tags, @JsonKey(name: 'is_public') required this.isPublic, required final  Map<String, dynamic> metadata, @JsonKey(name: 'course_title') required this.courseTitle, required final  List<String> years, required final  List<dynamic> batches, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt}): _tags = tags,_metadata = metadata,_years = years,_batches = batches,super._();
  factory _ResourceModel.fromJson(Map<String, dynamic> json) => _$ResourceModelFromJson(json);

@override final  String id;
@override final  String type;
@override final  String title;
@override final  String description;
@override@JsonKey(name: 'course_code') final  String courseCode;
@override@JsonKey(name: 'file_url') final  String fileUrl;
@override@JsonKey(name: 'thumbnail_url') final  String thumbnailUrl;
@override@JsonKey(name: 'lesson_no') final  int lessonNo;
@override final  String status;
@override@JsonKey(name: 'access_level') final  String accessLevel;
@override@JsonKey(name: 'rejected_note') final  String rejectedNote;
@override@JsonKey(name: 'reviewed_by_id') final  String reviewedBy;
@override@JsonKey(name: 'reviewed_at') final  DateTime? reviewedAt;
@override@JsonKey(name: 'uploader_id') final  String uploaderId;
@override@JsonKey(name: 'uploader_uid') final  String uploaderUid;
@override@JsonKey(name: 'uploader_name') final  String uploaderName;
@override@JsonKey(name: 'university_id') final  String universityId;
@override@JsonKey(name: 'department_id') final  String departmentId;
@override@JsonKey(name: 'file_size_bytes') final  int fileSizeBytes;
@override@JsonKey(name: 'page_count') final  int pageCount;
@override@JsonKey(name: 'download_count') final  int downloadCount;
@override@JsonKey(name: 'view_count') final  int viewCount;
@override@JsonKey(name: 'rating_avg') final  double ratingAvg;
@override@JsonKey(name: 'rating_count') final  int ratingCount;
@override@JsonKey(name: 'is_verified') final  bool isVerified;
 final  List<String> _tags;
@override List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override@JsonKey(name: 'is_public') final  bool isPublic;
 final  Map<String, dynamic> _metadata;
@override Map<String, dynamic> get metadata {
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadata);
}

@override@JsonKey(name: 'course_title') final  String courseTitle;
 final  List<String> _years;
@override List<String> get years {
  if (_years is EqualUnmodifiableListView) return _years;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_years);
}

 final  List<dynamic> _batches;
@override List<dynamic> get batches {
  if (_batches is EqualUnmodifiableListView) return _batches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_batches);
}

@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of ResourceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResourceModelCopyWith<_ResourceModel> get copyWith => __$ResourceModelCopyWithImpl<_ResourceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResourceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResourceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.lessonNo, lessonNo) || other.lessonNo == lessonNo)&&(identical(other.status, status) || other.status == status)&&(identical(other.accessLevel, accessLevel) || other.accessLevel == accessLevel)&&(identical(other.rejectedNote, rejectedNote) || other.rejectedNote == rejectedNote)&&(identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt)&&(identical(other.uploaderId, uploaderId) || other.uploaderId == uploaderId)&&(identical(other.uploaderUid, uploaderUid) || other.uploaderUid == uploaderUid)&&(identical(other.uploaderName, uploaderName) || other.uploaderName == uploaderName)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.downloadCount, downloadCount) || other.downloadCount == downloadCount)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.ratingAvg, ratingAvg) || other.ratingAvg == ratingAvg)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&const DeepCollectionEquality().equals(other._years, _years)&&const DeepCollectionEquality().equals(other._batches, _batches)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,type,title,description,courseCode,fileUrl,thumbnailUrl,lessonNo,status,accessLevel,rejectedNote,reviewedBy,reviewedAt,uploaderId,uploaderUid,uploaderName,universityId,departmentId,fileSizeBytes,pageCount,downloadCount,viewCount,ratingAvg,ratingCount,isVerified,const DeepCollectionEquality().hash(_tags),isPublic,const DeepCollectionEquality().hash(_metadata),courseTitle,const DeepCollectionEquality().hash(_years),const DeepCollectionEquality().hash(_batches),createdAt,updatedAt]);

@override
String toString() {
  return 'ResourceModel(id: $id, type: $type, title: $title, description: $description, courseCode: $courseCode, fileUrl: $fileUrl, thumbnailUrl: $thumbnailUrl, lessonNo: $lessonNo, status: $status, accessLevel: $accessLevel, rejectedNote: $rejectedNote, reviewedBy: $reviewedBy, reviewedAt: $reviewedAt, uploaderId: $uploaderId, uploaderUid: $uploaderUid, uploaderName: $uploaderName, universityId: $universityId, departmentId: $departmentId, fileSizeBytes: $fileSizeBytes, pageCount: $pageCount, downloadCount: $downloadCount, viewCount: $viewCount, ratingAvg: $ratingAvg, ratingCount: $ratingCount, isVerified: $isVerified, tags: $tags, isPublic: $isPublic, metadata: $metadata, courseTitle: $courseTitle, years: $years, batches: $batches, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ResourceModelCopyWith<$Res> implements $ResourceModelCopyWith<$Res> {
  factory _$ResourceModelCopyWith(_ResourceModel value, $Res Function(_ResourceModel) _then) = __$ResourceModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, String title, String description,@JsonKey(name: 'course_code') String courseCode,@JsonKey(name: 'file_url') String fileUrl,@JsonKey(name: 'thumbnail_url') String thumbnailUrl,@JsonKey(name: 'lesson_no') int lessonNo, String status,@JsonKey(name: 'access_level') String accessLevel,@JsonKey(name: 'rejected_note') String rejectedNote,@JsonKey(name: 'reviewed_by_id') String reviewedBy,@JsonKey(name: 'reviewed_at') DateTime? reviewedAt,@JsonKey(name: 'uploader_id') String uploaderId,@JsonKey(name: 'uploader_uid') String uploaderUid,@JsonKey(name: 'uploader_name') String uploaderName,@JsonKey(name: 'university_id') String universityId,@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'file_size_bytes') int fileSizeBytes,@JsonKey(name: 'page_count') int pageCount,@JsonKey(name: 'download_count') int downloadCount,@JsonKey(name: 'view_count') int viewCount,@JsonKey(name: 'rating_avg') double ratingAvg,@JsonKey(name: 'rating_count') int ratingCount,@JsonKey(name: 'is_verified') bool isVerified, List<String> tags,@JsonKey(name: 'is_public') bool isPublic, Map<String, dynamic> metadata,@JsonKey(name: 'course_title') String courseTitle, List<String> years, List<dynamic> batches,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$ResourceModelCopyWithImpl<$Res>
    implements _$ResourceModelCopyWith<$Res> {
  __$ResourceModelCopyWithImpl(this._self, this._then);

  final _ResourceModel _self;
  final $Res Function(_ResourceModel) _then;

/// Create a copy of ResourceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? title = null,Object? description = null,Object? courseCode = null,Object? fileUrl = null,Object? thumbnailUrl = null,Object? lessonNo = null,Object? status = null,Object? accessLevel = null,Object? rejectedNote = null,Object? reviewedBy = null,Object? reviewedAt = freezed,Object? uploaderId = null,Object? uploaderUid = null,Object? uploaderName = null,Object? universityId = null,Object? departmentId = null,Object? fileSizeBytes = null,Object? pageCount = null,Object? downloadCount = null,Object? viewCount = null,Object? ratingAvg = null,Object? ratingCount = null,Object? isVerified = null,Object? tags = null,Object? isPublic = null,Object? metadata = null,Object? courseTitle = null,Object? years = null,Object? batches = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_ResourceModel(
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
as List<dynamic>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
