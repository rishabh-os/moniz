import "dart:math";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:moniz/data/SimpleStore/settingsStore.dart";
import "package:moniz/data/account.dart";
import "package:moniz/data/category.dart";
import "package:moniz/data/transactions.dart";

class CategoryChart extends ConsumerStatefulWidget {
  const CategoryChart({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryChartState();
}

class _CategoryChartState extends ConsumerState<CategoryChart> {
  bool showCat = true;
  late List<PieChartSectionData> data;
  late Widget _legend;

  @override
  Widget build(BuildContext context) {
    final double smallestLength = min(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    final totalSize = smallestLength * 0.3;
    final centerRadius = totalSize * 0.5;
    (List, Map<String, double>) spendsByCat() {
      List<Transaction> transactionList = ref.watch(transactionsProvider);
      List<TransactionCategory> catergoryList = ref.watch(categoriesProvider);
      // ? Init a dict with spends from all categories
      Map<String, double> spendsByCat = {
        for (var v in catergoryList) v.id: 0.0
      };
      for (var trans in transactionList) {
        if (trans.amount < 0) {
          spendsByCat.update(trans.categoryID,
              (value) => spendsByCat[trans.categoryID]! + trans.amount.abs());
        }
      }
      return (catergoryList, spendsByCat);
    }

    (List, Map<String, double>) spendsByAcc() {
      List<Transaction> transactionList = ref.watch(transactionsProvider);
      List<Account> accountList = ref.watch(accountsProvider);
      // ? Init a dict with spends from all categories
      Map<String, double> spendsByAcc = {for (var v in accountList) v.id: 0.0};
      for (var trans in transactionList) {
        if (trans.amount < 0) {
          spendsByAcc.update(trans.accountID,
              (value) => spendsByAcc[trans.accountID]! + trans.amount.abs());
        }
      }
      return (accountList, spendsByAcc);
    }

    var spends = showCat ? spendsByCat() : spendsByAcc();
    data = spends.$2.entries.map((e) {
      var cat = spends.$1.firstWhere((element) => element.id == e.key);
      return PieChartSectionData(
          // ? If null it shows the value by default
          title: "",
          badgeWidget: Icon(
            IconData(cat.iconCodepoint, fontFamily: "MaterialIcons"),
            color: Color(cat.color),
          ),
          badgePositionPercentageOffset: 1.4,
          value: e.value,
          radius: totalSize - centerRadius,
          color: Color(cat.color));
    }).toList();
    // ? This puts the largest spends first
    data = data.reversed.toList();

    NumberFormat numberFormat = ref.watch(numberFormatProvider);
    _legend = SizedBox(
      height: 100,
      key: Key(showCat.toString()),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          runAlignment: WrapAlignment.start,
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceEvenly,
          spacing: 16,
          children: data
              .map((label) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.square_rounded,
                        color: label.color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        numberFormat.format(label.value),
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    ],
                  ))
              .toList(),
        ),
      ),
    );

    // ? AspectRatio prevents overflow errors in a Column
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Show spends by",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(width: 5),
            DropdownButton(
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.center,
                borderRadius: BorderRadius.circular(15),
                underline: Container(),
                value: showCat.toString(),
                items: [true, false].map<DropdownMenuItem>((value) {
                  return DropdownMenuItem(
                    value: value.toString(),
                    child: Text(value ? "Category" : "Account"),
                  );
                }).toList(),
                onChanged: (e) {
                  var x = bool.parse(e!);
                  setState(() {
                    showCat = x;
                  });
                }),
          ]),
          AspectRatio(
            aspectRatio: 1.4,
            child: PieChart(
              PieChartData(
                borderData:
                    FlBorderData(show: true, border: Border.all(width: 40)),
                startDegreeOffset: 270,
                sections: data,
                centerSpaceRadius: centerRadius,
              ),
              swapAnimationCurve: Curves.easeOut,
              swapAnimationDuration: const Duration(milliseconds: 300),
            ),
          ),
          const SizedBox(height: 20),
          AnimatedSwitcher(
              duration: const Duration(milliseconds: 200), child: _legend),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
