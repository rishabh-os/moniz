import "package:flutter/material.dart";
import "package:get_storage/get_storage.dart";
import "package:latlong2/latlong.dart";
import "package:moniz/data/database/db.dart";
import "package:moniz/data/transactions.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "basicStore.g.dart";

@Riverpod(keepAlive: true)
class DB extends _$DB {
  @override
  MyDatabase build() => MyDatabase();
}

@Riverpod(keepAlive: true)
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

@Riverpod(keepAlive: true)
class OverviewIncome extends _$OverviewIncome {
  @override
  int build() {
    final x = ref.watch(searchedTransProvider);
    int total = 0;
    for (final element in x) {
      if (element.amount > 0) {
        total += element.amount.abs();
      }
    }
    return total;
  }
}

@Riverpod(keepAlive: true)
class OverviewExpense extends _$OverviewExpense {
  @override
  int build() {
    final x = ref.watch(searchedTransProvider);
    int total = 0;
    for (final element in x) {
      if (element.amount < 0) {
        total += element.amount.abs();
      }
    }
    return total;
  }
}

@Riverpod(keepAlive: true)
class GraphByCat extends _$GraphByCat {
  @override
  bool build() => false;
  void toggle() => super.state = !state;
}

// ? This provider exists to remember the last used location on the map
@Riverpod(keepAlive: true)
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
