import 'kafe_type.dart';

class KafePlant {
  final KafeType? kafeType;
  final DateTime? plantedAt;

  KafePlant({required this.kafeType, required this.plantedAt});

  /// Constructeur vide pour les plantes non initialisées
  factory KafePlant.empty() {
    return KafePlant(kafeType: null, plantedAt: null);
  }

  factory KafePlant.fromMap(Map<String, dynamic>? data) {
    if (data == null || data['cafeType'] == null || data['plantedAt'] == null) {
      return KafePlant.empty();
    }

    return KafePlant(
      kafeType: KafeType.fromMap(data['cafeType']),
      plantedAt: DateTime.tryParse(data['plantedAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    if (kafeType == null || plantedAt == null) {
      return {};
    }

    return {
      'cafeType': kafeType!.toMap(),
      'plantedAt': plantedAt!.toIso8601String(),
    };
  }

  KafePlant copyWith({KafeType? cafeType, DateTime? plantedAt}) {
    return KafePlant(
      kafeType: cafeType ?? this.kafeType,
      plantedAt: plantedAt ?? this.plantedAt,
    );
  }

  DateTime get harvestTime => plantedAt!.add(kafeType!.growTime);

  bool get isReadyForHarvest =>
      plantedAt != null && DateTime.now().isAfter(harvestTime);

  Duration get remainingTime {
    if (plantedAt == null || kafeType == null) return Duration.zero;
    final remaining = harvestTime.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  double get growthProgress {
    if (plantedAt == null || kafeType == null) return 0.0;
    final elapsed = DateTime.now().difference(plantedAt!);
    return (elapsed.inSeconds / kafeType!.growTime.inSeconds).clamp(0.0, 1.0);
  }

  bool get isEmpty => kafeType == null || plantedAt == null;
}
