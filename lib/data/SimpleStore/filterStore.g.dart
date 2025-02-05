// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filterStore.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filterQueryHash() => r'd9e0e72566713b0b856557245986ec87db5c12b2';

/// See also [FilterQuery].
@ProviderFor(FilterQuery)
final filterQueryProvider = NotifierProvider<FilterQuery, String>.internal(
  FilterQuery.new,
  name: r'filterQueryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$filterQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FilterQuery = Notifier<String>;
String _$freqHistHash() => r'80dd9f0a29265ce2e2797bdbd1bde3907131157c';

/// See also [FreqHist].
@ProviderFor(FreqHist)
final freqHistProvider = NotifierProvider<FreqHist, Map<double, int>>.internal(
  FreqHist.new,
  name: r'freqHistProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$freqHistHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FreqHist = Notifier<Map<double, int>>;
String _$freqKeysHash() => r'01f0f6967c664d8806f79fd3df96d9c0efa376e3';

/// See also [FreqKeys].
@ProviderFor(FreqKeys)
final freqKeysProvider = NotifierProvider<FreqKeys, List<double>>.internal(
  FreqKeys.new,
  name: r'freqKeysProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$freqKeysHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FreqKeys = Notifier<List<double>>;
String _$rangeValueHash() => r'02af78376fc9cfdff110cc7c3e0273ff03c86b39';

/// See also [RangeValue].
@ProviderFor(RangeValue)
final rangeValueProvider = NotifierProvider<RangeValue, RangeValues>.internal(
  RangeValue.new,
  name: r'rangeValueProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$rangeValueHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RangeValue = Notifier<RangeValues>;
String _$filteredCategoriesHash() =>
    r'34c5fb56b8ff3eec6839f9da0afde921cfc5b9fc';

/// See also [FilteredCategories].
@ProviderFor(FilteredCategories)
final filteredCategoriesProvider =
    NotifierProvider<FilteredCategories, List<TransactionCategory>>.internal(
  FilteredCategories.new,
  name: r'filteredCategoriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredCategoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FilteredCategories = Notifier<List<TransactionCategory>>;
String _$filteredAccountsHash() => r'6260b6ec7a56ae8a04fecb78866054e651b17bf3';

/// See also [FilteredAccounts].
@ProviderFor(FilteredAccounts)
final filteredAccountsProvider =
    NotifierProvider<FilteredAccounts, List<Account>>.internal(
  FilteredAccounts.new,
  name: r'filteredAccountsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredAccountsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FilteredAccounts = Notifier<List<Account>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
