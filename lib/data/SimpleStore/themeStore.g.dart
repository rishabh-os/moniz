// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'themeStore.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ThemeColor)
const themeColorProvider = ThemeColorProvider._();

final class ThemeColorProvider extends $NotifierProvider<ThemeColor, Color> {
  const ThemeColorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeColorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeColorHash();

  @$internal
  @override
  ThemeColor create() => ThemeColor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Color value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Color>(value),
    );
  }
}

String _$themeColorHash() => r'4a2af7394b58fa8015cc72d113d346ff3f5220e2';

abstract class _$ThemeColor extends $Notifier<Color> {
  Color build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Color, Color>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Color, Color>,
              Color,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(Bright)
const brightProvider = BrightProvider._();

final class BrightProvider extends $NotifierProvider<Bright, Brightness> {
  const BrightProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'brightProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$brightHash();

  @$internal
  @override
  Bright create() => Bright();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Brightness value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Brightness>(value),
    );
  }
}

String _$brightHash() => r'4e93d89a9a9be91ee223b5fedf02e33054551526';

abstract class _$Bright extends $Notifier<Brightness> {
  Brightness build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Brightness, Brightness>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Brightness, Brightness>,
              Brightness,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(DynamicColor)
const dynamicColorProvider = DynamicColorProvider._();

final class DynamicColorProvider extends $NotifierProvider<DynamicColor, bool> {
  const DynamicColorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dynamicColorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dynamicColorHash();

  @$internal
  @override
  DynamicColor create() => DynamicColor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$dynamicColorHash() => r'baff793c31f32aaf9ab9836646cfcba7c5106910';

abstract class _$DynamicColor extends $Notifier<bool> {
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
