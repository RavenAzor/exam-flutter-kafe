import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kafe_app/data/kafe_plants_data.dart';
import 'package:kafe_app/models/field.dart';
import 'package:kafe_app/logic/provider/exploitation_provider.dart';
import 'package:kafe_app/models/gato_scores.dart';
import 'package:kafe_app/models/kafe_type.dart';

import '../../constants/constants.dart';
import '../../logic/provider/user_provider.dart';
import '../../models/kafe_plant.dart';
import '../../models/stocks.dart';

class StocksView extends ConsumerStatefulWidget {
  const StocksView({super.key});

  @override
  _StocksViewState createState() => _StocksViewState();
}

class _StocksViewState extends ConsumerState<StocksView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 1.0),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: colorTitle(),
              foregroundColor: backgroundItemsColor(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () {
              _showBoutiqueModal(context, ref);
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.construction, size: 20),
                SizedBox(width: 8),
                Text('Assemblage'),
              ],
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.green,
          tabs: const [
            Tab(text: "Graines"),
            Tab(text: "Récolte"),
            Tab(text: "Assemblage"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Consumer(
              builder: (context, ref, _) {
                final user = ref.watch(userNotifier);

                if (user == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                return FutureBuilder(
                  future: ref
                      .read(userNotifier.notifier)
                      .getUserStock(user.id!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(
                        child: Text("Aucune plante en stock."),
                      );
                    }

                    final stock = snapshot.data!;
                    final allPlants = getKafePlants();

                    final plantEntries =
                        stock.plantsQuantities.entries.map((entry) {
                          final plant = allPlants.firstWhere(
                            (p) => p.name == entry.key,
                            orElse: () => KafePlant.empty(),
                          );
                          return MapEntry(plant, entry.value);
                        }).toList();

                    if (plantEntries.isEmpty) {
                      return const Center(
                        child: Text("Aucune plante en stock."),
                      );
                    }

                    return GridView.builder(
                      itemCount: plantEntries.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1,
                          ),
                      itemBuilder: (context, index) {
                        final entry = plantEntries[index];
                        final plant = entry.key;
                        final quantity = entry.value;

                        return GestureDetector(
                          onTap: () {
                            _showPlantDialog(context, plant, quantity);
                          },
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: colorOfText(),
                                    width: 2,
                                  ),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                      'assets/images/grain.png',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    "${plant.name}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: colorOfTextBlack(),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Center(
                                child: Icon(
                                  Icons.add,
                                  size: 48,
                                  color: colorOfTextBlack(),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          const Center(
            child: Text(
              "Bientôt",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const Center(
            child: Text(
              "Bientôt",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

void _showBoutiqueModal(BuildContext context, WidgetRef ref) {
  final plants = getKafePlants();
  final fieldCount = 0;

  List<Map<String, dynamic>> boutiqueItems = [
    {
      'type': 'field',
      'name': 'Champ',
      'cost': 15,
      'icon': Icons.agriculture,
      'field': Field(
        name: generateFieldName(fieldCount + 1),
        plants: List.generate(4, (_) => KafePlant.empty()),
        speciality: FieldSpecialityExtension.getRandom(),
      ),
    },
    ...plants
        .map(
          (plant) => {
            'type': 'plante',
            'name': plant.name,
            'cost': plant.costDeeVee,
            'icon': Icons.eco,
            'kafeType': plant,
          },
        )
        .toList(),
  ];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
        content: SizedBox(
          width: 350,
          height: 400,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children:
                        boutiqueItems.map((item) {
                          return Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.0,
                                ),
                                leading: Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Icon(item['icon'], size: 40),
                                ),
                                title: Text(
                                  item['name'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Coût: ${item['cost']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.add_shopping_cart,
                                    size: 30,
                                    color: Colors.green,
                                  ),
                                  onPressed: () async {
                                    final user = ref.read(userNotifier);

                                    if (item['type'] == 'field') {
                                      await ref
                                          .read(exploitationNotifier.notifier)
                                          .addFieldToExploitation(
                                            item['field'],
                                          );
                                    } else if (item['type'] == 'plante') {
                                      ref
                                          .read(userNotifier.notifier)
                                          .addPlantToUserStock(
                                            item['kafeType'],
                                          );
                                    }

                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              Divider(thickness: 1),
                            ],
                          );
                        }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Fermer'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Génère un nom pour le champ secondaire, basé sur le nombre de champs existants
String generateFieldName(int fieldCount) {
  return 'Champ secondaire $fieldCount';
}

// Fonction pour obtenir une spécialité aléatoire
FieldSpeciality getRandomSpeciality() {
  List<FieldSpeciality> specialities = FieldSpeciality.values;

  Random random = Random();
  return specialities[random.nextInt(specialities.length)];
}

// Fonction pour afficher la modale de détail du champ
void _showPlantDialog(BuildContext context, KafeType plant, int quantity) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: backgroundItemsColor(),
        title: Center(
          child: Text(
            "${plant.name}",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colorTitle(),
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.warehouse, color: colorOfText()),
                  SizedBox(width: 8),
                  Text(
                    "Quantité en stock : $quantity",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.access_time, color: colorOfText()),
                  SizedBox(width: 8),
                  Text(
                    "Temps de pousse : ${plant.growTime.inMinutes} minutes",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.scale, color: colorOfText()),
                  SizedBox(width: 8),
                  Text(
                    "Poids du fruit : ${plant.fruitWeight.toStringAsFixed(3)} kg",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Score G.A.T.O.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorTitle(),
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Icon(
                          Icons.sentiment_satisfied_alt,
                          color: colorOfText(),
                        ), // Goût
                        SizedBox(width: 8),
                        Text(
                          "Goût : ${plant.gato.gout}",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Icon(
                          Icons.sentiment_very_dissatisfied,
                          color: colorOfText(),
                        ), // Amertume
                        SizedBox(width: 8),
                        Text(
                          "Amertume : ${plant.gato.amertume}",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Icon(Icons.equalizer, color: colorOfText()),
                        SizedBox(width: 8),
                        Text(
                          "Teneur : ${plant.gato.teneur}",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Icon(Icons.air, color: colorOfText()),
                        SizedBox(width: 8),
                        Text(
                          "Odorat : ${plant.gato.odorat}",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "Fermer",
              style: TextStyle(fontSize: 18, color: colorTitle()),
            ),
          ),
        ],
      );
    },
  );
}

String _specialityToString(FieldSpeciality speciality) {
  switch (speciality) {
    case FieldSpeciality.rendementX2:
      return "Rendement x2";
    case FieldSpeciality.tempsDivPar2:
      return "Temps / 2";
    case FieldSpeciality.neutre:
    default:
      return "Neutre";
  }
}
