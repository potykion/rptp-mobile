// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VKState _$VKStateFromJson(Map<String, dynamic> json) {
  return VKState(
    accessToken: json['access_token'] as String,
    videoQuery: json['video_query'] as String,
    videos: (json['videos'] as List)
        ?.map((e) =>
            e == null ? null : VideoVM.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    loadingStatus:
        _$enumDecodeNullable(_$LoadingStatusEnumMap, json['loading_status']),
    accessTokenExpired: json['access_token_expired'] as bool,
  );
}

Map<String, dynamic> _$VKStateToJson(VKState instance) => <String, dynamic>{
      'access_token': instance.accessToken,
      'access_token_expired': instance.accessTokenExpired,
      'loading_status': _$LoadingStatusEnumMap[instance.loadingStatus],
      'video_query': instance.videoQuery,
      'videos': instance.videos?.map((e) => e?.toJson())?.toList(),
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$LoadingStatusEnumMap = {
  LoadingStatus.started: 'started',
  LoadingStatus.finished: 'finished',
};
