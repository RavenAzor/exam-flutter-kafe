import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kafe_app/models/user.dart' as app;
import 'package:kafe_app/logic/provider/firebase_auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userNotifier = StateNotifierProvider<UserNotifier, app.User?>(
  (ref) => UserNotifier(ref),
);

class UserNotifier extends StateNotifier<app.User?> {
  final Ref ref;
  UserNotifier(this.ref) : super(null);

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

        await createNewUser(newUser); // Enregistre dans Firestore ou autre
        state = newUser; // Stocke dans le state
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
    } catch (e) {
      print("Create user error: $e");
    }
  }

  // Future<bool> loginInFirebase(String email, String password) async {
  //   try {
  //     final userCredential = await ref
  //         .read(firebaseNotifier.notifier)
  //         .login(email: email, password: password);

  //     if (userCredential != null && userCredential.user != null) {
  //       final snapshot =
  //           await FirebaseFirestore.instance
  //               .collection('users')
  //               .doc(userCredential.user!.uid)
  //               .get();

  //       if (snapshot.exists) {
  //         state = app.User.fromMap(snapshot.data()!);
  //         return true;
  //       }
  //     }
  //   } catch (e) {
  //     print("Login error: $e");
  //   }
  //   return false;
  // }

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
          state = user; // garde en mémoire dans le state
          return user;
        }
      }
    } catch (e) {
      print("Login error: $e");
    }

    return null; // En cas d’échec
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
