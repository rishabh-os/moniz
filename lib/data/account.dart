import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moniz/data/database/db.dart';
import 'package:moniz/data/SimpleStore/basicStore.dart';

class Account {
  const Account({
    required this.id,
    required this.name,
    required this.iconCodepoint,
    required this.color,
    required this.balance,
    this.netTransactions = 0,
  });

  final String id;
  final String name;
  final int iconCodepoint;
  final int color;
  final double balance;
  final double netTransactions;

  Account copyWith({
    String? name,
    int? iconCodepoint,
    int? color,
    double? balance,
    double? netTransactions,
  }) {
    return Account(
        id: id,
        name: name ?? this.name,
        iconCodepoint: iconCodepoint ?? this.iconCodepoint,
        color: color ?? this.color,
        balance: balance ?? this.balance,
        netTransactions: netTransactions ?? this.netTransactions);
  }
}

class AccountNotifier extends StateNotifier<List<Account>> {
  AccountNotifier(this.db) : super([]);
  final MyDatabase db;
  Future<void> loadAccounts() async {
    final allAccounts = await db.select(db.accountsTable).get();

    List<Account> loadedAccounts = allAccounts
        .map((e) => Account(
              id: e.id,
              name: e.name,
              iconCodepoint: e.iconCodepoint,
              color: e.color,
              balance: e.balance,
              netTransactions: e.netTransactions,
            ))
        .toList();
    state = loadedAccounts;
  }

  void editAccount(Account editedAccount) {
    db.updateAccount(editedAccount);
    state = [
      for (final acc in state)
        if (acc.id == editedAccount.id)
          acc.copyWith(
            name: editedAccount.name,
            iconCodepoint: editedAccount.iconCodepoint,
            color: editedAccount.color,
            balance: editedAccount.balance,
            netTransactions: editedAccount.netTransactions,
          )
        else
          acc,
    ];
  }

  void addAccount(Account newAccount) async {
    state = [...state, newAccount];
    await db.into(db.accountsTable).insert(AccountsTableCompanion.insert(
          id: newAccount.id,
          name: newAccount.name,
          iconCodepoint: newAccount.iconCodepoint,
          color: newAccount.color,
          balance: newAccount.balance,
          netTransactions: newAccount.netTransactions,
        ));
  }

  void deleteAccount(String accountID) async {
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
