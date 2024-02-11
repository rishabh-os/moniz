import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/data/database/db.dart";
import "package:moniz/data/transactions.dart";

final globalDateRangeProvider =
    StateProvider<DateTimeRange>((ref) => DateTimeRange(
          start: DateTime.now().copyWith(
              day: 1,
              hour: 0,
              minute: 0,
              second: 0,
              millisecond: 0,
              microsecond: 0),
          // ? This allows entries on the selected day to be shown
          end: DateTime.now().add(const Duration(days: 1)),
        ));

final overviewIncomeProvider = StateProvider<double>((ref) {
  var x = ref.watch(transactionsProvider);
  double total = 0;
  for (var element in x) {
    if (element.amount > 0) {
      total += element.amount.abs();
    }
  }
  return total;
});
final overviewExpenseProvider = StateProvider<double>((ref) {
  var x = ref.watch(transactionsProvider);
  double total = 0;
  for (var element in x) {
    if (element.amount < 0) {
      total += element.amount.abs();
    }
  }
  return total;
});

final dbProvider = Provider<MyDatabase>((ref) => MyDatabase());

final chartScrollProvider = StateProvider<bool>((ref) => true);

final graphByCatProvider = StateProvider<bool>((ref) {
  return false;
});
