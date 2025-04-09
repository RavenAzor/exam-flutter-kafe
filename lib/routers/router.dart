import 'package:kafe_app/logic/provider/firebase_auth_provider.dart';
import 'package:kafe_app/routers/route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: appRoutes,
  initialLocation: "/exploitation",
  redirect: (context, state) {
    final container = ProviderScope.containerOf(context);
    final isSignedIn = container.read(firebaseNotifier);

    if (isSignedIn == null) {
      if (state.fullPath == "/home") {
        return null;
      }
      print("home");
      return '/home';
    }
    return null;
  },
);
