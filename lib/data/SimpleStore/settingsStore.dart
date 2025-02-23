import "package:currency_picker/currency_picker.dart";
// ? It's a hack, because I only want to store the currency string symbol
// ignore: implementation_imports
import "package:currency_picker/src/currencies.dart";
import "package:get_storage/get_storage.dart";
import "package:intl/intl.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "settingsStore.g.dart";

@Riverpod(keepAlive: true)
class Curr extends _$Curr {
  @override
  Currency build() {
    // ? Only save the name of the currency
    listenSelf(
      (previous, next) => GetStorage().write("currency", next.code),
    );
    GetStorage().read("currency") ?? GetStorage().write("currency", "INR");
    final Map<String, dynamic> m = currencies.firstWhere(
      (element) => element["code"] == GetStorage().read("currency") as String,
      // ? This should never happen, but just in case
      orElse: () => currencies[0],
    );
    return Currency.from(json: m);
  }

  @override
  set state(Currency newState) => super.state = newState;
}

@Riverpod(keepAlive: true)
class TransDelete extends _$TransDelete {
  @override
  bool build() {
    listenSelf(
      (previous, next) => GetStorage().write("transDeleteConfirmation", next),
    );
    GetStorage().read("transDeleteConfirmation") ??
        GetStorage().write("transDeleteConfirmation", false);
    return GetStorage().read("transDeleteConfirmation") as bool;
  }

  @override
  set state(bool newState) => super.state = newState;
}

@Riverpod(keepAlive: true)
class ChipsMultiLine extends _$ChipsMultiLine {
  @override
  bool build() {
    listenSelf(
      (previous, next) => GetStorage().write("chipsMultiLine", next),
    );
    GetStorage().read("chipsMultiLine") ??
        GetStorage().write("chipsMultiLine", false);
    return GetStorage().read("chipsMultiLine") as bool;
  }

  @override
  set state(bool newState) => super.state = newState;
}

@Riverpod(keepAlive: true)
class ShowLocation extends _$ShowLocation {
  @override
  bool build() {
    listenSelf(
      (previous, next) => GetStorage().write("showLocation", next),
    );
    GetStorage().read("showLocation") ??
        GetStorage().write("showLocation", false);
    return GetStorage().read("showLocation") as bool;
  }

  @override
  set state(bool newState) => super.state = newState;
}

@Riverpod(keepAlive: true)
class InitialPage extends _$InitialPage {
  @override
  int build() {
    listenSelf(
      (previous, next) => GetStorage().write("initialPage", next),
    );
    GetStorage().read("initialPage") ?? GetStorage().write("initialPage", 0);
    return GetStorage().read("initialPage") as int;
  }

  @override
  set state(int newState) => super.state = newState;
}

@Riverpod(keepAlive: true)
class NumberF extends _$NumberF {
  @override
  NumberFormat build() {
    final Currency currency = ref.watch(currProvider);
    final NumberFormat numberFormat = NumberFormat.currency(
      symbol: currency.symbol,
      decimalDigits: 2,
      name: currency.name,
    );
    return numberFormat;
  }
}
