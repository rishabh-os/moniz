import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:get_storage/get_storage.dart";
import "package:tutorial_coach_mark/tutorial_coach_mark.dart";

final entriesGkListProvider = Provider<List<GlobalKey>>(
  (ref) => ref.read(entriesTargetProvider).keys.toList(),
);

final entriesTargetProvider = Provider((ref) {
  return {
    GlobalKey(debugLabel: "entries0"): [
      "Date Range",
      "This is the range for which all transactions are shown. Defaults to showing the past calendar month.",
    ],
    GlobalKey(debugLabel: "entries1"): [
      "Change Date Range",
      "You can change the range here. Chose from a few options or pick your own custom range.",
    ],
    GlobalKey(debugLabel: "entries2"): [
      "Settings",
      "You can change the application theme and access other settings here",
    ],
    GlobalKey(debugLabel: "entries3"): [
      "Filter",
      "You can filter the transactions shown here by amount, category, or account. You can also search by text.",
    ],
    GlobalKey(debugLabel: "entries4"): [
      "New Transactions",
      "Add a new transaction by using the button. Once you've added a transaction, you can click on it to edit it.",
    ],
  };
});

final entriesTutorialCompletedProvider = StateProvider<bool>((ref) {
  ref.listenSelf(
    (previous, next) => GetStorage().write("entriesTutorialCompleted", next),
  );
  GetStorage().read("entriesTutorialCompleted") ??
      GetStorage().write("entriesTutorialCompleted", false);
  return GetStorage().read("entriesTutorialCompleted") as bool;
});

final manageGkListProvider = Provider<List<GlobalKey>>(
  (ref) => ref.read(manageTargetListProvider).keys.toList(),
);

final manageTargetListProvider = Provider(
  (ref) => {
    GlobalKey(debugLabel: "manage0"): [
      "Accounts",
      "You can add different accounts to keep track of here.",
    ],
    GlobalKey(debugLabel: "manage1"): [
      "Categories",
      "Manage various categories to organize your transactions here. Categories can also be reordered.",
    ],
  },
);

final manageTutorialCompletedProvider = StateProvider<bool>((ref) {
  ref.listenSelf(
    (previous, next) => GetStorage().write("manageTutorialCompleted", next),
  );
  GetStorage().read("manageTutorialCompleted") ??
      GetStorage().write("manageTutorialCompleted", false);
  return GetStorage().read("manageTutorialCompleted") as bool;
});

final analysisGkListProvider = Provider<List<GlobalKey>>(
  (ref) => ref.read(analysisTargetListProvider).keys.toList(),
);

final analysisTargetListProvider = Provider(
  (ref) => {
    GlobalKey(debugLabel: "analysis0"): [
      "Pie Chart",
      "Breakdown your spends by category or account",
    ],
    GlobalKey(debugLabel: "analysis1"): [
      "Line Graph",
      "See your spending habits over the course of the selected range",
    ],
  },
);

final analysisTutorialCompletedProvider = StateProvider<bool>((ref) {
  ref.listenSelf(
    (previous, next) => GetStorage().write("analysisTutorialCompleted", next),
  );
  GetStorage().read("analysisTutorialCompleted") ??
      GetStorage().write("analysisTutorialCompleted", false);
  return GetStorage().read("analysisTutorialCompleted") as bool;
});

enum Screen { entries, manage, analysis }

final tutorialProvider = Provider((ref) {
  void showTutorial(
    BuildContext context,
    Screen screen,
  ) {
    Map<GlobalKey, List<String>> targetDetails;
    switch (screen) {
      case Screen.entries:
        targetDetails = ref.read(entriesTargetProvider);
      case Screen.manage:
        targetDetails = ref.read(manageTargetListProvider);
      case Screen.analysis:
        targetDetails = ref.read(analysisTargetListProvider);
    }

    final List listOfKeys = targetDetails.keys.toList();
    TargetFocus customTarget(
      BuildContext context,
      GlobalKey key,
      String title,
      String details,
    ) {
      return TargetFocus(
        keyTarget: key,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(),
            builder: (context, controller) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    details,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontSize: 16,
                    ),
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
                          child: const Text("PREVIOUS"),
                        ),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        onPressed: () {
                          controller.next();
                        },
                        child: Text(listOfKeys.last != key ? "NEXT" : "FINISH"),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      );
    }

    TutorialCoachMark(
      targets: targetDetails.entries
          .map(
            (e) => customTarget(context, e.key, e.value.first, e.value.last),
          )
          .toList(), // List<TargetFocus>
      colorShadow: Theme.of(context).colorScheme.secondaryContainer,
      hideSkip: true,
      opacityShadow: 0.9,
      focusAnimationDuration: const Duration(milliseconds: 250),
      unFocusAnimationDuration: const Duration(milliseconds: 250),
      pulseAnimationDuration: const Duration(milliseconds: 1000),
    ).show(context: context);
  }

  return showTutorial;
});
