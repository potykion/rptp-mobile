// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vk.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VKVideoImage _$VKVideoImageFromJson(Map<String, dynamic> json) {
  return VKVideoImage(
    width: json['width'] as int,
    height: json['height'] as int,
    url: json['url'] as String,
    withPadding: intToBool(json['with_padding'] as int),
  );
}

Map<String, dynamic> _$VKVideoImageToJson(VKVideoImage instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'url': instance.url,
      'with_padding': instance.withPadding,
    };

VKVideoLikes _$VKVideoLikesFromJson(Map<String, dynamic> json) {
  return VKVideoLikes(
    count: json['count'] as int,
    userLikes: json['user_likes'] as int,
  );
}

Map<String, dynamic> _$VKVideoLikesToJson(VKVideoLikes instance) =>
    <String, dynamic>{
      'count': instance.count,
      'user_likes': instance.userLikes,
    };

VKVideo _$VKVideoFromJson(Map<String, dynamic> json) {
  return VKVideo(
    id: json['id'] as int,
    ownerId: json['owner_id'] as int,
    title: json['title'] as String,
    description: json['description'] as String,
    images: (json['image'] as List)
        ?.map((e) =>
            e == null ? null : VKVideoImage.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    duration: json['duration'] as int,
    views: json['views'] as int,
    likes: json['likes'] == null
        ? null
        : VKVideoLikes.fromJson(json['likes'] as Map<String, dynamic>),
    date: timestampToDateTime(json['date'] as int),
    comments: json['comments'] as int,
    canAdd: intToBool(json['can_add'] as int),
  );
}

Map<String, dynamic> _$VKVideoToJson(VKVideo instance) => <String, dynamic>{
      'id': instance.id,
      'owner_id': instance.ownerId,
      'title': instance.title,
      'description': instance.description,
      'image': instance.images,
      'duration': instance.duration,
      'views': instance.views,
      'likes': instance.likes,
      'date': instance.date?.toIso8601String(),
      'comments': instance.comments,
      'can_add': instance.canAdd,
    };
