import "package:currency_picker/currency_picker.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
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
    bool transDeleteConfirmation = ref.watch(transDeleteProvider);
    bool chipsScroll = ref.watch(chipsMultiLineProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Show confirmation before deleting transactions"),
            value: transDeleteConfirmation,
            onChanged: (e) {
              ref.watch(transDeleteProvider.notifier).update((state) => e);
            },
          ),
          SwitchListTile(
            title:
                const Text("Show category and account chips on multiple lines"),
            value: chipsScroll,
            onChanged: (e) {
              ref.watch(chipsMultiLineProvider.notifier).update((state) => e);
            },
          ),
          ListTile(
            onTap: () => showCurrencyPicker(
                context: context,
                onSelect: (e) {
                  ref
                      .watch(currencyProvider.notifier)
                      .update((state) => e.code);
                }),
            title: const Text("Change currency"),
            trailing: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).colorScheme.primaryContainer),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  ref.watch(currencyProvider),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
              ),
            ),
          ),
          ListTile(
            onTap: () => ref.read(dbProvider).shareDB(),
            title: const Text("Export data"),
            leading: const Icon(Icons.file_upload_outlined),
          ),
          ListTile(
            onTap: () => ref.read(dbProvider).importDB(),
            title: const Text("Import data"),
            subtitle: const Text(
                "File must be a compatible sqlite database.\nApp requires restart after import"),
            leading: const Icon(Icons.file_download_outlined),
          ),
          ListTile(
            title: const Text("Rerun the tutorial"),
            onTap: () {
              ref
                  .read(entriesTutorialCompletedProvider.notifier)
                  .update((state) => false);
              ref
                  .read(accountsTutorialCompletedProvider.notifier)
                  .update((state) => false);
              ref
                  .read(analysisTutorialCompletedProvider.notifier)
                  .update((state) => false);
              Navigator.of(context).pushNamedAndRemoveUntil(
                "/welcome",
                (route) => false,
              );
            },
          )
        ],
      ),
    );
  }
}
