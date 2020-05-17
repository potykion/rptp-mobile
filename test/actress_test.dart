import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:dotenv/dotenv.dart';
import 'package:rptpmobile/ptg.dart';

main() {
  test("PTG url with proxy", () {
    load();

    String ptgUrl = PTGUrl(
      "/debutyear/debut.html",
      proxyKey: env['PROXY_KEY'],
    ).url;

    expect(
      ptgUrl,
      "https://potyk-simple-proxy.herokuapp.com/?"
      "url=http%3A%2F%2Fwww.pornteengirl.com%2Fdebutyear%2Fdebut.html&"
      "key=${env['PROXY_KEY']}",
    );
  });

  test("Test PTG debut page parse", () async {
    var body = await FilePTGPageLoad('test_data/ptg_debut_page.html').load();

    var actresses = PTGDebutPageParse(body).parsedActresses;
    var actressesDebutYears = actresses.map((a) => a.debutYear).toSet();

    expect(actressesDebutYears.reduce(max), 2018);
    expect(actressesDebutYears.reduce(min), 1990);
  });

  test("PTG thumbs page parse", () async {
    var body = await FilePTGPageLoad('test_data/ptg_thumbs_a.html').load();

    var actresses = PTGThumbPageParse(body).parsedActresses;

    expect(actresses.length, 725);
  });
}
