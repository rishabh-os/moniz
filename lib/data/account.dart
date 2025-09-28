import "package:drift/drift.dart";
import "package:moniz/data/SimpleStore/basicStore.dart";
import "package:moniz/data/category.dart";
import "package:moniz/data/database/db.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "account.g.dart";

final class Account extends Classifier {
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
  int balance;

  @override
  Account copyWith({
    String? name,
    int? iconCodepoint,
    int? color,
    int? balance,
    double? netTransactions,
    int? order,
    bool? isArchived,
  }) {
    return Account(
      id: id,
      name: name ?? this.name,
      iconCodepoint: iconCodepoint ?? this.iconCodepoint,
      color: color ?? this.color,
      balance: balance ?? this.balance,
      order: order ?? this.order,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}

@Riverpod(keepAlive: true)
class Accounts extends _$Accounts {
  @override
  List<Account> build() => [];
  Future<void> loadAccounts() async {
    final db = ref.read(dBProvider);

    final allAccounts = await db.select(db.accountsTable).get();

    allAccounts.sort((a, b) => a.order.compareTo(b.order));
    state = allAccounts;
  }

  Future<void> edit(Account editedAccount) async {
    final db = ref.read(dBProvider);
    await db.updateAccount(editedAccount);
    state = [
      for (final acc in state)
        if (acc.id == editedAccount.id)
          acc.copyWith(
            name: editedAccount.name,
            iconCodepoint: editedAccount.iconCodepoint,
            color: editedAccount.color,
            balance: editedAccount.balance,
            order: editedAccount.order,
            isArchived: editedAccount.isArchived,
          )
        else
          acc,
    ];
  }

  Future<void> add(Account newAccount) async {
    state = [...state, newAccount];
    final db = ref.read(dBProvider);
    await db
        .into(db.accountsTable)
        .insert(
          AccountsTableCompanion.insert(
            id: newAccount.id,
            name: newAccount.name,
            iconCodepoint: newAccount.iconCodepoint,
            color: newAccount.color,
            balance: newAccount.balance,
            order: newAccount.order,
            isArchived: newAccount.isArchived,
          ),
        );
  }

  Future<void> delete(String accountID) async {
    state = [
      for (final account in state)
        if (account.id != accountID) account,
    ];
    final db = ref.read(dBProvider);
    await db.accountsTable.deleteWhere((tbl) => tbl.id.equals(accountID));
  }
}
