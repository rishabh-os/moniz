// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filterStore.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FilterQuery)
const filterQueryProvider = FilterQueryProvider._();

final class FilterQueryProvider extends $NotifierProvider<FilterQuery, String> {
  const FilterQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filterQueryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filterQueryHash();

  @$internal
  @override
  FilterQuery create() => FilterQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$filterQueryHash() => r'd9e0e72566713b0b856557245986ec87db5c12b2';

abstract class _$FilterQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(FreqHist)
const freqHistProvider = FreqHistProvider._();

final class FreqHistProvider
    extends $NotifierProvider<FreqHist, Map<double, int>> {
  const FreqHistProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'freqHistProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$freqHistHash();

  @$internal
  @override
  FreqHist create() => FreqHist();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<double, int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<double, int>>(value),
    );
  }
}

String _$freqHistHash() => r'b2c45d91769b983b38e547f462cbe13883124e87';

abstract class _$FreqHist extends $Notifier<Map<double, int>> {
  Map<double, int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Map<double, int>, Map<double, int>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<double, int>, Map<double, int>>,
              Map<double, int>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(FreqKeys)
const freqKeysProvider = FreqKeysProvider._();

final class FreqKeysProvider extends $NotifierProvider<FreqKeys, List<double>> {
  const FreqKeysProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'freqKeysProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$freqKeysHash();

  @$internal
  @override
  FreqKeys create() => FreqKeys();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<double> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<double>>(value),
    );
  }
}

String _$freqKeysHash() => r'01f0f6967c664d8806f79fd3df96d9c0efa376e3';

abstract class _$FreqKeys extends $Notifier<List<double>> {
  List<double> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<double>, List<double>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<double>, List<double>>,
              List<double>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(RangeValue)
const rangeValueProvider = RangeValueProvider._();

final class RangeValueProvider
    extends $NotifierProvider<RangeValue, RangeValues> {
  const RangeValueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rangeValueProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rangeValueHash();

  @$internal
  @override
  RangeValue create() => RangeValue();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RangeValues value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RangeValues>(value),
    );
  }
}

String _$rangeValueHash() => r'02af78376fc9cfdff110cc7c3e0273ff03c86b39';

abstract class _$RangeValue extends $Notifier<RangeValues> {
  RangeValues build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<RangeValues, RangeValues>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RangeValues, RangeValues>,
              RangeValues,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(FilteredCategories)
const filteredCategoriesProvider = FilteredCategoriesProvider._();

final class FilteredCategoriesProvider
    extends $NotifierProvider<FilteredCategories, List<TransactionCategory>> {
  const FilteredCategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredCategoriesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredCategoriesHash();

  @$internal
  @override
  FilteredCategories create() => FilteredCategories();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TransactionCategory> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TransactionCategory>>(value),
    );
  }
}

String _$filteredCategoriesHash() =>
    r'6cba2865400001674e264699ba06c454f748d3ca';

abstract class _$FilteredCategories
    extends $Notifier<List<TransactionCategory>> {
  List<TransactionCategory> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<List<TransactionCategory>, List<TransactionCategory>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<TransactionCategory>, List<TransactionCategory>>,
              List<TransactionCategory>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(FilteredAccounts)
const filteredAccountsProvider = FilteredAccountsProvider._();

final class FilteredAccountsProvider
    extends $NotifierProvider<FilteredAccounts, List<Account>> {
  const FilteredAccountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredAccountsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredAccountsHash();

  @$internal
  @override
  FilteredAccounts create() => FilteredAccounts();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Account> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Account>>(value),
    );
  }
}

String _$filteredAccountsHash() => r'37e4fdc548931ed389aded51e452dbb832b5993b';

abstract class _$FilteredAccounts extends $Notifier<List<Account>> {
  List<Account> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<Account>, List<Account>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Account>, List<Account>>,
              List<Account>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
