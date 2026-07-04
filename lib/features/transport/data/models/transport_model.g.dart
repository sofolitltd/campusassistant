// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transport_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransportModel _$TransportModelFromJson(Map<String, dynamic> json) =>
    _TransportModel(
      id: json['id'] as String,
      title: json['title'] as String,
      image: json['image'] as String,
      time: json['time'] as String,
    );

Map<String, dynamic> _$TransportModelToJson(_TransportModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'image': instance.image,
      'time': instance.time,
    };
