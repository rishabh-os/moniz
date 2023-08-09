import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:get_storage/get_storage.dart";

final incomeColorSchemeProvider = StateProvider((ref) {
  return ColorScheme.fromSeed(
      seedColor: Colors.green, brightness: ref.watch(brightnessProvider));
});

final expenseColorSchemeProvider = StateProvider((ref) {
  return ColorScheme.fromSeed(
      seedColor: Colors.red, brightness: ref.watch(brightnessProvider));
});
final themeColorProvider = StateProvider<Color>((ref) {
  ref.listenSelf(
    (previous, next) => GetStorage().write("themeColor", next.value),
  );
  GetStorage().read("themeColor") ??
      // ? Colors.blueGrey is the default app color
      GetStorage().write("themeColor", Colors.blueGrey.value);
  return Color(GetStorage().read("themeColor"));
});
final brightnessProvider = StateProvider<Brightness>((ref) {
  ref.listenSelf(
    (previous, next) =>
        GetStorage().write("isDark", next == Brightness.dark ? false : true),
  );
  GetStorage().read("isDark") ??
      // ? App is light by default
      GetStorage().write("isDark", false);
  return GetStorage().read("isDark") ? Brightness.light : Brightness.dark;
});

StateProvider<bool> dynamicProvider = StateProvider<bool>((ref) {
  ref.listenSelf(
    (previous, next) => GetStorage().write("isDynamic", next),
  );
  GetStorage().read("isDynamic") ?? GetStorage().write("isDynamic", true);
  return GetStorage().read("isDynamic");
});
