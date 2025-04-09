import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kafe_app/constants/constants.dart';
import 'package:kafe_app/views/auth/register/register_form.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

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
            Padding(padding: const EdgeInsets.all(16.0), child: RegisterForm()),
            TextButton(
              onPressed: () {
                context.go("/login");
              },
              style: TextButton.styleFrom(foregroundColor: colorTitle()),
              child: const Text('Vous avez déjà un compte ? Connectez-vous !'),
            ),
          ],
        ),
      ),
    );
  }
}
