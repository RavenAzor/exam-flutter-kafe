import 'package:flutter/material.dart';
import 'package:kafe_app/layout/app_scaffold.dart';
import 'package:kafe_app/views/auth/login/login_view.dart';
import 'package:kafe_app/views/auth/register/register_view.dart';
import 'package:kafe_app/views/plantation/exploitation_view.dart';
import 'package:kafe_app/views/concours/concours_view.dart';
import 'package:kafe_app/views/profile/profile_page.dart';
import 'package:go_router/go_router.dart';
import 'package:kafe_app/views/home/home_view.dart';

import '../views/home/welcome_screen.dart';
import '../views/stocks/stocks_view.dart';

final List<GoRoute> appRoutes = [
  GoRoute(
    path: '/home',
    name: "Home",
    pageBuilder: (context, state) {
      return _buildSlideFromLeftTransitionPage(
        context,
        state,
        const HomePage(),
      );
    },
  ),
  GoRoute(
    path: '/login',
    name: "Login",
    pageBuilder: (context, state) {
      return _buildSlideFromLeftTransitionPage(
        context,
        state,
        const LoginView(),
      );
    },
  ),
  GoRoute(
    path: '/register',
    name: "Register",
    pageBuilder: (context, state) {
      return _buildSlideFromLeftTransitionPage(
        context,
        state,
        const RegisterView(),
      );
    },
  ),
  GoRoute(
    path: '/welcome',
    builder: (context, state) {
      final data = state.extra as Map<String, dynamic>;
      final firstname = data['firstname'] ?? '';
      return WelcomeScreen(firstname: firstname);
    },
  ),
  GoRoute(
    path: '/exploitation',
    name: "Exploitation",
    pageBuilder: (context, state) {
      return _buildSlideFromLeftTransitionPage(
        context,
        state,
        AppScaffold(body: ExploitationView()),
      );
    },
  ),
  GoRoute(
    path: '/stocks',
    name: "Stocks",
    pageBuilder: (context, state) {
      return _buildSlideFromLeftTransitionPage(
        context,
        state,
        AppScaffold(body: const StocksView()),
      );
    },
  ),
  GoRoute(
    path: '/concours',
    name: "Concours",
    pageBuilder: (context, state) {
      return _buildSlideFromLeftTransitionPage(
        context,
        state,
        AppScaffold(body: const ConcoursView()),
      );
    },
  ),
  GoRoute(
    path: '/profil',
    name: "Profil",
    pageBuilder: (context, state) {
      return _buildSlideFromLeftTransitionPage(
        context,
        state,
        AppScaffold(body: const ProfilePage()),
      );
    },
  ),
];

Page _buildSlideFromLeftTransitionPage(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final opacityAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));

      final offsetAnimation = Tween<Offset>(
        begin: Offset(-1.0, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));

      return FadeTransition(
        opacity: opacityAnimation,
        child: SlideTransition(position: offsetAnimation, child: child),
      );
    },
  );
}
