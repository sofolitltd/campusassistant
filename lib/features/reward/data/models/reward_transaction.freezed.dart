// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reward_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RewardTransaction {

 String get id; String get type; int get amount;@JsonKey(name: 'balance_after') int get balanceAfter;@JsonKey(name: 'resource_id') String? get resourceId; String? get description;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of RewardTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RewardTransactionCopyWith<RewardTransaction> get copyWith => _$RewardTransactionCopyWithImpl<RewardTransaction>(this as RewardTransaction, _$identity);

  /// Serializes this RewardTransaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RewardTransaction;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RewardTransaction&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.balanceAfter, _this.balanceAfter) || other.balanceAfter == _this.balanceAfter)&&(identical(other.resourceId, _this.resourceId) || other.resourceId == _this.resourceId)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RewardTransaction;
  return Object.hash(runtimeType,_this.id,_this.type,_this.amount,_this.balanceAfter,_this.resourceId,_this.description,_this.createdAt);
}

@override
String toString() {
  final _this = this as RewardTransaction;
  return 'RewardTransaction(id: ${_this.id}, type: ${_this.type}, amount: ${_this.amount}, balanceAfter: ${_this.balanceAfter}, resourceId: ${_this.resourceId}, description: ${_this.description}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $RewardTransactionCopyWith<$Res>  {
  factory $RewardTransactionCopyWith(RewardTransaction value, $Res Function(RewardTransaction) _then) = _$RewardTransactionCopyWithImpl;
@useResult
$Res call({
 String id, String type, int amount,@JsonKey(name: 'balance_after') int balanceAfter,@JsonKey(name: 'resource_id') String? resourceId, String? description,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$RewardTransactionCopyWithImpl<$Res>
    implements $RewardTransactionCopyWith<$Res> {
  _$RewardTransactionCopyWithImpl(this._self, this._then);

  final RewardTransaction _self;
  final $Res Function(RewardTransaction) _then;

/// Create a copy of RewardTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? amount = null,Object? balanceAfter = null,Object? resourceId = freezed,Object? description = freezed,Object? createdAt = null,}) {
  return _then(RewardTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,balanceAfter: null == balanceAfter ? _self.balanceAfter : balanceAfter // ignore: cast_nullable_to_non_nullable
as int,resourceId: freezed == resourceId ? _self.resourceId : resourceId // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RewardTransaction].
extension RewardTransactionPatterns on RewardTransaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RewardTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RewardTransaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RewardTransaction value)  $default,){
final _that = this;
switch (_that) {
case _RewardTransaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RewardTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _RewardTransaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  int amount, @JsonKey(name: 'balance_after')  int balanceAfter, @JsonKey(name: 'resource_id')  String? resourceId,  String? description, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RewardTransaction() when $default != null:
return $default(_that.id,_that.type,_that.amount,_that.balanceAfter,_that.resourceId,_that.description,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  int amount, @JsonKey(name: 'balance_after')  int balanceAfter, @JsonKey(name: 'resource_id')  String? resourceId,  String? description, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _RewardTransaction():
return $default(_that.id,_that.type,_that.amount,_that.balanceAfter,_that.resourceId,_that.description,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  int amount, @JsonKey(name: 'balance_after')  int balanceAfter, @JsonKey(name: 'resource_id')  String? resourceId,  String? description, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _RewardTransaction() when $default != null:
return $default(_that.id,_that.type,_that.amount,_that.balanceAfter,_that.resourceId,_that.description,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RewardTransaction implements RewardTransaction {
  const _RewardTransaction({required this.id, required this.type, required this.amount, @JsonKey(name: 'balance_after') required this.balanceAfter, @JsonKey(name: 'resource_id') this.resourceId, this.description, @JsonKey(name: 'created_at') required this.createdAt});
  factory _RewardTransaction.fromJson(Map<String, dynamic> json) => _$RewardTransactionFromJson(json);

@override final  String id;
@override final  String type;
@override final  int amount;
@override@JsonKey(name: 'balance_after') final  int balanceAfter;
@override@JsonKey(name: 'resource_id') final  String? resourceId;
@override final  String? description;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of RewardTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RewardTransactionCopyWith<_RewardTransaction> get copyWith => __$RewardTransactionCopyWithImpl<_RewardTransaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RewardTransactionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RewardTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.balanceAfter, balanceAfter) || other.balanceAfter == balanceAfter)&&(identical(other.resourceId, resourceId) || other.resourceId == resourceId)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,type,amount,balanceAfter,resourceId,description,createdAt);
}

@override
String toString() {
    return 'RewardTransaction(id: $id, type: $type, amount: $amount, balanceAfter: $balanceAfter, resourceId: $resourceId, description: $description, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$RewardTransactionCopyWith<$Res> implements $RewardTransactionCopyWith<$Res> {
  factory _$RewardTransactionCopyWith(_RewardTransaction value, $Res Function(_RewardTransaction) _then) = __$RewardTransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, int amount,@JsonKey(name: 'balance_after') int balanceAfter,@JsonKey(name: 'resource_id') String? resourceId, String? description,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$RewardTransactionCopyWithImpl<$Res>
    implements _$RewardTransactionCopyWith<$Res> {
  __$RewardTransactionCopyWithImpl(this._self, this._then);

  final _RewardTransaction _self;
  final $Res Function(_RewardTransaction) _then;

/// Create a copy of RewardTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? amount = null,Object? balanceAfter = null,Object? resourceId = freezed,Object? description = freezed,Object? createdAt = null,}) {
  return _then(_RewardTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,balanceAfter: null == balanceAfter ? _self.balanceAfter : balanceAfter // ignore: cast_nullable_to_non_nullable
as int,resourceId: freezed == resourceId ? _self.resourceId : resourceId // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
