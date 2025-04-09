import 'package:flutter/material.dart';
import '../constants/constants.dart';
import 'package:go_router/go_router.dart';

class AppTopNav extends StatelessWidget implements PreferredSizeWidget {
  final Function() onLogoutPressed;
  const AppTopNav({super.key, required this.onLogoutPressed});

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
      child: AppBar(
        elevation: 10.0,
        backgroundColor: backgroundItemsColor(),
        title: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'Le torréfacteur K',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              onLogoutPressed();
              context.go("/home");
            },
            icon: const Icon(Icons.login),
            color: colorTitle(),
          ),
        ],
      ),
    );
  }
}
