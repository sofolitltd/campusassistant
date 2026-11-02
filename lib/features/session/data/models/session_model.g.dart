// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionModel _$SessionModelFromJson(Map<String, dynamic> json) =>
    _SessionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      kind: json['kind'] as String? ?? 'academic_year',
      startYear: (json['start_year'] as num?)?.toInt() ?? 0,
      term: json['term'] as String? ?? '',
    );

Map<String, dynamic> _$SessionModelToJson(_SessionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'kind': instance.kind,
      'start_year': instance.startYear,
      'term': instance.term,
    };
