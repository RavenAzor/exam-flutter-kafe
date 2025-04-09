import 'package:flutter/material.dart';
import 'package:kafe_app/layout/app_top_nav.dart';
import 'package:kafe_app/layout/app_bottom_nav.dart';
import 'package:kafe_app/logic/provider/firebase_auth_provider.dart';
import 'package:kafe_app/logic/provider/user_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppScaffold extends ConsumerWidget {
  final Widget body;
  AppScaffold({super.key, required this.body});
  final dynamic _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userCredentials = ref.watch(firebaseNotifier);
    final user = ref.read(userNotifier.notifier);
    void onLoginPressed() {
      if (userCredentials != null) {
        user.logoutFromFirebase();
        context.go('/login');
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppTopNav(onLogoutPressed: () => onLoginPressed()),
      bottomNavigationBar: const AppBottomNav(),
      body: body,
    );
  }
}
