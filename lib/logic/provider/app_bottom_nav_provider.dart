import 'package:hooks_riverpod/hooks_riverpod.dart';

class BottomNavIndexProvider extends StateNotifier<int> {
  BottomNavIndexProvider() : super(0);
  void changeIndex(int index) => state = index;
}

final bottomNavIndexProvider =
    StateNotifierProvider<BottomNavIndexProvider, int>(
      (ref) => BottomNavIndexProvider(),
    );
