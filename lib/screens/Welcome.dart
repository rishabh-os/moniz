import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Welcome extends ConsumerStatefulWidget {
  const Welcome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WelcomeState();
}

class _WelcomeState extends ConsumerState<Welcome> {
  void goHome() {
    Navigator.of(context).pushNamed("/home");
    GetStorage().write("welcome", true);
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      done: const Text("Start"),
      next: const Text("Next"),
      skip: const Text("Skip"),
      onDone: goHome,
      onSkip: () {
        goHome();
        GetStorage().write("entriesTutorialCompleted", true);
        GetStorage().write("accountsTutorialCompleted", true);
        GetStorage().write("analysisTutorialCompleted", true);
      },
      showSkipButton: true,
      pages: [
        PageViewModel(
          title: "Welcome to Moniz!",
          body: "Yet another app to manage your money.",
          image: const Center(
            child: Icon(Icons.waving_hand_rounded, size: 100.0),
          ),
        ),
        PageViewModel(
          title: "Tutorial",
          body:
              "Proceed to start the tutorial.\nOr you can go back and skip it.",
          image: const Center(
            child: Icon(Icons.school_rounded, size: 100.0),
          ),
        )
      ],
    );
  }
}
