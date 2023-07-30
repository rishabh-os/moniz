import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

final entriesGkListProvider = Provider<List<GlobalKey>>(
    (ref) => ref.read(entriesTargetProvider).keys.toList());

final entriesTargetProvider = Provider((ref) {
  return {
    GlobalKey(debugLabel: "entries0"): [
      "Date Range",
      "This is the range for which all transactions are shown. Defaults to showing the past month."
    ],
    GlobalKey(debugLabel: "entries1"): [
      "Change Range",
      "You can change the range here"
    ],
    GlobalKey(debugLabel: "entries2"): [
      "Change Range Quickly",
      "Don't want to pick a range every time? Here are some quick options for you to pick from"
    ],
    GlobalKey(debugLabel: "entries3"): [
      "Settings",
      "You can change the application theme, manage categories and access other settings here"
    ],
    GlobalKey(debugLabel: "entries4"): [
      "New Transactions",
      "Add a new transaction by using the button. Once you've added a transaction, you can click on it to edit it."
    ],
  };
});

// ? Not working on mobile properly
final entriesTutorialCompletedProvider = StateProvider<Function>((ref) {
  bool newMethod() {
    if (GetStorage().hasData("entriesTutorialCompleted")) {
      return false;
    } else {
      GetStorage().write("entriesTutorialCompleted", true);
      return true;
    }
  }

  return newMethod;
});

final accountsGkListProvider = Provider<List<GlobalKey>>(
    (ref) => ref.read(accountsTargetListProvider).keys.toList());

final accountsTargetListProvider = Provider((ref) => {
      GlobalKey(debugLabel: "accounts0"): [
        "Accounts",
        "You can add different accounts to keep track of here."
      ],
    });

final accountsTutorialCompletedProvider = StateProvider<Function>((ref) {
  bool newMethod() {
    if (GetStorage().hasData("accountsTutorialCompleted")) {
      return false;
    } else {
      GetStorage().write("accountsTutorialCompleted", true);
      return true;
    }
  }

  return newMethod;
});

final analysisGkListProvider = Provider<List<GlobalKey>>(
    (ref) => ref.read(analysisTargetListProvider).keys.toList());

final analysisTargetListProvider = Provider((ref) => {
      GlobalKey(debugLabel: "analysis0"): [
        "Pie Chart",
        "Breakdown your spends by category or account"
      ],
      GlobalKey(debugLabel: "analysis1"): [
        "Line Graph",
        "See your spending habits over the course of the selected range"
      ],
    });

final analysisTutorialCompletedProvider = StateProvider<Function>((ref) {
  bool newMethod() {
    if (GetStorage().hasData("analysisTutorialCompleted")) {
      return false;
    } else {
      GetStorage().write("analysisTutorialCompleted", true);
      return true;
    }
  }

  return newMethod;
});

enum Screen { entries, accounts, analysis }

final tutorialProvider = Provider((ref) {
  void showTutorial(
    BuildContext context,
    Screen screen,
  ) {
    Map<GlobalKey, List<String>> targetDetails;
    switch (screen) {
      case Screen.entries:
        targetDetails = ref.read(entriesTargetProvider);
        break;
      case Screen.accounts:
        targetDetails = ref.read(accountsTargetListProvider);
        break;
      case Screen.analysis:
        targetDetails = ref.read(analysisTargetListProvider);
        break;
      default:
        targetDetails = {};
    }

    List listOfKeys = targetDetails.keys.toList();
    TargetFocus customTarget(
        BuildContext context, GlobalKey key, String title, String details) {
      return TargetFocus(enableTargetTab: true, keyTarget: key, contents: [
        TargetContent(
          align: ContentAlign.custom,
          customPosition: CustomTargetContentPosition(),
          builder: (context, controller) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontSize: 24),
                ),
                const SizedBox(height: 10),
                Text(
                  details,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontSize: 16),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (listOfKeys.first != key)
                      OutlinedButton(
                          onPressed: () {
                            controller.previous();
                          },
                          child: const Text("PREVIOUS")),
                    const SizedBox(width: 10),
                    OutlinedButton(
                        onPressed: () {
                          controller.next();
                        },
                        child: Text(listOfKeys.last != key ? "NEXT" : "FINISH"))
                  ],
                )
              ],
            );
          },
        )
      ]);
    }

    TutorialCoachMark(
            targets: targetDetails.entries
                .map((e) =>
                    customTarget(context, e.key, e.value.first, e.value.last))
                .toList(), // List<TargetFocus>
            colorShadow: Theme.of(context).colorScheme.secondaryContainer,
            hideSkip: true,
            opacityShadow: 0.9,
            focusAnimationDuration: const Duration(milliseconds: 250),
            unFocusAnimationDuration: const Duration(milliseconds: 250),
            pulseAnimationDuration: const Duration(milliseconds: 1000))
        .show(context: context);
  }

  return showTutorial;
});
