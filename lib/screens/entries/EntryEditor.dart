import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/components/DateTimePickers.dart";
import "package:moniz/components/input/AmountField.dart";
import "package:moniz/components/input/ChipSelector.dart";
import "package:moniz/components/input/Header.dart";
import "package:moniz/components/input/Location.dart";
import "package:moniz/components/input/SaveFAB.dart";
import "package:moniz/components/input/deleteFunctions.dart";
import "package:moniz/data/SimpleStore/settingsStore.dart";
import "package:moniz/data/SimpleStore/themeStore.dart";
import "package:moniz/data/account.dart";
import "package:moniz/data/api/response.dart";
import "package:moniz/data/category.dart";
import "package:moniz/data/transactions.dart";
import "package:uuid/uuid.dart";

class EntryEditor extends ConsumerStatefulWidget {
  const EntryEditor({
    super.key,
    this.transaction,
  });

  final Transaction? transaction;

  @override
  ConsumerState<EntryEditor> createState() => _EntryEditorState();
}

class _EntryEditorState extends ConsumerState<EntryEditor> {
  List<String> entryTypeStrings = ["Income", "Expense"];
  int _entryType = 1;
  String _title = "Untitled";
  late TextEditingController titleController;
  int _amount = 0;
  late TextEditingController amountController;
  int _selectedCategory = 0;
  int _selectedAccount = 0;
  String appBarTitle = "Add";
  // ? These are initialized when their respective widgets are built
  late TimeOfDay _selectedTime = TimeOfDay.now();
  late DateTime _selectedDate = DateTime.now();
  late List<Account> accounts;
  late List<TransactionCategory> categories;
  String? _additionalInfo;
  GMapsPlace? _selectedLocation;
  late TextEditingController addInfoController;
  late Function(Transaction transaction) saveAction;
  List<Widget> actions = [];

