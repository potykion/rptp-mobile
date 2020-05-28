import 'package:json_annotation/json_annotation.dart';
import 'package:rptpmobile/vk/video/models.dart';

part 'view_models.g.dart';

@JsonSerializable()
class VideoVM {
  final String preview;
  final String title;
  final String duration;
  final String url;

  VideoVM({this.preview, this.title, this.duration, this.url});

  factory VideoVM.fromVKVideo(VKVideo video) => VideoVM(
        title: video.title,
        duration: video.durationString,
        preview: video.imageMoreThan600px,
        url: video.url,
      );

  factory VideoVM.fromJson(Map<String, dynamic> json) =>
      _$VideoVMFromJson(json);

  Map<String, dynamic> toJson() => _$VideoVMToJson(this);
}
