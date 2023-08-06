import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:patrol/patrol.dart';
import 'skip_test.dart';

// ! Note: individual tests work but executing them using a single command on Linux throws a debugger error. Best to run them natively on Android.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  initWindow();
  const String accountName = "test account";
  patrolTest('Skip welcome and account delete', config: config,
      (PatrolTester $) async {
    initApp($);
    await $("Accounts").tap();
    await $("Add Account").tap();
    await $(#name).enterText(accountName);
    await $.tester.testTextInput.receiveAction(TextInputAction.done);
    await $("Save").tap();

    await $("Entries").tap();
    await $("New Entry").tap();
    await $(#amount).enterText("300");
    await $.tester.testTextInput.receiveAction(TextInputAction.done);
    // ? Patrol finder can't find the text in the chip
    await $("Default")
        .scrollTo(
      view: $(#chips).last,
      scrollDirection: AxisDirection.right,
      maxScrolls: 1,
      step: 800,
    )
        .onError((error, stackTrace) {
      return $("Edit");
    });
    // ? So I go back to the native tester
    await $.tester.tap(find.text(accountName), warnIfMissed: false);
    await $("Save").tap();

    await $("Accounts").tap();
    await $($(Icons.edit)).last.tap();
    await $($(Icons.delete_forever_outlined)).tap();
    await $("Delete").tap();
    await $("Yes").tap();
    await $("Entries").tap();
    expect($(accountName), findsNothing);
  });
}
