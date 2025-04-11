import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kafe_app/logic/provider/user_provider.dart';
import 'package:kafe_app/models/kafe_type.dart';
import 'package:kafe_app/models/stocks.dart';

class StockProvider extends ChangeNotifier {
  final String userId;

  StockProvider({required this.userId});

  Future<Stocks?> getUserStock() async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('stocks')
              .doc('userStock')
              .get();

      if (doc.exists) {
        return Stocks.fromMap(doc.data()!);
      }
    } catch (e) {
      print("Get stock error: $e");
    }
    return null;
  }

  Future<void> addPlantToUserStock(KafeType plant) async {
    final stock = await getUserStock();
    if (stock != null) {
      final name = plant.name;
      final currentQty = stock.plantsQuantities[name] ?? 0;
      stock.plantsQuantities[name] = currentQty + 1;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('stocks')
          .doc('userStock')
          .update(stock.toMap());

      notifyListeners();
    }
  }

  Future<bool> hasGrain(KafeType plant) async {
    final stock = await getUserStock();
    if (stock == null) return false;

    final currentQty = stock.plantsQuantities[plant.name] ?? 0;
    return currentQty > 0;
  }

  Future<bool> removeGrain(KafeType plant) async {
    final stock = await getUserStock();
    if (stock != null) {
      final name = plant.name;
      final currentQty = stock.plantsQuantities[name] ?? 0;

      if (currentQty <= 0) return false;

      stock.plantsQuantities[name] = currentQty - 1;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('stocks')
          .doc('userStock')
          .update(stock.toMap());

      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> addRecolteToUserStock(KafeType plant) async {
    final stock = await getUserStock();
    if (stock != null) {
      final name = plant.name;
      final currentQty = stock.recolteQuantities[name] ?? 0;
      stock.recolteQuantities[name] = currentQty + 1;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('stocks')
          .doc('userStock')
          .update(stock.toMap());

      notifyListeners();
    }
  }
}

final stockProvider = ChangeNotifierProvider<StockProvider>((ref) {
  final user = ref.watch(userNotifier);
  if (user == null) throw Exception("User not logged in");
  return StockProvider(userId: user.id!);
});
