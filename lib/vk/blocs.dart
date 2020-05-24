import 'package:bloc/bloc.dart';
import 'package:rptpmobile/vk/video/models.dart';

import 'core/models.dart';
import 'core/services.dart';
import 'video/services.dart';

class VKEvent {}

class VKAccessTokenSetEvent extends VKEvent {
  String accessToken;

  VKAccessTokenSetEvent(this.accessToken);
}

class VKVideoSearchStarted extends VKEvent {
  String query;

  VKVideoSearchStarted([this.query]);
}

class VideoQuerySetEvent extends VKEvent {
  String query;

  VideoQuerySetEvent(this.query);
}

enum LoadingStatus { started, finished }

class VKState {
  final String accessToken;
  final bool accessTokenExpired;
  final LoadingStatus loadingStatus;
  final String videoQuery;
  final List<VKVideo> videos;

  VKState({
    this.accessToken,
    this.videoQuery,
    this.videos = const [],
    this.loadingStatus = LoadingStatus.finished,
    this.accessTokenExpired = false,
  });

  get accessTokenValid => accessToken != null && !accessTokenExpired;

  get apiClient =>
      accessToken != null ? VKApiClient(accessToken: accessToken) : null;

  AdultVKVideoSearch get videoSearch => apiClient != null
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
      var videoQuery = event.query ?? state.videoQuery;
      if (videoQuery == null) {
        return;
      } else {
        yield state.copyWith(videoQuery: videoQuery);
      }

      if (!state.accessTokenValid) {
        return;
      }

      try {
        yield state.copyWith(loadingStatus: LoadingStatus.started);
        var videos = await state.videoSearch.search(videoQuery);
        yield state.copyWith(
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
