class Stocks {
  final String kafeType;
  final double grainWeight;

  Stocks({required this.kafeType, required this.grainWeight});

  factory Stocks.fromMap(Map<String, dynamic> data) {
    return Stocks(
      kafeType: data['cafeType'],
      grainWeight: (data['grainWeight'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'cafeType': kafeType, 'grainWeight': grainWeight};
  }

  Stocks copyWith({String? cafeType, double? grainWeight}) {
    return Stocks(
      kafeType: cafeType ?? this.kafeType,
      grainWeight: grainWeight ?? this.grainWeight,
    );
  }
}
