class Actress {
  String name;
  int debutYear;
  String ptgLink;

  Actress({
    this.name,
    this.debutYear,
    this.ptgLink,
  });

  Actress copyWith({
    String name,
    int debutYear,
    String ptgLink,
  }) {
    return new Actress(
      name: name ?? this.name,
      debutYear: debutYear ?? this.debutYear,
      ptgLink: ptgLink ?? this.ptgLink,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'debutYear': this.debutYear,
      'ptgLink': this.ptgLink,
    };
  }

  factory Actress.fromMap(Map<String, dynamic> map) {
    return new Actress(
      name: map['name'] as String,
      debutYear: map['debutYear'] as int,
      ptgLink: map['ptgLink'] as String,
    );
  }
}
