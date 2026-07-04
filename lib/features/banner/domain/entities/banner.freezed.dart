// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'banner.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Banner {

 String get id; String get title; String get imageUrl; String get clickUrl; int get priority; bool get isActive; DateTime get startAt; DateTime get endAt; String get targetScope; List<BannerTarget> get targets;
/// Create a copy of Banner
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BannerCopyWith<Banner> get copyWith => _$BannerCopyWithImpl<Banner>(this as Banner, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Banner&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.clickUrl, clickUrl) || other.clickUrl == clickUrl)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.endAt, endAt) || other.endAt == endAt)&&(identical(other.targetScope, targetScope) || other.targetScope == targetScope)&&const DeepCollectionEquality().equals(other.targets, targets));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,imageUrl,clickUrl,priority,isActive,startAt,endAt,targetScope,const DeepCollectionEquality().hash(targets));

@override
String toString() {
  return 'Banner(id: $id, title: $title, imageUrl: $imageUrl, clickUrl: $clickUrl, priority: $priority, isActive: $isActive, startAt: $startAt, endAt: $endAt, targetScope: $targetScope, targets: $targets)';
}


}

/// @nodoc
abstract mixin class $BannerCopyWith<$Res>  {
  factory $BannerCopyWith(Banner value, $Res Function(Banner) _then) = _$BannerCopyWithImpl;
@useResult
$Res call({
 String id, String title, String imageUrl, String clickUrl, int priority, bool isActive, DateTime startAt, DateTime endAt, String targetScope, List<BannerTarget> targets
});




}
/// @nodoc
class _$BannerCopyWithImpl<$Res>
    implements $BannerCopyWith<$Res> {
  _$BannerCopyWithImpl(this._self, this._then);

  final Banner _self;
  final $Res Function(Banner) _then;

/// Create a copy of Banner
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
as List<BannerTarget>,
  ));
}

}


/// Adds pattern-matching-related methods to [Banner].
extension BannerPatterns on Banner {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Banner value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Banner() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Banner value)  $default,){
final _that = this;
switch (_that) {
case _Banner():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Banner value)?  $default,){
final _that = this;
switch (_that) {
case _Banner() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String imageUrl,  String clickUrl,  int priority,  bool isActive,  DateTime startAt,  DateTime endAt,  String targetScope,  List<BannerTarget> targets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Banner() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String imageUrl,  String clickUrl,  int priority,  bool isActive,  DateTime startAt,  DateTime endAt,  String targetScope,  List<BannerTarget> targets)  $default,) {final _that = this;
switch (_that) {
case _Banner():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String imageUrl,  String clickUrl,  int priority,  bool isActive,  DateTime startAt,  DateTime endAt,  String targetScope,  List<BannerTarget> targets)?  $default,) {final _that = this;
switch (_that) {
case _Banner() when $default != null:
return $default(_that.id,_that.title,_that.imageUrl,_that.clickUrl,_that.priority,_that.isActive,_that.startAt,_that.endAt,_that.targetScope,_that.targets);case _:
  return null;

}
}

}

/// @nodoc


class _Banner implements Banner {
  const _Banner({required this.id, required this.title, required this.imageUrl, required this.clickUrl, required this.priority, required this.isActive, required this.startAt, required this.endAt, required this.targetScope, final  List<BannerTarget> targets = const []}): _targets = targets;
  

@override final  String id;
@override final  String title;
@override final  String imageUrl;
@override final  String clickUrl;
@override final  int priority;
@override final  bool isActive;
@override final  DateTime startAt;
@override final  DateTime endAt;
@override final  String targetScope;
 final  List<BannerTarget> _targets;
@override@JsonKey() List<BannerTarget> get targets {
  if (_targets is EqualUnmodifiableListView) return _targets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_targets);
}


/// Create a copy of Banner
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BannerCopyWith<_Banner> get copyWith => __$BannerCopyWithImpl<_Banner>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Banner&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.clickUrl, clickUrl) || other.clickUrl == clickUrl)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.endAt, endAt) || other.endAt == endAt)&&(identical(other.targetScope, targetScope) || other.targetScope == targetScope)&&const DeepCollectionEquality().equals(other._targets, _targets));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,imageUrl,clickUrl,priority,isActive,startAt,endAt,targetScope,const DeepCollectionEquality().hash(_targets));

@override
String toString() {
  return 'Banner(id: $id, title: $title, imageUrl: $imageUrl, clickUrl: $clickUrl, priority: $priority, isActive: $isActive, startAt: $startAt, endAt: $endAt, targetScope: $targetScope, targets: $targets)';
}


}

