import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/components/input/Header.dart";
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
  final TextEditingController accController = TextEditingController();
  late List<TransactionCategory> selectedCategories;
  late List<Account> selectedAccounts;
  late String filterQuery;
  late List<TransactionCategory> categories;
  late List<Account> accounts;
  late List<Transaction> transactions;
  late RangeValues rangeValues;
  late Map<double, int> frequencyHistorgram;
  List<double> freqKeys = [];

  @override
  Widget build(BuildContext context) {
    categories = ref.watch(categoriesProvider);
    accounts = ref.watch(accountsProvider);
    transactions = ref.watch(transactionsProvider);
    filterQuery = ref.watch(filterQueryProvider);
    titleController.value = TextEditingValue(text: filterQuery);
    selectedCategories = ref.watch(filteredCategoriesProvider);
    selectedAccounts = ref.watch(filteredAccountsProvider);
    frequencyHistorgram = ref.watch(freqHistProvider);
    freqKeys = ref.watch(freqKeysProvider);
    rangeValues = ref.watch(rangeValueProvider);
    final transResults = transactions
        .where(
          (element) => filterQuery != ""
              ? element.title
                      .toLowerCase()
                      .contains(filterQuery.toLowerCase()) ||
                  // ? Return true if additionalInfo is null
                  (element.additionalInfo
                          ?.toLowerCase()
                          .contains(filterQuery.toLowerCase()) ??
                      false)
              : true,
        )
        .where(
          (element) =>
              freqKeys[rangeValues.start.toInt()] <= element.amount.abs() &&
              element.amount.abs() <= freqKeys[rangeValues.end.toInt()],
        )
        .where(
          (element) => selectedCategories.isNotEmpty
              ? selectedCategories.map((e) => e.id).contains(element.categoryID)
              : true,
        )
        .where(
          (element) => selectedAccounts.isNotEmpty
              ? selectedAccounts.map((e) => e.id).contains(element.accountID)
              : true,
        )
        .toList();
    Future.delayed(Duration.zero, () {
      ref.read(searchedTransProvider.notifier).state = transResults;
    });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
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
                ),
              ),
              textCapitalization: TextCapitalization.words,
              onChanged: (value) {
                ref.read(filterQueryProvider.notifier).update((state) => value);
              },
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              const Header(text: "Categories"),
              ...categories.map(
                (e) => FilterChip(
                  showCheckmark: false,
                  label: Text(e.name),
                  selectedShadowColor: Color(e.color),
                  elevation: 4,
                  onSelected: (value) {
                    setState(() {
                      value
                          ? selectedCategories.add(e)
                          : selectedCategories.remove(e);
                    });
                  },
                  selected: selectedCategories.contains(e),
                ),
              ),
              const Header(text: "Accounts"),
              ...accounts.map(
                (e) => FilterChip(
                  showCheckmark: false,
                  label: Text(e.name),
                  selectedShadowColor: Color(e.color),
                  elevation: 4,
                  onSelected: (value) {
                    setState(() {
                      value
                          ? selectedAccounts.add(e)
                          : selectedAccounts.remove(e);
                    });
                  },
                  selected: selectedAccounts.contains(e),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Center(
            child: Text("Amount", style: Theme.of(context).textTheme.bodyLarge),
          ),
          SliderTheme(
            data: const SliderThemeData(
              showValueIndicator: ShowValueIndicator.always,
            ),
            child: frequencyHistorgram.length > 1
                ? RangeSlider(
                    max: frequencyHistorgram.length.toDouble() - 1,
                    values: rangeValues,
                    divisions: frequencyHistorgram.length - 1,
                    onChanged: (value) {
                      ref
                          .watch(rangeValueProvider.notifier)
                          .update((state) => value);
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
              ref.read(filterQueryProvider.notifier).update((state) => "");
              ref
                  .read(filteredCategoriesProvider.notifier)
                  .update((state) => []);
              ref
                  .watch(filteredAccountsProvider.notifier)
                  .update((state) => []);
              setState(() {
                rangeValues =
                    RangeValues(0, frequencyHistorgram.length.toDouble() - 1);
              });
            },
            icon: const Icon(Icons.undo),
            label: const Text("Reset all"),
          ),
        ],
      ),
    );
  }
}
