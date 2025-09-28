import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/components/input/Header.dart";
import "package:moniz/data/SimpleStore/filterStore.dart";
import "package:moniz/data/account.dart";
import "package:moniz/data/category.dart";

class Filters extends ConsumerStatefulWidget {
  const Filters({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FiltersState();
}

class _FiltersState extends ConsumerState<Filters> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController accController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final List<TransactionCategory> categories = ref.watch(categoriesProvider);
    final List<Account> accounts = ref.watch(accountsProvider);
    final String filterQuery = ref.watch(filterQueryProvider);
    titleController.value = TextEditingValue(text: filterQuery);
    final Map<double, int> frequencyHistorgram = ref.watch(freqHistProvider);
    final List<double> freqKeys = ref.watch(freqKeysProvider);
    final RangeValues rangeValues = ref.watch(rangeValueProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 40),
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
              const Header(text: "Amount"),
              SliderTheme(
                data: const SliderThemeData(
                  showValueIndicator: ShowValueIndicator.onDrag,
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
                  ref.watch(rangeValueProvider.notifier).state = RangeValues(
                    0,
                    frequencyHistorgram.length.toDouble() - 1,
                  );
                },
                icon: const Icon(Icons.undo),
                label: const Text("Reset all"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
