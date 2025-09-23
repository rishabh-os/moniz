// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Accounts)
const accountsProvider = AccountsProvider._();

final class AccountsProvider
    extends $NotifierProvider<Accounts, List<Account>> {
  const AccountsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'accountsProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$accountsHash();

  @$internal
  @override
  Accounts create() => Accounts();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Account> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Account>>(value),
    );
  }
}

String _$accountsHash() => r'ae91bdc7feccdf9814210285fd96c7012c586e64';

abstract class _$Accounts extends $Notifier<List<Account>> {
  List<Account> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<Account>, List<Account>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<List<Account>, List<Account>>,
        List<Account>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