/// @nodoc
abstract mixin class _$BannerCopyWith<$Res> implements $BannerCopyWith<$Res> {
  factory _$BannerCopyWith(_Banner value, $Res Function(_Banner) _then) = __$BannerCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String imageUrl, String clickUrl, int priority, bool isActive, DateTime startAt, DateTime endAt, String targetScope, List<BannerTarget> targets
});




}
/// @nodoc
class __$BannerCopyWithImpl<$Res>
    implements _$BannerCopyWith<$Res> {
  __$BannerCopyWithImpl(this._self, this._then);

  final _Banner _self;
  final $Res Function(_Banner) _then;

/// Create a copy of Banner
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? imageUrl = null,Object? clickUrl = null,Object? priority = null,Object? isActive = null,Object? startAt = null,Object? endAt = null,Object? targetScope = null,Object? targets = null,}) {
  return _then(_Banner(
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
as List<BannerTarget>,
  ));
}


}

/// @nodoc
mixin _$BannerTarget {

 int? get id; String get bannerId; String? get universityId; String? get departmentId;
/// Create a copy of BannerTarget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BannerTargetCopyWith<BannerTarget> get copyWith => _$BannerTargetCopyWithImpl<BannerTarget>(this as BannerTarget, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BannerTarget&&(identical(other.id, id) || other.id == id)&&(identical(other.bannerId, bannerId) || other.bannerId == bannerId)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId));
}


@override
int get hashCode => Object.hash(runtimeType,id,bannerId,universityId,departmentId);

@override
String toString() {
  return 'BannerTarget(id: $id, bannerId: $bannerId, universityId: $universityId, departmentId: $departmentId)';
}


}

/// @nodoc
abstract mixin class $BannerTargetCopyWith<$Res>  {
  factory $BannerTargetCopyWith(BannerTarget value, $Res Function(BannerTarget) _then) = _$BannerTargetCopyWithImpl;
@useResult
$Res call({
 int? id, String bannerId, String? universityId, String? departmentId
});




}
/// @nodoc
class _$BannerTargetCopyWithImpl<$Res>
    implements $BannerTargetCopyWith<$Res> {
  _$BannerTargetCopyWithImpl(this._self, this._then);

  final BannerTarget _self;
  final $Res Function(BannerTarget) _then;

/// Create a copy of BannerTarget
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


/// Adds pattern-matching-related methods to [BannerTarget].
extension BannerTargetPatterns on BannerTarget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BannerTarget value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BannerTarget() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BannerTarget value)  $default,){
final _that = this;
switch (_that) {
case _BannerTarget():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BannerTarget value)?  $default,){
final _that = this;
switch (_that) {
case _BannerTarget() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String bannerId,  String? universityId,  String? departmentId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BannerTarget() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String bannerId,  String? universityId,  String? departmentId)  $default,) {final _that = this;
switch (_that) {
case _BannerTarget():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String bannerId,  String? universityId,  String? departmentId)?  $default,) {final _that = this;
switch (_that) {
case _BannerTarget() when $default != null:
return $default(_that.id,_that.bannerId,_that.universityId,_that.departmentId);case _:
  return null;

}
}

}

/// @nodoc


class _BannerTarget implements BannerTarget {
  const _BannerTarget({this.id, required this.bannerId, this.universityId, this.departmentId});
  

@override final  int? id;
@override final  String bannerId;
@override final  String? universityId;
@override final  String? departmentId;

/// Create a copy of BannerTarget
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BannerTargetCopyWith<_BannerTarget> get copyWith => __$BannerTargetCopyWithImpl<_BannerTarget>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BannerTarget&&(identical(other.id, id) || other.id == id)&&(identical(other.bannerId, bannerId) || other.bannerId == bannerId)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId));
}


@override
int get hashCode => Object.hash(runtimeType,id,bannerId,universityId,departmentId);

@override
String toString() {
  return 'BannerTarget(id: $id, bannerId: $bannerId, universityId: $universityId, departmentId: $departmentId)';
}


}

/// @nodoc
abstract mixin class _$BannerTargetCopyWith<$Res> implements $BannerTargetCopyWith<$Res> {
  factory _$BannerTargetCopyWith(_BannerTarget value, $Res Function(_BannerTarget) _then) = __$BannerTargetCopyWithImpl;
@override @useResult
$Res call({
 int? id, String bannerId, String? universityId, String? departmentId
});




}
/// @nodoc
class __$BannerTargetCopyWithImpl<$Res>
    implements _$BannerTargetCopyWith<$Res> {
  __$BannerTargetCopyWithImpl(this._self, this._then);

  final _BannerTarget _self;
  final $Res Function(_BannerTarget) _then;

/// Create a copy of BannerTarget
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? bannerId = null,Object? universityId = freezed,Object? departmentId = freezed,}) {
  return _then(_BannerTarget(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,bannerId: null == bannerId ? _self.bannerId : bannerId // ignore: cast_nullable_to_non_nullable
as String,universityId: freezed == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String?,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
