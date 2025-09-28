// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Categories)
const categoriesProvider = CategoriesProvider._();

final class CategoriesProvider
    extends $NotifierProvider<Categories, List<TransactionCategory>> {
  const CategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoriesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoriesHash();

  @$internal
  @override
  Categories create() => Categories();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TransactionCategory> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TransactionCategory>>(value),
    );
  }
}

String _$categoriesHash() => r'8f2569238ce96e26d6d93ac5aff0946bcaeb7bba';

abstract class _$Categories extends $Notifier<List<TransactionCategory>> {
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
