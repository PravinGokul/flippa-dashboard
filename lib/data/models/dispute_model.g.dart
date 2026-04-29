// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DisputeModel _$DisputeModelFromJson(Map<String, dynamic> json) =>
    _DisputeModel(
      id: json['id'] as String,
      rentalId: json['rentalId'] as String,
      reporterId: json['reporterId'] as String,
      otherPartyId: json['otherPartyId'] as String,
      reason: json['reason'] as String,
      status: json['status'] as String? ?? 'pending',
      resolution: json['resolution'] as String?,
      evidenceUrls:
          (json['evidenceUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$DisputeModelToJson(_DisputeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rentalId': instance.rentalId,
      'reporterId': instance.reporterId,
      'otherPartyId': instance.otherPartyId,
      'reason': instance.reason,
      'status': instance.status,
      'resolution': instance.resolution,
      'evidenceUrls': instance.evidenceUrls,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
