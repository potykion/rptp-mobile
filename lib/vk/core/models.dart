import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable()
class VKError implements Exception {
  @JsonKey(name: "error_code")
  int code;
  @JsonKey(name: "error_msg")
  String message;

  VKError({this.code, this.message});

  factory VKError.fromJson(Map<String, dynamic> json) =>
      _$VKErrorFromJson(json);

  Map<String, dynamic> toJson() => _$VKErrorToJson(this);

  get isTokenExpired => code == 5;

  @override
  String toString() => this.message;
}
