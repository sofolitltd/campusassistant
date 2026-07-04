// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'batch_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BatchModel {

 String get id; String get name; String get slug; bool get isStudying; String get departmentId; String get universityId; List<SessionModel> get sessions;
/// Create a copy of BatchModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BatchModelCopyWith<BatchModel> get copyWith => _$BatchModelCopyWithImpl<BatchModel>(this as BatchModel, _$identity);

  /// Serializes this BatchModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BatchModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.isStudying, isStudying) || other.isStudying == isStudying)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&const DeepCollectionEquality().equals(other.sessions, sessions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,slug,isStudying,departmentId,universityId,const DeepCollectionEquality().hash(sessions));

@override
String toString() {
  return 'BatchModel(id: $id, name: $name, slug: $slug, isStudying: $isStudying, departmentId: $departmentId, universityId: $universityId, sessions: $sessions)';
}


}

/// @nodoc
abstract mixin class $BatchModelCopyWith<$Res>  {
  factory $BatchModelCopyWith(BatchModel value, $Res Function(BatchModel) _then) = _$BatchModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String slug, bool isStudying, String departmentId, String universityId, List<SessionModel> sessions
});




}
/// @nodoc
class _$BatchModelCopyWithImpl<$Res>
    implements $BatchModelCopyWith<$Res> {
  _$BatchModelCopyWithImpl(this._self, this._then);

  final BatchModel _self;
  final $Res Function(BatchModel) _then;

/// Create a copy of BatchModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? isStudying = null,Object? departmentId = null,Object? universityId = null,Object? sessions = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,isStudying: null == isStudying ? _self.isStudying : isStudying // ignore: cast_nullable_to_non_nullable
as bool,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<SessionModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [BatchModel].
extension BatchModelPatterns on BatchModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BatchModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BatchModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BatchModel value)  $default,){
final _that = this;
switch (_that) {
case _BatchModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BatchModel value)?  $default,){
final _that = this;
switch (_that) {
case _BatchModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String slug,  bool isStudying,  String departmentId,  String universityId,  List<SessionModel> sessions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BatchModel() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.isStudying,_that.departmentId,_that.universityId,_that.sessions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String slug,  bool isStudying,  String departmentId,  String universityId,  List<SessionModel> sessions)  $default,) {final _that = this;
switch (_that) {
case _BatchModel():
return $default(_that.id,_that.name,_that.slug,_that.isStudying,_that.departmentId,_that.universityId,_that.sessions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String slug,  bool isStudying,  String departmentId,  String universityId,  List<SessionModel> sessions)?  $default,) {final _that = this;
switch (_that) {
case _BatchModel() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.isStudying,_that.departmentId,_that.universityId,_that.sessions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BatchModel extends BatchModel {
  const _BatchModel({required this.id, required this.name, required this.slug, this.isStudying = true, required this.departmentId, required this.universityId, final  List<SessionModel> sessions = const []}): _sessions = sessions,super._();
  factory _BatchModel.fromJson(Map<String, dynamic> json) => _$BatchModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String slug;
@override@JsonKey() final  bool isStudying;
@override final  String departmentId;
@override final  String universityId;
 final  List<SessionModel> _sessions;
@override@JsonKey() List<SessionModel> get sessions {
  if (_sessions is EqualUnmodifiableListView) return _sessions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sessions);
}


/// Create a copy of BatchModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BatchModelCopyWith<_BatchModel> get copyWith => __$BatchModelCopyWithImpl<_BatchModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BatchModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BatchModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.isStudying, isStudying) || other.isStudying == isStudying)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&const DeepCollectionEquality().equals(other._sessions, _sessions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,slug,isStudying,departmentId,universityId,const DeepCollectionEquality().hash(_sessions));

@override
String toString() {
  return 'BatchModel(id: $id, name: $name, slug: $slug, isStudying: $isStudying, departmentId: $departmentId, universityId: $universityId, sessions: $sessions)';
}


}

/// @nodoc
abstract mixin class _$BatchModelCopyWith<$Res> implements $BatchModelCopyWith<$Res> {
  factory _$BatchModelCopyWith(_BatchModel value, $Res Function(_BatchModel) _then) = __$BatchModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String slug, bool isStudying, String departmentId, String universityId, List<SessionModel> sessions
});




}
/// @nodoc
class __$BatchModelCopyWithImpl<$Res>
    implements _$BatchModelCopyWith<$Res> {
  __$BatchModelCopyWithImpl(this._self, this._then);

  final _BatchModel _self;
  final $Res Function(_BatchModel) _then;

/// Create a copy of BatchModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? isStudying = null,Object? departmentId = null,Object? universityId = null,Object? sessions = null,}) {
  return _then(_BatchModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,isStudying: null == isStudying ? _self.isStudying : isStudying // ignore: cast_nullable_to_non_nullable
as bool,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,sessions: null == sessions ? _self._sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<SessionModel>,
  ));
}


}

// dart format on
