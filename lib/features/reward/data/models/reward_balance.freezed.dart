// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reward_balance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RewardBalance {

 int get balance;@JsonKey(name: 'lifetime_earned') int get lifetimeEarned;@JsonKey(name: 'lifetime_spent') int get lifetimeSpent;
/// Create a copy of RewardBalance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RewardBalanceCopyWith<RewardBalance> get copyWith => _$RewardBalanceCopyWithImpl<RewardBalance>(this as RewardBalance, _$identity);

  /// Serializes this RewardBalance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RewardBalance;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RewardBalance&&(identical(other.balance, _this.balance) || other.balance == _this.balance)&&(identical(other.lifetimeEarned, _this.lifetimeEarned) || other.lifetimeEarned == _this.lifetimeEarned)&&(identical(other.lifetimeSpent, _this.lifetimeSpent) || other.lifetimeSpent == _this.lifetimeSpent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RewardBalance;
  return Object.hash(runtimeType,_this.balance,_this.lifetimeEarned,_this.lifetimeSpent);
}

@override
String toString() {
  final _this = this as RewardBalance;
  return 'RewardBalance(balance: ${_this.balance}, lifetimeEarned: ${_this.lifetimeEarned}, lifetimeSpent: ${_this.lifetimeSpent})';
}


}

/// @nodoc
abstract mixin class $RewardBalanceCopyWith<$Res>  {
  factory $RewardBalanceCopyWith(RewardBalance value, $Res Function(RewardBalance) _then) = _$RewardBalanceCopyWithImpl;
@useResult
$Res call({
 int balance,@JsonKey(name: 'lifetime_earned') int lifetimeEarned,@JsonKey(name: 'lifetime_spent') int lifetimeSpent
});




}
/// @nodoc
class _$RewardBalanceCopyWithImpl<$Res>
    implements $RewardBalanceCopyWith<$Res> {
  _$RewardBalanceCopyWithImpl(this._self, this._then);

  final RewardBalance _self;
  final $Res Function(RewardBalance) _then;

/// Create a copy of RewardBalance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? balance = null,Object? lifetimeEarned = null,Object? lifetimeSpent = null,}) {
  return _then(RewardBalance(
balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,lifetimeEarned: null == lifetimeEarned ? _self.lifetimeEarned : lifetimeEarned // ignore: cast_nullable_to_non_nullable
as int,lifetimeSpent: null == lifetimeSpent ? _self.lifetimeSpent : lifetimeSpent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RewardBalance].
extension RewardBalancePatterns on RewardBalance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RewardBalance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RewardBalance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RewardBalance value)  $default,){
final _that = this;
switch (_that) {
case _RewardBalance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RewardBalance value)?  $default,){
final _that = this;
switch (_that) {
case _RewardBalance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int balance, @JsonKey(name: 'lifetime_earned')  int lifetimeEarned, @JsonKey(name: 'lifetime_spent')  int lifetimeSpent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RewardBalance() when $default != null:
return $default(_that.balance,_that.lifetimeEarned,_that.lifetimeSpent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int balance, @JsonKey(name: 'lifetime_earned')  int lifetimeEarned, @JsonKey(name: 'lifetime_spent')  int lifetimeSpent)  $default,) {final _that = this;
switch (_that) {
case _RewardBalance():
return $default(_that.balance,_that.lifetimeEarned,_that.lifetimeSpent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int balance, @JsonKey(name: 'lifetime_earned')  int lifetimeEarned, @JsonKey(name: 'lifetime_spent')  int lifetimeSpent)?  $default,) {final _that = this;
switch (_that) {
case _RewardBalance() when $default != null:
return $default(_that.balance,_that.lifetimeEarned,_that.lifetimeSpent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RewardBalance implements RewardBalance {
  const _RewardBalance({required this.balance, @JsonKey(name: 'lifetime_earned') required this.lifetimeEarned, @JsonKey(name: 'lifetime_spent') required this.lifetimeSpent});
  factory _RewardBalance.fromJson(Map<String, dynamic> json) => _$RewardBalanceFromJson(json);

@override final  int balance;
@override@JsonKey(name: 'lifetime_earned') final  int lifetimeEarned;
@override@JsonKey(name: 'lifetime_spent') final  int lifetimeSpent;

/// Create a copy of RewardBalance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RewardBalanceCopyWith<_RewardBalance> get copyWith => __$RewardBalanceCopyWithImpl<_RewardBalance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RewardBalanceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RewardBalance&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.lifetimeEarned, lifetimeEarned) || other.lifetimeEarned == lifetimeEarned)&&(identical(other.lifetimeSpent, lifetimeSpent) || other.lifetimeSpent == lifetimeSpent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,balance,lifetimeEarned,lifetimeSpent);
}

@override
String toString() {
    return 'RewardBalance(balance: $balance, lifetimeEarned: $lifetimeEarned, lifetimeSpent: $lifetimeSpent)';
}


}

/// @nodoc
abstract mixin class _$RewardBalanceCopyWith<$Res> implements $RewardBalanceCopyWith<$Res> {
  factory _$RewardBalanceCopyWith(_RewardBalance value, $Res Function(_RewardBalance) _then) = __$RewardBalanceCopyWithImpl;
@override @useResult
$Res call({
 int balance,@JsonKey(name: 'lifetime_earned') int lifetimeEarned,@JsonKey(name: 'lifetime_spent') int lifetimeSpent
});




}
/// @nodoc
class __$RewardBalanceCopyWithImpl<$Res>
    implements _$RewardBalanceCopyWith<$Res> {
  __$RewardBalanceCopyWithImpl(this._self, this._then);

  final _RewardBalance _self;
  final $Res Function(_RewardBalance) _then;

/// Create a copy of RewardBalance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? balance = null,Object? lifetimeEarned = null,Object? lifetimeSpent = null,}) {
  return _then(_RewardBalance(
balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,lifetimeEarned: null == lifetimeEarned ? _self.lifetimeEarned : lifetimeEarned // ignore: cast_nullable_to_non_nullable
as int,lifetimeSpent: null == lifetimeSpent ? _self.lifetimeSpent : lifetimeSpent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
