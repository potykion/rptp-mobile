class Actress {
  final String name;
  final String ptgLink;
  final String ptgThumbnail;

  Actress({
    this.name,
    this.ptgLink,
    this.ptgThumbnail,
  });

  Actress copyWith({
    String name,
    String ptgLink,
    String ptgThumbnail,
  }) =>
      new Actress(
        name: name ?? this.name,
        ptgLink: ptgLink ?? this.ptgLink,
        ptgThumbnail: ptgThumbnail ?? this.ptgThumbnail,
      );
}
