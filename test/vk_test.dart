import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rptpmobile/vk.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group("vk робит", () {
    test("VKAuthUrl робит", () {
      expect(
        VKAuthUrl(clientId: "1488").url,
        "https://oauth.vk.com/authorize?client_id=1488&redirect_uri=https%3A%2F%2Foauth.vk.com%2Fblank.html&display=mobile&scope=video&response_type=token",
      );
    });

    test("VKAccessTokenParse робит", () {
      expect(
        VKAccessTokenParse(
                "https://oauth.vk.com/blank.html#access_token=4d63da13466b3cb399dca9cbb072eab6cfa7c54ba80622ec4bf91fcb29190fb9417dab58ff252679d5c2d&expires_in=86400&user_id=16231309")
            .accessToken,
        "4d63da13466b3cb399dca9cbb072eab6cfa7c54ba80622ec4bf91fcb29190fb9417dab58ff252679d5c2d",
      );
    });

    test("VKVideoSearch робит", () async {
      var mockUrl =
          "https://api.vk.com/method/video.search?access_token=sam&v=5.103&q=riley+reid&sort=0&hd=1&adult=1&count=200";
      var mockBody = await File('test_data/vk_videos.json').readAsString();
      var mockHttpClient = MockHttpClient();
      when(mockHttpClient.get(mockUrl)).thenAnswer(
        (_) async => http.Response(
          mockBody,
          200,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
          },
        ),
      );

      var videos = await VKVideoSearch(
        apiClient: VKApiClient(
          accessToken: "sam",
          httpClient: mockHttpClient,
        ),
      ).search("riley reid");

      expect(videos.first.url, "https://vk.com/video-49411171_456239097");
      expect(videos.first.imageMoreThan600px, "https://sun9-6.userapi.com/c840521/v840521507/27118/bmtXJx0FKTY.jpg");
      expect(videos.first.likesCount, 8344);
      expect(videos.first.date, DateTime(2017, 11, 24, 9, 48, 52));
      expect(videos.first.durationString, "00:27:44");

    });
  });
}
