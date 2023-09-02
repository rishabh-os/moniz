import "dart:convert";
import "dart:math";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:get_storage/get_storage.dart";
import "package:moniz/data/category.dart";
import "package:moniz/data/database/db.dart";
import "package:moniz/data/transactions.dart";

final nameProvider = StateProvider<String>((ref) => "Rishabh");
final scrollProvider =
    StateProvider<ScrollController>((ref) => ScrollController());
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

class CatOrderNotifier extends StateNotifier<List<int>> {
  CatOrderNotifier(this.catLen) : super([]);
  final int catLen;
  Future<void> loadOrder() async {
    GetStorage().writeIfNull(
        "order", <int>[for (var i = 0; i <= catLen; i++) i].toString());
    String x = GetStorage().read("order");
    List<int> test = (jsonDecode(x) as List).cast<int>();
    state = test;
  }

  void updateOrder(List<int> order) {
    state = order;
    GetStorage().write("order", order.toString());
  }

  void handleCatChange() {
    String x = GetStorage().read("order");
    List<int> oldState = (jsonDecode(x) as List).cast<int>();
    try {
      assert(oldState.length == catLen);
    } catch (e) {
      // ? Handles adding and removing of categories
      if (oldState.length < catLen) {
        while (oldState.length < catLen) {
          oldState.add(oldState.reduce(max) + 1);
        }
      } else if (oldState.length > catLen) {
        while (oldState.length > catLen) {
          oldState.removeWhere((element) => element == oldState.reduce(max));
        }
      }
    }
    state = oldState;
    GetStorage().write("order", oldState.toString());
  }
}

final catOrderProvider =
    StateNotifierProvider<CatOrderNotifier, List<int>>((ref) {
  return CatOrderNotifier(ref.watch(categoriesProvider).length);
});
