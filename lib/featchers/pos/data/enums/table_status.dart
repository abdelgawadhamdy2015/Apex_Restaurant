import 'package:json_annotation/json_annotation.dart';

@JsonEnum(alwaysCreate: true)
enum TableStatus {
  @JsonValue(0)
  unAvailable,
  @JsonValue(1)
  available,

  @JsonValue(2)
  occupied,

  @JsonValue(3)
  reserved,

  @JsonValue(4)
  maintenance,
}
