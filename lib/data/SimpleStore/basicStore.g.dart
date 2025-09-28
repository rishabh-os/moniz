// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basicStore.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DB)
const dBProvider = DBProvider._();

final class DBProvider extends $NotifierProvider<DB, MyDatabase> {
  const DBProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dBProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dBHash();

  @$internal
  @override
  DB create() => DB();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MyDatabase>(value),
    );
  }
}

String _$dBHash() => r'65d29f0a22fa0428b136b6be31735601fdc61d5f';

abstract class _$DB extends $Notifier<MyDatabase> {
  MyDatabase build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<MyDatabase, MyDatabase>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MyDatabase, MyDatabase>,
              MyDatabase,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(GlobalDateRange)
const globalDateRangeProvider = GlobalDateRangeProvider._();

final class GlobalDateRangeProvider
    extends $NotifierProvider<GlobalDateRange, DateTimeRange<DateTime>> {
  const GlobalDateRangeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'globalDateRangeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$globalDateRangeHash();

  @$internal
  @override
  GlobalDateRange create() => GlobalDateRange();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTimeRange<DateTime> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTimeRange<DateTime>>(value),
    );
  }
}

String _$globalDateRangeHash() => r'2bf3d98c4ddaaa61d3960d86695057a1e8a5e716';

abstract class _$GlobalDateRange extends $Notifier<DateTimeRange<DateTime>> {
  DateTimeRange<DateTime> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<DateTimeRange<DateTime>, DateTimeRange<DateTime>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTimeRange<DateTime>, DateTimeRange<DateTime>>,
              DateTimeRange<DateTime>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(OverviewIncome)
const overviewIncomeProvider = OverviewIncomeProvider._();

final class OverviewIncomeProvider
    extends $NotifierProvider<OverviewIncome, int> {
  const OverviewIncomeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'overviewIncomeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$overviewIncomeHash();

  @$internal
  @override
  OverviewIncome create() => OverviewIncome();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$overviewIncomeHash() => r'a617c893dc765463b86ae0b86fa5967cab1af43d';

abstract class _$OverviewIncome extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(OverviewExpense)
const overviewExpenseProvider = OverviewExpenseProvider._();

final class OverviewExpenseProvider
    extends $NotifierProvider<OverviewExpense, int> {
  const OverviewExpenseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'overviewExpenseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$overviewExpenseHash();

  @$internal
  @override
  OverviewExpense create() => OverviewExpense();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$overviewExpenseHash() => r'1e274913be8c115f5b748c51deb25daf318b775e';

abstract class _$OverviewExpense extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(GraphByCat)
const graphByCatProvider = GraphByCatProvider._();

final class GraphByCatProvider extends $NotifierProvider<GraphByCat, bool> {
  const GraphByCatProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'graphByCatProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$graphByCatHash();

  @$internal
  @override
  GraphByCat create() => GraphByCat();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$graphByCatHash() => r'50bb7dc368d4b8756c0c96bc83072c57b526e49a';

abstract class _$GraphByCat extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(InitialCenter)
const initialCenterProvider = InitialCenterProvider._();

final class InitialCenterProvider
    extends $NotifierProvider<InitialCenter, LatLng> {
  const InitialCenterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'initialCenterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$initialCenterHash();

  @$internal
  @override
  InitialCenter create() => InitialCenter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LatLng value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LatLng>(value),
    );
  }
}

String _$initialCenterHash() => r'09ec34daacab0394eb288cc639864b103db9873c';

abstract class _$InitialCenter extends $Notifier<LatLng> {
  LatLng build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<LatLng, LatLng>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LatLng, LatLng>,
              LatLng,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
