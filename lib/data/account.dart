import "package:drift/drift.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/data/SimpleStore/basicStore.dart";
import "package:moniz/data/category.dart";
import "package:moniz/data/database/db.dart";

class Account extends Classifier {
  Account({
    required this.id,
    required this.name,
    required this.iconCodepoint,
    required this.color,
    required this.balance,
    required this.order,
    required this.isArchived,
  });

  @override
  final String id;
  @override
  final String name;
  @override
  final int iconCodepoint;
  @override
  final int color;
  @override
  final int order;
  @override
  final bool isArchived;
  double balance;

  @override
  Account copyWith(
      {String? name,
      int? iconCodepoint,
      int? color,
      double? balance,
      double? netTransactions,
      int? order,
      bool? isArchived}) {
    return Account(
        id: id,
        name: name ?? this.name,
        iconCodepoint: iconCodepoint ?? this.iconCodepoint,
        color: color ?? this.color,
        balance: balance ?? this.balance,
        order: order ?? this.order,
        isArchived: isArchived ?? this.isArchived);
  }
}

class AccountNotifier extends StateNotifier<List<Account>> {
  AccountNotifier(this.db) : super([]);
  final MyDatabase db;
  Future<void> loadAccounts() async {
    final allAccounts = await db.select(db.accountsTable).get();

    allAccounts.sort((a, b) => a.order.compareTo(b.order));
    state = allAccounts;
  }

  void edit(Account editedAccount) {
    db.updateAccount(editedAccount);
    state = [
      for (final acc in state)
        if (acc.id == editedAccount.id)
          acc.copyWith(
              name: editedAccount.name,
              iconCodepoint: editedAccount.iconCodepoint,
              color: editedAccount.color,
              balance: editedAccount.balance,
              order: editedAccount.order,
              isArchived: editedAccount.isArchived)
        else
          acc,
    ];
  }

  void add(Account newAccount) async {
    state = [...state, newAccount];
    await db.into(db.accountsTable).insert(AccountsTableCompanion.insert(
          id: newAccount.id,
          name: newAccount.name,
          iconCodepoint: newAccount.iconCodepoint,
          color: newAccount.color,
          balance: newAccount.balance,
          order: newAccount.order,
          isArchived: newAccount.isArchived,
        ));
  }

  void delete(String accountID) async {
    state = [
      for (final account in state)
        if (account.id != accountID) account,
    ];
    await db.accountsTable.deleteWhere((tbl) => tbl.id.equals(accountID));
  }
}

final accountsProvider =
    StateNotifierProvider<AccountNotifier, List<Account>>((ref) {
  return AccountNotifier(ref.read(dbProvider));
});
