import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'models.dart';

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
