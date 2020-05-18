import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ui_bloc.dart';

part 'vk.g.dart';

/// Авторизация VK API
/// https://vk.com/dev/implicit_flow_user
class VKAuth {
  VKAuthUrl vkAuthUrl;

  VKAuth({vkAuthUrl}) : this.vkAuthUrl = vkAuthUrl ?? VKAuthUrl();

  /// Ссылка на авторизацию
  get authUrl => VKAuthUrl().url;

  /// Получение access-токена из урла
  tryParseToken(String urlWithToken) =>
      VKAccessTokenParse(urlWithToken).accessToken;
}

/// Ссылка на авторизацию
/// https://vk.com/dev/implicit_flow_user
class VKAuthUrl {
  String clientId;
  String redirectUri = "https://oauth.vk.com/blank.html";
  String display = "mobile";
  String scope = "video";
  String responseType = "token";

  VKAuthUrl({clientId}) : this.clientId = clientId ?? DotEnv().env['VK_APP_ID'];

  get url {
    var params = {
      "client_id": clientId,
      "redirect_uri": redirectUri,
      "display": display,
      "scope": scope,
      "response_type": responseType,
    };
    var uri = Uri.https("oauth.vk.com", "/authorize", params).toString();
    return uri;
  }
}

class VKAccessTokenParse {
  final String urlToParse;

  VKAccessTokenParse(this.urlToParse);

  get accessToken =>
      Uri.splitQueryString(Uri.parse(urlToParse).fragment)["access_token"];
}

class VKAuthPage extends StatefulWidget {
  final VKAuth auth;

  VKAuthPage({auth}) : this.auth = auth ?? VKAuth();

  @override
  _VKAuthPageState createState() => _VKAuthPageState();
}

