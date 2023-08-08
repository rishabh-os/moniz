import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:get_storage/get_storage.dart";
import "package:intl/intl.dart";

final currencyProvider = StateProvider<String>((ref) {
  ref.listenSelf(
    (previous, next) => GetStorage().write("currency", next),
  );
  GetStorage().read("currency") ?? GetStorage().write("currency", "INR");
  return (GetStorage().read("currency"));
});
final transDeleteProvider = StateProvider<bool>((ref) {
  ref.listenSelf(
    (previous, next) => GetStorage().write("transDeleteConfirmation", next),
  );
  GetStorage().read("transDeleteConfirmation") ??
      GetStorage().write("transDeleteConfirmation", false);
  return GetStorage().read("transDeleteConfirmation");
});
StateProvider<bool> chipsMultiLineProvider = StateProvider<bool>((ref) {
  ref.listenSelf(
    (previous, next) => GetStorage().write("chipsMultiLine", next),
  );
  GetStorage().read("chipsMultiLine") ??
      GetStorage().write("chipsMultiLine", false);
  return GetStorage().read("chipsMultiLine");
});
final numberFormatProvider = StateProvider<NumberFormat>((ref) {
  return NumberFormat("#,##0.00", "en_US");
});