  @override
  void initState() {
    super.initState();
    accounts = ref.read(accountsProvider);
    categories = ref.read(categoriesProvider);

    saveAction = (transaction) {
      ref.read(transactionsProvider.notifier).add(transaction);

      // ? Update account balance on add
      final targetAccount =
          accounts.firstWhere((element) => element.id == transaction.accountID);
      ref.read(accountsProvider.notifier).edit(
            targetAccount.copyWith(
              balance: targetAccount.balance + transaction.amount,
            ),
          );
    };

    if (widget.transaction != null) {
      appBarTitle = "Edit";
      actions = deleteAction(() {
        void deleteTransaction() {
          ref
              .read(transactionsProvider.notifier)
              .delete(widget.transaction!.id);
          Navigator.of(context).pop();
          // ? Update account balance on delete
          final targetAccount = accounts.firstWhere(
            (element) => element.id == widget.transaction!.accountID,
          );
          ref.read(accountsProvider.notifier).edit(
                targetAccount.copyWith(
                  balance: targetAccount.balance - widget.transaction!.amount,
                ),
              );
        }

        ref.watch(transDeleteProvider)
            ? showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  // title: const Text("Are you sure?"),
                  content: const Text(
                    "Are you sure you want to delete this transaction?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        deleteTransaction();
                        Navigator.of(context).pop();
                      },
                      child: const Text("Yes"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("No"),
                    ),
                  ],
                ),
              )
            : deleteTransaction();
      });
      _entryType = widget.transaction!.amount > 0 ? 0 : 1;
      _title = widget.transaction!.title;
      _amount = widget.transaction!.amount.abs();
      // ? This complicated code brought to you by having to store only the id in the database

      _selectedCategory = categories.indexOf(
        categories.firstWhere(
          (element) => element.id == widget.transaction!.categoryID,
        ),
      );
      _selectedAccount = accounts.indexOf(
        accounts.firstWhere(
          (element) => element.id == widget.transaction!.accountID,
        ),
      );
      _selectedDate = widget.transaction!.recorded;
      _selectedTime = TimeOfDay(
        hour: widget.transaction!.recorded.hour,
        minute: widget.transaction!.recorded.minute,
      );
      _additionalInfo = widget.transaction!.additionalInfo;
      _selectedLocation = widget.transaction!.location;
      saveAction = (transaction) {
        ref.read(transactionsProvider.notifier).edit(transaction);
        // ? Handle all the cases when the transaction is edited
        final targetAccount = accounts
            .firstWhere((element) => element.id == transaction.accountID);
        final oldTransaction = ref
            .read(transactionsProvider)
            .firstWhere((element) => element.id == transaction.id);
        final oldAccount = accounts
            .firstWhere((element) => element.id == oldTransaction.accountID);
        if (oldTransaction.accountID == transaction.accountID) {
          final changedAmount = transaction.amount - oldTransaction.amount;
          ref.read(accountsProvider.notifier).edit(
                targetAccount.copyWith(
                  balance: targetAccount.balance + changedAmount,
                ),
              );
        } else {
          ref.read(accountsProvider.notifier).edit(
                oldAccount.copyWith(
                  balance: oldAccount.balance - oldTransaction.amount,
                ),
              );
          ref.read(accountsProvider.notifier).edit(
                targetAccount.copyWith(
                  balance: targetAccount.balance + transaction.amount,
                ),
              );
        }
      };
    }
    // ? The checks are to make sure the hints show up properly
    titleController =
        TextEditingController(text: _title == "Untitled" ? null : _title);
    addInfoController = TextEditingController(
      text: _additionalInfo == "None" ? null : _additionalInfo,
    );
    amountController = TextEditingController(
      text: _amount.toString() == "0.0" ? null : (_amount / 100).toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("$appBarTitle Entry"),
        actions: actions,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            runSpacing: 10,
            children: [
              Wrap(
                spacing: 8.0,
                children: List<Widget>.generate(
                  entryTypeStrings.length,
                  (int index) {
                    return Theme(
                      data: ThemeData(
                        useMaterial3: true,
                        colorScheme: ref.watch(
                          entryTypeStrings[index] == "Income"
                              ? incomeColorSchemeProvider
                              : expenseColorSchemeProvider,
                        ),
                      ),
                      child: ChoiceChip.elevated(
                        label: Text(
                          entryTypeStrings[index].toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        selected: _entryType == index,
                        onSelected: (bool selected) {
                          setState(() {
                            _entryType = index;
                          });
                        },
                      ),
                    );
                  },
                  growable: false,
                ).toList(),
              ),
              TextFormField(
                controller: titleController,
                onChanged: (value) {
                  _title = value;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Title",
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              AmountField(
                amountController: amountController,
                amountCallback: (amount) {
                  _amount =
                      int.parse(amount.toStringAsFixed(2).replaceAll(".", ""));
                },
              ),
              const Header(text: "Category"),
              ChipSelector(
                // ? Reorders the categories based on the order provided
                items: List.generate(
                  categories.length,
                  (index) => categories[index],
                ),
                selection: _selectedCategory,
                returnSelected: (selected) {
                  setState(() {
                    _selectedCategory = selected;
                  });
                },
              ),
              const Header(text: "Account"),
              ChipSelector(
                items: accounts,
                selection: _selectedAccount,
                returnSelected: (selected) {
                  setState(() {
                    _selectedAccount = selected;
                  });
                },
              ),
              const Header(text: "Location and Time"),
              Wrap(
                spacing: 5,
                runSpacing: 5,
                alignment: WrapAlignment.center,
                children: [
                  DatePicker(
                    initialDate: _selectedDate,
                    returnSelectedDate: (selectedDate) {
                      setState(() {
                        _selectedDate = selectedDate;
                      });
                    },
                  ),
                  TimePicker(
                    initialTime: _selectedTime,
                    returnSelectedTime: (selectedTime) {
                      setState(() {
                        _selectedTime = selectedTime;
                      });
                    },
                  ),
                  LocationPickerButton(
                    initialLocation: _selectedLocation,
                    returnSelectedLocation: (location) => {
                      setState(() {
                        _selectedLocation = location;
                      }),
                    },
                  ),
                ],
              ),
              // * Not sure why it needs to be this big, when the actual space it gives is a lot less
              const SizedBox(height: 40),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Additional Information",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: "Optional",
                ),
                controller: addInfoController,
                onChanged: (value) {
                  _additionalInfo = value;
                },
                minLines: 1,
                maxLines: 5,
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SaveFAB(
        onPressed: () {
          if (_amount == 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please enter a non zero amount")),
            );
          } else {
            final DateTime recorded = DateTime(
              _selectedDate.year,
              _selectedDate.month,
              _selectedDate.day,
              _selectedTime.hour,
              _selectedTime.minute,
            );
            // ? I use v1 because it encodes some information about the device used and the time of creation, which may be useful informaiton later for bug fixing or something
            final String uuid = widget.transaction?.id ?? const Uuid().v1();
            saveAction(
              Transaction(
                id: uuid,
                title: _title,
                additionalInfo: _additionalInfo,
                categoryID: categories[_selectedCategory].id,
                accountID: accounts[_selectedAccount].id,
                amount: _entryType == 1 ? _amount * -1 : _amount,
                recorded: recorded,
                location: _selectedLocation,
              ),
            );

            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
