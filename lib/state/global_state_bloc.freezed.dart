// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'global_state_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GlobalState {

 Locale get locale; String get currency; double get exchangeRate;
/// Create a copy of GlobalState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GlobalStateCopyWith<GlobalState> get copyWith => _$GlobalStateCopyWithImpl<GlobalState>(this as GlobalState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GlobalState&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.exchangeRate, exchangeRate) || other.exchangeRate == exchangeRate));
}


@override
int get hashCode => Object.hash(runtimeType,locale,currency,exchangeRate);

@override
String toString() {
  return 'GlobalState(locale: $locale, currency: $currency, exchangeRate: $exchangeRate)';
}


}

/// @nodoc
abstract mixin class $GlobalStateCopyWith<$Res>  {
  factory $GlobalStateCopyWith(GlobalState value, $Res Function(GlobalState) _then) = _$GlobalStateCopyWithImpl;
@useResult
$Res call({
 Locale locale, String currency, double exchangeRate
});




}
/// @nodoc
class _$GlobalStateCopyWithImpl<$Res>
    implements $GlobalStateCopyWith<$Res> {
  _$GlobalStateCopyWithImpl(this._self, this._then);

  final GlobalState _self;
  final $Res Function(GlobalState) _then;

/// Create a copy of GlobalState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? locale = null,Object? currency = null,Object? exchangeRate = null,}) {
  return _then(_self.copyWith(
locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as Locale,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,exchangeRate: null == exchangeRate ? _self.exchangeRate : exchangeRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [GlobalState].
extension GlobalStatePatterns on GlobalState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GlobalState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GlobalState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GlobalState value)  $default,){
final _that = this;
switch (_that) {
case _GlobalState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GlobalState value)?  $default,){
final _that = this;
switch (_that) {
case _GlobalState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Locale locale,  String currency,  double exchangeRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GlobalState() when $default != null:
return $default(_that.locale,_that.currency,_that.exchangeRate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Locale locale,  String currency,  double exchangeRate)  $default,) {final _that = this;
switch (_that) {
case _GlobalState():
return $default(_that.locale,_that.currency,_that.exchangeRate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Locale locale,  String currency,  double exchangeRate)?  $default,) {final _that = this;
switch (_that) {
case _GlobalState() when $default != null:
return $default(_that.locale,_that.currency,_that.exchangeRate);case _:
  return null;

}
}

}

/// @nodoc


class _GlobalState implements GlobalState {
  const _GlobalState({this.locale = const Locale('en', 'US'), this.currency = 'USD', this.exchangeRate = 1.0});
  

@override@JsonKey() final  Locale locale;
@override@JsonKey() final  String currency;
@override@JsonKey() final  double exchangeRate;

/// Create a copy of GlobalState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GlobalStateCopyWith<_GlobalState> get copyWith => __$GlobalStateCopyWithImpl<_GlobalState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GlobalState&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.exchangeRate, exchangeRate) || other.exchangeRate == exchangeRate));
}


@override
int get hashCode => Object.hash(runtimeType,locale,currency,exchangeRate);

@override
String toString() {
  return 'GlobalState(locale: $locale, currency: $currency, exchangeRate: $exchangeRate)';
}


}

/// @nodoc
abstract mixin class _$GlobalStateCopyWith<$Res> implements $GlobalStateCopyWith<$Res> {
  factory _$GlobalStateCopyWith(_GlobalState value, $Res Function(_GlobalState) _then) = __$GlobalStateCopyWithImpl;
@override @useResult
$Res call({
 Locale locale, String currency, double exchangeRate
});




}
/// @nodoc
class __$GlobalStateCopyWithImpl<$Res>
    implements _$GlobalStateCopyWith<$Res> {
  __$GlobalStateCopyWithImpl(this._self, this._then);

  final _GlobalState _self;
  final $Res Function(_GlobalState) _then;

/// Create a copy of GlobalState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? locale = null,Object? currency = null,Object? exchangeRate = null,}) {
  return _then(_GlobalState(
locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as Locale,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,exchangeRate: null == exchangeRate ? _self.exchangeRate : exchangeRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$GlobalEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GlobalEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GlobalEvent()';
}


}

/// @nodoc
class $GlobalEventCopyWith<$Res>  {
$GlobalEventCopyWith(GlobalEvent _, $Res Function(GlobalEvent) __);
}


/// Adds pattern-matching-related methods to [GlobalEvent].
extension GlobalEventPatterns on GlobalEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _ChangeLanguage value)?  changeLanguage,TResult Function( _ChangeCurrency value)?  changeCurrency,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangeLanguage() when changeLanguage != null:
return changeLanguage(_that);case _ChangeCurrency() when changeCurrency != null:
return changeCurrency(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _ChangeLanguage value)  changeLanguage,required TResult Function( _ChangeCurrency value)  changeCurrency,}){
final _that = this;
switch (_that) {
case _ChangeLanguage():
return changeLanguage(_that);case _ChangeCurrency():
return changeCurrency(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _ChangeLanguage value)?  changeLanguage,TResult? Function( _ChangeCurrency value)?  changeCurrency,}){
final _that = this;
switch (_that) {
case _ChangeLanguage() when changeLanguage != null:
return changeLanguage(_that);case _ChangeCurrency() when changeCurrency != null:
return changeCurrency(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Locale locale)?  changeLanguage,TResult Function( String currencyCode)?  changeCurrency,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChangeLanguage() when changeLanguage != null:
return changeLanguage(_that.locale);case _ChangeCurrency() when changeCurrency != null:
return changeCurrency(_that.currencyCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Locale locale)  changeLanguage,required TResult Function( String currencyCode)  changeCurrency,}) {final _that = this;
switch (_that) {
case _ChangeLanguage():
return changeLanguage(_that.locale);case _ChangeCurrency():
return changeCurrency(_that.currencyCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Locale locale)?  changeLanguage,TResult? Function( String currencyCode)?  changeCurrency,}) {final _that = this;
switch (_that) {
case _ChangeLanguage() when changeLanguage != null:
return changeLanguage(_that.locale);case _ChangeCurrency() when changeCurrency != null:
return changeCurrency(_that.currencyCode);case _:
  return null;

}
}

}

