import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import 'utils.dart';

part 'models.g.dart';

@JsonSerializable()
class VKVideoImage {
  int width;
  int height;
  String url;
  @JsonKey(fromJson: intToBool)
  bool withPadding;

  VKVideoImage({this.width, this.height, this.url, this.withPadding});

  factory VKVideoImage.fromJson(Map<String, dynamic> json) =>
      _$VKVideoImageFromJson(json);

  Map<String, dynamic> toJson() => _$VKVideoImageToJson(this);
}

@JsonSerializable()
class VKVideoLikes {
  int count;
  int userLikes;

  VKVideoLikes({this.count, this.userLikes});

  factory VKVideoLikes.fromJson(Map<String, dynamic> json) =>
      _$VKVideoLikesFromJson(json);

  Map<String, dynamic> toJson() => _$VKVideoLikesToJson(this);
}

/// https://vk.com/dev/objects/video
@JsonSerializable()
class VKVideo {
  int id;
  int ownerId;
  String title;
  String description;
  @JsonKey(name: "image")
  List<VKVideoImage> images;
  int duration;
  int views;
  VKVideoLikes likes;
  @JsonKey(fromJson: timestampToDateTime)
  DateTime date;
  int comments;
  @JsonKey(fromJson: intToBool)
  bool canAdd;

  VKVideo({
    this.id,
    this.ownerId,
    this.title,
    this.description,
    this.images,
    this.duration,
    this.views,
    this.likes,
    this.date,
    this.comments,
    this.canAdd,
  });

  factory VKVideo.fromJson(Map<String, dynamic> json) =>
      _$VKVideoFromJson(json);

  Map<String, dynamic> toJson() => _$VKVideoToJson(this);

  int get likesCount => likes.count;

  /// < 600px выглядит плохо на мобилке =>
  /// берем первое изображение > 600px или крайнее изображение
  String get imageMoreThan600px {
    var imagesMoreThan600 = images.where((i) => i.width > 600);
    return imagesMoreThan600.length > 0
        ? imagesMoreThan600.first.url
        : images.last.url;
  }

  String get url => "https://vk.com/video${ownerId}_${id}";

  DateTime get durationDatetime => DateTime(
        2020,
        1,
        1,
        duration ~/ 3600,
        duration % 3600 ~/ 60,
        duration % 3600 % 60,
      );

  String get durationString => DateFormat.Hms().format(durationDatetime);
}
