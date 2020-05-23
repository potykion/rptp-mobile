// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VKError _$VKErrorFromJson(Map<String, dynamic> json) {
  return VKError(
    code: json['error_code'] as int,
    message: json['error_msg'] as String,
  );
}

Map<String, dynamic> _$VKErrorToJson(VKError instance) => <String, dynamic>{
      'error_code': instance.code,
      'error_msg': instance.message,
    };
