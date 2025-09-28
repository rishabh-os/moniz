// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settingsStore.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Curr)
const currProvider = CurrProvider._();

final class CurrProvider extends $NotifierProvider<Curr, Currency> {
  const CurrProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currHash();

  @$internal
  @override
  Curr create() => Curr();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Currency value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Currency>(value),
    );
  }
}

String _$currHash() => r'cc606d215b73453f87ac4f41b2f9e582db54261d';

abstract class _$Curr extends $Notifier<Currency> {
  Currency build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Currency, Currency>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Currency, Currency>,
              Currency,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(TransDelete)
const transDeleteProvider = TransDeleteProvider._();

final class TransDeleteProvider extends $NotifierProvider<TransDelete, bool> {
  const TransDeleteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transDeleteProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transDeleteHash();

  @$internal
  @override
  TransDelete create() => TransDelete();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$transDeleteHash() => r'de6ae90e06b6d7da27fbb05e9d1cc6563f24e661';

abstract class _$TransDelete extends $Notifier<bool> {
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

@ProviderFor(ChipsMultiLine)
const chipsMultiLineProvider = ChipsMultiLineProvider._();

final class ChipsMultiLineProvider
    extends $NotifierProvider<ChipsMultiLine, bool> {
  const ChipsMultiLineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chipsMultiLineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chipsMultiLineHash();

  @$internal
  @override
  ChipsMultiLine create() => ChipsMultiLine();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$chipsMultiLineHash() => r'6b9fe42a383120e90406a175f646dcafd2aad888';

abstract class _$ChipsMultiLine extends $Notifier<bool> {
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

@ProviderFor(ShowLocation)
const showLocationProvider = ShowLocationProvider._();

final class ShowLocationProvider extends $NotifierProvider<ShowLocation, bool> {
  const ShowLocationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showLocationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showLocationHash();

  @$internal
  @override
  ShowLocation create() => ShowLocation();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$showLocationHash() => r'3576bc8d9d0317491c1228527e4e4418f202e07a';

abstract class _$ShowLocation extends $Notifier<bool> {
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

@ProviderFor(ColorMapIcons)
const colorMapIconsProvider = ColorMapIconsProvider._();

final class ColorMapIconsProvider
    extends $NotifierProvider<ColorMapIcons, bool> {
  const ColorMapIconsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'colorMapIconsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$colorMapIconsHash();

  @$internal
  @override
  ColorMapIcons create() => ColorMapIcons();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$colorMapIconsHash() => r'66b52c4739041116ad251e786216abd4b7c1e19e';

abstract class _$ColorMapIcons extends $Notifier<bool> {
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

@ProviderFor(InitialPage)
const initialPageProvider = InitialPageProvider._();

final class InitialPageProvider extends $NotifierProvider<InitialPage, int> {
  const InitialPageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'initialPageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$initialPageHash();

  @$internal
  @override
  InitialPage create() => InitialPage();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$initialPageHash() => r'1715fd2619f6c5a3c191135c3c449f36598240ee';

abstract class _$InitialPage extends $Notifier<int> {
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

@ProviderFor(NumberF)
const numberFProvider = NumberFProvider._();

final class NumberFProvider extends $NotifierProvider<NumberF, NumberFormat> {
  const NumberFProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'numberFProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$numberFHash();

  @$internal
  @override
  NumberF create() => NumberF();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NumberFormat value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NumberFormat>(value),
    );
  }
}

String _$numberFHash() => r'59a2d4fde25cc4e390c83c924fdb7f3a5f59618f';

abstract class _$NumberF extends $Notifier<NumberFormat> {
  NumberFormat build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<NumberFormat, NumberFormat>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NumberFormat, NumberFormat>,
              NumberFormat,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
