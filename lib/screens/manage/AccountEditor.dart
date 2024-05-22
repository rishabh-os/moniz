// ignore_for_file: avoid_dynamic_calls

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/components/IconPicker.dart";
import "package:moniz/components/input/AmountField.dart";
import "package:moniz/components/input/ColorPicker.dart";
import "package:moniz/components/input/Header.dart";
import "package:moniz/components/input/SaveFAB.dart";
import "package:moniz/components/input/deleteFunctions.dart";
import "package:moniz/data/account.dart";
import "package:moniz/data/category.dart";
import "package:moniz/data/transactions.dart";
import "package:uuid/uuid.dart";

class AccountEditor extends ConsumerStatefulWidget {
  const AccountEditor({
    super.key,
    this.editedAccount,
    this.editedCategory,
    required this.type,
  });
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
      saveAction = ref.read(accountsProvider.notifier).add;
    } else {
      saveAction = ref.read(categoriesProvider.notifier).add;
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
        saveAction = ref.read(accountsProvider.notifier).edit;
        deleteItem = deleteAction(() => handleAccountDelete());
      } else {
        title += "Category";
        _accountName = widget.editedCategory!.name;
        _selectedColor = widget.editedCategory!.color;
        _selectedIcon = widget.editedCategory!.iconCodepoint;
        saveAction = ref.read(categoriesProvider.notifier).edit;
        deleteItem = deleteAction(() => handleCategoryDelete());
      }
    }
    accountNameController =
        TextEditingController(text: _accountName == "" ? null : _accountName);
    balanceController = TextEditingController(
      text: _balance.toString() == "0.0" ? null : _balance.toString(),
    );
  }

  Future<void> handleAccountDelete() async {
    void delete() {
      ref.read(accountsProvider.notifier).delete(widget.editedAccount!.id);
      Navigator.popUntil(context, ModalRoute.withName("/home"));
    }

    final List<Transaction> transactionList = await ref
        .watch(transactionsProvider.notifier)
        .loadAllTransationsFromDB();
    final List<Transaction> activeTransactions = transactionList
        .where((e) => e.accountID == widget.editedAccount!.id)
        .toList();
    final List<Account> accounts = ref.watch(accountsProvider);
    if (!mounted) return;
    if (accounts.length == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You can't delete the last account"),
        ),
      );
      return;
    }
    activeTransactions.isEmpty
        ? delete()
        : ScaffoldMessenger.of(context).showSnackBar(
            deleteSnack(
              context,
              widget.type,
              () {
                for (final trans in transactionList) {
                  if (trans.accountID == widget.editedAccount!.id) {
                    ref.watch(transactionsProvider.notifier).delete(trans.id);
                  }
                  delete();
                }
              },
            ),
          );
  }

  Future<void> handleCategoryDelete() async {
    void delete() {
      ref.read(categoriesProvider.notifier).delete(widget.editedCategory!.id);
      Navigator.of(context).maybePop();
    }

    final List<Transaction> transactionList = await ref
        .watch(transactionsProvider.notifier)
        .loadAllTransationsFromDB();
    final List<Transaction> activeTransactions = transactionList
        .where((e) => e.categoryID == widget.editedCategory!.id)
        .toList();
    final List<TransactionCategory> categories = ref.watch(categoriesProvider);

    if (!mounted) return;
    if (categories.length == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You can't delete the last category"),
        ),
      );
      return;
    }
    activeTransactions.isEmpty
        ? delete()
        : ScaffoldMessenger.of(context).showSnackBar(
            deleteSnack(context, widget.type, () {
              for (final trans in transactionList) {
                if (trans.categoryID == widget.editedCategory!.id) {
                  ref.watch(transactionsProvider.notifier).delete(trans.id);
                }
                delete();
              }
            }),
          );
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
              key: const Key("name"),
              controller: accountNameController,
              onChanged: (value) {
                _accountName = value;
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: "${widget.type} Name",
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            if (widget.type == "Account") ...[
              const Header(text: "Current Balance"),
              AmountField(
                amountController: balanceController,
                amountCallback: (amount) => _balance = amount,
              ),
            ],
            Header(text: "${widget.type} color"),
            ColorPicker(
              colorCallback: (selectedColor) {
                setState(() {
                  _selectedColor = selectedColor.value;
                });
              },
            ),
            Header(text: "${widget.type} icon"),
            IconPicker(
              iconCodepoint: _selectedIcon,
              color: _selectedColor,
              iconCallback: (selectedIcon) {
                setState(() {
                  _selectedIcon = selectedIcon.codePoint;
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SaveFAB(
        onPressed: () {
          if (_accountName == "") {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please enter name")),
            );
          } else {
            if (widget.type == "Account") {
              final String uuid = widget.editedAccount?.id ?? const Uuid().v1();
              saveAction(
                Account(
                  id: uuid,
                  name: _accountName,
                  iconCodepoint: _selectedIcon,
                  color: _selectedColor,
                  balance: _balance,
                  order: 0,
                  isArchived: false,
                ),
              );
            } else {
              final String uuid =
                  widget.editedCategory?.id ?? const Uuid().v1();
              saveAction(
                TransactionCategory(
                  id: uuid,
                  name: _accountName,
                  iconCodepoint: _selectedIcon,
                  color: _selectedColor,
                  order: 0,
                  isArchived: false,
                ),
              );
            }
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
