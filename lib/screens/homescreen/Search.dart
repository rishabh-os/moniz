import "dart:math";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/data/account.dart";
import "package:moniz/data/category.dart";
import "package:moniz/data/transactions.dart";
import "package:moniz/screens/entries/TransactionList.dart";

class Search extends ConsumerStatefulWidget {
  const Search({
    super.key,
  });

  @override
  ConsumerState<Search> createState() => _SearchState();
}

class _SearchState extends ConsumerState<Search> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController catController = TextEditingController();
  final TextEditingController accController = TextEditingController();
  TransactionCategory? selectedCategory;
  Account? selectedAccount;
  String query = "";
  late List<TransactionCategory> categories;
  late List<Account> accounts;
  late List<Transaction> allTransactions;
  late double sliderMax;
  late RangeValues rangeValues;

  @override
  void initState() {
    super.initState();
    categories = ref.read(categoriesProvider);
    accounts = ref.read(accountsProvider);
    allTransactions = ref.read(allTransProvider).reversed.toList();
    sliderMax = allTransactions.map<double>((e) => e.amount.abs()).reduce(max);
    rangeValues = RangeValues(0, sliderMax);
  }

  @override
  Widget build(BuildContext context) {
    var transResults = allTransactions
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
    return Scaffold(
      appBar: AppBar(title: const Text("Search")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
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
                    hintText: "Search",
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
                child: Text("Amount",
                    style: Theme.of(context).textTheme.bodyLarge)),
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
            TransactionList(
                transactions: transResults.length == allTransactions.length
                    ? []
                    : transResults)
          ]),
        ),
      ),
    );
  }
}
