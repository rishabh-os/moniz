import "dart:math";
import "dart:ui";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:graphic/graphic.dart";
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
                child: LineChart(data: spotsByDay)),
          ))
    ]));
  }
}

class LineChart extends StatelessWidget {
  const LineChart({super.key, required this.data});
  final Map data;

  @override
  Widget build(BuildContext context) {
    return Chart(
      rebuild: true,
      data: data.entries.toList(),
      variables: {
        "day": Variable(
          accessor: (MapEntry spot) =>
              DateFormat("d MMM").format(DateTime.parse(spot.key)),
        ),
        "amount": Variable(
          accessor: (MapEntry spot) => spot.value as double,
        ),
      },
      marks: [
        LineMark(
          size: SizeEncode(value: 5),
          shape: ShapeEncode(value: BasicLineShape(smooth: true)),
          color: ColorEncode(
              value: Theme.of(context).colorScheme.secondary.withOpacity(0.8)),
          transition: Transition(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutQuint),
          entrance: {MarkEntrance.opacity, MarkEntrance.y},
        ),
        AreaMark(
          shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
          color: ColorEncode(
            value: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
          ),
          transition: Transition(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutQuint),
          entrance: {MarkEntrance.opacity, MarkEntrance.y},
        )
      ],
      axes: [
        AxisGuide(
            label: LabelStyle(
                offset: const Offset(0, 20),
                rotation: -pi / 2,
                textStyle: Theme.of(context).textTheme.bodySmall)),
        AxisGuide(
            label: LabelStyle(
                offset: const Offset(-10, 0),
                textStyle: Theme.of(context).textTheme.bodySmall)),
      ],
      coord: RectCoord(
        horizontalRange: [-0.5, 2.55],
        horizontalRangeUpdater: Defaults.horizontalRangeEvent,
        // verticalRangeUpdater: Defaults.verticalRangeEvent
      ),
      selections: {
        "tap": PointSelection(
          dim: Dim.x,
          on: {GestureType.longPress, GestureType.longPressMoveUpdate},
          nearest: false,
        ),
        "tooltipMouse": PointSelection(
          on: {
            GestureType.hover,
          },
          devices: {PointerDeviceKind.mouse},
          nearest: false,
        ),
        "tooltipTouch": PointSelection(
          on: {
            GestureType.scaleUpdate,
            GestureType.tapDown,
            GestureType.longPressMoveUpdate
          },
          devices: {PointerDeviceKind.touch},
          nearest: false,
        ),
      },
      tooltip: TooltipGuide(
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
                rect:
                    Rect.fromCenter(center: labelOffset, width: 60, height: 30),
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
      ),
    );
  }
}
