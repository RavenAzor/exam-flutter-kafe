import 'package:kafe_app/models/kafe_type.dart';
import 'package:kafe_app/models/gato_scores.dart';

List<KafeType> getKafePlants() {
  return [
    KafeType(
      name: 'Rubisca',
      growTime: Duration(minutes: 1),
      costDeeVee: 2,
      fruitWeight: 0.632,
      gato: GatoScores(gout: 15, amertume: 54, teneur: 35, odorat: 19),
    ),
    KafeType(
      name: 'Arbrista',
      growTime: Duration(minutes: 4),
      costDeeVee: 6,
      fruitWeight: 0.274,
      gato: GatoScores(gout: 87, amertume: 4, teneur: 35, odorat: 59),
    ),
    KafeType(
      name: 'Roupetta',
      growTime: Duration(minutes: 2),
      costDeeVee: 3,
      fruitWeight: 0.461,
      gato: GatoScores(gout: 35, amertume: 41, teneur: 75, odorat: 67),
    ),
    KafeType(
      name: 'Tourista',
      growTime: Duration(minutes: 1),
      costDeeVee: 1,
      fruitWeight: 0.961,
      gato: GatoScores(gout: 3, amertume: 91, teneur: 74, odorat: 6),
    ),
    KafeType(
      name: 'Goldoria',
      growTime: Duration(minutes: 3),
      costDeeVee: 2,
      fruitWeight: 0.473,
      gato: GatoScores(gout: 39, amertume: 9, teneur: 7, odorat: 87),
    ),
  ];
}

KafeType getKafeTypeByName(String name) {
  final List<KafeType> allKafeTypes = getKafePlants();
  return allKafeTypes.firstWhere(
    (type) => type.name == name,
    orElse: () => KafeType.empty(),
  );
}
