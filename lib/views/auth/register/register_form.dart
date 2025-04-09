import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kafe_app/constants/constants.dart';
import 'package:kafe_app/logic/provider/user_provider.dart';

import '../../../models/user.dart';

class RegisterForm extends HookConsumerWidget {
  RegisterForm({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = useState("");
    final password = useState("");
    final firstName = useState("");
    final lastName = useState("");
    final obscureText = useState(false);

    void onSubmited(bool isRegistered, User? user) {
      if (isRegistered && user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Compte créé avec succès",
              style: TextStyle(color: colorOfText()),
            ),
            backgroundColor: backgroundItemsColor(),
          ),
        );

        context.go('/welcome', extra: {'firstname': user.firstName ?? ''});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Erreur lors de l'inscription",
              style: TextStyle(color: colorOfText()),
            ),
            backgroundColor: backgroundItemsColor(),
          ),
        );
      }
    }

    Future<void> submitForm() async {
      if (_formKey.currentState?.validate() ?? false) {
        _formKey.currentState?.save();

        final user = await ref
            .read(userNotifier.notifier)
            .registerInFirebase(
              email.value,
              password.value,
              firstName.value,
              lastName.value,
            );

        onSubmited(user != null, user);
      }
    }

    void togglePasswordVisibility() {
      obscureText.value = !obscureText.value;
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Champ email
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorOfText(),
                borderRadius: buttonBorderRadius(),
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: backgroundItemsColor()),
                  border: InputBorder.none,
                  contentPadding: textFieldPadding(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez votre email';
                  }
                  return null;
                },
                onSaved: (value) {
                  email.value = value ?? '';
                },
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Champ firstName
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorOfText(),
                borderRadius: buttonBorderRadius(),
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Prénom',
                  labelStyle: TextStyle(color: backgroundItemsColor()),
                  border: InputBorder.none,
                  contentPadding: textFieldPadding(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez votre prénom';
                  }
                  return null;
                },
                onSaved: (value) {
                  firstName.value = value ?? '';
                },
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Champ lastName
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorOfText(),
                borderRadius: buttonBorderRadius(),
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nom',
                  labelStyle: TextStyle(color: backgroundItemsColor()),
                  border: InputBorder.none,
                  contentPadding: textFieldPadding(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez votre nom';
                  }
                  return null;
                },
                onSaved: (value) {
                  lastName.value = value ?? '';
                },
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Champ mot de passe
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorOfText(),
                borderRadius: buttonBorderRadius(),
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: backgroundItemsColor()),
                  border: InputBorder.none,
                  contentPadding: textFieldPadding(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureText.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: togglePasswordVisibility,
                  ),
                ),
                obscureText: !obscureText.value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez votre mot de passe';
                  }
                  return null;
                },
                onSaved: (value) {
                  password.value = value ?? '';
                },
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                onPressed: submitForm,
                backgroundColor: Colors.orange,
                foregroundColor: backgroundItemsColor(),
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person_add, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
