import "package:flutter/material.dart";
import "package:integration_test/integration_test.dart";
import "package:patrol/patrol.dart";
import "skip_test.dart";

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  initWindow();
  patrolTest("Complete tutorial", config: config, (PatrolTester $) async {
    await initApp($, skipWelcome: false);
    await $("Next").tap();
    await $("Start").tap();
    await $("NEXT").tap();
    await $("NEXT").tap();
    await $("NEXT").tap();
    await $("NEXT").tap();
    await $("FINISH").tap();
    await $("Accounts").tap();
    await $("FINISH").tap();
    await $("Entries").tap();
    await $("New Entry").tap();
    await $(#amount).enterText("100");
    await $.tester.testTextInput.receiveAction(TextInputAction.done);
    await $("Save").tap();
    await $("Analysis").tap();
    await $("NEXT").tap();
    await $("FINISH").tap();
  });
}
