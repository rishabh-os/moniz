import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/components/input/Header.dart";
import "package:moniz/data/SimpleStore/filterStore.dart";
import "package:moniz/data/account.dart";
import "package:moniz/data/category.dart";
import "package:moniz/data/transactions.dart";

class Filters extends ConsumerStatefulWidget {
  const Filters({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FiltersState();
}

class _FiltersState extends ConsumerState<Filters> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController accController = TextEditingController();
  late String filterQuery;
  late List<TransactionCategory> categories;
  late List<Account> accounts;
  late List<Transaction> transactions;
  late RangeValues rangeValues;
  late Map<double, int> frequencyHistorgram;
  late List<double> freqKeys;

  @override
  Widget build(BuildContext context) {
    categories = ref.watch(categoriesProvider);
    accounts = ref.watch(accountsProvider);
    transactions = ref.watch(transactionsProvider);
    filterQuery = ref.watch(filterQueryProvider);
    titleController.value = TextEditingValue(text: filterQuery);
    frequencyHistorgram = ref.watch(freqHistProvider);
    freqKeys = ref.watch(freqKeysProvider);
    rangeValues = ref.watch(rangeValueProvider);
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
                hintText: "Search by title, info or location name",
                suffixIcon: IconButton(
                  splashRadius: 20,
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: () {
                    ref.read(filterQueryProvider.notifier).state = "";
                  },
                ),
              ),
              textCapitalization: TextCapitalization.words,
              onChanged: (value) {
                ref.read(filterQueryProvider.notifier).state = value;
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
                          ? ref
                              .watch(filteredCategoriesProvider.notifier)
                              .add(e)
                          : ref
                              .watch(filteredCategoriesProvider.notifier)
                              .remove(e);
                    });
                  },
                  selected: ref.watch(filteredCategoriesProvider).contains(e),
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
                          ? ref.watch(filteredAccountsProvider.notifier).add(e)
                          : ref
                              .watch(filteredAccountsProvider.notifier)
                              .remove(e);
                    });
                  },
                  selected: ref.watch(filteredAccountsProvider).contains(e),
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
                      ref.watch(rangeValueProvider.notifier).state = value;
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
              ref.watch(filterQueryProvider.notifier).state = "";
              ref.watch(filteredCategoriesProvider.notifier).state = [];
              ref.watch(filteredAccountsProvider.notifier).state = [];
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
