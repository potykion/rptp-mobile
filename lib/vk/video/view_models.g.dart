// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'view_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoVM _$VideoVMFromJson(Map json) {
  return VideoVM(
    preview: json['preview'] as String,
    title: json['title'] as String,
    duration: json['duration'] as String,
    url: json['url'] as String,
  );
}

Map<String, dynamic> _$VideoVMToJson(VideoVM instance) => <String, dynamic>{
      'preview': instance.preview,
      'title': instance.title,
      'duration': instance.duration,
      'url': instance.url,
    };
