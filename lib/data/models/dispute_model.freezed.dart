// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dispute_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DisputeModel {

 String get id; String get rentalId; String get reporterId; String get otherPartyId; String get reason; String get status;// pending, in_review, resolved, dismissed
 String? get resolution; List<String> get evidenceUrls; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of DisputeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DisputeModelCopyWith<DisputeModel> get copyWith => _$DisputeModelCopyWithImpl<DisputeModel>(this as DisputeModel, _$identity);

  /// Serializes this DisputeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DisputeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.rentalId, rentalId) || other.rentalId == rentalId)&&(identical(other.reporterId, reporterId) || other.reporterId == reporterId)&&(identical(other.otherPartyId, otherPartyId) || other.otherPartyId == otherPartyId)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.status, status) || other.status == status)&&(identical(other.resolution, resolution) || other.resolution == resolution)&&const DeepCollectionEquality().equals(other.evidenceUrls, evidenceUrls)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,rentalId,reporterId,otherPartyId,reason,status,resolution,const DeepCollectionEquality().hash(evidenceUrls),createdAt,updatedAt);

@override
String toString() {
  return 'DisputeModel(id: $id, rentalId: $rentalId, reporterId: $reporterId, otherPartyId: $otherPartyId, reason: $reason, status: $status, resolution: $resolution, evidenceUrls: $evidenceUrls, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DisputeModelCopyWith<$Res>  {
  factory $DisputeModelCopyWith(DisputeModel value, $Res Function(DisputeModel) _then) = _$DisputeModelCopyWithImpl;
@useResult
$Res call({
 String id, String rentalId, String reporterId, String otherPartyId, String reason, String status, String? resolution, List<String> evidenceUrls, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$DisputeModelCopyWithImpl<$Res>
    implements $DisputeModelCopyWith<$Res> {
  _$DisputeModelCopyWithImpl(this._self, this._then);

  final DisputeModel _self;
  final $Res Function(DisputeModel) _then;

/// Create a copy of DisputeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? rentalId = null,Object? reporterId = null,Object? otherPartyId = null,Object? reason = null,Object? status = null,Object? resolution = freezed,Object? evidenceUrls = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,rentalId: null == rentalId ? _self.rentalId : rentalId // ignore: cast_nullable_to_non_nullable
as String,reporterId: null == reporterId ? _self.reporterId : reporterId // ignore: cast_nullable_to_non_nullable
as String,otherPartyId: null == otherPartyId ? _self.otherPartyId : otherPartyId // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,resolution: freezed == resolution ? _self.resolution : resolution // ignore: cast_nullable_to_non_nullable
as String?,evidenceUrls: null == evidenceUrls ? _self.evidenceUrls : evidenceUrls // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DisputeModel].
extension DisputeModelPatterns on DisputeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DisputeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DisputeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DisputeModel value)  $default,){
final _that = this;
switch (_that) {
case _DisputeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DisputeModel value)?  $default,){
final _that = this;
switch (_that) {
case _DisputeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String rentalId,  String reporterId,  String otherPartyId,  String reason,  String status,  String? resolution,  List<String> evidenceUrls,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DisputeModel() when $default != null:
return $default(_that.id,_that.rentalId,_that.reporterId,_that.otherPartyId,_that.reason,_that.status,_that.resolution,_that.evidenceUrls,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String rentalId,  String reporterId,  String otherPartyId,  String reason,  String status,  String? resolution,  List<String> evidenceUrls,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DisputeModel():
return $default(_that.id,_that.rentalId,_that.reporterId,_that.otherPartyId,_that.reason,_that.status,_that.resolution,_that.evidenceUrls,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String rentalId,  String reporterId,  String otherPartyId,  String reason,  String status,  String? resolution,  List<String> evidenceUrls,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DisputeModel() when $default != null:
return $default(_that.id,_that.rentalId,_that.reporterId,_that.otherPartyId,_that.reason,_that.status,_that.resolution,_that.evidenceUrls,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DisputeModel implements DisputeModel {
  const _DisputeModel({required this.id, required this.rentalId, required this.reporterId, required this.otherPartyId, required this.reason, this.status = 'pending', this.resolution, final  List<String> evidenceUrls = const [], this.createdAt, this.updatedAt}): _evidenceUrls = evidenceUrls;
  factory _DisputeModel.fromJson(Map<String, dynamic> json) => _$DisputeModelFromJson(json);

@override final  String id;
@override final  String rentalId;
@override final  String reporterId;
@override final  String otherPartyId;
@override final  String reason;
@override@JsonKey() final  String status;
// pending, in_review, resolved, dismissed
@override final  String? resolution;
 final  List<String> _evidenceUrls;
@override@JsonKey() List<String> get evidenceUrls {
  if (_evidenceUrls is EqualUnmodifiableListView) return _evidenceUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_evidenceUrls);
}

@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of DisputeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DisputeModelCopyWith<_DisputeModel> get copyWith => __$DisputeModelCopyWithImpl<_DisputeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DisputeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DisputeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.rentalId, rentalId) || other.rentalId == rentalId)&&(identical(other.reporterId, reporterId) || other.reporterId == reporterId)&&(identical(other.otherPartyId, otherPartyId) || other.otherPartyId == otherPartyId)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.status, status) || other.status == status)&&(identical(other.resolution, resolution) || other.resolution == resolution)&&const DeepCollectionEquality().equals(other._evidenceUrls, _evidenceUrls)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,rentalId,reporterId,otherPartyId,reason,status,resolution,const DeepCollectionEquality().hash(_evidenceUrls),createdAt,updatedAt);

@override
String toString() {
  return 'DisputeModel(id: $id, rentalId: $rentalId, reporterId: $reporterId, otherPartyId: $otherPartyId, reason: $reason, status: $status, resolution: $resolution, evidenceUrls: $evidenceUrls, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DisputeModelCopyWith<$Res> implements $DisputeModelCopyWith<$Res> {
  factory _$DisputeModelCopyWith(_DisputeModel value, $Res Function(_DisputeModel) _then) = __$DisputeModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String rentalId, String reporterId, String otherPartyId, String reason, String status, String? resolution, List<String> evidenceUrls, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$DisputeModelCopyWithImpl<$Res>
    implements _$DisputeModelCopyWith<$Res> {
  __$DisputeModelCopyWithImpl(this._self, this._then);

  final _DisputeModel _self;
  final $Res Function(_DisputeModel) _then;

/// Create a copy of DisputeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? rentalId = null,Object? reporterId = null,Object? otherPartyId = null,Object? reason = null,Object? status = null,Object? resolution = freezed,Object? evidenceUrls = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_DisputeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,rentalId: null == rentalId ? _self.rentalId : rentalId // ignore: cast_nullable_to_non_nullable
as String,reporterId: null == reporterId ? _self.reporterId : reporterId // ignore: cast_nullable_to_non_nullable
as String,otherPartyId: null == otherPartyId ? _self.otherPartyId : otherPartyId // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,resolution: freezed == resolution ? _self.resolution : resolution // ignore: cast_nullable_to_non_nullable
as String?,evidenceUrls: null == evidenceUrls ? _self._evidenceUrls : evidenceUrls // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
