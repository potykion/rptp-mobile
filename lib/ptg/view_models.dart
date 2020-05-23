
import 'package:rptpmobile/actress/models.dart';

import '../core/string_extensions.dart';

class LetterProgress {
  final String letter;

  LetterProgress(this.letter);

  double get letterProgress => (alphabet.indexOf(letter) + 1) / alphabet.length;
}

class LetterActresses {
  final String letter;
  final List<Actress> actresses;

  LetterActresses(this.letter, this.actresses);
}

final List<String> alphabet = "abcdefghijklmnopqrstuvwxyz".asList();

