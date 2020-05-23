import 'package:flutter_test/flutter_test.dart';
import 'package:dotenv/dotenv.dart';
import 'package:rptpmobile/ptg/models.dart';
import 'package:rptpmobile/ptg/services.dart';

main() {
  test("PTG url with proxy", () {
    load();

    String ptgUrl = PTGUrl(
      "/debutyear/debut.html",
      proxyKey: env['PTG_PROXY_KEY'],
    ).url;

    expect(
      ptgUrl,
      "https://potyk-simple-proxy.herokuapp.com/html?"
      "url=http%3A%2F%2Fwww.pornteengirl.com%2Fdebutyear%2Fdebut.html&"
      "key=${env['PTG_PROXY_KEY']}",
    );
  });

  test("PTG thumbs page parse", () async {
    var body = await FilePTGPageLoad('test_data/ptg_thumbs_a.html').load();

    var actresses = PTGThumbPageParse(body, proxy: true).parsedActresses;

    expect(actresses.length, 725);
  });

  test("PTG actress id parse from proxy url", () async {
    var url = "https://potyk-simple-proxy.herokuapp.com/?key=jknjknkjnjknsfcsdf&url=http%3A%2F%2Fwww.pornteengirl.com%2Fmodel%2Faaliyah.html";
    var id = PTGActressIdParse(url, proxy: true).id;
    expect(id, "aaliyah");

    url = "http://www.pornteengirl.com/model/aaliyah.html";
    id = PTGActressIdParse(url, proxy: false).id;
    expect(id, "aaliyah");
  });
}
