extension StringAsList on String {
  /// Конвертит строку в список символов
  /// https://stackoverflow.com/a/18883818/5500609
  List<String> asList() =>
      this.runes.map((charCode) => String.fromCharCode(charCode)).toList();
}
