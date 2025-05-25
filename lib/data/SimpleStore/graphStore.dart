import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:moniz/data/SimpleStore/basicStore.dart";
import "package:moniz/data/category.dart";
import "package:moniz/data/transactions.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "graphStore.g.dart";

@Riverpod(keepAlive: true)
class GraphData extends _$GraphData {
  @override
  Future<(List<SpendsByDay>, List<SpendsByCat>)> build() {
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

(List<SpendsByDay>, List<SpendsByCat>) getSpots(
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

  final List<SpendsByCat> spendsByCategory = [
    for (final x in days)
      for (final y in data.categories) SpendsByCat(x, y, 0.0),
  ];

  for (final transaction in data.transactionList) {
    for (final element in spendsByCategory) {
      if (element.day == getDTString(transaction.recorded) &&
          element.category.id == transaction.categoryID &&
          transaction.amount.isNegative) {
        element.amount +=
            double.parse(transaction.amount.abs().toStringAsFixed(2));
      }
    }
  }

  final List<SpendsByDay> spendsByDay = [];
  for (final day in days) {
    final x = spendsByCategory.fold(0.0, (sum, element) {
      if (element.day == day) {
        return sum + element.amount;
      }
      return double.parse(sum.toStringAsFixed(2));
    });
    spendsByDay.add(SpendsByDay(day, x));
  }
  return (spendsByDay, spendsByCategory);
}

class SpendsByCat extends SpendsBy {
  final TransactionCategory category;
  SpendsByCat(super.day, this.category, super.amount);
}

class SpendsByDay extends SpendsBy {
  SpendsByDay(super.day, super.amount);
}

abstract class SpendsBy {
  final String day;
  double amount;
  SpendsBy(this.day, this.amount);
}

String getDTString(DateTime trans) {
  // ? This type is needed so that sorting works easily
  return "${trans.year}-${trans.month.toString().padLeft(2, '0')}-${trans.day.toString().padLeft(2, '0')}";
}
