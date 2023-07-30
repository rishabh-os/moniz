import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';

final incomeColorSchemeProvider = StateProvider((ref) {
  return ColorScheme.fromSeed(
      seedColor: Colors.green, brightness: ref.watch(brightnessProvider));
});

final expenseColorSchemeProvider = StateProvider((ref) {
  return ColorScheme.fromSeed(
      seedColor: Colors.red, brightness: ref.watch(brightnessProvider));
});
final themeColorProvider = StateProvider<Color>((ref) {
  GetStorage().read("themeColor") ??
      // ? Colors.blueGrey is the default app color
      GetStorage().write("themeColor", Colors.blueGrey.value);
  return Color(GetStorage().read("themeColor"));
});
final brightnessProvider = StateProvider<Brightness>((ref) {
  GetStorage().read("isDark") ??
      // ? Colors.blueGrey is the default app color
      GetStorage().write("isDark", false);
  return GetStorage().read("isDark") ? Brightness.light : Brightness.dark;
});

final dynamicProvider = StateProvider<bool>((ref) {
  GetStorage().read("isDynamic") ??
      // ? Colors.blueGrey is the default app color
      GetStorage().write("isDynamic", false);
  return GetStorage().read("isDynamic");
});
