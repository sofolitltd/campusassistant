import 'package:freezed_annotation/freezed_annotation.dart';

part 'transport.freezed.dart';

@freezed
abstract class Transport with _$Transport {
  const factory Transport({
    required String id,
    required String title,
    required String image,
    required String time,
  }) = _Transport;
}
