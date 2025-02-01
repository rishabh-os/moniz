import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:moniz/components/MoneyDisplay.dart";
import "package:moniz/components/deleteRoute.dart";
import "package:moniz/data/SimpleStore/settingsStore.dart";
import "package:moniz/data/SimpleStore/themeStore.dart";
import "package:moniz/data/account.dart";
import "package:moniz/data/category.dart";
import "package:moniz/data/transactions.dart";

class TransactionList extends ConsumerStatefulWidget {
  const TransactionList({super.key, required this.transactions});
  final List<Transaction> transactions;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransactionListState();
}

class _TransactionListState extends ConsumerState<TransactionList> {
  @override
  Widget build(BuildContext context) {
    // ? Convert to an AnimatedList someday
    return ListView.custom(
      // physics: const NeverScrollableScrollPhysics(),
      cacheExtent: 20,
      shrinkWrap: true,
      childrenDelegate: SliverChildBuilderDelegate(
          findChildIndexCallback: (key) {
            final ValueKey<String> valueKey = key as ValueKey<String>;
            final index =
                widget.transactions.indexWhere((m) => m.id == valueKey.value);
            return index;
          },
          childCount: widget.transactions.length + 1,
          (context, index) {
            if (index == widget.transactions.length) {
              return const ListTile(
                isThreeLine: true,
                subtitle: Text(""),
              );
            }
            final trans = widget.transactions[index];

            // ? Provides space so that the FAB doesn't block the last transaction

            return TransactionListTile(transaction: trans);
          }),
    );
  }
}

class TransactionListTile extends ConsumerStatefulWidget {
  const TransactionListTile({
    super.key,
    required this.transaction,
  });
  final Transaction transaction;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransactionListTileState();
}

class _TransactionListTileState extends ConsumerState<TransactionListTile> {
  @override
  Widget build(BuildContext context) {
    final transAccount = ref
        .watch(accountsProvider)
        .firstWhere((element) => element.id == widget.transaction.accountID);
    final transCategory = ref
        .watch(categoriesProvider)
        .firstWhere((element) => element.id == widget.transaction.categoryID);
    final key = GlobalKey();
    return InkWell(
      onTap: () => handleTap(key, context, widget.transaction),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DateFormat("EEE, d MMM yyyy K:mm a")
                  .format(widget.transaction.recorded),
            ),
            const SizedBox(
              height: 4,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    color: ColorScheme.fromSeed(
                      seedColor: Color(transAccount.color),
                      // ? The color does not update properly, that's why I need to manually specify the brightness
                      brightness: ref.watch(brightnessProvider),
                    ).primaryContainer,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 6,
                    ),
                    child: Text(transAccount.name),
                  ),
                ),
                if (widget.transaction.location != null &&
                    ref.watch(showLocationProvider))
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      color: ColorScheme.fromSeed(
                        seedColor: ref.watch(themeColorProvider),
                        // ? The color does not update properly, that's why I need to manually specify the brightness
                        brightness: ref.watch(brightnessProvider),
                      ).primaryContainer,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 6,
                      ),
                      child: Text(
                        widget.transaction.location!.displayName!.text ?? "",
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                // ? The global key is attached here to prevent the entire ListView from rebuiling
                key: key,
                IconData(
                  transCategory.iconCodepoint,
                  fontFamily: "MaterialIcons",
                ),
                color: Color(transCategory.color),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Flexible(
              child: Text(
                widget.transaction.title,
              ),
            ),
          ],
        ),
        trailing: Transform.scale(
          scale: 0.9,
          child: MoneyDisplay(
            amount: widget.transaction.amount.abs(),
            textColor: ref
                .watch(
                  widget.transaction.amount > 0
                      ? incomeColorSchemeProvider
                      : expenseColorSchemeProvider,
                )
                .primary,
          ),
        ),
      ),
    );
  }
}
