import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/data/SimpleStore/filterStore.dart";
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
  late TransactionCategory? selectedCategory;
  late Account? selectedAccount;
  late String filterQuery;
  late List<TransactionCategory> categories;
  late List<Account> accounts;
  late List<Transaction> transactions;
  late RangeValues rangeValues;
  Map<double, int> frequencyHistorgram = {};
  List<double> freqKeys = [];
  @override
  void initState() {
    super.initState();
    // ? This is a bit hacky and there probably is a better way to do this
    frequencyHistorgram = ref.read(freqHistProvider);
    rangeValues = RangeValues(0, frequencyHistorgram.length.toDouble() - 1);
  }

  @override
  Widget build(BuildContext context) {
    categories = ref.watch(categoriesProvider);
    accounts = ref.watch(accountsProvider);
    transactions = ref.watch(transactionsProvider);
    filterQuery = ref.watch(filterQueryProvider);
    titleController.value = TextEditingValue(text: filterQuery);
    selectedCategory = ref.watch(filterCategoryProvider);
    selectedAccount = ref.watch(filterAccountProvider);
    frequencyHistorgram = ref.watch(freqHistProvider);
    freqKeys = ref.watch(freqKeysProvider);
    catController.value = TextEditingValue(text: selectedCategory?.name ?? "");
    accController.value = TextEditingValue(text: selectedAccount?.name ?? "");
    var transResults = transactions
        .where((element) => filterQuery != ""
            ? element.title.toLowerCase().contains(filterQuery.toLowerCase()) ||
                // ? Return true if additionalInfo is null
                (element.additionalInfo
                        ?.toLowerCase()
                        .contains(filterQuery.toLowerCase()) ??
                    true)
            : true)
        .where((element) =>
            freqKeys[rangeValues.start.toInt()] <= element.amount.abs() &&
            element.amount.abs() <= freqKeys[rangeValues.end.toInt()])
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
                    ref
                        .read(filterQueryProvider.notifier)
                        .update((state) => "");
                  },
                )),
            textCapitalization: TextCapitalization.words,
            onChanged: (value) {
              ref.read(filterQueryProvider.notifier).update((state) => value);
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
              requestFocusOnTap: true,
              controller: catController,
              inputDecorationTheme: const InputDecorationTheme(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              label: const Text("Category"),
              dropdownMenuEntries: categories
                  .map((e) => DropdownMenuEntry<TransactionCategory>(
                      value: e, label: e.name))
                  .toList(),
              onSelected: (TransactionCategory? category) => ref
                  .watch(filterCategoryProvider.notifier)
                  .update((state) => category),
            ),
            DropdownMenu<Account>(
              width: MediaQuery.of(context).size.width * 0.5 - 20,
              requestFocusOnTap: true,
              controller: accController,
              label: const Text("Account"),
              inputDecorationTheme: const InputDecorationTheme(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              dropdownMenuEntries: accounts
                  .map((e) =>
                      DropdownMenuEntry<Account>(value: e, label: e.name))
                  .toList(),
              onSelected: (Account? account) => ref
                  .watch(filterAccountProvider.notifier)
                  .update((state) => account),
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
          child: frequencyHistorgram.length > 1
              ? RangeSlider(
                  min: 0,
                  max: frequencyHistorgram.length.toDouble() - 1,
                  values: rangeValues,
                  divisions: frequencyHistorgram.length - 1,
                  onChanged: (value) {
                    setState(() {
                      rangeValues = value;
                    });
                  },
                  labels: RangeLabels(
                    freqKeys[rangeValues.start.toInt()].abs().toString(),
                    freqKeys[rangeValues.end.toInt()].abs().toString(),
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text("Not enough data to show a range slider"),
                ),
        ),
        TextButton.icon(
            onPressed: () {
              // ref
              //     .read(rangeProvider.notifier)
              //     .update((state) => RangeValues(0, sliderMax));
              ref.read(filterQueryProvider.notifier).update((state) => "");
              ref.read(filterCategoryProvider.notifier).update((state) => null);
              ref.watch(filterAccountProvider.notifier).update((state) => null);
            },
            icon: const Icon(Icons.undo),
            label: const Text("Reset all"))
      ]),
    );
  }
}
