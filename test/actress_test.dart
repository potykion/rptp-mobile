import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:dotenv/dotenv.dart';
import 'package:rptpmobile/ptg.dart';

main() {
  test("PTG url with proxy", () {
    load();

    String ptgUrl = PTGUrl(
      "/debutyear/debut.html",
      withProxy: true,
      proxyKey: env['PROXY_KEY'],
    ).url;

    expect(
      ptgUrl,
      "https://potyk-simple-proxy.herokuapp.com/?url=http%3A%2F%2Fwww.pornteengirl.com%2Fdebutyear%2Fdebut.html&key=${env['PROXY_KEY']}",
    );
  });

  test("Test PTG parse", () async {
    var body = await File('test_data/ptg_debut_page.html').readAsString(
      encoding: Encoding.getByName("iso-8859-1"),
    );

    var actresses = PTGDebutPageParse(body).parsedActresses;
    var actressesDebutYears = actresses.map((a) => a.debutYear).toSet();

    expect(actressesDebutYears.reduce(max), 2018);
    expect(actressesDebutYears.reduce(min), 1990);
  });
}
