import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:get_storage/get_storage.dart";
import "package:latlong2/latlong.dart";
import "package:moniz/data/database/db.dart";
import "package:moniz/data/transactions.dart";

final globalDateRangeProvider = StateProvider<DateTimeRange>((ref) {
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
});

final overviewIncomeProvider = StateProvider<double>((ref) {
  final x = ref.watch(transactionsProvider);
  double total = 0;
  for (final element in x) {
    if (element.amount > 0) {
      total += element.amount.abs();
    }
  }
  return total;
});
final overviewExpenseProvider = StateProvider<double>((ref) {
  final x = ref.watch(transactionsProvider);
  double total = 0;
  for (final element in x) {
    if (element.amount < 0) {
      total += element.amount.abs();
    }
  }
  return total;
});

final dbProvider = Provider<MyDatabase>((ref) => MyDatabase());

final chartScrollProvider = StateProvider<bool>((ref) => true);

final graphByCatProvider = StateProvider<bool>((ref) {
  return false;
});

final initialCenterProvider = StateProvider<LatLng>((ref) {
  ref.listenSelf(
    (previous, next) => GetStorage()
        .write("mapCenter", <double>[next.longitude, next.latitude]),
  );
  GetStorage().read("mapCenter") ??
      GetStorage().write("mapCenter", <double>[46.0748, 11.1217]);
  final List longlat = GetStorage().read("mapCenter") as List;
  return LatLng(longlat.last as double, longlat.first as double);
});
