import "package:drift/drift.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/data/SimpleStore/basicStore.dart";
import "package:moniz/data/api/response.dart";
import "package:moniz/data/database/db.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
part "transactions.g.dart";

class Transaction {
  const Transaction({
    required this.id,
    required this.title,
    this.additionalInfo,
    required this.categoryID,
    required this.accountID,
    required this.amount,
    required this.recorded,
    this.location,
  });
  final String id;
  final String title;
  final String? additionalInfo;
  final String categoryID;
  final String accountID;
  final double amount;
  final DateTime recorded;
  final GMapsPlace? location;

  Transaction copyWith({
    String? transactionType,
    String? title,
    String? additionalInfo,
    String? categoryID,
    String? accountID,
    double? amount,
    DateTime? recorded,
    GMapsPlace? location,
  }) {
    return Transaction(
      // ? This makes the ID field unchangeable
      id: id,
      title: title ?? this.title,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      categoryID: categoryID ?? this.categoryID,
      accountID: accountID ?? this.accountID,
      amount: amount ?? this.amount,
      recorded: recorded ?? this.recorded,
      location: location ?? this.location,
    );
  }
}

@Riverpod(keepAlive: true)
class Transactions extends _$Transactions {
  @override
  List<Transaction> build() => [];

  Future<void> filterTransactions() async {
    final globalDateRange = ref.watch(globalDateRangeProvider);
    final List<Transaction> loadedTransactions =
        await loadAllTransationsFromDB();
    final List<Transaction> filteredTransactions = loadedTransactions
        .where(
          (element) =>
              element.recorded.isAfter(globalDateRange.start) &&
              element.recorded.isBefore(globalDateRange.end),
        )
        .toList();
    state = filteredTransactions;
    state.sort((a, b) => b.recorded.compareTo(a.recorded));
  }

  Future<List<Transaction>> loadAllTransationsFromDB() async {
    final db = ref.read(dBProvider);
    final List<Transaction> loadedTransactions =
        (await db.select(db.transactionTable).get())
            .map(
              (e) => Transaction(
                id: e.id,
                title: e.title,
                categoryID: e.categoryID,
                accountID: e.accountID,
                amount: e.amount,
                recorded: e.recorded,
                additionalInfo: e.additionalInfo,
                location: e.location,
              ),
            )
            .toList();
    return loadedTransactions;
  }

  Future<void> edit(Transaction editedTransaction) async {
    final db = ref.read(dBProvider);
    await db.updateTransaction(editedTransaction);
    state = [
      for (final trans in state)
        if (trans.id == editedTransaction.id)
          trans.copyWith(
            title: editedTransaction.title,
            additionalInfo: editedTransaction.additionalInfo,
            categoryID: editedTransaction.categoryID,
            accountID: editedTransaction.accountID,
            amount: editedTransaction.amount,
            recorded: editedTransaction.recorded,
            location: editedTransaction.location,
          )
        else
          trans,
    ];
    state.sort((a, b) => b.recorded.compareTo(a.recorded));
  }

  Future<void> add(Transaction newTransaction) async {
    final db = ref.read(dBProvider);
    state = [newTransaction, ...state];
    state.sort((a, b) => b.recorded.compareTo(a.recorded));
    await db.into(db.transactionTable).insert(
          TransactionTableCompanion.insert(
            id: newTransaction.id,
            title: newTransaction.title,
            categoryID: newTransaction.categoryID,
            accountID: newTransaction.accountID,
            amount: newTransaction.amount,
            recorded: newTransaction.recorded,
            additionalInfo: Value(newTransaction.additionalInfo),
            location: Value(newTransaction.location),
          ),
        );
  }

  Future<void> delete(String transactionID) async {
    final db = ref.read(dBProvider);
    state = [
      for (final transaction in state)
        if (transaction.id != transactionID) transaction,
    ];
    await db.transactionTable
        .deleteWhere((tbl) => tbl.id.equals(transactionID));
  }
}

final searchedTransProvider = StateProvider<List<Transaction>>((ref) {
  return ref.watch(transactionsProvider);
});