class _VKAuthPageState extends State<VKAuthPage> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.onUrlChanged.listen((String url) async {
      var accessToken = widget.auth.tryParseToken(url);
      if (accessToken != null) {
        Navigator.pop(context, accessToken);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    flutterWebviewPlugin.close();
  }

  @override
  Widget build(BuildContext context) =>
      WebviewScaffold(url: widget.auth.authUrl);
}

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

class VKApiClient {
  /// Токен
  /// https://vk.com/dev/first_guide
  String accessToken;

  /// Версия
  String version = "5.103";

  http.Client httpClient;

  VKApiClient({@required this.accessToken, httpClient})
      : this.httpClient = httpClient ?? http.Client();

  Future<Map<String, dynamic>> makeGetRequest(
      String method, Map<String, String> params) async {
    var url = Uri.https(
      "api.vk.com",
      "/method/$method",
      {"access_token": accessToken, "v": version}..addAll(params),
    ).toString();
    var resp = await httpClient.get(url);
    Map<String, dynamic> jsonResp = jsonDecode(resp.body);
    if (jsonResp.containsKey("error")) {
      throw VKError.fromJson(jsonResp["error"]);
    }
    return jsonResp;
  }
}

/// Ищет видео в ВК
/// https://vk.com/dev/video.search
class VKVideoSearch {
  VKApiClient apiClient;

  /// Сортировка результатов. Возможные значения:
  ///   - 0 — по дате добавления видеозаписи;
  ///   - 1 — по длительности;
  ///   - 2 — по релевантности
  int sort = 0;

  /// Если не равен нулю, то поиск производится только по видеозаписям высокого качества.
  int hd = 1;

  /// Фильтр «Безопасный поиск». Возможные значения:
  ///   - 1 — выключен;
  ///   - 0 — включен.
  int adult = 1;

  /// Список критериев (список слов, разделенных через запятую), по которым требуется отфильтровать видео:
  ///   - mp4 — искать только видео в формате mp4 (воспроизводимое на iOS);
  ///   - youtube — возвращать только youtube видео;
  ///   - vimeo — возвращать только vimeo видео;
  ///   - short — возвращать только короткие видеозаписи;
  ///   - long — возвращать только длинные видеозаписи
  // String filters = "";
  /// 1 — искать по видеозаписям пользователя, 0 — не искать по видеозаписям пользователя. По умолчанию: 0.
  // search_own
  /// Смещение относительно первой найденной видеозаписи для выборки определенного подмножества.
  //  offset
  /// Количество секунд, видеозаписи длиннее которого необходимо вернуть.
  // longer
  /// Количество секунд, видеозаписи короче которого необходимо вернуть.
  // shorter
  /// Количество возвращаемых видеозаписей - по умолчанию 20, максимальное значение 200
  /// Обратите внимание — даже при использовании параметра offset для получения информации доступны только первые 1000 результатов.
  int count = 200;

  /// 1 — в ответе будут возвращены дополнительные поля profiles и groups,
  /// содержащие информацию о пользователях и сообществах. По умолчанию: 0.
  //  extended

  VKVideoSearch({
    @required this.apiClient,
  });

  Future<List<VKVideo>> search(String query) async {
    var videosResp = await apiClient.makeGetRequest(
      "video.search",
      {
        "q": query,
        "sort": sort.toString(),
        "hd": hd.toString(),
        "adult": adult.toString(),
        "count": count.toString(),
      },
    );
    List videosJson = videosResp["response"]["items"];
    var videos = videosJson.map((v) => VKVideo.fromJson(v)).toList();
    return videos;
  }
}

intToBool(int int_) => int_ == 1;

timestampToDateTime(int timestamp) =>
    DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

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

class AdultVKVideoSearch {
  VKVideoSearch videoSearch;

  AdultVKVideoSearch(this.videoSearch);

  Future<List<VKVideo>> search(String query) async =>
      (await videoSearch.search(query)).where((v) => !v.canAdd).toList();
}

class VKEvent {}

class VKAccessTokenSetEvent extends VKEvent {
  String accessToken;

  VKAccessTokenSetEvent(this.accessToken);
}

class VKVideoSearchStarted extends VKEvent {
  String query;

  VKVideoSearchStarted(this.query);
}

enum LoadingStatus { started, finished }

class VKState {
  String accessToken;
  bool accessTokenExpired;

  LoadingStatus loadingStatus;
  String videoQuery;
  List<VKVideo> videos;

  VKState({
    this.accessToken,
    this.videoQuery = "riley reid",
    this.videos = const [],
    this.loadingStatus = LoadingStatus.finished,
    this.accessTokenExpired = false,
  });

  get accessTokenValid => accessToken != null && !accessTokenExpired;

  get apiClient =>
      accessToken != null ? VKApiClient(accessToken: accessToken) : null;

  get videoSearch => apiClient != null
      ? AdultVKVideoSearch(VKVideoSearch(apiClient: apiClient))
      : null;

  copyWith({
    accessToken,
    videoQuery,
    videos,
    loadingStatus,
    accessTokenExpired,
  }) =>
      VKState(
        accessToken: accessToken ?? this.accessToken,
        videoQuery: videoQuery ?? this.videoQuery,
        videos: videos ?? this.videos,
        loadingStatus: loadingStatus ?? this.loadingStatus,
        accessTokenExpired: accessTokenExpired ?? this.accessTokenExpired,
      );
}

class VKBloc extends Bloc<VKEvent, VKState> {
  @override
  VKState get initialState => VKState();

  @override
  Stream<VKState> mapEventToState(VKEvent event) async* {
    if (event is VKAccessTokenSetEvent) {
      yield state.copyWith(
        accessToken: event.accessToken,
        accessTokenExpired: false,
      );
    } else if (event is VKVideoSearchStarted) {
      yield state.copyWith(
        loadingStatus: LoadingStatus.started,
      );
      try {
        var videos = await state.videoSearch.search(event.query);
        yield state.copyWith(
          videoQuery: event.query,
          videos: videos,
          loadingStatus: LoadingStatus.finished,
        );
      } on VKError catch (e) {
        if (e.isTokenExpired) {
          yield state.copyWith(
            loadingStatus: LoadingStatus.finished,
            accessTokenExpired: true,
          );
        }
      }
    }
  }
}

class VKVideoCard extends StatelessWidget {
  final VKVideo video;

  VKVideoCard({@required this.video});

  @override
  Widget build(BuildContext context) => Card(
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              BlocBuilder<UIBloc, UIState>(
                builder: (_, state) => state.kittenPreview
                    ? Image.asset("assets/kitten1.jpg")
                    : Image.network(video.imageMoreThan600px, fit: BoxFit.fill),
              ),
              Positioned(
                child: Chip(label: Text(video.durationString)),
                bottom: 0,
                right: 5,
              )
            ],
          ),
          onTap: () => launch(video.url),
        ),
      );
}

class VKVideoQueryInput extends StatefulWidget {
  final String initialQuery;

  const VKVideoQueryInput({Key key, this.initialQuery}) : super(key: key);

  @override
  _VKVideoQueryInputState createState() => _VKVideoQueryInputState();
}

class _VKVideoQueryInputState extends State<VKVideoQueryInput> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.initialQuery;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              context.bloc<VKBloc>().add(VKVideoSearchStarted(controller.text));
              FocusScope.of(context).requestFocus(new FocusNode());
            },
          )),
    );
  }
}
