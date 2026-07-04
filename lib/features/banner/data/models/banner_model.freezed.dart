// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'banner_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BannerModel {

 String get id; String get title;@JsonKey(name: 'image_url') String get imageUrl;@JsonKey(name: 'click_url') String get clickUrl; int get priority;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'start_at') DateTime get startAt;@JsonKey(name: 'end_at') DateTime get endAt;@JsonKey(name: 'target_scope') String get targetScope; List<BannerTargetModel> get targets;
/// Create a copy of BannerModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BannerModelCopyWith<BannerModel> get copyWith => _$BannerModelCopyWithImpl<BannerModel>(this as BannerModel, _$identity);

  /// Serializes this BannerModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BannerModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.clickUrl, clickUrl) || other.clickUrl == clickUrl)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.endAt, endAt) || other.endAt == endAt)&&(identical(other.targetScope, targetScope) || other.targetScope == targetScope)&&const DeepCollectionEquality().equals(other.targets, targets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,imageUrl,clickUrl,priority,isActive,startAt,endAt,targetScope,const DeepCollectionEquality().hash(targets));

@override
String toString() {
  return 'BannerModel(id: $id, title: $title, imageUrl: $imageUrl, clickUrl: $clickUrl, priority: $priority, isActive: $isActive, startAt: $startAt, endAt: $endAt, targetScope: $targetScope, targets: $targets)';
}


}

/// @nodoc
abstract mixin class $BannerModelCopyWith<$Res>  {
  factory $BannerModelCopyWith(BannerModel value, $Res Function(BannerModel) _then) = _$BannerModelCopyWithImpl;
@useResult
$Res call({
 String id, String title,@JsonKey(name: 'image_url') String imageUrl,@JsonKey(name: 'click_url') String clickUrl, int priority,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'start_at') DateTime startAt,@JsonKey(name: 'end_at') DateTime endAt,@JsonKey(name: 'target_scope') String targetScope, List<BannerTargetModel> targets
});




}
/// @nodoc
class _$BannerModelCopyWithImpl<$Res>
    implements $BannerModelCopyWith<$Res> {
  _$BannerModelCopyWithImpl(this._self, this._then);

  final BannerModel _self;
  final $Res Function(BannerModel) _then;

/// Create a copy of BannerModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? imageUrl = null,Object? clickUrl = null,Object? priority = null,Object? isActive = null,Object? startAt = null,Object? endAt = null,Object? targetScope = null,Object? targets = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,clickUrl: null == clickUrl ? _self.clickUrl : clickUrl // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,startAt: null == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime,endAt: null == endAt ? _self.endAt : endAt // ignore: cast_nullable_to_non_nullable
as DateTime,targetScope: null == targetScope ? _self.targetScope : targetScope // ignore: cast_nullable_to_non_nullable
as String,targets: null == targets ? _self.targets : targets // ignore: cast_nullable_to_non_nullable
as List<BannerTargetModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [BannerModel].
extension BannerModelPatterns on BannerModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BannerModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BannerModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BannerModel value)  $default,){
final _that = this;
switch (_that) {
case _BannerModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BannerModel value)?  $default,){
final _that = this;
switch (_that) {
case _BannerModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title, @JsonKey(name: 'image_url')  String imageUrl, @JsonKey(name: 'click_url')  String clickUrl,  int priority, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'start_at')  DateTime startAt, @JsonKey(name: 'end_at')  DateTime endAt, @JsonKey(name: 'target_scope')  String targetScope,  List<BannerTargetModel> targets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BannerModel() when $default != null:
return $default(_that.id,_that.title,_that.imageUrl,_that.clickUrl,_that.priority,_that.isActive,_that.startAt,_that.endAt,_that.targetScope,_that.targets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title, @JsonKey(name: 'image_url')  String imageUrl, @JsonKey(name: 'click_url')  String clickUrl,  int priority, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'start_at')  DateTime startAt, @JsonKey(name: 'end_at')  DateTime endAt, @JsonKey(name: 'target_scope')  String targetScope,  List<BannerTargetModel> targets)  $default,) {final _that = this;
switch (_that) {
case _BannerModel():
return $default(_that.id,_that.title,_that.imageUrl,_that.clickUrl,_that.priority,_that.isActive,_that.startAt,_that.endAt,_that.targetScope,_that.targets);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title, @JsonKey(name: 'image_url')  String imageUrl, @JsonKey(name: 'click_url')  String clickUrl,  int priority, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'start_at')  DateTime startAt, @JsonKey(name: 'end_at')  DateTime endAt, @JsonKey(name: 'target_scope')  String targetScope,  List<BannerTargetModel> targets)?  $default,) {final _that = this;
switch (_that) {
case _BannerModel() when $default != null:
return $default(_that.id,_that.title,_that.imageUrl,_that.clickUrl,_that.priority,_that.isActive,_that.startAt,_that.endAt,_that.targetScope,_that.targets);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BannerModel extends BannerModel {
  const _BannerModel({required this.id, required this.title, @JsonKey(name: 'image_url') required this.imageUrl, @JsonKey(name: 'click_url') required this.clickUrl, required this.priority, @JsonKey(name: 'is_active') required this.isActive, @JsonKey(name: 'start_at') required this.startAt, @JsonKey(name: 'end_at') required this.endAt, @JsonKey(name: 'target_scope') required this.targetScope, final  List<BannerTargetModel> targets = const []}): _targets = targets,super._();
  factory _BannerModel.fromJson(Map<String, dynamic> json) => _$BannerModelFromJson(json);

@override final  String id;
@override final  String title;
@override@JsonKey(name: 'image_url') final  String imageUrl;
@override@JsonKey(name: 'click_url') final  String clickUrl;
@override final  int priority;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'start_at') final  DateTime startAt;
@override@JsonKey(name: 'end_at') final  DateTime endAt;
@override@JsonKey(name: 'target_scope') final  String targetScope;
 final  List<BannerTargetModel> _targets;
@override@JsonKey() List<BannerTargetModel> get targets {
  if (_targets is EqualUnmodifiableListView) return _targets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_targets);
}


/// Create a copy of BannerModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BannerModelCopyWith<_BannerModel> get copyWith => __$BannerModelCopyWithImpl<_BannerModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BannerModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BannerModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.clickUrl, clickUrl) || other.clickUrl == clickUrl)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.endAt, endAt) || other.endAt == endAt)&&(identical(other.targetScope, targetScope) || other.targetScope == targetScope)&&const DeepCollectionEquality().equals(other._targets, _targets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,imageUrl,clickUrl,priority,isActive,startAt,endAt,targetScope,const DeepCollectionEquality().hash(_targets));

@override
String toString() {
  return 'BannerModel(id: $id, title: $title, imageUrl: $imageUrl, clickUrl: $clickUrl, priority: $priority, isActive: $isActive, startAt: $startAt, endAt: $endAt, targetScope: $targetScope, targets: $targets)';
}


}

