import "dart:math";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:moniz/data/SimpleStore/basicStore.dart";
import "package:moniz/data/transactions.dart";

class SpendsByDay extends ConsumerStatefulWidget {
  const SpendsByDay({super.key});

  @override
  ConsumerState<SpendsByDay> createState() => _SpendsByDayState();
}

class _SpendsByDayState extends ConsumerState<SpendsByDay> {
  List<String> days = [];

  String getDTString(DateTime trans) {
    // ? This type is needed so that sorting works easily
    return DateTime(trans.year, trans.month, trans.day)
        .toString()
        .split(" ")[0];
  }

  @override
  Widget build(BuildContext context) {
    List<Transaction> transactionList = ref.watch(transactionsProvider);
    final range = ref.watch(globalDateRangeProvider);
    final numberOfDays = range.end.difference(range.start).inDays;
    days = List.generate(
        numberOfDays,
        (i) => getDTString(DateTime(
            range.start.year, range.start.month, range.start.day + (i))));
    // ? The built-in sort method works! Ez pz
    days.sort((a, b) {
      return a.compareTo(b);
    });
    Map<String, double> spotsByDay = {for (var v in days) v: 0};
    for (var trans in transactionList) {
      if (trans.amount < 0) {
        spotsByDay.update(
          getDTString(trans.recorded),
          (value) =>
              spotsByDay[getDTString(trans.recorded)]! + trans.amount.abs(),
          ifAbsent: () => 0,
        );
      }
    }
    List<FlSpot> spotData = spotsByDay.entries
        .map((e) => FlSpot(days.indexOf(e.key).toDouble(), e.value))
        .toList();

    return SingleChildScrollView(
        child: Column(children: [
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
          child: AspectRatio(
            aspectRatio: 1.4,
            child: Padding(
                padding: const EdgeInsets.only(
                  right: 18,
                  left: 12,
                  bottom: 18,
                ),
                child: TotalLineChart(
                  data: spotData,
                  days: days,
                )),
          ))
    ]));
  }
}

class TotalLineChart extends StatelessWidget {
  const TotalLineChart({super.key, required this.data, required this.days});
  final List<FlSpot> data;
  final List days;

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    Widget text;
    if (value % 1 == 0 && days.isNotEmpty) {
      try {
        var x = days[value.toInt()];
        text = Text(DateFormat("d MMM").format(DateTime.parse(x)));
      } on RangeError catch (_) {
        text = Container();
      }
    } else {
      text = Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Transform.translate(
        offset: const Offset(0, 10),
        child: Transform.rotate(
          angle: -pi / 2.5,
          child: text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
            getTouchedSpotIndicator: (barData, spotIndexes) {
              return spotIndexes.map((spotIndex) {
                return TouchedSpotIndicatorData(
                  const FlLine(strokeWidth: 0),
                  FlDotData(
                    getDotPainter: (spot, percent, barData, index) =>
                        FlDotCirclePainter(
                            radius: 6,
                            color: Theme.of(context).colorScheme.secondary,
                            strokeWidth: 0),
                  ),
                );
              }).toList();
            },
            touchTooltipData: LineTouchTooltipData(
                tooltipRoundedRadius: 20,
                tooltipBgColor:
                    Theme.of(context).colorScheme.secondaryContainer)),
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: bottomTitleWidgets,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minY: 0,
        lineBarsData: [
          LineChartBarData(
            spots: data,
            isCurved: true,
            preventCurveOverShooting: true,
            barWidth: 5,
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
            isStrokeCapRound: true,
            showingIndicators: [],
            dotData: const FlDotData(
              show: false,
            ),
            belowBarData: BarAreaData(
                show: true,
                color:
                    Theme.of(context).colorScheme.secondary.withOpacity(0.2)),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 300),
    );
  }
}
