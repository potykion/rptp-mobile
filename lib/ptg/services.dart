class PTGActressIdParse {
  final String url;
  final bool proxy;

  PTGActressIdParse(this.url, {this.proxy = false});

  String get id {
    var uri = Uri.parse(this.url);
    var ptgUri = this.proxy ? Uri.parse(uri.queryParameters["url"]) : uri;
    var actressPage = ptgUri.pathSegments.last;
    var actressId = actressPage.substring(0, actressPage.length - ".html".length);
    return actressId;
  }
}