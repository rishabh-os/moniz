import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/data/account.dart";
import "package:moniz/data/category.dart";
import "package:moniz/data/transactions.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "filterStore.g.dart";

@riverpod
class FilterQuery extends _$FilterQuery {
  @override
  String build() => "";
  @override
  set state(String value) => super.state = value;
}

@riverpod
class FreqHist extends _$FreqHist {
  @override
  Map<double, int> build() {
    final List<Transaction> transactions = ref.watch(transactionsProvider);
    final Map<double, int> frequencyHistorgram = {};
    for (final x in transactions) {
      final amt = x.amount.abs();
      frequencyHistorgram[amt] = !frequencyHistorgram.containsKey(amt)
          ? (1)
          : (frequencyHistorgram[amt]! + 1);
    }
    return frequencyHistorgram;
  }
}

@riverpod
class FreqKeys extends _$FreqKeys {
  @override
  List<double> build() {
    final Map<double, int> frequencyHistorgram = ref.watch(freqHistProvider);
    final List<double> freqKeys = frequencyHistorgram.keys.toList();
    freqKeys.sort();
    return freqKeys;
  }
}

@riverpod
class RangeValue extends _$RangeValue {
  @override
  RangeValues build() {
    final frequencyHistorgram = ref.watch(freqHistProvider);
    return RangeValues(0, frequencyHistorgram.length.toDouble() - 1);
  }

  @override
  set state(RangeValues value) => super.state = value;
}

@riverpod
class FilteredCategories extends _$FilteredCategories {
  @override
  List<TransactionCategory> build() => [];
  @override
  set state(List<TransactionCategory> value) => super.state = value;
}

@riverpod
class FilteredAccounts extends _$FilteredAccounts {
  @override
  List<Account> build() => [];
  @override
  set state(List<Account> value) => super.state = value;
}
