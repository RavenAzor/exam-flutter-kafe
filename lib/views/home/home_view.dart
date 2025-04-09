import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import '../../constants/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/video/moving.mp4')
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
        });
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Center(child: Image.asset('assets/images/kafe-logo.jpg')),
            ),
          ),

          // Boutons
          Positioned(
            top: MediaQuery.of(context).size.height / 2 + 30,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 160,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.go("/login");
                          },
                          icon: const Icon(Icons.login),
                          label: const Text('Se connecter'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorOfText(),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),

                      Container(
                        width: 160,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.go("/register");
                          },
                          icon: const Icon(Icons.person_add),
                          label: const Text('S\'inscrire'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Container(
              height: 150,
              child:
                  _isVideoInitialized
                      ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                      : Container(
                        color: backgroundItemsColor(),
                        width: double.infinity,
                        height: 150,
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
