// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FeedbackItemModel _$FeedbackItemModelFromJson(Map<String, dynamic> json) =>
    _FeedbackItemModel(
      id: json['id'] as String,
      category: json['category'] as String,
      subject: json['subject'] as String,
      message: json['message'] as String,
      attachmentUrl: json['attachment_url'] as String?,
      status: json['status'] as String? ?? 'pending',
      adminReply: json['admin_reply'] as String?,
      repliedAt: json['replied_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$FeedbackItemModelToJson(_FeedbackItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'subject': instance.subject,
      'message': instance.message,
      'attachment_url': ?instance.attachmentUrl,
      'status': instance.status,
      'admin_reply': ?instance.adminReply,
      'replied_at': ?instance.repliedAt,
      'created_at': ?instance.createdAt,
      'updated_at': ?instance.updatedAt,
    };
