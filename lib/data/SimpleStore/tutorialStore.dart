import "package:flutter/material.dart";
import "package:get_storage/get_storage.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:tutorial_coach_mark/tutorial_coach_mark.dart";
part "tutorialStore.g.dart";

final List<(GlobalKey, String, String)> entriesTargets = [
  (
    GlobalKey(debugLabel: "entries0"),
    "Date Range",
    "This is the range for which all transactions are shown. Defaults to showing the past calendar month.",
  ),
  (
    GlobalKey(debugLabel: "entries1"),
    "Filter",
    "You can filter the transactions shown here by amount, category, or account. You can also search by text.",
  ),
  (
    GlobalKey(debugLabel: "entries2"),
    "Change Date Range",
    "You can change the range here. Chose from a few options or pick your own custom range.",
  ),
  (
    GlobalKey(debugLabel: "entries3"),
    "Settings",
    "You can change the application theme and access other settings here",
  ),
  (
    GlobalKey(debugLabel: "entries4"),
    "New Transactions",
    "Add a new transaction by using the button. Once you've added a transaction, you can click on it to edit it.",
  ),
];

@Riverpod(keepAlive: true)
class EntriesTutorialCompleted extends _$EntriesTutorialCompleted {
  @override
  bool build() {
    listenSelf(
      (previous, next) => GetStorage().write("entriesTutorialCompleted", next),
    );
    GetStorage().read("entriesTutorialCompleted") ??
        GetStorage().write("entriesTutorialCompleted", false);
    return GetStorage().read("entriesTutorialCompleted") as bool;
  }

  @override
  set state(bool newState) => super.state = newState;
}

final List<(GlobalKey, String, String)> manageTargets = [
  (
    GlobalKey(debugLabel: "manage0"),
    "Accounts",
    "You can add different accounts to keep track of here.",
  ),
  (
    GlobalKey(debugLabel: "manage1"),
    "Categories",
    "Manage various categories to organize your transactions here. Categories can also be reordered.",
  ),
];

@Riverpod(keepAlive: true)
class ManageTutorialCompleted extends _$ManageTutorialCompleted {
  @override
  bool build() {
    listenSelf(
      (previous, next) => GetStorage().write("manageTutorialCompleted", next),
    );
    GetStorage().read("manageTutorialCompleted") ??
        GetStorage().write("manageTutorialCompleted", false);
    return GetStorage().read("manageTutorialCompleted") as bool;
  }

  @override
  set state(bool newState) => super.state = newState;
}

final List<(GlobalKey, String, String)> analysisTargets = [
  (
    GlobalKey(debugLabel: "analysis0"),
    "Pie Chart",
    "Breakdown your spending by category or account",
  ),
  (
    GlobalKey(debugLabel: "analysis1"),
    "Line Graph",
    "See how your spending habits change over time",
  ),
  (
    GlobalKey(debugLabel: "analysis2"),
    "Map View",
    "View a bubble map of the places where you've spent money",
  ),
];

@Riverpod(keepAlive: true)
class AnalysisTutorialCompleted extends _$AnalysisTutorialCompleted {
  @override
  bool build() {
    listenSelf(
      (previous, next) => GetStorage().write("analysisTutorialCompleted", next),
    );
    GetStorage().read("analysisTutorialCompleted") ??
        GetStorage().write("analysisTutorialCompleted", false);
    return GetStorage().read("analysisTutorialCompleted") as bool;
  }

  @override
  set state(bool newState) => super.state = newState;
}

enum Screen { entries, manage, analysis }

void showTutorial(BuildContext context, Screen screen) {
  List<(GlobalKey, String, String)> targetDetails;
  switch (screen) {
    case Screen.entries:
      targetDetails = entriesTargets;
    case Screen.manage:
      targetDetails = manageTargets;
    case Screen.analysis:
      targetDetails = analysisTargets;
  }

  final List<GlobalKey> listOfKeys = targetDetails.map((e) => e.$1).toList();
  TargetFocus customTarget(
    BuildContext context,
    GlobalKey key,
    String title,
    String details,
  ) {
    return TargetFocus(
      keyTarget: key,
      shape: ShapeLightFocus.RRect,
      radius: 25,
      contents: [
        TargetContent(
          // ? Because the FAB is at the very bottom
          align: title == "New Transactions"
              ? ContentAlign.top
              : ContentAlign.bottom,
          builder: (context, controller) {
            return SizedBox(
              height: 200,
              child: Column(
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
              ),
            );
          },
        ),
      ],
    );
  }

  TutorialCoachMark(
    targets: targetDetails
        .map((e) => customTarget(context, e.$1, e.$2, e.$3))
        .toList(), // List<TargetFocus>
    colorShadow: Theme.of(context).colorScheme.secondaryContainer,
    hideSkip: true,
    opacityShadow: 0.9,
    focusAnimationDuration: const Duration(milliseconds: 250),
    unFocusAnimationDuration: const Duration(milliseconds: 250),
    pulseAnimationDuration: const Duration(milliseconds: 1000),
  ).show(context: context);
}
