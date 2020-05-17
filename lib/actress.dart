class Actress {
  final String name;
  final int debutYear;
  final String ptgLink;
  final String ptgThumbnail;

  Actress({
    this.name,
    this.debutYear,
    this.ptgLink,
    this.ptgThumbnail,
  });

  Actress copyWith({
    String name,
    int debutYear,
    String ptgLink,
    String ptgThumbnail,
  }) =>
      new Actress(
        name: name ?? this.name,
        debutYear: debutYear ?? this.debutYear,
        ptgLink: ptgLink ?? this.ptgLink,
        ptgThumbnail: ptgThumbnail ?? this.ptgThumbnail,
      );
}
