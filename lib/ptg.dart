import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:html/parser.dart';
import 'actress.dart';
import 'string_extensions.dart';

/// PTG = http://www.pornteengirl.com/

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
        "/",
        {"url": urlToProxy, "key": proxyKey},
      ).toString();
}

/// Парс PTG debut-страницы: http://www.pornteengirl.com/debutyear/debut.html
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

/// Парс PTG thumb-страницы: http://www.pornteengirl.com/thumbs/thumbs-a.html
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

/// Загрузка содержимого PTG-страницы
abstract class PTGPageLoad {
  Future<String> load();
}

/// Загрузка содержимого PTG-страницы из файла
class FilePTGPageLoad extends PTGPageLoad {
  final String filePath;

  FilePTGPageLoad(this.filePath);

  @override
  Future<String> load() async => await File(this.filePath)
      .readAsString(encoding: Encoding.getByName("iso-8859-1"));
}

class LetterActresses {
  final String letter;
  final List<Actress> actresses;

  LetterActresses(this.letter, this.actresses);
}

/// Берет все thumb-страницы по алфавиту, грузит и парсит их по буквенным спискам
class AlphabetPTGActressLoad {
  final List<String> alphabet = "abcdefghijklmnopqrstuvwxyz".asList();

  final String proxyKey;
  final http.Client httpClient;

  AlphabetPTGActressLoad({this.proxyKey, httpClient})
      : this.httpClient = httpClient ?? http.Client();

  Stream<LetterActresses> get actressStream async* {
    for (var letter in alphabet) {
      var url = PTGUrl.thumbUrl(letter: letter, proxyKey: proxyKey).url;
      var pageBody = (await httpClient.get(url)).body;
      var actresses = PTGThumbPageParse(pageBody).parsedActresses;
      yield LetterActresses(letter, actresses);
    }
  }
}
