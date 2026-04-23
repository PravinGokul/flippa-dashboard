import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'dispute_model.freezed.dart';
part 'dispute_model.g.dart';

@freezed
class DisputeModel with _$DisputeModel {
  const factory DisputeModel({
    required String id,
    required String rentalId,
    required String reporterId,
    required String otherPartyId,
    required String reason,
    @Default('pending') String status, // pending, in_review, resolved, dismissed
    String? resolution,
    @Default([]) List<String> evidenceUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DisputeModel;

  factory DisputeModel.fromJson(Map<String, dynamic> json) => _$DisputeModelFromJson(json);
}
