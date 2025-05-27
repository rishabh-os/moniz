import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/data/SimpleStore/settingsStore.dart";
import "package:numeral/numeral.dart";

class MoneyDisplay extends ConsumerStatefulWidget {
  const MoneyDisplay({
    super.key,
    required this.amount,
    this.textColor,
    this.fontSize = 24,
    this.pretty = true,
  });

  final int amount;
  final Color? textColor;
  final double? fontSize;
  final bool pretty;

  @override
  ConsumerState<MoneyDisplay> createState() => _MoneyDisplayState();
}

class _MoneyDisplayState extends ConsumerState<MoneyDisplay> {
  @override
  Widget build(BuildContext context) {
    final numberFormat = ref.watch(numberFProvider);
    final prettyValue = (widget.amount / 100).numeral(digits: 2);

    final String displayValue;
    if (RegExp("[a-zA-Z]")
            .hasMatch(prettyValue.substring(prettyValue.length - 1)) &&
        widget.pretty) {
      final double numericalPart =
          double.parse(prettyValue.substring(0, prettyValue.length - 1));
      final String suffix = prettyValue.substring(prettyValue.length - 1);
      displayValue = "${numberFormat.format(numericalPart)}$suffix";
    } else {
      displayValue = numberFormat.format(widget.amount / 100);
    }

    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: [
          TextSpan(
            text: displayValue,
            style: TextStyle(
              fontFeatures: const [FontFeature.enable("ss02")],
              fontFamily: "VictorMono",
              fontSize: widget.fontSize,
              color: widget.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
