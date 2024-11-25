import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:get_storage/get_storage.dart";
import "package:latlong2/latlong.dart";
import "package:moniz/data/database/db.dart";
import "package:moniz/data/transactions.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "basicStore.g.dart";

@riverpod
class GlobalDateRange extends _$GlobalDateRange {
  @override
  DateTimeRange build() {
    final now = DateTime.now();
    return DateTimeRange(
      start: now.copyWith(
        day: 1,
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      ),
      // ? This allows entries on the selected day to be shown
      end: now.add(const Duration(days: 1)),
    );
  }

  @override
  set state(DateTimeRange value) => super.state = value;
}

@riverpod
class OverviewIncome extends _$OverviewIncome {
  @override
  double build() {
    final x = ref.watch(transactionsProvider);
    double total = 0;
    for (final element in x) {
      if (element.amount > 0) {
        total += element.amount.abs();
      }
    }
    return total;
  }
}

@riverpod
class OverviewExpense extends _$OverviewExpense {
  @override
  double build() {
    final x = ref.watch(transactionsProvider);
    double total = 0;
    for (final element in x) {
      if (element.amount < 0) {
        total += element.amount.abs();
      }
    }
    return total;
  }
}

@riverpod
MyDatabase db(Ref ref) {
  return MyDatabase();
}

@riverpod
class GraphByCat extends _$GraphByCat {
  @override
  bool build() => false;
  void toggle() => super.state = !state;
}

@riverpod
class ChartScroll extends _$ChartScroll {
  @override
  bool build() => true;
  @override
  set state(bool value) => state = value;
}

@riverpod
class InitialCenter extends _$InitialCenter {
  @override
  LatLng build() {
    super.listenSelf(
      (previous, next) => GetStorage()
          .write("mapCenter", <double>[next.longitude, next.latitude]),
    );
    GetStorage().read("mapCenter") ??
        GetStorage().write("mapCenter", <double>[46.0748, 11.1217]);
    final List longlat = GetStorage().read("mapCenter") as List;
    return LatLng(longlat.last as double, longlat.first as double);
  }

  @override
  set state(LatLng value) => super.state = value;
}
