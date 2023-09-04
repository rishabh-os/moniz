import "dart:math";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/data/account.dart";
import "package:moniz/data/category.dart";
import "package:moniz/data/transactions.dart";

class Filters extends ConsumerStatefulWidget {
  const Filters({
    super.key,
  });

  @override
  ConsumerState<Filters> createState() => _FiltersState();
}

class _FiltersState extends ConsumerState<Filters> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController catController = TextEditingController();
  final TextEditingController accController = TextEditingController();
  TransactionCategory? selectedCategory;
  Account? selectedAccount;
  String query = "";
  late List<TransactionCategory> categories;
  late List<Account> accounts;
  late List<Transaction> transactions;
  late double sliderMax;
  late RangeValues rangeValues;

  @override
  void initState() {
    super.initState();
    categories = ref.read(categoriesProvider);
    accounts = ref.read(accountsProvider);
    transactions = ref.read(transactionsProvider);
    sliderMax = transactions.map<double>((e) => e.amount.abs()).reduce(max);
    rangeValues = RangeValues(0, sliderMax);
  }

  @override
  Widget build(BuildContext context) {
    var transResults = transactions
        .where((element) => query != ""
            ? element.title.toLowerCase().contains(query.toLowerCase()) ||
                element.additionalInfo
                    .toLowerCase()
                    .contains(query.toLowerCase())
            : true)
        .where((element) =>
            rangeValues.start <= element.amount.abs() &&
            element.amount.abs() <= rangeValues.end)
        .where((element) => selectedCategory != null
            ? element.categoryID == selectedCategory!.id
            : true)
        .where((element) => selectedAccount != null
            ? element.accountID == selectedAccount!.id
            : true)
        .toList();
    Future.delayed(const Duration(milliseconds: 0), () {
      ref.read(searchedTransProvider.notifier).state = transResults;
    });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextField(
            controller: titleController,
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                isDense: true,
                hintText: "Search by title and info",
                suffixIcon: IconButton(
                  splashRadius: 20,
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: () {
                    titleController.clear();
                    setState(() {
                      query = "";
                    });
                  },
                )),
            textCapitalization: TextCapitalization.words,
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  query = value;
                });
              }
            },
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          alignment: WrapAlignment.spaceEvenly,
          children: [
            DropdownMenu<TransactionCategory>(
              // ? Manual width because using expanded doesn't work
              width: MediaQuery.of(context).size.width * 0.5 - 20,
              controller: catController,
              inputDecorationTheme: const InputDecorationTheme(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              label: const Text("Category"),
              dropdownMenuEntries: categories
                  .map((e) => DropdownMenuEntry<TransactionCategory>(
                      value: e, label: e.name))
                  .toList(),
              onSelected: (TransactionCategory? category) {
                setState(() {
                  selectedCategory = category;
                });
              },
            ),
            DropdownMenu<Account>(
              width: MediaQuery.of(context).size.width * 0.5 - 20,
              controller: accController,
              label: const Text("Account"),
              inputDecorationTheme: const InputDecorationTheme(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              dropdownMenuEntries: accounts
                  .map((e) =>
                      DropdownMenuEntry<Account>(value: e, label: e.name))
                  .toList(),
              onSelected: (Account? account) {
                setState(() {
                  selectedAccount = account;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        Center(
            child:
                Text("Amount", style: Theme.of(context).textTheme.bodyLarge)),
        SliderTheme(
          data: const SliderThemeData(
            showValueIndicator: ShowValueIndicator.always,
          ),
          child: RangeSlider(
            min: 0,
            max: sliderMax,
            values: rangeValues,
            onChanged: (value) {
              setState(() {
                rangeValues = value;
              });
            },
            labels: RangeLabels(
              rangeValues.start.round().toString(),
              rangeValues.end.round().toString(),
            ),
          ),
        ),
        TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.undo),
            label: const Text("Reset all"))
      ]),
    );
  }
}