/// @nodoc
abstract mixin class _$BannerModelCopyWith<$Res> implements $BannerModelCopyWith<$Res> {
  factory _$BannerModelCopyWith(_BannerModel value, $Res Function(_BannerModel) _then) = __$BannerModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title,@JsonKey(name: 'image_url') String imageUrl,@JsonKey(name: 'click_url') String clickUrl, int priority,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'start_at') DateTime startAt,@JsonKey(name: 'end_at') DateTime endAt,@JsonKey(name: 'target_scope') String targetScope, List<BannerTargetModel> targets
});




}
/// @nodoc
class __$BannerModelCopyWithImpl<$Res>
    implements _$BannerModelCopyWith<$Res> {
  __$BannerModelCopyWithImpl(this._self, this._then);

  final _BannerModel _self;
  final $Res Function(_BannerModel) _then;

/// Create a copy of BannerModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? imageUrl = null,Object? clickUrl = null,Object? priority = null,Object? isActive = null,Object? startAt = null,Object? endAt = null,Object? targetScope = null,Object? targets = null,}) {
  return _then(_BannerModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,clickUrl: null == clickUrl ? _self.clickUrl : clickUrl // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,startAt: null == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime,endAt: null == endAt ? _self.endAt : endAt // ignore: cast_nullable_to_non_nullable
as DateTime,targetScope: null == targetScope ? _self.targetScope : targetScope // ignore: cast_nullable_to_non_nullable
as String,targets: null == targets ? _self._targets : targets // ignore: cast_nullable_to_non_nullable
as List<BannerTargetModel>,
  ));
}


}


/// @nodoc
mixin _$BannerTargetModel {

 int? get id;@JsonKey(name: 'banner_id') String get bannerId;@JsonKey(name: 'university_id') String? get universityId;@JsonKey(name: 'department_id') String? get departmentId;
/// Create a copy of BannerTargetModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BannerTargetModelCopyWith<BannerTargetModel> get copyWith => _$BannerTargetModelCopyWithImpl<BannerTargetModel>(this as BannerTargetModel, _$identity);

  /// Serializes this BannerTargetModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BannerTargetModel&&(identical(other.id, id) || other.id == id)&&(identical(other.bannerId, bannerId) || other.bannerId == bannerId)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bannerId,universityId,departmentId);

@override
String toString() {
  return 'BannerTargetModel(id: $id, bannerId: $bannerId, universityId: $universityId, departmentId: $departmentId)';
}


}

