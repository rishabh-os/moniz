import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

final currencyProvider = StateProvider<String>((ref) {
  GetStorage().read("currency") ??
      // ? Default currency is INR
      GetStorage().write("currency", "INR");
  return (GetStorage().read("currency"));
});
final transDeleteProvider = StateProvider<bool>((ref) {
  GetStorage().read("transDeleteConfirmation") ??
      // ? Colors.blueGrey is the default app color
      GetStorage().write("transDeleteConfirmation", false);
  return GetStorage().read("transDeleteConfirmation");
});
final numberFormatProvider = StateProvider<NumberFormat>((ref) {
  return NumberFormat("#,##0.00", "en_US");
});
