import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/components/MoneyDisplay.dart";
import "package:moniz/data/SimpleStore/basicStore.dart";
import "package:moniz/data/SimpleStore/themeStore.dart";
import "package:moniz/data/transactions.dart";
import "package:moniz/screens/entries/TransactionList.dart";

class Overview extends ConsumerStatefulWidget {
  const Overview({super.key});

  @override
  ConsumerState<Overview> createState() => _OverviewState();
}

class _OverviewState extends ConsumerState<Overview>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final List<Transaction> transactions =
        ref.watch(searchedTransProvider) ?? ref.watch(transactionsProvider);
    return SingleChildScrollView(
      controller: ref.read(scrollProvider),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Income(
                title: "Income",
                icon: Icons.file_download_outlined,
                colorProvider: incomeColorSchemeProvider,
                amountProvider: overviewIncomeProvider,
              ),
              Income(
                title: "Expense",
                icon: Icons.file_upload_outlined,
                colorProvider: expenseColorSchemeProvider,
                amountProvider: overviewExpenseProvider,
              ),
            ],
          ),
          TransactionList(transactions: transactions),
          // ? Provides space so that the FAB doesn't block the last transaction
          const ListTile(
            isThreeLine: true,
            subtitle: Text(""),
          ),
        ],
      ),
    );
  }
}

class Income extends ConsumerStatefulWidget {
  const Income(
      {super.key,
      required this.title,
      required this.icon,
      required this.colorProvider,
      required this.amountProvider});

  final String title;
  final IconData icon;

  final ProviderListenable<ColorScheme> colorProvider;
  final ProviderListenable<double> amountProvider;

  @override
  ConsumerState<Income> createState() => _IncomeState();
}

class _IncomeState extends ConsumerState<Income> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        // ? There's some extra padding coming from somewhere
        padding: const EdgeInsets.all(2.0),
        child: Card(
          color: ref.watch(widget.colorProvider).primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      widget.icon,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      widget.title.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                MoneyDisplay(
                  amount: ref.watch(widget.amountProvider),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