/// @nodoc
abstract mixin class $BannerTargetModelCopyWith<$Res>  {
  factory $BannerTargetModelCopyWith(BannerTargetModel value, $Res Function(BannerTargetModel) _then) = _$BannerTargetModelCopyWithImpl;
@useResult
$Res call({
 int? id,@JsonKey(name: 'banner_id') String bannerId,@JsonKey(name: 'university_id') String? universityId,@JsonKey(name: 'department_id') String? departmentId
});




}
/// @nodoc
class _$BannerTargetModelCopyWithImpl<$Res>
    implements $BannerTargetModelCopyWith<$Res> {
  _$BannerTargetModelCopyWithImpl(this._self, this._then);

  final BannerTargetModel _self;
  final $Res Function(BannerTargetModel) _then;

/// Create a copy of BannerTargetModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? bannerId = null,Object? universityId = freezed,Object? departmentId = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,bannerId: null == bannerId ? _self.bannerId : bannerId // ignore: cast_nullable_to_non_nullable
as String,universityId: freezed == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String?,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BannerTargetModel].
extension BannerTargetModelPatterns on BannerTargetModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BannerTargetModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BannerTargetModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BannerTargetModel value)  $default,){
final _that = this;
switch (_that) {
case _BannerTargetModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BannerTargetModel value)?  $default,){
final _that = this;
switch (_that) {
case _BannerTargetModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id, @JsonKey(name: 'banner_id')  String bannerId, @JsonKey(name: 'university_id')  String? universityId, @JsonKey(name: 'department_id')  String? departmentId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BannerTargetModel() when $default != null:
return $default(_that.id,_that.bannerId,_that.universityId,_that.departmentId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id, @JsonKey(name: 'banner_id')  String bannerId, @JsonKey(name: 'university_id')  String? universityId, @JsonKey(name: 'department_id')  String? departmentId)  $default,) {final _that = this;
switch (_that) {
case _BannerTargetModel():
return $default(_that.id,_that.bannerId,_that.universityId,_that.departmentId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id, @JsonKey(name: 'banner_id')  String bannerId, @JsonKey(name: 'university_id')  String? universityId, @JsonKey(name: 'department_id')  String? departmentId)?  $default,) {final _that = this;
switch (_that) {
case _BannerTargetModel() when $default != null:
return $default(_that.id,_that.bannerId,_that.universityId,_that.departmentId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BannerTargetModel extends BannerTargetModel {
  const _BannerTargetModel({this.id, @JsonKey(name: 'banner_id') required this.bannerId, @JsonKey(name: 'university_id') this.universityId, @JsonKey(name: 'department_id') this.departmentId}): super._();
  factory _BannerTargetModel.fromJson(Map<String, dynamic> json) => _$BannerTargetModelFromJson(json);

@override final  int? id;
@override@JsonKey(name: 'banner_id') final  String bannerId;
@override@JsonKey(name: 'university_id') final  String? universityId;
@override@JsonKey(name: 'department_id') final  String? departmentId;

/// Create a copy of BannerTargetModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BannerTargetModelCopyWith<_BannerTargetModel> get copyWith => __$BannerTargetModelCopyWithImpl<_BannerTargetModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BannerTargetModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BannerTargetModel&&(identical(other.id, id) || other.id == id)&&(identical(other.bannerId, bannerId) || other.bannerId == bannerId)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bannerId,universityId,departmentId);

@override
String toString() {
  return 'BannerTargetModel(id: $id, bannerId: $bannerId, universityId: $universityId, departmentId: $departmentId)';
}


}

/// @nodoc
abstract mixin class _$BannerTargetModelCopyWith<$Res> implements $BannerTargetModelCopyWith<$Res> {
  factory _$BannerTargetModelCopyWith(_BannerTargetModel value, $Res Function(_BannerTargetModel) _then) = __$BannerTargetModelCopyWithImpl;
@override @useResult
$Res call({
 int? id,@JsonKey(name: 'banner_id') String bannerId,@JsonKey(name: 'university_id') String? universityId,@JsonKey(name: 'department_id') String? departmentId
});




}
/// @nodoc
class __$BannerTargetModelCopyWithImpl<$Res>
    implements _$BannerTargetModelCopyWith<$Res> {
  __$BannerTargetModelCopyWithImpl(this._self, this._then);

  final _BannerTargetModel _self;
  final $Res Function(_BannerTargetModel) _then;

/// Create a copy of BannerTargetModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? bannerId = null,Object? universityId = freezed,Object? departmentId = freezed,}) {
  return _then(_BannerTargetModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,bannerId: null == bannerId ? _self.bannerId : bannerId // ignore: cast_nullable_to_non_nullable
as String,universityId: freezed == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String?,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
