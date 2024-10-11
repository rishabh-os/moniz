import "dart:math";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:graphic/graphic.dart";
import "package:intl/intl.dart";
import "package:moniz/data/SimpleStore/basicStore.dart";
import "package:moniz/data/category.dart";
import "package:moniz/data/transactions.dart";

String getDTString(DateTime date) {
  // ? This type is needed so that sorting works easily
  return DateTime(date.year, date.month, date.day).toString().split(" ")[0];
}

class LineGraph2 extends ConsumerStatefulWidget {
  const LineGraph2({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _Linegraph2State();
}

typedef ChartData = Map<String, Map<TransactionCategory, double>>;

class _Linegraph2State extends ConsumerState<LineGraph2> {
  @override
  Widget build(BuildContext context) {
    final bool showByCat = ref.watch(graphByCatProvider);
    final List<Transaction> transactionList = ref.watch(searchedTransProvider);
    final range = ref.watch(globalDateRangeProvider);
    final numberOfDays = range.end.difference(range.start).inDays;
    final List<String> days = List.generate(
      numberOfDays,
      (i) => getDTString(
        DateTime(
          range.start.year,
          range.start.month,
          range.start.day + i,
        ),
      ),
    );
    // ? The built-in sort method works! Ez pz
    days.sort((a, b) {
      return a.compareTo(b);
    });

    final ChartData chartData = {
      for (final day in days)
        day: {
          for (final category in ref.read(categoriesProvider)) category: 0.0,
        },
    };
    for (final trans in transactionList) {
      if (trans.amount < 0) {
        final day = getDTString(trans.recorded);
        final transCategory = ref.read(categoriesProvider).firstWhere(
              (element) => element.id == trans.categoryID,
            );
        chartData[day]?[transCategory] = trans.amount.abs();
      }
    }

    // ? MAP CONSTANTS

    final Map<
        String,
        Variable<MapEntry<String, Map<TransactionCategory, double>>,
            dynamic>> variables = {
      "day": Variable(
        accessor: (MapEntry<String, Map<TransactionCategory, double>> spot) {
          final String dayMonth =
              DateFormat("d MMM yy").format(DateTime.parse(spot.key));
          return dayMonth;
        },
      ),
      "amount": Variable(
        accessor: (MapEntry<String, Map<TransactionCategory, double>> spot) {
          // ? Combine all category values into one total for the day
          return spot.value.values.reduce((a, b) => a + b);
        },
      ),
      "category": Variable(
        accessor: (MapEntry<String, Map<TransactionCategory, double>> spot) {
          return spot.value.keys.first.name;
        },
      ),
    };

    final List<Mark> marks = [
      LineMark(
        size: SizeEncode(value: 5),
        shape: ShapeEncode(value: BasicLineShape(smooth: true)),
        color: ColorEncode(
          value: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
        ),
        transition: Transition(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubicEmphasized,
        ),
        entrance: {MarkEntrance.opacity, MarkEntrance.y},
      ),
      AreaMark(
        shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
        color: ColorEncode(
          value: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
        ),
        transition: Transition(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubicEmphasized,
        ),
        entrance: {MarkEntrance.opacity, MarkEntrance.y},
      ),
    ];

    final axes = [
      AxisGuide(
        label: LabelStyle(
          offset: const Offset(-10, 30),
          rotation: -pi / 2,
          textStyle: Theme.of(context).textTheme.bodySmall,
        ),
      ),
      AxisGuide(
        label: LabelStyle(
          offset: const Offset(-10, 0),
          textStyle: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          SwitchListTile.adaptive(
            value: showByCat,
            onChanged: (value) {
              ref.watch(graphByCatProvider.notifier).state = value;
            },
            title: const Text("Show category-wise spends"),
          ),
          AspectRatio(
            aspectRatio: 1.4,
            child: Padding(
              // ? It different to account for how it looks with the axis labels
              padding: const EdgeInsets.only(
                right: 18,
                left: 12,
              ),
              child: Chart(
                data: chartData.entries.toList(),
                variables: variables,
                marks: marks,
                axes: axes,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
