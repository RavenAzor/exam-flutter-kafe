import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kafe_app/constants/constants.dart';
import 'package:kafe_app/logic/provider/user_provider.dart';
import 'package:kafe_app/logic/provider/firebase_auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kafe_app/models/user.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifier);

    if (user == null) {
      return Center(child: CircularProgressIndicator());
    }

    final firstNameController = TextEditingController(text: user.firstName);
    final lastNameController = TextEditingController(text: user.lastName);
    final emailController = TextEditingController(text: user.email);

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
              Container(
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/kafe-logo.jpg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 20),

              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nom: ${user.firstName ?? "Non défini"}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: colorTitle(),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: colorOfText()),
                        onPressed: () {
                          isEditingFirstName = !isEditingFirstName;
                          if (isEditingFirstName) {
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
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Prénom: ${user.lastName ?? "Non défini"}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: colorTitle(),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: colorOfText()),
                        onPressed: () {
                          isEditingLastName = !isEditingLastName;
                          if (isEditingLastName) {
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
            ],
          ),
        ),
      ),
    );
  }
}
