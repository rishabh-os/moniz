// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionsHash() => r'9a3d86f3453def7c9d2a4846b47a9e92b042f672';

/// See also [Transactions].
@ProviderFor(Transactions)
final transactionsProvider =
    NotifierProvider<Transactions, List<Transaction>>.internal(
  Transactions.new,
  name: r'transactionsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$transactionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Transactions = Notifier<List<Transaction>>;
String _$searchedTransHash() => r'58019aee61bd67e01fb184c6ffe298f5cf4491b5';

/// See also [SearchedTrans].
@ProviderFor(SearchedTrans)
final searchedTransProvider =
    NotifierProvider<SearchedTrans, List<Transaction>>.internal(
  SearchedTrans.new,
  name: r'searchedTransProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchedTransHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchedTrans = Notifier<List<Transaction>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
