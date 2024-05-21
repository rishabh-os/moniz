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

final filterCategoryProvider = StateProvider<TransactionCategory?>((ref) {
  return null;
});

final filterAccountProvider = StateProvider<Account?>((ref) {
  return null;
});
