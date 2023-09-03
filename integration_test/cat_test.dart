import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:integration_test/integration_test.dart";
import "package:patrol/patrol.dart";
import "skip_test.dart";

// ! Note: individual tests work but executing them using a single command on Linux throws a debugger error. Best to run them natively on Android.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  initWindow();
  const String categoryName = "test cat";
  patrolTest("Skip welcome and category delete", config: config,
      (PatrolIntegrationTester $) async {
    await initApp($);
    await $("Entries").tap();
    await $($(Icons.more_vert)).tap();
    await $("Categories").tap();
    await $("Add Category").tap();
    await $(#name).enterText(categoryName);
    await $.tester.testTextInput.receiveAction(TextInputAction.done);
    await $("Save").tap();
    await $.tester.drag(find.text("Add Category"), const Offset(0, 300));

    await $("New Entry").tap();
    await $(#amount).enterText("300");
    await $.tester.testTextInput.receiveAction(TextInputAction.done);
    // ? Patrol finder can't find the text in the chip
    await $("Default")
        .scrollTo(
      view: $(#chips).first,
      scrollDirection: AxisDirection.right,
      maxScrolls: 1,
      step: 800,
    )
        .onError((error, stackTrace) {
      return $("Edit");
    });
    // ? So I go back to the native tester
    await $.tester.tap(find.text(categoryName), warnIfMissed: false);
    await $("Save").tap();

    await $($(Icons.more_vert)).tap();
    await $("Categories").tap();
    await $(Icons.edit_rounded).last.tap();
    await $($(Icons.delete_forever_rounded)).tap();
    await $("Delete").tap();
    await $("Yes").tap();
    expect($(categoryName), findsNothing);
  });
}
