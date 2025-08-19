import "package:flutter/material.dart";
import "package:flutter_riverpod/legacy.dart";
import "package:get_storage/get_storage.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "themeStore.g.dart";

final incomeColorSchemeProvider = StateProvider((ref) {
  return ColorScheme.fromSeed(
    dynamicSchemeVariant: DynamicSchemeVariant.rainbow,
    seedColor: Colors.green,
    brightness: ref.watch(brightProvider),
  );
});

final expenseColorSchemeProvider = StateProvider((ref) {
  return ColorScheme.fromSeed(
    dynamicSchemeVariant: DynamicSchemeVariant.rainbow,
    seedColor: Colors.red,
    brightness: ref.watch(brightProvider),
  );
});

@Riverpod(keepAlive: true)
class ThemeColor extends _$ThemeColor {
  @override
  Color build() {
    listenSelf(
      (previous, next) => GetStorage().write("themeColor", next.toARGB32()),
    );
    GetStorage().read("themeColor") ??
        // ? Colors.blueGrey is the default app color
        GetStorage().write("themeColor", Colors.blueGrey.toARGB32());
    return Color(GetStorage().read("themeColor") as int);
  }

  @override
  set state(Color newState) => super.state = newState;
}

@Riverpod(keepAlive: true)
class Bright extends _$Bright {
  @override
  Brightness build() {
    listenSelf(
      (previous, next) =>
          GetStorage().write("isDark", !(next == Brightness.dark) || true),
    );
    GetStorage().read("isDark") ??
        // ? App is light by default
        GetStorage().write("isDark", false);
    return GetStorage().read("isDark") as bool
        ? Brightness.light
        : Brightness.dark;
  }

  @override
  set state(Brightness newState) => super.state = newState;
}

@Riverpod(keepAlive: true)
class DynamicColor extends _$DynamicColor {
  @override
  bool build() {
    listenSelf(
      (previous, next) => GetStorage().write("isDynamic", next),
    );
    GetStorage().read("isDynamic") ?? GetStorage().write("isDynamic", true);
    return GetStorage().read("isDynamic") as bool;
  }

  @override
  set state(bool newState) => super.state = newState;
}
