import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:moniz/data/SimpleStore/settingsStore.dart";
import "package:moniz/data/listOfCurrencies.dart";

class MoneyDisplay extends ConsumerStatefulWidget {
  const MoneyDisplay({
    super.key,
    required this.amount,
    this.textColor,
  });

  final double amount;
  final Color? textColor;

  @override
  ConsumerState<MoneyDisplay> createState() => _MoneyDisplayState();
}

class _MoneyDisplayState extends ConsumerState<MoneyDisplay> {
  @override
  Widget build(BuildContext context) {
    final String symbol = currencies.firstWhere(
      (element) => element["code"] == ref.watch(currencyProvider),
    )["symbol"] as String;
    final NumberFormat numberFormat = ref.watch(numberFormatProvider);
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: [
          TextSpan(
            text: symbol,
            style: TextStyle(
              fontSize: 24,
              fontFamily: "VictorMono",
              fontWeight: FontWeight.w600,
              color: widget.textColor,
            ),
          ),
          TextSpan(
            text: numberFormat.format(widget.amount),
            style: TextStyle(
              fontFeatures: const [FontFeature.enable("ss02")],
              fontFamily: "VictorMono",
              fontSize: 24,
              color: widget.textColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
