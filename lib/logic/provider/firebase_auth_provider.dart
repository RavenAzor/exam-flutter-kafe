import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firebaseProvider = StateProvider<User?>((ref) => null);

final firebaseNotifier = StateNotifierProvider<FirebaseProvider, FirebaseAuth?>(
  (ref) => FirebaseProvider(ref),
);

class FirebaseProvider extends StateNotifier<FirebaseAuth?> {
  Ref ref;
  FirebaseProvider(this.ref) : super(null);

  Future<void> initialize() async {
    state = FirebaseAuth.instance;
    if (state != null) {
      state!.authStateChanges().listen((User? user) {
        if (user == null) {
          ref.read(firebaseProvider.notifier).state = null;
        } else {
          ref.read(firebaseProvider.notifier).state = user;
        }
      });
    }
  }

  Future<UserCredential?> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final userCredential = await state!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Utilisateur enregistré : $userCredential');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      handleAuthException(e, "Erreur d'inscription");
    } catch (e) {
      handleGenericError(e, "Erreur inconnue lors de l'inscription");
    }
    return null;
  }

  Future<bool> logout() async {
    try {
      await state!.signOut();
      print('Déconnexion réussie');
      return true;
    } on FirebaseAuthException catch (e) {
      handleAuthException(e, "Erreur de déconnexion");
    } catch (e) {
      handleGenericError(e, "Erreur inconnue lors de la déconnexion");
    }
    return false;
  }

  Future<UserCredential?> login({
    required String email,
    required String password,
  }) async {
    try {
      var userCredential = await state!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Utilisateur connecté : $userCredential');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      handleAuthException(e, "Erreur de connexion");
    } catch (e) {
      handleGenericError(e, "Erreur inconnue lors de la connexion");
    }
    return null;
  }

  Future<void> updateUserEmail(String newEmail, String password) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("Aucun utilisateur connecté");
      }

      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email ?? "",
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      print("Ré-authentification réussie.");

      await user.updateEmail(newEmail);
      print("Email mis à jour dans Firebase Authentication.");

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'email': newEmail},
      );
      print("Email mis à jour dans Firestore.");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
          'L\'utilisateur doit se ré-authentifier avant de changer son email.',
        );
      } else if (e.code == 'wrong-password') {
        print('Mot de passe incorrect. Impossible de ré-authentifier.');
      } else if (e.code == 'email-already-in-use') {
        print('Cet email est déjà utilisé par un autre compte.');
      } else {
        print('Erreur lors de la mise à jour de l\'email : $e');
      }
    } catch (e) {
      print('Erreur inconnue : $e');
    }
  }

  void handleAuthException(FirebaseAuthException e, String context) {
    switch (e.code) {
      case 'email-already-in-use':
        print('$context : L\'adresse e-mail est déjà utilisée.');
        break;
      case 'invalid-email':
        print('$context : L\'adresse e-mail est invalide.');
        break;
      case 'weak-password':
        print('$context : Le mot de passe est trop faible.');
        break;
      case 'user-not-found':
        print('$context : Aucun utilisateur trouvé avec cet e-mail.');
        break;
      case 'wrong-password':
        print('$context : Le mot de passe est incorrect.');
        break;
      default:
        print('$context : ${e.code} - ${e.message}');
        break;
    }
  }

  void handleGenericError(Object e, String context) {
    print('$context : $e');
  }
}
