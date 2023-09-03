import "package:animations/animations.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/data/account.dart";
import "package:moniz/data/transactions.dart";
import "package:moniz/screens/manage/AccountCard.dart";
import "package:moniz/screens/manage/AccountEditor.dart";

class Accounts extends ConsumerStatefulWidget {
  const Accounts({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountsState();
}

class _AccountsState extends ConsumerState<Accounts> {
  @override
  Widget build(BuildContext context) {
    List<Account> accounts = ref.watch(accountsProvider);
    return Column(
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: accounts.length,
          itemBuilder: (context, index) {
            var acc = accounts[index];
            List<Transaction> transactionList = ref.watch(transactionsProvider);
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
        OpenContainer(
            closedColor: Theme.of(context).colorScheme.secondaryContainer,
            middleColor: Theme.of(context).colorScheme.secondaryContainer,
            openColor: Theme.of(context).colorScheme.background,
            transitionType: ContainerTransitionType.fadeThrough,
            closedElevation: 0,
            openShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            closedShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            closedBuilder: (context, action) => TextButton.icon(
                onPressed: action,
                icon: const Icon(Icons.add),
                label: const Text("Add Account")),
            openBuilder: (context, action) => const AccountEditor(
                  type: "Account",
                )),
      ],
    );
  }
}
