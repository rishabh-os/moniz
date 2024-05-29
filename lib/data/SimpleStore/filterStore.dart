import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/data/account.dart";
import "package:moniz/data/category.dart";
import "package:moniz/data/transactions.dart";

final filterQueryProvider = StateProvider<String>((ref) {
  return "";
});

final freqHistProvider = StateProvider<Map<double, int>>((ref) {
  final List<Transaction> transactions = ref.watch(transactionsProvider);
  final Map<double, int> frequencyHistorgram = {};
  for (final x in transactions) {
    final amt = x.amount.abs();
    frequencyHistorgram[amt] = !frequencyHistorgram.containsKey(amt)
        ? (1)
        : (frequencyHistorgram[amt]! + 1);
  }
  return frequencyHistorgram;
});

final freqKeysProvider = StateProvider<List<double>>((ref) {
  final Map<double, int> frequencyHistorgram = ref.watch(freqHistProvider);
  final List<double> freqKeys = frequencyHistorgram.keys.toList();
  freqKeys.sort();
  return freqKeys;
});

final rangeValueProvider = StateProvider<RangeValues>((ref) {
  final frequencyHistorgram = ref.watch(freqHistProvider);
  return RangeValues(0, frequencyHistorgram.length.toDouble() - 1);
});

final filteredCategoriesProvider =
    StateProvider<List<TransactionCategory>>((ref) {
  return [];
});

final filteredAccountsProvider = StateProvider<List<Account>>((ref) {
  return [];
});
