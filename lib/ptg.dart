import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:html/parser.dart';
import 'actress.dart';

class PTGUrl {
  final String path;
  final bool withProxy;
  final String proxyKey;

  PTGUrl(this.path, {this.withProxy = false, this.proxyKey});

  String get url => withProxy
      ? ProxyUrl(urlToProxy: _ptgUrl, proxyKey: proxyKey).url
      : _ptgUrl;

  String get _ptgUrl => Uri.http("www.pornteengirl.com", path).toString();
}

class ProxyUrl {
  final String urlToProxy;
  final String proxyKey;

  ProxyUrl({@required this.urlToProxy, @required this.proxyKey});

  String get url => Uri.https(
        "potyk-simple-proxy.herokuapp.com",
        "/",
        {"url": urlToProxy, "key": proxyKey},
      ).toString();
}

class PTGDebutPageParse {
  final String pageContent;

  PTGDebutPageParse(this.pageContent);

  List<Actress> get parsedActresses => parse(this.pageContent)
      .getElementById("debut")
      .getElementsByTagName("tbody")
      .expand(
        (row) => row.getElementsByTagName("a").map(
              (link) => Actress(
                name: link.text,
                debutYear: int.parse(row.getElementsByTagName("th").first.text),
                ptgLink: PTGUrl(link.attributes["href"]).url,
              ),
            ),
      )
      .toList();
}

class PTGThumbPageParse {
  final String pageContent;

  PTGThumbPageParse(this.pageContent);

  List<Actress> get parsedActresses => parse(this.pageContent)
      .getElementById("updatedvd")
      .getElementsByClassName("search")
      .map((e) => e.getElementsByTagName("td").first)
      .map(
        (e) => Actress(
          name: e.text,
          ptgLink: e.getElementsByTagName("a").first.attributes["href"],
          ptgThumbnail: e.getElementsByTagName("img").first.attributes["src"],
        ),
      )
      .toList();
}

abstract class PTGPageLoad {
  Future<String> load();
}

class FilePTGPageLoad extends PTGPageLoad {
  final String filePath;

  FilePTGPageLoad(this.filePath);

  @override
  Future<String> load() async => await File(this.filePath)
      .readAsString(encoding: Encoding.getByName("iso-8859-1"));
}

class WebPTGPageLoad extends PTGPageLoad {
  final String path;
  final String proxyKey;
  final http.Client httpClient;

  WebPTGPageLoad(this.path, {this.proxyKey, httpClient})
      : this.httpClient = httpClient ?? http.Client();

  String get url => PTGUrl(
        this.path,
        withProxy: this.proxyKey != null,
        proxyKey: this.proxyKey,
      ).url;

  @override
  Future<String> load() async => (await httpClient.get(url)).body;
}
