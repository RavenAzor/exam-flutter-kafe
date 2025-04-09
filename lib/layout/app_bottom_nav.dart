import 'package:flutter/material.dart';
import 'package:kafe_app/logic/provider/app_bottom_nav_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../constants/constants.dart';

class AppBottomNav extends HookConsumerWidget {
  const AppBottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final indexNotifier = ref.read(bottomNavIndexProvider.notifier);

    void onItemTapped(int index) {
      indexNotifier.changeIndex(index);
      switch (index) {
        case 0:
          context.go('/plantation');
          break;
        case 1:
          context.go('/stocks');
          break;
        case 2:
          context.go('/concours');
          break;
        case 3:
          context.go('/profil');
          break;
      }
    }

    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.nature), label: 'Plantation'),
        BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Stocks'),
        BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Concours'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ],
      currentIndex: currentIndex,
      onTap: (index) => onItemTapped(index),
      selectedItemColor: colorOfText(),
      unselectedItemColor: colorTitle(),
    );
  }
}
