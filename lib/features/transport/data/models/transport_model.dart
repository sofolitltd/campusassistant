import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/transport.dart';

part 'transport_model.freezed.dart';
part 'transport_model.g.dart';

@freezed
abstract class TransportModel with _$TransportModel {
  const TransportModel._();

  const factory TransportModel({
    required String id,
    required String title,
    required String image,
    required String time,
  }) = _TransportModel;

  factory TransportModel.fromJson(Map<String, dynamic> json) =>
      _$TransportModelFromJson(json);

  Transport toEntity() => Transport(
        id: id,
        title: title,
        image: image,
        time: time,
      );

  factory TransportModel.fromEntity(Transport transport) => TransportModel(
        id: transport.id,
        title: transport.title,
        image: transport.image,
        time: transport.time,
      );
}
