import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:graphic/graphic.dart";
import "package:intl/intl.dart";
import "package:moniz/data/SimpleStore/basicStore.dart";
import "package:moniz/data/SimpleStore/settingsStore.dart";
import "package:moniz/data/account.dart";
import "package:moniz/data/category.dart";
import "package:moniz/data/transactions.dart";

class CategoryChart extends ConsumerStatefulWidget {
  const CategoryChart({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryChartState();
}

class _CategoryChartState extends ConsumerState<CategoryChart>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool showCat = true;
  late List<PieChartSectionData> data;
  late Widget _legend;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    (List, Map<String, double>) spendsByCat() {
      List<Transaction> transactionList = ref.watch(transactionsProvider);
      List<TransactionCategory> catergoryList = ref.watch(categoriesProvider);
      catergoryList = List.generate(catergoryList.length,
          (index) => catergoryList[ref.watch(catOrderProvider)[index]]);
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

    NumberFormat numberFormat = ref.watch(numberFormatProvider);
    _legend = Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 3,
        childAspectRatio: 2.5,
        children: spends.$2.entries.map((label) {
          var cat = spends.$1.firstWhere((element) => element.id == label.key);
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        width: 3)),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    IconData(cat.iconCodepoint, fontFamily: "MaterialIcons"),
                    size: 24,
                    color: Color(cat.color),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                numberFormat.format(label.value),
                style: Theme.of(context).textTheme.bodyLarge,
              )
            ],
          );
        }).toList(),
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
            child: Chart(
              rebuild: true,
              data: spends.$2.entries
                  .map((e) => {"genre": e.key, "sold": e.value})
                  .toList(),
              variables: {
                "genre": Variable(
                  accessor: (Map map) => map["genre"] as String,
                ),
                "sold": Variable(
                  accessor: (Map map) => map["sold"] as num,
                  scale: LinearScale(min: 0),
                ),
              },
              transforms: [
                Proportion(
                  variable: "sold",
                  as: "percent",
                ),
              ],
              marks: [
                IntervalMark(
                  shape: ShapeEncode(
                      value: RectShape(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  )),
                  position: Varset("percent") / Varset("genre"),
                  color: ColorEncode(
                      variable: "genre",
                      // ? This is needed because internally the widget needs values to be >= 2 for unknown reasons
                      values:
                          spends.$1.map((e) => Color(e.color)).toList().length >
                                  1
                              ? spends.$1.map((e) => Color(e.color)).toList()
                              : [
                                  spends.$1.map((e) => Color(e.color)).first,
                                  Colors.blue
                                ]),
                  modifiers: [StackModifier()],
                  transition: Transition(
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutQuint),
                  entrance: {MarkEntrance.opacity, MarkEntrance.y},
                )
              ],
              coord: PolarCoord(
                  transposed: true,
                  dimCount: 1,
                  startRadius: 0.4,
                  endRadius: 0.9),
            ),
          ),
          const SizedBox(height: 20),
          AnimatedSwitcher(
              duration: const Duration(milliseconds: 200), child: _legend),
          // ? Provides space so that the FAB doesn't block elements
          const ListTile(
            isThreeLine: true,
            subtitle: Text(""),
          ),
        ],
      ),
    );
  }
}
