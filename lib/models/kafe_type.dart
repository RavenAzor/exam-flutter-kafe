import 'gato_scores.dart';

class KafeType {
  final String name;
  final Duration growTime;
  final int costDeeVee;
  final double fruitWeight;
  final GatoScores gato;

  KafeType({
    required this.name,
    required this.growTime,
    required this.costDeeVee,
    required this.fruitWeight,
    required this.gato,
  });

  bool isEmpty() {
    return name.isEmpty;
  }

  static KafeType empty() {
    return KafeType(
      name: 'Unknown',
      growTime: Duration(minutes: 1),
      costDeeVee: 1,
      fruitWeight: 0.0,
      gato: GatoScores.empty(),
    );
  }

  factory KafeType.fromMap(Map<String, dynamic> data) {
    return KafeType(
      name: data['name'],
      growTime: Duration(minutes: data['growTime'] ?? 1),
      costDeeVee: data['costDeeVee'] ?? 1,
      fruitWeight: (data['fruitWeight'] ?? 0.0).toDouble(),
      gato: GatoScores.fromMap(data['gato']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'growTime': growTime.inMinutes,
      'costDeeVee': costDeeVee,
      'fruitWeight': fruitWeight,
      'gato': gato.toMap(),
    };
  }

  KafeType copyWith({
    String? name,
    Duration? growTime,
    int? costDeeVee,
    double? fruitWeight,
    GatoScores? gato,
  }) {
    return KafeType(
      name: name ?? this.name,
      growTime: growTime ?? this.growTime,
      costDeeVee: costDeeVee ?? this.costDeeVee,
      fruitWeight: fruitWeight ?? this.fruitWeight,
      gato: gato ?? this.gato,
    );
  }
}
