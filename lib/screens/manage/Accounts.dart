import "package:animations/animations.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/data/account.dart";
import "package:moniz/screens/manage/AccountCard.dart";
import "package:moniz/screens/manage/AccountEditor.dart";
import "package:moniz/screens/manage/Categories.dart";

class Accounts extends ConsumerStatefulWidget {
  const Accounts({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountsState();
}

class _AccountsState extends ConsumerState<Accounts> {
  @override
  Widget build(BuildContext context) {
    final List<Account> accounts = ref.watch(accountsProvider);
    return Column(
      children: [
        ReorderableListView.builder(
          onReorder: (oldIndex, newIndex) => {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final item = accounts.removeAt(oldIndex);
              accounts.insert(newIndex, item);
              for (int i = 0; i < accounts.length; i++) {
                ref
                    .read(accountsProvider.notifier)
                    .edit(accounts[i].copyWith(order: i));
              }
            }),
          },
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          buildDefaultDragHandles: false,
          proxyDecorator: proxyDecorator,
          itemCount: accounts.length,
          itemBuilder: (context, index) {
            final acc = accounts[index];
            final key = GlobalObjectKey(acc.id);
            return AccountCard(globalKey: key, account: acc);
          },
        ),
        const SizedBox(height: 8),
        OpenContainer(
          closedColor: Theme.of(context).colorScheme.secondaryContainer,
          middleColor: Theme.of(context).colorScheme.secondaryContainer,
          openColor: Theme.of(context).colorScheme.surface,
          transitionType: ContainerTransitionType.fadeThrough,
          closedElevation: 0,
          openShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          closedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          closedBuilder: (context, action) => TextButton.icon(
            onPressed: action,
            icon: const Icon(Icons.add),
            label: const Text("Add Account"),
          ),
          openBuilder: (context, action) =>
              const AccountEditor(type: "Account"),
        ),
      ],
    );
  }
}
