import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:moniz/components/MoneyDisplay.dart";
import "package:moniz/components/deleteRoute.dart";
import "package:moniz/data/SimpleStore/themeStore.dart";
import "package:moniz/data/account.dart";
import "package:moniz/data/category.dart";
import "package:moniz/data/transactions.dart";

class TransactionList extends ConsumerStatefulWidget {
  const TransactionList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransactionListState();
}

class _TransactionListState extends ConsumerState<TransactionList> {
  @override
  Widget build(BuildContext context) {
    final List<Transaction> transactions = ref.watch(transactionsProvider);
    // ? Convert to an AnimatedList someday
    return ListView.custom(
      physics: const NeverScrollableScrollPhysics(),
      cacheExtent: 10,
      shrinkWrap: true,
      childrenDelegate: SliverChildBuilderDelegate(
          findChildIndexCallback: (key) {
            final ValueKey<String> valueKey = key as ValueKey<String>;
            final index =
                transactions.indexWhere((m) => m.id == valueKey.value);
            return index;
          },
          childCount: transactions.length,
          (context, index) {
            final trans = transactions[index];
            final transAccount = ref
                .watch(accountsProvider)
                .firstWhere((element) => element.id == trans.accountID);
            final transCategory = ref
                .watch(categoriesProvider)
                .firstWhere((element) => element.id == trans.categoryID);
            final key = GlobalKey();
            return InkWell(
              onTap: () => handleTap(key, context, trans),
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                subtitle: Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  spacing: 4,
                  children: [
                    Text(DateFormat("EEE, d MMM yyyy K:mm a")
                        .format(trans.recorded)),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        color: ColorScheme.fromSeed(
                                seedColor: Color(transAccount.color),
                                // ? The color does not update properly, that's why I need to manually specify the brightness
                                brightness: ref.watch(brightnessProvider))
                            .primaryContainer,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 6),
                        child: Text(transAccount.name),
                      ),
                    ),
                  ],
                ),
                leading: Icon(
                  // ? The global key is attached here to prevent the entire ListView from rebuiling
                  key: key,
                  IconData(transCategory.iconCodepoint,
                      fontFamily: "MaterialIcons"),
                  color: Color(transCategory.color),
                ),
                title: Text(trans.title),
                trailing: Transform.scale(
                    scale: 0.9,
                    child: MoneyDisplay(
                        amount: trans.amount.abs(),
                        textColor: ref
                            .watch(trans.amount > 0
                                ? incomeColorSchemeProvider
                                : expenseColorSchemeProvider)
                            .primary)),
              ),
            );
          }),
    );
  }
}
