import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/data/account.dart";
import "package:moniz/data/category.dart";
import "package:moniz/data/transactions.dart";

final filterQueryProvider = StateProvider<String>((ref) {
  return "";
});

final freqHistProvider = StateProvider<Map<double, int>>((ref) {
  List transactions = ref.watch(transactionsProvider);
  Map<double, int> frequencyHistorgram = {};
  for (var x in transactions) {
    var amt = x.amount.abs();
    frequencyHistorgram[amt] = !frequencyHistorgram.containsKey(amt)
        ? (1)
        : (frequencyHistorgram[amt]! + 1);
  }
  return frequencyHistorgram;
});

final freqKeysProvider = StateProvider<List<double>>((ref) {
  Map<double, int> frequencyHistorgram = ref.watch(freqHistProvider);
  List<double> freqKeys = (frequencyHistorgram.keys.toList());
  freqKeys.sort();
  return freqKeys;
});

final filterCategoryProvider = StateProvider<TransactionCategory?>((ref) {
  return null;
});

final filterAccountProvider = StateProvider<Account?>((ref) {
  return null;
});
