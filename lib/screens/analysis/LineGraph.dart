import "dart:math";
import "dart:ui";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:graphic/graphic.dart";
import "package:moniz/data/SimpleStore/basicStore.dart";
import "package:moniz/data/category.dart";
import "package:moniz/data/transactions.dart";

class LineGraph extends ConsumerStatefulWidget {
  const LineGraph({super.key});

  @override
  ConsumerState<LineGraph> createState() => _LineGraphState();
}

class _LineGraphState extends ConsumerState<LineGraph> {
  List<String> days = [];

  String getDTString(DateTime trans) {
    // ? This type is needed so that sorting works easily
    return DateTime(trans.year, trans.month, trans.day)
        .toString()
        .split(" ")[0];
  }

  @override
  Widget build(BuildContext context) {
    bool showByCat = ref.watch(graphByCatProvider);
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

    List<List> spendsByCategory = [
      for (var x in days)
        for (var y in ref.read(categoriesProvider)) [x, y, 0.0]
    ];

    for (var transaction in transactionList) {
      for (var element in spendsByCategory) {
        if (element[0] == getDTString(transaction.recorded) &&
            element[1].id == transaction.categoryID &&
            transaction.amount.isNegative) {
          element[2] += transaction.amount.abs();
        }
      }
    }

    List<List> spendsByDay = [];
    for (var day in days) {
      var x = spendsByCategory.fold(0.0, (sum, element) {
        if (element[0] == day) {
          return sum + element[2];
        }
        return sum;
      });
      spendsByDay.add([day, x]);
    }

    return SingleChildScrollView(
        child: Column(children: [
      SwitchListTile.adaptive(
        value: showByCat,
        onChanged: (value) {
          ref.watch(graphByCatProvider.notifier).state = value;
        },
        title: const Text("Show category-wise spends"),
      ),
      Padding(
          padding: const EdgeInsets.only(top: 20),
          child: AspectRatio(
            aspectRatio: 1.4,
            child: Padding(
                padding: const EdgeInsets.only(
                  right: 18,
                  left: 12,
                  bottom: 18,
                ),
                child: LineChart(
                  data: showByCat ? spendsByCategory : spendsByDay,
                  maxY: spendsByDay.reduce((currentDay, nextDay) =>
                      currentDay[1] > nextDay[1] ? currentDay : nextDay)[1],
                  showCat: showByCat,
                )),
          ))
    ]));
  }
}

class LineChart extends ConsumerStatefulWidget {
  const LineChart(
      {super.key,
      required this.data,
      required this.maxY,
      required this.showCat});
  final List<List> data;
  final double maxY;
  final bool showCat;

  @override
  ConsumerState<LineChart> createState() => _LineChartState();
}

class _LineChartState extends ConsumerState<LineChart> {
  @override
  Widget build(BuildContext context) {
    var selections2 = {
      "tooltipMouse": PointSelection(
        on: {GestureType.hover},
        devices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
        nearest: false,
      ),
      "tooltipTouch": PointSelection(
        on: {
          GestureType.scaleUpdate,
          GestureType.tapDown,
          GestureType.longPressMoveUpdate
        },
        devices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
        nearest: false,
      ),
    };
    var tooltipGuide = TooltipGuide(
      selections: {"tooltipTouch", "tooltipMouse"},
      followPointer: [false, false],
      renderer: (size, anchor, selectedTuples) {
        var amount = (selectedTuples.entries.first.value["amount"]);
        Offset labelOffset = anchor + const Offset(0, -30);
        return [
          OvalElement(
            oval: Rect.fromCircle(center: anchor, radius: 5),
            style: PaintStyle(
              fillColor: Theme.of(context).colorScheme.secondary,
              strokeWidth: 2,
            ),
          ),
          RectElement(
              rect: Rect.fromCenter(center: labelOffset, width: 60, height: 30),
              borderRadius: BorderRadius.circular(15),
              style: PaintStyle(
                  fillColor: Theme.of(context).colorScheme.secondaryContainer,
                  strokeWidth: 2)),
          LabelElement(
              text: amount.toString(),
              anchor: labelOffset,
              style: LabelStyle(
                textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ))
        ];
      },
    );
    var axes2 = [
      AxisGuide(
          label: LabelStyle(
              offset: const Offset(-10, 40),
              rotation: -pi / 2,
              textStyle: Theme.of(context).textTheme.bodySmall)),
      AxisGuide(
          label: LabelStyle(
              offset: const Offset(-10, 0),
              textStyle: Theme.of(context).textTheme.bodySmall)),
    ];

    Map<String, Variable<List<dynamic>, dynamic>> variables = widget.showCat
        ? {
            "day": Variable(
              accessor: (List spot) => spot[0] as String,
            ),
            "category": Variable(
              accessor: (List spot) => spot[1].name as String,
            ),
            "amount": Variable(
              accessor: (List spot) => spot[2] as double,
              scale: LinearScale(
                min: 0,
                max: widget.maxY * 1.30,
              ),
            ),
          }
        : {
            "day": Variable(
              accessor: (List spot) => spot[0] as String,
            ),
            "amount": Variable(
              accessor: (List spot) => spot[1] as double,
              scale: LinearScale(
                min: 0,
                max: widget.maxY * 1.30,
              ),
            ),
          };

    List<Mark<Shape>> marks = widget.showCat
        ? [
            IntervalMark(
              size: SizeEncode(value: 20),
              position: Varset("day") * Varset("amount") / Varset("category"),
              shape: ShapeEncode(
                  value: RectShape(borderRadius: BorderRadius.circular(2))),
              color: ColorEncode(
                variable: "category",
                values: ref
                    .read(categoriesProvider)
                    .map((e) => Color(e.color))
                    .toList(),
              ),
              transition: Transition(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutQuint),
              entrance: {MarkEntrance.opacity, MarkEntrance.y},
              modifiers: [StackModifier()],
            ),
          ]
        : [
            LineMark(
              size: SizeEncode(value: 5),
              shape: ShapeEncode(value: BasicLineShape(smooth: true)),
              color: ColorEncode(
                  value:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.8)),
              transition: Transition(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutQuint),
              entrance: {MarkEntrance.opacity, MarkEntrance.y},
            ),
            AreaMark(
              shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
              color: ColorEncode(
                value: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              ),
              transition: Transition(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutQuint),
              entrance: {MarkEntrance.opacity, MarkEntrance.y},
            ),
          ];
// ? Here I do some maths to scale the graph to the number of days
    List days = [];
    for (var element in widget.data) {
      days.add(element[0]);
    }
    int nDays = days.toSet().length;
    // ? Cutoff assumes 12 bars can fit on screen comfortably
    int cutOff = 12;
    var rectCoord = RectCoord(
      horizontalRange:
          nDays >= cutOff ? [0, 1 + (1 / cutOff) * (nDays - cutOff)] : [0, 1],
      horizontalRangeUpdater: Defaults.horizontalRangeEvent,
      // verticalRangeUpdater: Defaults.verticalRangeEvent
    );
    // ? The mouse region allows the chart interaction to take priority
    return MouseRegion(
      onHover: (event) {
        ref.read(chartScrollProvider.notifier).update((state) => false);
      },
      onExit: (event) =>
          ref.read(chartScrollProvider.notifier).update((state) => true),
      child: Chart(
        rebuild: true,
        data: widget.data,
        variables: variables,
        marks: marks,
        axes: axes2,
        coord: rectCoord,
        selections: selections2,
        tooltip: tooltipGuide,
      ),
    );
  }
}
