import 'package:kafe_app/models/gato_scores.dart';

import 'kafe_type.dart';

class KafePlant implements KafeType {
  final KafeType? kafeType;
  final DateTime? plantedAt;

  KafePlant({required this.kafeType, required this.plantedAt});

  bool isEmpty() {
    return kafeType?.isEmpty() ?? true && plantedAt == null;
  }

  factory KafePlant.empty() {
    return KafePlant(kafeType: KafeType.empty(), plantedAt: null);
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

  factory KafePlant.fromKafeType(KafeType kafeType) {
    return KafePlant(kafeType: kafeType, plantedAt: DateTime.now());
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

  KafePlant copyWith({
    String? name,
    Duration? growTime,
    int? costDeeVee,
    double? fruitWeight,
    GatoScores? gato,
    KafeType? kafeType,
    DateTime? plantedAt,
  }) {
    return KafePlant(
      kafeType:
          kafeType ??
          this.kafeType?.copyWith(
            name: name,
            growTime: growTime,
            costDeeVee: costDeeVee,
            fruitWeight: fruitWeight,
            gato: gato,
          ),
      plantedAt: plantedAt ?? this.plantedAt,
    );
  }

  DateTime get harvestTime {
    if (plantedAt == null || kafeType == null) return DateTime.now();
    return plantedAt!.add(growTime);
  }

  bool get isReadyForHarvest {
    if (plantedAt == null || kafeType == null) return false;
    return DateTime.now().isAfter(harvestTime);
  }

  Duration get remainingTime {
    if (plantedAt == null || kafeType == null) return Duration.zero;
    final remaining = harvestTime.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  double get growthProgress {
    if (plantedAt == null || kafeType == null) return 0.0;
    final elapsed = DateTime.now().difference(plantedAt!);
    return (elapsed.inSeconds / growTime.inSeconds).clamp(0.0, 1.0);
  }

  @override
  String get name => kafeType?.name ?? '';

  @override
  Duration get growTime => kafeType?.growTime ?? Duration.zero;

  @override
  int get costDeeVee => kafeType?.costDeeVee ?? 0;

  @override
  double get fruitWeight => kafeType?.fruitWeight ?? 0.0;

  @override
  GatoScores get gato => kafeType?.gato ?? GatoScores.empty();
}
