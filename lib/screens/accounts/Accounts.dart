import "package:animations/animations.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/data/SimpleStore/tutorialStore.dart";
import "package:moniz/data/account.dart";
import "package:moniz/data/transactions.dart";
import "package:moniz/screens/accounts/AccountCard.dart";
import "package:moniz/screens/accounts/AccountEditor.dart";
import "package:visibility_detector/visibility_detector.dart";

class Accounts extends ConsumerStatefulWidget {
  const Accounts({super.key});

  @override
  ConsumerState<Accounts> createState() => _AccountsState();
}

class _AccountsState extends ConsumerState<Accounts>
    with AutomaticKeepAliveClientMixin {
  late final List<GlobalKey> listOfKeys;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    listOfKeys = ref.read(accountsGkListProvider);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<Account> accounts = ref.watch(accountsProvider);
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                var acc = accounts[index];
                List<Transaction> transactionList =
                    ref.watch(transactionsProvider);
                double accountIncome = 0;
                double accountExpense = 0;
                for (var trans in transactionList) {
                  if (trans.accountID == acc.id) {
                    if (trans.amount > 0) {
                      accountIncome += trans.amount;
                    } else {
                      accountExpense += trans.amount.abs();
                    }
                  }
                }
                final key = GlobalKey();
                return AccountCard(
                    key: key,
                    account: acc,
                    income: accountIncome,
                    expense: accountExpense);
              },
            ),
            VisibilityDetector(
              key: listOfKeys[0],
              onVisibilityChanged: (info) {
                // ? It is still possible to misalign this if one swipes fast enough, but that's a problem for later
                if (!ref.watch(accountsTutorialCompletedProvider)) {
                  Future.delayed(const Duration(milliseconds: 100), () {
                    if (info.visibleFraction == 1) {
                      ref.read(tutorialProvider)(context, Screen.accounts);
                      ref
                          .watch(accountsTutorialCompletedProvider.notifier)
                          .update((state) => true);
                    }
                  });
                }
              },
              child: OpenContainer(
                  closedColor: Theme.of(context).colorScheme.secondaryContainer,
                  middleColor: Theme.of(context).colorScheme.secondaryContainer,
                  openColor: Theme.of(context).colorScheme.background,
                  transitionType: ContainerTransitionType.fadeThrough,
                  closedElevation: 0,
                  openShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  closedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  closedBuilder: (context, action) => TextButton.icon(
                      onPressed: action,
                      icon: const Icon(Icons.add),
                      label: const Text("Add Account")),
                  openBuilder: (context, action) => const AccountEditor(
                        type: "Account",
                      )),
            ),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
