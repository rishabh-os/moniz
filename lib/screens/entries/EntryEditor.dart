import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moniz/components/DateTimePickers.dart';
import 'package:moniz/components/input/AmountField.dart';
import 'package:moniz/components/input/SaveFAB.dart';
import 'package:moniz/components/input/deleteFunctions.dart';
import 'package:moniz/data/SimpleStore/settingsStore.dart';
import 'package:moniz/data/SimpleStore/themeStore.dart';
import 'package:moniz/data/account.dart';
import 'package:moniz/data/category.dart';
import 'package:moniz/data/transactions.dart';
import 'package:uuid/uuid.dart';

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
  // * Both title and addInfo should be nullable, but currently I am unable to implement this in the database, so this will have to do for now
  String _title = "Untitled";
  late TextEditingController titleController;
  double _amount = 0;
  late TextEditingController amountController;
  int _selectedCategory = 0;
  int _selectedAccount = 0;
  String appBarTitle = "Add";
  // ? These are initialized when their respective widgets are built
  late TimeOfDay _selectedTime = TimeOfDay.now();
  late DateTime _selectedDate = DateTime.now();
  late List<Account> accounts;
  late List<TransactionCategory> categories;
  String _additionalInfo = "None";
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
      var targetAccount =
          accounts.firstWhere((element) => element.id == transaction.accountID);
      ref.read(accountsProvider.notifier).edit(targetAccount.copyWith(
          balance: targetAccount.balance + transaction.amount));
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
          var targetAccount = accounts.firstWhere(
              (element) => element.id == widget.transaction!.accountID);
          ref.read(accountsProvider.notifier).edit(targetAccount.copyWith(
              balance: targetAccount.balance - widget.transaction!.amount));
        }

        ref.watch(transDeleteProvider)
            ? showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  // title: const Text("Are you sure?"),
                  content: const Text(
                      "Are you sure you want to delete this transaction?"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          deleteTransaction();
                          Navigator.of(context).pop();
                        },
                        child: const Text("Yes")),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("No"))
                  ],
                ),
              )
            : deleteTransaction();
      });
      _entryType = widget.transaction!.amount > 0 ? 0 : 1;
      _title = widget.transaction!.title;
      _amount = widget.transaction!.amount.abs();
      // ? This complicated code brought to you by having to store only the name in the database
      _selectedCategory = categories.indexOf(categories.firstWhere(
          (element) => element.id == widget.transaction!.categoryID));
      _selectedAccount = accounts.indexOf(accounts.firstWhere(
          (element) => element.id == widget.transaction!.accountID));
      _selectedDate = widget.transaction!.recorded;
      _selectedTime = TimeOfDay(
          hour: widget.transaction!.recorded.hour,
          minute: widget.transaction!.recorded.minute);
      _additionalInfo = widget.transaction!.additionalInfo;
      saveAction = (transaction) {
        ref.read(transactionsProvider.notifier).edit(transaction);
        // ? Handle all the cases when the transaction is edited
        var targetAccount = accounts
            .firstWhere((element) => element.id == transaction.accountID);
        var oldTransaction = ref
            .read(transactionsProvider)
            .firstWhere((element) => element.id == transaction.id);
        var oldAccount = accounts
            .firstWhere((element) => element.id == oldTransaction.accountID);
        if (oldTransaction.accountID == transaction.accountID) {
          var changedAmount = transaction.amount - oldTransaction.amount;
          ref.read(accountsProvider.notifier).edit(targetAccount.copyWith(
              balance: targetAccount.balance + changedAmount));
        } else {
          ref.read(accountsProvider.notifier).edit(oldAccount.copyWith(
              balance: oldAccount.balance - oldTransaction.amount));
          ref.read(accountsProvider.notifier).edit(targetAccount.copyWith(
              balance: targetAccount.balance + transaction.amount));
        }
      };
    }
    // ? The checks are to make sure the hints show up properly
    titleController =
        TextEditingController(text: _title == "Untitled" ? null : _title);
    addInfoController = TextEditingController(
        text: _additionalInfo == "None" ? null : _additionalInfo);
    amountController = TextEditingController(
        text: _amount.toString() == "0.0" ? null : _amount.toString());
  }

  // IconButton deleteAction() {
  //   return IconButton.filledTonal(
  //     onPressed: () {
  //       void deleteTransaction() {
  //         ref
  //             .read(transactionsProvider.notifier)
  //             .deleteTransaction(widget.transaction!.id);
  //         Navigator.of(context).pop();
  //         // ? Update account balance on delete
  //         var targetAccount = accounts.firstWhere(
  //             (element) => element.id == widget.transaction!.accountID);
  //         ref.read(accountsProvider.notifier).editAccount(
  //             targetAccount.copyWith(
  //                 balance: targetAccount.balance - widget.transaction!.amount));
  //       }

  //       ref.watch(transDeleteProvider)
  //           ? showDialog(
  //               context: context,
  //               builder: (context) => AlertDialog(
  //                 // title: const Text("Are you sure?"),
  //                 content: const Text(
  //                     "Are you sure you want to delete this transaction?"),
  //                 actions: [
  //                   TextButton(
  //                       onPressed: () {
  //                         deleteTransaction();
  //                         Navigator.of(context).pop();
  //                       },
  //                       child: const Text("Yes")),
  //                   TextButton(
  //                       onPressed: () {
  //                         Navigator.of(context).pop();
  //                       },
  //                       child: const Text("No"))
  //                 ],
  //               ),
  //             )
  //           : deleteTransaction();
  //     },
  //     icon: const Icon(Icons.delete_forever_rounded),
  //     tooltip: "Delete entry",
  //   );
  // }

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
                children:
                    List<Widget>.generate(entryTypeStrings.length, (int index) {
                  return Theme(
                    data: ThemeData(
                        useMaterial3: true,
                        colorScheme: ref.watch(
                            entryTypeStrings[index] == "Income"
                                ? incomeColorSchemeProvider
                                : expenseColorSchemeProvider)),
                    child: ChoiceChip(
                      label: Text(
                        entryTypeStrings[index].toUpperCase(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      selected: _entryType == index,
                      onSelected: (bool selected) {
                        setState(() {
                          _entryType = index;
                        });
                      },
                    ),
                  );
                }, growable: false)
                        .toList(),
              ),
              TextFormField(
                controller: titleController,
                onChanged: (value) {
                  _title = value;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              AmountField(
                amountController: amountController,
                amountCallback: (amount) => _amount = amount,
              ),
              // ? This Center widget is technically not needed since both widgets
              // ? above and below it are too big to fit in a single line
              Center(
                child: Text("Category".toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    )),
              ),
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children:
                      List<Widget>.generate(categories.length, (int index) {
                    TransactionCategory cat = categories[index];
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ChoiceChip(
                        label: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          children: [
                            Icon(
                              IconData(cat.iconCodepoint,
                                  fontFamily: 'MaterialIcons'),
                              color: Color(cat.color),
                            ),
                            Text(categories[index].name),
                          ],
                        ),
                        selected: _selectedCategory == index,
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedCategory = index;
                          });
                        },
                      ),
                    );
                  }, growable: false)
                          .toList(),
                ),
              ),
              Center(
                child: Text("Account".toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    )),
              ),
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List<Widget>.generate(accounts.length, (int index) {
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ChoiceChip(
                        label: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          children: [
                            Icon(
                              IconData(accounts[index].iconCodepoint,
                                  fontFamily: 'MaterialIcons'),
                              color: Color(accounts[index].color),
                            ),
                            Text(accounts[index].name),
                          ],
                        ),
                        selected: _selectedAccount == index,
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedAccount = index;
                          });
                        },
                      ),
                    );
                  }, growable: false)
                      .toList(),
                ),
              ),
              Center(
                child: Text("Date and time".toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    )),
              ),
              Wrap(
                spacing: 5,
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
                  )
                ],
              ),
              // * Not sure why it needs to be this big, when the actual space it gives is a lot less
              const SizedBox(height: 40),
              TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Additional Information',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Optional"),
                controller: addInfoController,
                onChanged: (value) {
                  _additionalInfo = value;
                },
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
              const SnackBar(content: Text('Please enter a non zero amount')),
            );
          } else {
            DateTime recorded = DateTime(
                _selectedDate.year,
                _selectedDate.month,
                _selectedDate.day,
                _selectedTime.hour,
                _selectedTime.minute);
            // ? I use v1 because it encodes some information about the device used and the time of creation, which may be useful informaiton later for bug fixing or something
            final String uuid = widget.transaction?.id ?? const Uuid().v1();
            saveAction(Transaction(
                id: uuid,
                title: _title,
                additionalInfo: _additionalInfo,
                categoryID: categories[_selectedCategory].id,
                accountID: accounts[_selectedAccount].id,
                amount: _entryType == 1 ? _amount * -1 : _amount,
                recorded: recorded));

            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
