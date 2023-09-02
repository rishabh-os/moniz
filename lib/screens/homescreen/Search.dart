import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/data/account.dart";
import "package:moniz/data/category.dart";
import "package:moniz/data/transactions.dart";

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
  @override
  Widget build(BuildContext context) {
    List<TransactionCategory> categories = ref.read(categoriesProvider);
    List<Account> accounts = ref.read(accountsProvider);
    List<Transaction> transactions = ref.read(transactionsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Search")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          TextField(
            autofocus: true,
            controller: titleController,
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                isDense: true,
                hintText: "Search",
                suffixIcon: IconButton(
                  splashRadius: 20,
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: () => titleController.clear(),
                )),
            textCapitalization: TextCapitalization.words,
            onSubmitted: (value) {},
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
                label: const Text("Category"),
                dropdownMenuEntries: categories
                    .map((e) => DropdownMenuEntry<TransactionCategory>(
                        value: e, label: e.name))
                    .toList(),
                onSelected: (TransactionCategory? category) {
                  setState(() {
                    print(category);
                  });
                },
              ),
              DropdownMenu<Account>(
                width: MediaQuery.of(context).size.width * 0.5 - 20,
                controller: accController,
                label: const Text("Account"),
                dropdownMenuEntries: accounts
                    .map((e) =>
                        DropdownMenuEntry<Account>(value: e, label: e.name))
                    .toList(),
                onSelected: (Account? account) {
                  setState(() {
                    print(account);
                  });
                },
              ),
            ],
          )
        ]),
      ),
    );
  }
}
