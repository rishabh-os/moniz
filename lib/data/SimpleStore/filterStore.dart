import "dart:math";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/data/account.dart";
import "package:moniz/data/category.dart";
import "package:moniz/data/transactions.dart";

final filterQueryProvider = StateProvider<String>((ref) {
  return "test";
});

final sliderMaxProvider = StateProvider<double>((ref) => ref
    .watch(transactionsProvider)
    .map<double>((e) => e.amount.abs())
    .reduce(max));

final rangeProvider = StateProvider<RangeValues>(
    (ref) => RangeValues(0, ref.watch(sliderMaxProvider)));

final filterCategoryProvider = StateProvider<TransactionCategory?>((ref) {
  return null;
});

final filterAccountProvider = StateProvider<Account?>((ref) {
  return null;
});
