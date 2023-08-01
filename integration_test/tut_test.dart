import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moniz/main.dart';
import 'package:patrol/patrol.dart';
import 'package:integration_test/integration_test.dart';
import 'package:window_manager/window_manager.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  if (Platform.isLinux) {
    windowManager.ensureInitialized();
    windowManager.waitUntilReadyToShow(
      const WindowOptions(
        size: Size(400, 700),
        title: 'Test 2',
      ),
      () async {
        await windowManager.show();
        await windowManager.focus();
      },
    );
  }
  // ? The custom config is needed because of the animations everywhere in the app. This causes SettlePolicy.settle to always fail
  const config = PatrolTesterConfig(
      settlePolicy: SettlePolicy.trySettle,
      settleTimeout: Duration(seconds: 2));

  patrolTest('Complete tutorial', config: config, (PatrolTester $) async {
    await $.pumpWidget(const ProviderScope(child: MyApp()));
    await $('Welcome to Moniz!').waitUntilVisible();
    await $('Next').tap();
    await $('Start').tap();
    await $("NEXT").tap();
    await $("NEXT").tap();
    await $("NEXT").tap();
    await $("NEXT").tap();
    await $("FINISH").tap();
    await $("Accounts").tap();
    await $("FINISH").tap();
    await $("Entries").tap();
    await $("New Entry").tap();
    await $(#AMOUNT).enterText("100");
    await $.tester.testTextInput.receiveAction(TextInputAction.done);
    await $("Save").tap();
    await $("Analysis").tap();
    await $("NEXT").tap();
    await $("FINISH").tap();
  });
}
