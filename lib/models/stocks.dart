import 'package:kafe_app/models/kafe_type.dart';

class Stocks {
  final String kafeType;
  double grainWeight;
  Map<String, int> plantsQuantities;

  Stocks({
    required this.kafeType,
    required this.grainWeight,
    Map<String, int>? plantsQuantities,
  }) : plantsQuantities = plantsQuantities ?? {};

  void addPlant(KafeType plant) {
    plantsQuantities.update(
      plant.name,
      (value) => value + 1,
      ifAbsent: () => 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'kafeType': kafeType,
      'grainWeight': grainWeight,
      'plantsQuantities': plantsQuantities,
    };
  }

  factory Stocks.fromMap(Map<String, dynamic> map) {
    return Stocks(
      kafeType: map['kafeType'] ?? '',
      grainWeight: (map['grainWeight'] ?? 0).toDouble(),
      plantsQuantities: Map<String, int>.from(map['plantsQuantities'] ?? {}),
    );
  }
}
