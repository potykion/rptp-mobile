import 'package:flutter_dotenv/flutter_dotenv.dart';

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

/// Парс ссылки с токеном
class VKAccessTokenParse {
  final String urlToParse;

  VKAccessTokenParse(this.urlToParse);

  get accessToken =>
      Uri.splitQueryString(Uri.parse(urlToParse).fragment)["access_token"];
}
