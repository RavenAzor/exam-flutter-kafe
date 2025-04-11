import 'package:kafe_app/models/kafe_type.dart';

class Stocks {
  final String kafeType;
  double grainWeight;
  Map<String, int> plantsQuantities;
  Map<String, int> recolteQuantities;

  Stocks({
    required this.kafeType,
    required this.grainWeight,
    Map<String, int>? plantsQuantities,
    Map<String, int>? recolteQuantities,
  }) : plantsQuantities = plantsQuantities ?? {},
       recolteQuantities = recolteQuantities ?? {};

  void removePlant(KafeType plant) {
    if (plantsQuantities.containsKey(plant.name) &&
        plantsQuantities[plant.name]! > 0) {
      plantsQuantities.update(
        plant.name,
        (value) => value - 1,
        ifAbsent: () => 0,
      );
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'kafeType': kafeType,
      'grainWeight': grainWeight,
      'plantsQuantities': plantsQuantities,
      'recolteQuantities': recolteQuantities,
    };
  }

  factory Stocks.fromMap(Map<String, dynamic> map) {
    return Stocks(
      kafeType: map['kafeType'] ?? '',
      grainWeight: (map['grainWeight'] ?? 0).toDouble(),
      plantsQuantities: Map<String, int>.from(map['plantsQuantities'] ?? {}),
      recolteQuantities: Map<String, int>.from(map['recolteQuantities'] ?? {}),
    );
  }

  Stocks copyWith({
    String? kafeType,
    double? grainWeight,
    Map<String, int>? plantsQuantities,
    Map<String, int>? recolteQuantities,
  }) {
    return Stocks(
      kafeType: kafeType ?? this.kafeType,
      grainWeight: grainWeight ?? this.grainWeight,
      plantsQuantities: plantsQuantities ?? this.plantsQuantities,
      recolteQuantities: recolteQuantities ?? this.recolteQuantities,
    );
  }
}
