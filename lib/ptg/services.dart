import 'dart:convert';
import 'dart:io';

import 'package:html/parser.dart';
import 'package:rptpmobile/actress/models.dart';
import 'package:http/http.dart' as http;
import 'package:rptpmobile/ptg/view_models.dart';

import 'models.dart';

/// PTG = http://www.pornteengirl.com/

class PTGActressIdParse {
  final String url;
  final bool proxy;

  PTGActressIdParse(this.url, {this.proxy = false});

  String get id {
    var uri = Uri.parse(this.url);
    var ptgUri = this.proxy ? Uri.parse(uri.queryParameters["url"]) : uri;
    var actressPage = ptgUri.pathSegments.last;
    var actressId =
        actressPage.substring(0, actressPage.length - ".html".length);
    return actressId;
  }
}

/// Парс PTG thumb-страницы: http://www.pornteengirl.com/thumbs/thumbs-a.html
class PTGThumbPageParse {
  final String pageContent;
  final bool proxy;

  PTGThumbPageParse(this.pageContent, {this.proxy = false});

  List<Actress> get parsedActresses => parse(this.pageContent)
          .getElementById("updatedvd")
          .getElementsByClassName("search")
          .map((e) => e.getElementsByTagName("td").first)
          .map(
        (e) {
          var ptgLink = e.getElementsByTagName("a").first.attributes["href"];
          var ptgThumbnail =
              e.getElementsByTagName("img").first.attributes["src"];
          var ptgId = PTGActressIdParse(ptgLink, proxy: proxy).id;

          return Actress(
            name: e.text,
            ptgLink: ptgLink,
            ptgThumbnail: ptgThumbnail,
            ptgId: ptgId,
          );
        },
      ).toList();
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

/// Берет все thumb-страницы по алфавиту, грузит и парсит их по буквенным спискам
class AlphabetPTGActressLoad {
  final String proxyKey;
  final http.Client httpClient;

  AlphabetPTGActressLoad({this.proxyKey, httpClient})
      : this.httpClient = httpClient ?? http.Client();

  Stream<LetterActresses> get actressStream async* {
    for (var letter in alphabet) {
      var url = PTGUrl.thumbUrl(letter: letter, proxyKey: proxyKey).url;
      var pageBody = (await httpClient.get(url)).body;
      var actresses =
          PTGThumbPageParse(pageBody, proxy: proxyKey != null).parsedActresses;
      yield LetterActresses(letter, actresses);
    }
  }
}
