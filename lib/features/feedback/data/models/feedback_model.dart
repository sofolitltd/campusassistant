import 'package:freezed_annotation/freezed_annotation.dart';

import '/features/feedback/domain/entities/feedback.dart';

part 'feedback_model.freezed.dart';
part 'feedback_model.g.dart';

@freezed
abstract class FeedbackItemModel with _$FeedbackItemModel {
  const FeedbackItemModel._();

  const factory FeedbackItemModel({
    required String id,
    required String category,
    required String subject,
    required String message,
    @JsonKey(name: 'attachment_url') String? attachmentUrl,
    @Default('pending') String status,
    @JsonKey(name: 'admin_reply') String? adminReply,
    @JsonKey(name: 'replied_at') String? repliedAt,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _FeedbackItemModel;

  factory FeedbackItemModel.fromJson(Map<String, dynamic> json) =>
      _$FeedbackItemModelFromJson(json);

  FeedbackItem toEntity() => FeedbackItem(
        id: id,
        category: category,
        subject: subject,
        message: message,
        attachmentUrl: attachmentUrl,
        status: status,
        adminReply: adminReply,
        repliedAt: repliedAt,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
