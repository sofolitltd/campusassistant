// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transport.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Transport {

 String get id; String get title; String get image; String get time;
/// Create a copy of Transport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransportCopyWith<Transport> get copyWith => _$TransportCopyWithImpl<Transport>(this as Transport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Transport&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.image, image) || other.image == image)&&(identical(other.time, time) || other.time == time));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,image,time);

@override
String toString() {
  return 'Transport(id: $id, title: $title, image: $image, time: $time)';
}


}

/// @nodoc
abstract mixin class $TransportCopyWith<$Res>  {
  factory $TransportCopyWith(Transport value, $Res Function(Transport) _then) = _$TransportCopyWithImpl;
@useResult
$Res call({
 String id, String title, String image, String time
});




}
/// @nodoc
class _$TransportCopyWithImpl<$Res>
    implements $TransportCopyWith<$Res> {
  _$TransportCopyWithImpl(this._self, this._then);

  final Transport _self;
  final $Res Function(Transport) _then;

/// Create a copy of Transport
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


/// Adds pattern-matching-related methods to [Transport].
extension TransportPatterns on Transport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Transport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Transport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Transport value)  $default,){
final _that = this;
switch (_that) {
case _Transport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Transport value)?  $default,){
final _that = this;
switch (_that) {
case _Transport() when $default != null:
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
case _Transport() when $default != null:
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
case _Transport():
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
case _Transport() when $default != null:
return $default(_that.id,_that.title,_that.image,_that.time);case _:
  return null;

}
}

}

/// @nodoc


class _Transport implements Transport {
  const _Transport({required this.id, required this.title, required this.image, required this.time});
  

@override final  String id;
@override final  String title;
@override final  String image;
@override final  String time;

/// Create a copy of Transport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransportCopyWith<_Transport> get copyWith => __$TransportCopyWithImpl<_Transport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Transport&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.image, image) || other.image == image)&&(identical(other.time, time) || other.time == time));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,image,time);

@override
String toString() {
  return 'Transport(id: $id, title: $title, image: $image, time: $time)';
}


}

/// @nodoc
abstract mixin class _$TransportCopyWith<$Res> implements $TransportCopyWith<$Res> {
  factory _$TransportCopyWith(_Transport value, $Res Function(_Transport) _then) = __$TransportCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String image, String time
});




}
/// @nodoc
class __$TransportCopyWithImpl<$Res>
    implements _$TransportCopyWith<$Res> {
  __$TransportCopyWithImpl(this._self, this._then);

  final _Transport _self;
  final $Res Function(_Transport) _then;

/// Create a copy of Transport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? image = null,Object? time = null,}) {
  return _then(_Transport(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
