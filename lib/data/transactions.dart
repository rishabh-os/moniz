import "package:drift/drift.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/data/SimpleStore/basicStore.dart";
import "package:moniz/data/database/db.dart";

class Transaction {
  const Transaction({
    required this.id,
    required this.title,
    required this.additionalInfo,
    required this.categoryID,
    required this.accountID,
    required this.amount,
    required this.recorded,
  });
  final String id;
  final String title;
  // ? additionalInfo should be optional
  final String additionalInfo;
  final String categoryID;
  final String accountID;
  final double amount;
  final DateTime recorded;

  Transaction copyWith({
    String? transactionType,
    String? title,
    String? additionalInfo,
    String? categoryID,
    String? accountID,
    double? amount,
    DateTime? recorded,
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
    );
  }
}

class TransactionNotifier extends StateNotifier<List<Transaction>> {
  TransactionNotifier(this.db, this.globalDateRange, this.allTransactions)
      : super([]);
  final MyDatabase db;
  final DateTimeRange globalDateRange;
  final List<Transaction> allTransactions;

  void filterTransactions() {
    List<Transaction> filteredTransactions = allTransactions
        .where((element) =>
            element.recorded.isAfter(globalDateRange.start) &&
            element.recorded.isBefore(globalDateRange.end))
        .toList();
    state = filteredTransactions;
    state.sort((a, b) => b.recorded.compareTo(a.recorded));
  }

  void edit(Transaction editedTransaction) async {
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
          )
        else
          trans,
    ];
    state.sort((a, b) => b.recorded.compareTo(a.recorded));
  }

  void add(Transaction newTransaction) async {
    state = [newTransaction, ...state];
    state.sort((a, b) => b.recorded.compareTo(a.recorded));
    await db.into(db.transactionTable).insert(TransactionTableCompanion.insert(
        id: newTransaction.id,
        title: newTransaction.title,
        categoryID: newTransaction.categoryID,
        accountID: newTransaction.accountID,
        amount: newTransaction.amount,
        recorded: newTransaction.recorded,
        additionalInfo: newTransaction.additionalInfo));
  }

  void delete(String transactionID) async {
    state = [
      for (final transaction in state)
        if (transaction.id != transactionID) transaction,
    ];
    await db.transactionTable
        .deleteWhere((tbl) => tbl.id.equals(transactionID));
  }
}

final transactionsProvider =
    StateNotifierProvider<TransactionNotifier, List<Transaction>>((ref) {
  return TransactionNotifier(ref.read(dbProvider),
      ref.watch(globalDateRangeProvider), ref.watch(allTransProvider));
});

class AllTransactionNotifier extends StateNotifier<List<Transaction>> {
  AllTransactionNotifier(this.db) : super([]);
  final MyDatabase db;

  // ? This method is only called once at app start up
  Future<void> loadAllTransactions() async {
    List<Transaction> loadedTransactions =
        (await db.select(db.transactionTable).get())
            .map((e) => Transaction(
                id: e.id,
                title: e.title,
                categoryID: e.categoryID,
                accountID: e.accountID,
                amount: e.amount,
                recorded: e.recorded,
                additionalInfo: e.additionalInfo))
            .toList();
    // ? Stuff is stored chronologically in the database but loaded in the reverse order in the app
    state = loadedTransactions;
  }
}

final allTransProvider =
    StateNotifierProvider<AllTransactionNotifier, List<Transaction>>((ref) {
  return AllTransactionNotifier(ref.read(dbProvider));
});

final searchedTransProvider = StateProvider<List<Transaction>?>((ref) {
  return null;
});
