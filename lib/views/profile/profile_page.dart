import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kafe_app/constants/constants.dart';
import 'package:kafe_app/logic/provider/user_provider.dart'; // Importer ton provider
import 'package:kafe_app/logic/provider/firebase_auth_provider.dart'; // Importer le provider d'authentification
import 'package:firebase_auth/firebase_auth.dart'; // Alias pour Firebase Auth
import 'package:kafe_app/models/user.dart'; // Alias pour ton modèle User

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Récupérer l'utilisateur actuel via le provider
    final user = ref.watch(userNotifier);

    // Si l'utilisateur n'est pas encore chargé
    if (user == null) {
      return Center(child: CircularProgressIndicator());
    }

    // Contrôleurs pour les champs modifiables
    final firstNameController = TextEditingController(text: user.firstName);
    final lastNameController = TextEditingController(text: user.lastName);
    final emailController = TextEditingController(text: user.email);

    // Variables pour savoir si l'édition est en cours
    bool isEditingFirstName = false;
    bool isEditingLastName = false;
    bool isEditingEmail = false;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Première section avec une grande image en haut
              Container(
                height:
                    MediaQuery.of(context).size.height / 2.5, // 1/3 de la page
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/kafe-logo.jpg',
                    ), // Remplace par l'image de ton choix
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 20),

              // Deuxième section avec les champs Nom et Prénom sur des lignes séparées
              Column(
                children: [
                  // Affichage du Nom avec un bouton "Modifier"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nom: ${user.firstName ?? "Non défini"}',
                        style: TextStyle(
                          fontSize: 22, // Taille du texte
                          fontWeight: FontWeight.bold, // Gras
                          color: colorTitle(), // Couleur du texte
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: colorOfText()),
                        onPressed: () {
                          isEditingFirstName = !isEditingFirstName;
                          if (isEditingFirstName) {
                            // Afficher un champ de saisie pour le nom
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Modifier le Nom'),
                                  content: TextField(
                                    controller: firstNameController,
                                    decoration: InputDecoration(
                                      labelText: 'Nom',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Annuler'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Mettre à jour le nom de l'utilisateur dans le provider
                                        ref
                                            .read(userNotifier.notifier)
                                            .updateUser(
                                              user.copyWith(
                                                firstName:
                                                    firstNameController.text,
                                              ),
                                            );
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Sauvegarder'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20), // Espace entre les champs
                  // Affichage du Prénom avec un bouton "Modifier"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Prénom: ${user.lastName ?? "Non défini"}',
                        style: TextStyle(
                          fontSize: 22, // Taille du texte
                          fontWeight: FontWeight.bold, // Gras
                          color: colorTitle(), // Couleur du texte
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: colorOfText()),
                        onPressed: () {
                          isEditingLastName = !isEditingLastName;
                          if (isEditingLastName) {
                            // Afficher un champ de saisie pour le prénom
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Modifier le Prénom'),
                                  content: TextField(
                                    controller: lastNameController,
                                    decoration: InputDecoration(
                                      labelText: 'Prénom',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Annuler'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Mettre à jour le prénom de l'utilisateur dans le provider
                                        ref
                                            .read(userNotifier.notifier)
                                            .updateUser(
                                              user.copyWith(
                                                lastName:
                                                    lastNameController.text,
                                              ),
                                            );
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Sauvegarder'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Troisième section avec l'email et le bouton de changement de mot de passe sur des lignes séparées
              Column(
                children: [
                  // Affichage de l'email avec un bouton "Modifier"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Email: ${user.email ?? "Non défini"}',
                        style: TextStyle(
                          fontSize: 22, // Taille du texte
                          fontWeight: FontWeight.bold, // Gras
                          color: colorTitle(), // Couleur du texte
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: colorOfText()),
                        onPressed: () {
                          isEditingEmail = !isEditingEmail;
                          if (isEditingEmail) {
                            // Afficher un champ de saisie pour l'email
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Modifier l\'Email'),
                                  content: TextField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Annuler'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        // Récupérer l'email et le mot de passe de l'utilisateur
                                        String newEmail = emailController.text;
                                        String password =
                                            'mot_de_passe_utilisateur'; // Tu devrais récupérer le mot de passe de manière sécurisée

                                        // Mettre à jour l'email de l'utilisateur dans le provider (FireStore ou ton modèle local)
                                        ref
                                            .read(userNotifier.notifier)
                                            .updateUser(
                                              user.copyWith(email: newEmail),
                                            );

                                        // Appeler la fonction pour mettre à jour l'email dans Firebase Auth avec ré-authentification
                                        await ref
                                            .read(firebaseNotifier.notifier)
                                            .updateUserEmail(
                                              newEmail,
                                              password,
                                            );

                                        // Fermer la boîte de dialogue
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Sauvegarder'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Bouton Modifier le mot de passe
                  ElevatedButton(
                    onPressed: () {
                      _showChangePasswordDialog(context);
                    },
                    child: Text(
                      'Modifier le mot de passe',
                      style: TextStyle(
                        fontSize: 18,
                        color: backgroundItemsColor(),
                      ), // Style du texte
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        colorTitle(),
                      ), // Couleur du bouton
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fonction pour afficher la modale pour modifier le mot de passe
  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier le mot de passe'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Nouveau mot de passe',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirmer le mot de passe',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la modale
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                // Logique de mise à jour du mot de passe
                Navigator.of(context).pop(); // Ferme la modale
              },
              child: Text('Modifier'),
            ),
          ],
        );
      },
    );
  }
}
