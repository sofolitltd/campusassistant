// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transport_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransportModel {

 String get id; String get title; String get image; String get time;
/// Create a copy of TransportModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransportModelCopyWith<TransportModel> get copyWith => _$TransportModelCopyWithImpl<TransportModel>(this as TransportModel, _$identity);

  /// Serializes this TransportModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransportModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.image, image) || other.image == image)&&(identical(other.time, time) || other.time == time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,image,time);

@override
String toString() {
  return 'TransportModel(id: $id, title: $title, image: $image, time: $time)';
}


}

/// @nodoc
abstract mixin class $TransportModelCopyWith<$Res>  {
  factory $TransportModelCopyWith(TransportModel value, $Res Function(TransportModel) _then) = _$TransportModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, String image, String time
});




}
/// @nodoc
class _$TransportModelCopyWithImpl<$Res>
    implements $TransportModelCopyWith<$Res> {
  _$TransportModelCopyWithImpl(this._self, this._then);

  final TransportModel _self;
  final $Res Function(TransportModel) _then;

/// Create a copy of TransportModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? image = null,Object? time = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TransportModel].
extension TransportModelPatterns on TransportModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransportModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransportModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransportModel value)  $default,){
final _that = this;
switch (_that) {
case _TransportModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransportModel value)?  $default,){
final _that = this;
switch (_that) {
case _TransportModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String image,  String time)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransportModel() when $default != null:
return $default(_that.id,_that.title,_that.image,_that.time);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String image,  String time)  $default,) {final _that = this;
switch (_that) {
case _TransportModel():
return $default(_that.id,_that.title,_that.image,_that.time);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String image,  String time)?  $default,) {final _that = this;
switch (_that) {
case _TransportModel() when $default != null:
return $default(_that.id,_that.title,_that.image,_that.time);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransportModel extends TransportModel {
  const _TransportModel({required this.id, required this.title, required this.image, required this.time}): super._();
  factory _TransportModel.fromJson(Map<String, dynamic> json) => _$TransportModelFromJson(json);

@override final  String id;
@override final  String title;
@override final  String image;
@override final  String time;

/// Create a copy of TransportModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransportModelCopyWith<_TransportModel> get copyWith => __$TransportModelCopyWithImpl<_TransportModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransportModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransportModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.image, image) || other.image == image)&&(identical(other.time, time) || other.time == time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,image,time);

@override
String toString() {
  return 'TransportModel(id: $id, title: $title, image: $image, time: $time)';
}


}

/// @nodoc
abstract mixin class _$TransportModelCopyWith<$Res> implements $TransportModelCopyWith<$Res> {
  factory _$TransportModelCopyWith(_TransportModel value, $Res Function(_TransportModel) _then) = __$TransportModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String image, String time
});




}
/// @nodoc
class __$TransportModelCopyWithImpl<$Res>
    implements _$TransportModelCopyWith<$Res> {
  __$TransportModelCopyWithImpl(this._self, this._then);

  final _TransportModel _self;
  final $Res Function(_TransportModel) _then;

/// Create a copy of TransportModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? image = null,Object? time = null,}) {
  return _then(_TransportModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
