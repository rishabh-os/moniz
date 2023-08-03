import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moniz/components/InputComponents.dart';
import 'package:moniz/data/category.dart';
import 'package:moniz/data/transactions.dart';
import 'package:moniz/components/ColorPicker.dart';
import 'package:moniz/components/IconPicker.dart';
import 'package:moniz/data/account.dart';
import 'package:uuid/uuid.dart';

class AccountEditor extends ConsumerStatefulWidget {
  const AccountEditor(
      {super.key, this.editedAccount, this.editedCategory, required this.type});
  final Account? editedAccount;
  final TransactionCategory? editedCategory;
  final String type;
  @override
  ConsumerState<AccountEditor> createState() => _AccountEditorState();
}

class _AccountEditorState extends ConsumerState<AccountEditor> {
  late String title = "Add ";
  late TextEditingController accountNameController;
  String _accountName = "";
  double _balance = 0;
  int _selectedColor = Colors.blue.value;
  int _selectedIcon = Icons.abc.codePoint;
  late TextEditingController balanceController;
  late Function saveAction;
  List<Widget> deleteItem = [];

  @override
  void initState() {
    super.initState();

    if (widget.type == "Account") {
      saveAction = ref.read(accountsProvider.notifier).addAccount;
    } else {
      saveAction = ref.read(categoriesProvider.notifier).addCategory;
    }
    title += widget.type;
    if (widget.editedAccount != null || widget.editedCategory != null) {
      title = "Edit ";
      if (widget.editedAccount != null) {
        title += "Account";
        _accountName = widget.editedAccount!.name;
        _selectedColor = widget.editedAccount!.color;
        _selectedIcon = widget.editedAccount!.iconCodepoint;
        _balance = widget.editedAccount!.balance;
        saveAction = ref.read(accountsProvider.notifier).editAccount;
        deleteItem = deleteAction(() => handleAccountDelete());
      } else {
        title += "Category";
        _accountName = widget.editedCategory!.name;
        _selectedColor = widget.editedCategory!.color;
        _selectedIcon = widget.editedCategory!.iconCodepoint;
        saveAction = ref.read(categoriesProvider.notifier).editCategory;
        deleteItem = deleteAction(() => handleCategoryDelete());
      }
    }
    accountNameController =
        TextEditingController(text: _accountName == "" ? null : _accountName);
    balanceController = TextEditingController(
        text: _balance.toString() == "0.0" ? null : _balance.toString());
  }

  void handleAccountDelete() {
    void delete() {
      ref
          .read(accountsProvider.notifier)
          .deleteAccount(widget.editedAccount!.id);
      Navigator.popUntil(context, ModalRoute.withName('/home'));
    }

    List<Transaction> transactionList = ref.watch(transactionsProvider);
    List<Transaction> acList = transactionList
        .where((e) => e.accountID == widget.editedAccount!.id)
        .toList();
    List<Account> accounts = ref.watch(accountsProvider);

    if (accounts.length == 1) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("You can't delete the last account"),
      ));
      return;
    }
    acList.isEmpty
        ? delete()
        : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                const Text("There are still transactions under this account"),
            action: SnackBarAction(
              label: "Delete",
              onPressed: () => {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Are you sure?"),
                    content: const Text(
                        "This will delete all transactions associated with this account."),
                    actions: [
                      TextButton(
                          onPressed: () {
                            for (var trans in transactionList) {
                              if (trans.accountID == widget.editedAccount!.id) {
                                ref
                                    .watch(transactionsProvider.notifier)
                                    .deleteTransaction(trans.id);
                              }
                              delete();
                            }
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
              },
            ),
          ));
  }

  void handleCategoryDelete() {
    void delete() {
      ref
          .read(categoriesProvider.notifier)
          .deleteCategory(widget.editedCategory!.id);
      Navigator.pop(context);
    }

    List<Transaction> transactionList = ref.watch(transactionsProvider);
    List<Transaction> acList = transactionList
        .where((e) => e.categoryID == widget.editedCategory!.name)
        .toList();
    List<TransactionCategory> categories = ref.watch(categoriesProvider);

    if (categories.length == 1) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("You can't delete the last account"),
      ));
      return;
    }
    acList.isEmpty
        ? delete()
        : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                const Text("There are still transactions under this account"),
            action: SnackBarAction(
              label: "Delete",
              onPressed: () => {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Are you sure?"),
                    content: const Text(
                        "This will delete all transactions associated with this account."),
                    actions: [
                      TextButton(
                          onPressed: () {
                            for (var trans in transactionList) {
                              if (trans.categoryID ==
                                  widget.editedCategory!.name) {
                                ref
                                    .watch(transactionsProvider.notifier)
                                    .deleteTransaction(trans.id);
                              }
                              delete();
                            }
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
              },
            ),
          ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: deleteItem,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 10,
          children: [
            TextFormField(
              controller: accountNameController,
              onChanged: (value) {
                _accountName = value;
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: '${widget.type} Name',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            if (widget.type == "Account") ...[
              Center(
                child: Text("Current Balance".toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    )),
              ),
              AmountField(
                amountController: balanceController,
                amountCallback: (amount) => _balance = amount,
              )
            ],
            Center(
              child: Text("${widget.type} color".toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  )),
            ),
            ColorPicker(
              colorCallback: (selectedColor) {
                setState(() {
                  _selectedColor = selectedColor.value;
                });
              },
            ),
            Center(
              child: Text("${widget.type} icon".toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  )),
            ),
            const SizedBox(
              height: 30,
            ),
            IconPicker(
              iconCodepoint: _selectedIcon,
              color: _selectedColor,
              iconCallback: (selectedIcon) {
                setState(() {
                  _selectedIcon = selectedIcon.codePoint;
                });
              },
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SaveFAB(
        onPressed: () {
          if (_accountName == "") {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please enter name')),
            );
          } else {
            if (widget.type == "Account") {
              final String uuid = widget.editedAccount?.id ?? const Uuid().v1();
              saveAction(Account(
                  id: uuid,
                  name: _accountName,
                  iconCodepoint: _selectedIcon,
                  color: _selectedColor,
                  balance: _balance));
            } else {
              final String uuid =
                  widget.editedCategory?.id ?? const Uuid().v1();
              saveAction(TransactionCategory(
                id: uuid,
                name: _accountName,
                iconCodepoint: _selectedIcon,
                color: _selectedColor,
              ));
            }
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
