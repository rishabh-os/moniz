import "dart:io";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";
import "package:integration_test/integration_test.dart";
import "package:moniz/main.dart";
import "package:patrol/patrol.dart";
import "package:window_manager/window_manager.dart";

// ! Note: individual tests work but executing them using a single command on Linux throws a debugger error. Best to run them natively on Android.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  initWindow();
  patrolTest("Skip welcome", config: config, (PatrolIntegrationTester $) async {
    await initApp($);
  });
}

void initWindow() {
  if (Platform.isLinux) {
    windowManager.ensureInitialized();
    windowManager.waitUntilReadyToShow(
      const WindowOptions(
        size: Size(400, 700),
        title: "Test 1",
      ),
      () async {
        await windowManager.show();
        await windowManager.focus();
      },
    );
  }
}

// ? The custom config is needed because of the animations everywhere in the app. This causes SettlePolicy.settle to always fail
const config = PatrolTesterConfig(
  settleTimeout: Duration(seconds: 5),
);

Future<void> initApp(
  PatrolIntegrationTester $, {
  bool skipWelcome = true,
}) async {
  await $.pumpWidget(const ProviderScope(child: MyApp()));
  await $("Welcome to Moniz!").waitUntilVisible();
  await $("meh")
      .waitUntilVisible(timeout: const Duration(seconds: 1))
      .tap()
      .onError((error, stackTrace) {});
  if (skipWelcome) {
    await $("Skip").tap();
  }
}
