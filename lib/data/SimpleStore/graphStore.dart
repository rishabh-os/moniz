// ignore_for_file: avoid_dynamic_calls
// ignore_for_file: non_bool_condition
// ignore_for_file: argument_type_not_assignable

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:moniz/data/SimpleStore/basicStore.dart";
import "package:moniz/data/category.dart";
import "package:moniz/data/transactions.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "graphStore.g.dart";

@riverpod
class GraphData extends _$GraphData {
  @override
  Future<(List<List<dynamic>>, List<List<dynamic>>)> build() async {
    final List<Transaction> transactionList = ref.watch(searchedTransProvider);
    final List<TransactionCategory> categories = ref.read(categoriesProvider);
    final range = ref.watch(globalDateRangeProvider);

    return compute(
      getSpots,
      GetSpotsData(transactionList, range, categories),
    );
  }
}

class GetSpotsData {
  final List<Transaction> transactionList;
  final DateTimeRange range;
  final List<TransactionCategory> categories;

  GetSpotsData(this.transactionList, this.range, this.categories);
}

(List<List>, List<List>) getSpots(
  GetSpotsData data,
) {
  List<String> days = [];
  final numberOfDays = data.range.end.difference(data.range.start).inDays;
  days = List.generate(
    numberOfDays,
    (i) => getDTString(
      DateTime(
        data.range.start.year,
        data.range.start.month,
        data.range.start.day + i,
      ),
    ),
  );
  // ? The built-in sort method works! Ez pz
  days.sort((a, b) {
    return a.compareTo(b);
  });
  final Map<String, double> spotsByDay = {for (final v in days) v: 0};
  for (final trans in data.transactionList) {
    if (trans.amount < 0) {
      spotsByDay.update(
        getDTString(trans.recorded),
        (value) =>
            spotsByDay[getDTString(trans.recorded)]! + trans.amount.abs(),
        ifAbsent: () => 0,
      );
    }
  }

  final List<List> spendsByCategory = [
    for (final x in days)
      for (final y in data.categories) [x, y, 0.0],
  ];

  for (final transaction in data.transactionList) {
    for (final element in spendsByCategory) {
      if (element[0] == getDTString(transaction.recorded) &&
          element[1].id == transaction.categoryID &&
          transaction.amount.isNegative) {
        element[2] += double.parse(transaction.amount.abs().toStringAsFixed(2));
      }
    }
  }

  final List<List> spendsByDay = [];
  for (final day in days) {
    final x = spendsByCategory.fold(0.0, (sum, element) {
      if (element[0] == day) {
        return sum + element[2];
      }
      return double.parse(sum.toStringAsFixed(2));
    });
    spendsByDay.add([day, x]);
  }
  return (spendsByDay, spendsByCategory);
}

String getDTString(DateTime trans) {
  // ? This type is needed so that sorting works easily
  return "${trans.year}-${trans.month.toString().padLeft(2, '0')}-${trans.day.toString().padLeft(2, '0')}";
}