/// @nodoc


class _ChangeLanguage implements GlobalEvent {
  const _ChangeLanguage(this.locale);
  

 final  Locale locale;

/// Create a copy of GlobalEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangeLanguageCopyWith<_ChangeLanguage> get copyWith => __$ChangeLanguageCopyWithImpl<_ChangeLanguage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangeLanguage&&(identical(other.locale, locale) || other.locale == locale));
}


@override
int get hashCode => Object.hash(runtimeType,locale);

@override
String toString() {
  return 'GlobalEvent.changeLanguage(locale: $locale)';
}


}

/// @nodoc
abstract mixin class _$ChangeLanguageCopyWith<$Res> implements $GlobalEventCopyWith<$Res> {
  factory _$ChangeLanguageCopyWith(_ChangeLanguage value, $Res Function(_ChangeLanguage) _then) = __$ChangeLanguageCopyWithImpl;
@useResult
$Res call({
 Locale locale
});




}
/// @nodoc
class __$ChangeLanguageCopyWithImpl<$Res>
    implements _$ChangeLanguageCopyWith<$Res> {
  __$ChangeLanguageCopyWithImpl(this._self, this._then);

  final _ChangeLanguage _self;
  final $Res Function(_ChangeLanguage) _then;

/// Create a copy of GlobalEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? locale = null,}) {
  return _then(_ChangeLanguage(
null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as Locale,
  ));
}


}

/// @nodoc


class _ChangeCurrency implements GlobalEvent {
  const _ChangeCurrency(this.currencyCode);
  

 final  String currencyCode;

/// Create a copy of GlobalEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangeCurrencyCopyWith<_ChangeCurrency> get copyWith => __$ChangeCurrencyCopyWithImpl<_ChangeCurrency>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangeCurrency&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode));
}


@override
int get hashCode => Object.hash(runtimeType,currencyCode);

@override
String toString() {
  return 'GlobalEvent.changeCurrency(currencyCode: $currencyCode)';
}


}

/// @nodoc
abstract mixin class _$ChangeCurrencyCopyWith<$Res> implements $GlobalEventCopyWith<$Res> {
  factory _$ChangeCurrencyCopyWith(_ChangeCurrency value, $Res Function(_ChangeCurrency) _then) = __$ChangeCurrencyCopyWithImpl;
@useResult
$Res call({
 String currencyCode
});




}
/// @nodoc
class __$ChangeCurrencyCopyWithImpl<$Res>
    implements _$ChangeCurrencyCopyWith<$Res> {
  __$ChangeCurrencyCopyWithImpl(this._self, this._then);

  final _ChangeCurrency _self;
  final $Res Function(_ChangeCurrency) _then;

/// Create a copy of GlobalEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? currencyCode = null,}) {
  return _then(_ChangeCurrency(
null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
