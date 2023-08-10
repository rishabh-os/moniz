// ignore: depend_on_referenced_packages
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/components/input/AmountField.dart";
import "package:moniz/components/input/Header.dart";
import "package:moniz/components/input/SaveFAB.dart";
import "package:moniz/data/category.dart";

class Budget extends ConsumerStatefulWidget {
  const Budget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BudgetState();
}

class _BudgetState extends ConsumerState<Budget> {
  bool isMonthly = true;
  late bool weekStartsMonday;
  double _totalBudget = 0.0;
  double _catBudget = 0.0;
  late TextEditingController amountController;
  @override
  void initState() {
    super.initState();
    amountController = TextEditingController(
        text:
            _totalBudget.toString() == "0.0" ? null : _totalBudget.toString());
    DateTime today = DateTime.now();
    var firstDayOfTheweek = today.subtract(Duration(days: today.weekday));
    weekStartsMonday = firstDayOfTheweek.weekday == DateTime.monday;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Budget"),
      ),
      body: Column(
        children: [
          const Header(text: "Set a budget for a regular interval"),
          DropdownButton(
            items: const [
              DropdownMenuItem(
                value: true,
                child: Text("Monthly"),
              ),
              DropdownMenuItem(
                value: false,
                child: Text("Weekly"),
              )
            ],
            value: isMonthly,
            onChanged: (value) {
              setState(() {
                isMonthly = value!;
              });
            },
          ),
          if (!isMonthly)
            ListTile(
              title: const Text("Week starts on"),
              trailing: DropdownButton(
                items: const [
                  DropdownMenuItem(
                    value: true,
                    child: Text("Monday"),
                  ),
                  DropdownMenuItem(
                    value: false,
                    child: Text("Sunday"),
                  )
                ],
                value: weekStartsMonday,
                onChanged: (value) {
                  setState(() {
                    weekStartsMonday = value!;
                  });
                },
              ),
            ),
          AmountField(
            amountController: amountController,
            amountCallback: (amount) => _totalBudget = amount,
          ),
          const Header(text: "Set a budget for each category (optional)"),
          CategoryBudgetList(returnTotalCatBud: (total) => _catBudget = total),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SaveFAB(onPressed: () {
        if (_catBudget > _totalBudget) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Category budgets cannot exceed the total budget"),
          ));
        }
      }),
    );
  }
}

class CategoryBudgetList extends ConsumerStatefulWidget {
  const CategoryBudgetList({super.key, required this.returnTotalCatBud});
  final Function(double total) returnTotalCatBud;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CategoryBudgetListState();
}

class _CategoryBudgetListState extends ConsumerState<CategoryBudgetList> {
  late final List<TransactionCategory> categories;
  late List<CategoryBudget> o;

  @override
  void initState() {
    super.initState();
    categories = ref.read(categoriesProvider);
    o = categories.map((e) => CategoryBudget(e, false, 0)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ...o.map(
        (e) {
          if (!e.isBudgeted) {
            e.amount = 0;
            widget.returnTotalCatBud(o.map((e) => e.amount).toList().sum);
          }
          return ListTile(
              leading: Checkbox(
                value: e.isBudgeted,
                onChanged: (bool? newValue) {
                  setState(() {
                    e.isBudgeted = newValue!;
                  });
                },
              ),
              title: Text(e.category.name),
              trailing: SizedBox(
                  width: 100,
                  child: TextField(
                    enabled: e.isBudgeted,
                    controller:
                        TextEditingController(text: e.amount.toString()),
                    onChanged: (value) {
                      e.amount = double.parse(value);

                      widget.returnTotalCatBud(
                          o.map((e) => e.amount).toList().sum);
                    },
                  )));
        },
      ).toList()
    ]);
  }
}

class CategoryBudget {
  TransactionCategory category;
  bool isBudgeted;
  double amount;
  CategoryBudget(this.category, this.isBudgeted, this.amount);
}
