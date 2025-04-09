import 'package:flutter/material.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import '../../constants/constants.dart';

class WelcomeScreen extends StatefulWidget {
  final String firstname;

  const WelcomeScreen({super.key, required this.firstname});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_fadeController);

    _fadeController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      _fadeController.reverse();

      Future.delayed(const Duration(seconds: 2), () {
        context.go('/exploitation');
      });
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundItemsColor(),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            'Bienvenue ${widget.firstname} 👋',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: colorOfText(),
            ),
          ),
        ),
      ),
    );
  }
}
