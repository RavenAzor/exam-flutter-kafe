import 'package:flutter/material.dart';
import 'package:kafe_app/constants/constants.dart';
import 'package:kafe_app/views/auth/login/login_form.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            ClipRRect(
              borderRadius: generalBorderRadius(),
              child: Image.asset(
                'assets/images/kafe-logo.jpg',
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Padding(padding: const EdgeInsets.all(16.0), child: LoginForm()),
            TextButton(
              onPressed: () {
                context.go("/register");
              },
              style: TextButton.styleFrom(foregroundColor: colorTitle()),
              child: const Text(
                'Vous n\'avez pas encore de compte ? Inscrivez-vous ici !',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
