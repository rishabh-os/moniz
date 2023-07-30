import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:moniz/data/SimpleStore/settingsStore.dart';
import 'package:moniz/data/listOfCurrencies.dart';

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
    String symbol = currencies.firstWhere(
        (element) => element["code"] == ref.watch(currencyProvider))["symbol"];
    NumberFormat numberFormat = ref.watch(numberFormatProvider);
    return Wrap(
      spacing: 4,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: [
        RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: [
              TextSpan(
                text: symbol,
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: "VictorMono",
                    fontWeight: FontWeight.w600,
                    color: widget.textColor),
              ),
              TextSpan(
                text: numberFormat.format(widget.amount),
                style: TextStyle(
                    fontFeatures: const [FontFeature.enable("ss02")],
                    fontFamily: "VictorMono",
                    fontSize: 24,
                    color: widget.textColor,
                    fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        // CounterTest(
        //   count: widget.amount,
        // )
      ],
    );
  }
}

class CounterTest extends StatefulWidget {
  const CounterTest({super.key, required this.count});
  final double count;
  @override
  createState() => CounterTestState();
}

class CounterTestState extends State<CounterTest>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );
    _animation = _controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    testMethod();
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(_animation.value.toStringAsFixed(2));
      },
    );
  }

  void testMethod() {
    // _miles += rng.nextInt(20) + 0.3;
    _animation = Tween<double>(
      begin: _animation.value,
      end: widget.count,
    ).animate(CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: _controller,
    ));

    _controller.forward(from: widget.count);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
