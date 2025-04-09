class GatoScores {
  final int gout;
  final int amertume;
  final int teneur;
  final int odorat;

  GatoScores({
    required this.gout,
    required this.amertume,
    required this.teneur,
    required this.odorat,
  });

  static GatoScores empty() {
    return GatoScores(gout: 0, amertume: 0, teneur: 0, odorat: 0);
  }

  factory GatoScores.fromMap(Map<String, dynamic> data) {
    return GatoScores(
      gout: data['gout'] ?? 0,
      amertume: data['amertume'] ?? 0,
      teneur: data['teneur'] ?? 0,
      odorat: data['odorat'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gout': gout,
      'amertume': amertume,
      'teneur': teneur,
      'odorat': odorat,
    };
  }

  GatoScores copyWith({int? gout, int? amertume, int? teneur, int? odorat}) {
    return GatoScores(
      gout: gout ?? this.gout,
      amertume: amertume ?? this.amertume,
      teneur: teneur ?? this.teneur,
      odorat: odorat ?? this.odorat,
    );
  }
}
