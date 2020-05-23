import 'package:meta/meta.dart';

/// PTG-урл с возможность проксирования
class PTGUrl {
  final String path;
  final String proxyKey;

  PTGUrl(this.path, {this.proxyKey});

  String get url => this.proxyKey != null
      ? ProxyUrl(urlToProxy: _ptgUrl, proxyKey: proxyKey).url
      : _ptgUrl;

  String get _ptgUrl => Uri.http("www.pornteengirl.com", path).toString();

  factory PTGUrl.thumbUrl({String letter = "a", String proxyKey}) =>
      PTGUrl("/thumbs/thumbs-$letter.html", proxyKey: proxyKey);
}

/// Прокси-урл
/// Прокси осуществляется с помощью https://github.com/potykion/simple-proxy
class ProxyUrl {
  final String urlToProxy;
  final String proxyKey;

  ProxyUrl({@required this.urlToProxy, @required this.proxyKey});

  String get url => Uri.https(
        "potyk-simple-proxy.herokuapp.com",
        "/html",
        {"url": urlToProxy, "key": proxyKey},
      ).toString();
}