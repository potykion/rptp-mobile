import 'package:meta/meta.dart';
import 'package:rptpmobile/vk/core/services.dart';

import 'models.dart';

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

class AdultVKVideoSearch {
  VKVideoSearch videoSearch;

  AdultVKVideoSearch(this.videoSearch);

  Future<List<VKVideo>> search(String query) async =>
      (await videoSearch.search(query)).where((v) => !v.canAdd).toList();
}
