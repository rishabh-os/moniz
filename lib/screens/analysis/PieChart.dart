import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:graphic/graphic.dart";
import "package:intl/intl.dart";
import "package:moniz/data/SimpleStore/settingsStore.dart";
import "package:moniz/data/account.dart";
import "package:moniz/data/category.dart";
import "package:moniz/data/transactions.dart";
import "package:moniz/screens/analysis/Analysis.dart";

class PieChartData {
  final Classifier classifier;
  double amount;
  PieChartData({
    required this.classifier,
    this.amount = 0,
  });

  void add(double amount) {
    this.amount += amount;
  }
}

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
  bool showIncome = false;
  late Widget _legend;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final List<Transaction> transactionList = ref.watch(searchedTransProvider);
    List<PieChartData> spendsByClassifier(bool isCat) {
      final List<Classifier> classifierList =
          isCat ? ref.watch(categoriesProvider) : ref.watch(accountsProvider);
      final List<PieChartData> spendsByClass = [
        for (final v in classifierList) PieChartData(classifier: v),
      ];
      for (final trans in transactionList) {
        final String id = isCat ? trans.categoryID : trans.accountID;
        final bool condition = showIncome ? trans.amount > 0 : trans.amount < 0;
        if (condition) {
          spendsByClass
              .firstWhere((element) => element.classifier.id == id)
              .add(trans.amount.abs());
        }
      }
      return spendsByClass;
    }

    final List<PieChartData> spends = spendsByClassifier(showCat);
    final List<PieChartData> unsortedSpends = [...spends];
    spends.sort((e1, e2) => e2.amount.compareTo(e1.amount));

    Padding dropdownChoice(
      (String, String) values,
      bool choice,
      Function(bool x) onChange,
    ) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: DropdownButton(
          alignment: Alignment.center,
          borderRadius: BorderRadius.circular(15),
          underline: Container(),
          value: choice.toString(),
          items: [true, false].map<DropdownMenuItem>((value) {
            return DropdownMenuItem(
              value: value.toString(),
              child: Text(value ? values.$1 : values.$2),
            );
          }).toList(),
          onChanged: (e) {
            final x = bool.parse(e as String);
            onChange(x);
          },
        ),
      );
    }

    final NumberFormat numberFormat = ref.watch(numberFProvider);
    _legend = Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 3,
        childAspectRatio: 2,
        children: unsortedSpends.map((label) {
          final Classifier classifier = label.classifier;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    width: 3,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    IconData(
                      classifier.iconCodepoint,
                      fontFamily: "MaterialIcons",
                    ),
                    size: 24,
                    color: Color(classifier.color),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                numberFormat.format(label.amount),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          );
        }).toList(),
      ),
    );

    final List<Map<String, dynamic>> data = spends
        .map((e) => {"classifier": e.classifier.id, "amount": e.amount})
        .toList();
    // ? AspectRatio prevents overflow errors in a Column
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Show",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              dropdownChoice(("Income", "Expense"), showIncome, (bool x) {
                setState(() {
                  showIncome = x;
                });
              }),
              Text(
                "by",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              dropdownChoice(("Category", "Account"), showCat, (bool x) {
                setState(() {
                  showCat = x;
                });
              }),
            ],
          ),
          AspectRatio(
            aspectRatio: 1.4,
            child: data.every((e) => e["amount"] == 0)
                ? const NoData()
                : Chart(
                    rebuild: true,
                    data: data,
                    variables: {
                      "classifier": Variable(
                        accessor: (Map map) => map["classifier"] as String,
                      ),
                      "amount": Variable(
                        accessor: (Map map) => map["amount"] as num,
                        scale: LinearScale(min: 0),
                      ),
                    },
                    transforms: [
                      Proportion(
                        variable: "amount",
                        as: "percent",
                      ),
                    ],
                    marks: [
                      IntervalMark(
                        shape: ShapeEncode(
                          value: RectShape(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        position: Varset("percent") / Varset("classifier"),
                        color: ColorEncode(
                          variable: "classifier",
                          // ? This is needed because internally the widget needs values to be >= 2 for unknown reasons
                          values: spends
                                      .map((e) => Color(e.classifier.color))
                                      .toList()
                                      .length >
                                  1
                              ? spends
                                  .map((e) => Color(e.classifier.color))
                                  .toList()
                              : [
                                  spends
                                      .map((e) => Color(e.classifier.color))
                                      .first,
                                  Colors.blue,
                                ],
                        ),
                        modifiers: [StackModifier()],
                        transition: Transition(
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeOutQuint,
                        ),
                        entrance: {MarkEntrance.opacity, MarkEntrance.y},
                      ),
                    ],
                    coord: PolarCoord(
                      transposed: true,
                      dimCount: 1,
                      startRadius: 0.4,
                      endRadius: 0.9,
                    ),
                  ),
          ),
          const SizedBox(height: 20),
          _legend,
        ],
      ),
    );
  }
}
