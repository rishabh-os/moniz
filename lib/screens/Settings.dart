import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moniz/data/SimpleStore/basicStore.dart';
import 'package:moniz/data/SimpleStore/settingsStore.dart';

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
          InkWell(
            onTap: () => showCurrencyPicker(
                context: context,
                onSelect: (e) {
                  ref
                      .watch(currencyProvider.notifier)
                      .update((state) => e.code);
                }),
            child: ListTile(
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
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () => ref.read(dbProvider).shareDB(),
            child: const ListTile(
              title: Text("Export data"),
              leading: Icon(Icons.file_upload_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
