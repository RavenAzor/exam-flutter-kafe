import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kafe_app/models/user.dart' as app;
import 'package:kafe_app/logic/provider/firebase_auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kafe_app/logic/provider/exploitation_provider.dart';

import '../../models/exploitation.dart';
import '../../models/field.dart';
import '../../models/kafe_type.dart';
import '../../models/stocks.dart';

final userNotifier = StateNotifierProvider<UserProvider, app.User?>(
  (ref) => UserProvider(ref),
);

class UserProvider extends StateNotifier<app.User?> {
  final Ref ref;
  UserProvider(this.ref) : super(null);

  Future<app.User?> registerInFirebase(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      final value = await ref
          .read(firebaseNotifier.notifier)
          .register(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName,
          );

      if (value != null && value.user != null) {
        final newUser = app.User(
          id: value.user!.uid,
          email: value.user!.email,
          firstName: firstName,
          lastName: lastName,
        );

        await createNewUser(newUser);

        final initialField = Field.empty("Champ principal");

        final newExploitation = Exploitation(
          fields: [initialField],
          userId: newUser.id,
        );

        await ref
            .read(exploitationNotifier.notifier)
            .createExploitation(newExploitation);

        state = newUser;
        return newUser;
      }
    } catch (e) {
      print("Register error: $e");
    }

    return null;
  }

  Future<void> createNewUser(app.User user) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .set(user.toMap());
      state = user;

      if (user.id != null) {
        await createStockForUser(user.id!);
      } else {
        print("Erreur: L'id de l'utilisateur est nul");
      }
    } catch (e) {
      print("Create user error: $e");
    }
  }

  Future<void> createStockForUser(String userId) async {
    try {
      final stock = Stocks(
        kafeType: '',
        grainWeight: 0.0,
        plantsQuantities: {},
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('stocks')
          .doc('userStock')
          .set(stock.toMap());
    } catch (e) {
      print("Create stock error: $e");
    }
  }

  Future<Stocks?> getUserStock(String userId) async {
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
    if (state == null) return;

    Stocks? userStock = await getUserStock(state!.id!);
    if (userStock != null) {
      final name = plant.name;
      final currentQty = userStock.plantsQuantities[name] ?? 0;
      userStock.plantsQuantities[name] = currentQty + 1;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(state!.id)
          .collection('stocks')
          .doc('userStock')
          .update(userStock.toMap());
    }
  }

  Future<app.User?> loginInFirebase(String email, String password) async {
    try {
      final userCredential = await ref
          .read(firebaseNotifier.notifier)
          .login(email: email, password: password);

      if (userCredential != null && userCredential.user != null) {
        final snapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userCredential.user!.uid)
                .get();

        if (snapshot.exists) {
          final user = app.User.fromMap(snapshot.data()!);
          state = user;

          await ref
              .read(exploitationNotifier.notifier)
              .getExploitationByUserId(user.id!);

          return user;
        }
      }
    } catch (e) {
      print("Login error: $e");
    }

    return null;
  }

  Future<bool> logoutFromFirebase() async {
    try {
      await ref.read(firebaseNotifier.notifier).logout();
      state = null;
      return true;
    } catch (e) {
      print("Logout error: $e");
    }
    return false;
  }

  Future<void> updateUser(app.User updatedUser) async {
    try {
      state = updatedUser;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(state!.id)
          .update(state!.toMap());
    } catch (e) {
      print("Update user error: $e");
    }
  }
}
