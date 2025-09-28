import "package:currency_picker/currency_picker.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/components/input/Header.dart";
import "package:moniz/components/utils.dart";
import "package:moniz/data/SimpleStore/basicStore.dart";
import "package:moniz/data/SimpleStore/settingsStore.dart";
import "package:moniz/data/SimpleStore/tutorialStore.dart";

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  @override
  Widget build(BuildContext context) {
    final bool transDeleteConfirmation = ref.watch(transDeleteProvider);
    final bool chipsScroll = ref.watch(chipsMultiLineProvider);
    final bool showLocation = ref.watch(showLocationProvider);
    final bool colorMapIcons = ref.watch(colorMapIconsProvider);
    final List<String> initalPages = ["Entries", "Analysis", "Manage"];
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          const Header(text: "Entries"),
          SwitchListTile.adaptive(
            title: const Text("Show confirmation before deleting transactions"),
            value: transDeleteConfirmation,
            onChanged: (e) async {
              await postHogCapture(
                eventName: "Transaction delete confirmation",
                properties: {"value": e},
              );
              ref.watch(transDeleteProvider.notifier).state = e;
            },
          ),
          SwitchListTile.adaptive(
            title: const Text(
              "Show category and account chips on multiple lines",
            ),
            value: chipsScroll,
            onChanged: (e) async {
              await postHogCapture(
                eventName: "Chips multiline",
                properties: {"value": e},
              );
              ref.watch(chipsMultiLineProvider.notifier).state = e;
            },
          ),
          SwitchListTile.adaptive(
            title: const Text(
              "Show location of the transaction in the list view",
            ),
            value: showLocation,
            onChanged: (e) async {
              await postHogCapture(
                eventName: "Show location",
                properties: {"value": e},
              );
              ref.watch(showLocationProvider.notifier).state = e;
            },
          ),
          const Header(text: "Analysis"),
          SwitchListTile.adaptive(
            title: const Text("Color map icons by category"),
            value: colorMapIcons,
            onChanged: (e) async {
              await postHogCapture(
                eventName: "Color map icons",
                properties: {"value": e},
              );
              ref.watch(colorMapIconsProvider.notifier).state = e;
            },
          ),
          const Header(text: "General"),
          ListTile(
            title: const Text("Default view on app start"),
            trailing: DropdownButton(
              alignment: Alignment.center,
              borderRadius: BorderRadius.circular(15),
              underline: Container(),
              value: initalPages[ref.watch(initialPageProvider)],
              onChanged: (value) async {
                await postHogCapture(
                  eventName: "Initial page",
                  properties: {"value": value!},
                );
                ref.watch(initialPageProvider.notifier).state = initalPages
                    .indexOf(value);
              },
              items: initalPages
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
            ),
          ),
          ListTile(
            onTap: () => showCurrencyPicker(
              context: context,
              onSelect: (e) async {
                await postHogCapture(
                  eventName: "Currency change",
                  properties: {"value": e.code},
                );
                ref.watch(currProvider.notifier).state = e;
              },
            ),
            title: const Text("Change currency"),
            trailing: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  ref.watch(currProvider).code,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ),
          const CustomDivider(),
          ListTile(
            title: const Text("About"),
            leading: const Icon(Icons.info_outline_rounded),
            onTap: () {
              Navigator.of(context).pushNamed("/about");
            },
          ),
          const CustomDivider(),
          ListTile(
            onTap: () async {
              await postHogCapture(eventName: "Export data");
              ref.read(dBProvider).shareDB();
            },
            title: const Text("Export data"),
            leading: const Icon(Icons.file_upload_outlined),
          ),
          ListTile(
            onTap: () async {
              await postHogCapture(eventName: "Import data");
              if (!context.mounted) return;
              showDialog<AlertDialog>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Are you sure?"),
                    content: const Text(
                      "This will delete any existing entries unless you have already exported them. \n\n The app will close and you will have to launch it again.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () async {
                          showDialog<Dialog>(
                            context: context,
                            builder: (context) {
                              return const Dialog(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 32),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [CircularProgressIndicator()],
                                  ),
                                ),
                              );
                            },
                          );
                          final bool imported = await ref
                              .read(dBProvider)
                              .importDB();
                          if (!context.mounted) return;
                          if (imported) {
                            await ref.read(dBProvider).close();
                            SystemChannels.platform.invokeMethod(
                              "SystemNavigator.pop",
                            );
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text("Import"),
                      ),
                    ],
                  );
                },
              );
            },
            title: const Text("Import data"),
            leading: const Icon(Icons.file_download_outlined),
          ),
          ListTile(
            title: const Text("Rerun the tutorial"),
            onTap: () {
              showDialog<AlertDialog>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Are you sure?"),
                    content: const Text(
                      "You will have to finish the tutorial again.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          ref
                                  .read(
                                    entriesTutorialCompletedProvider.notifier,
                                  )
                                  .state =
                              false;
                          ref
                                  .read(
                                    manageTutorialCompletedProvider.notifier,
                                  )
                                  .state =
                              false;
                          ref
                                  .read(
                                    analysisTutorialCompletedProvider.notifier,
                                  )
                                  .state =
                              false;
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            "/welcome",
                            (route) => false,
                          );
                        },
                        child: const Text("Rerun"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 4),
        Divider(thickness: 2),
        SizedBox(height: 4),
      ],
    );
  }
}
