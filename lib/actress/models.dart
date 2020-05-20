import 'package:meta/meta.dart';

class Actress {
  final String name;
  final String ptgId;
  final String ptgLink;
  final String ptgThumbnail;

  Actress({
    @required this.name,
    @required this.ptgId,
    @required this.ptgLink,
    @required this.ptgThumbnail,
  });

  Actress copyWith({
    String name,
    String ptgId,
    String ptgLink,
    String ptgThumbnail,
  }) =>
      new Actress(
        name: name ?? this.name,
        ptgId: ptgId ?? this.ptgId,
        ptgLink: ptgLink ?? this.ptgLink,
        ptgThumbnail: ptgThumbnail ?? this.ptgThumbnail,
      );
}
