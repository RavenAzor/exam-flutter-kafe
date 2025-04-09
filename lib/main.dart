import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:kafe_app/firebase_options.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kafe_app/constants/constants.dart';
import 'logic/provider/firebase_auth_provider.dart';
import 'package:kafe_app/routers/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  MyApp({super.key});

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _playBackgroundMusic();

    Future.microtask(() => ref.read(firebaseNotifier.notifier).initialize());

    return ProviderScope(
      child: MaterialApp.router(
        title: 'Le torréfacteur K',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: backgroundItemsColor(),
        ),
        locale: const Locale('fr', 'fr'),
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }

  void _playBackgroundMusic() async {
    await _audioPlayer.setSource(
      AssetSource('assets/sounds/kafe_background_sound.mp3'),
    );

    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(
      AssetSource('assets/sounds/kafe_background_sound.mp3'),
    );
  }
}
