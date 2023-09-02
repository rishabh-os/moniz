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

  @override
  Widget build(BuildContext context) {
    List<TransactionCategory> categories = ref.read(categoriesProvider);
    List<Account> accounts = ref.read(accountsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Search")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
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
                      selectedCategory = category;
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
                      selectedAccount = account;
                    });
                  },
                ),
              ],
            ),
            TransactionList(
                transactions: ref
                    .read(allTransProvider)
                    .where((element) => query != ""
                        ? element.title
                                .toLowerCase()
                                .contains(query.toLowerCase()) ||
                            element.additionalInfo
                                .toLowerCase()
                                .contains(query.toLowerCase())
                        : false)
                    .where((element) => selectedCategory != null
                        ? element.categoryID == selectedCategory!.id
                        : true)
                    .where((element) => selectedAccount != null
                        ? element.accountID == selectedAccount!.id
                        : true)
                    .toList())
          ]),
        ),
      ),
    );
  }
}
