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
