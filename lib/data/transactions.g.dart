// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Transactions)
const transactionsProvider = TransactionsProvider._();

final class TransactionsProvider
    extends $NotifierProvider<Transactions, List<Transaction>> {
  const TransactionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionsHash();

  @$internal
  @override
  Transactions create() => Transactions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Transaction> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Transaction>>(value),
    );
  }
}

String _$transactionsHash() => r'9a3d86f3453def7c9d2a4846b47a9e92b042f672';

abstract class _$Transactions extends $Notifier<List<Transaction>> {
  List<Transaction> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<Transaction>, List<Transaction>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Transaction>, List<Transaction>>,
              List<Transaction>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SearchedTrans)
const searchedTransProvider = SearchedTransProvider._();

final class SearchedTransProvider
    extends $NotifierProvider<SearchedTrans, List<Transaction>> {
  const SearchedTransProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchedTransProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchedTransHash();

  @$internal
  @override
  SearchedTrans create() => SearchedTrans();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Transaction> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Transaction>>(value),
    );
  }
}

String _$searchedTransHash() => r'1ca9c5aabf4ea0fa46968b9e9635b89958b74983';

abstract class _$SearchedTrans extends $Notifier<List<Transaction>> {
  List<Transaction> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<Transaction>, List<Transaction>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Transaction>, List<Transaction>>,
              List<Transaction>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
