// ignore_for_file: avoid_dynamic_calls
// ignore_for_file: non_bool_condition
// ignore_for_file: argument_type_not_assignable

import "dart:math";
import "dart:ui";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:graphic/graphic.dart";
import "package:intl/intl.dart";
import "package:moniz/data/SimpleStore/basicStore.dart";
import "package:moniz/data/SimpleStore/graphStore.dart";
import "package:moniz/data/category.dart";
import "package:moniz/screens/analysis/Analysis.dart";

class LineGraph extends ConsumerStatefulWidget {
  const LineGraph({super.key});

  @override
  ConsumerState<LineGraph> createState() => _LineGraphState();
}

class _LineGraphState extends ConsumerState<LineGraph> {
  @override
  Widget build(BuildContext context) {
    final bool showByCat = ref.watch(graphByCatProvider);
    final graphData = ref.watch(graphDataProvider);
    return SingleChildScrollView(
      child: Column(
        children: [
          SwitchListTile.adaptive(
            value: showByCat,
            onChanged: (_) => ref.watch(graphByCatProvider.notifier).toggle(),
            title: const Text("Show category-wise spends"),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: graphData.when(
                data: (data) => <Widget>[
                  AspectRatio(
                    aspectRatio: 1.4,
                    child: Padding(
                      // ? It different to account for how it looks with the axis labels
                      padding: const EdgeInsets.only(
                        right: 18,
                        left: 12,
                      ),
                      child: LineChart(
                        data: showByCat ? data.$2 : data.$1,
                        showCat: showByCat,
                      ),
                    ),
                  ),
                ],
                error: (error, stackTrace) => <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text("Error: $error"),
                  ),
                ],
                loading: () {
                  // ? Make this delayed by like 100ms idk
                  return const <Widget>[
                    SizedBox(height: 100),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          strokeWidth: 8,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text("Calculating..."),
                    ),
                  ];
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LineChart extends ConsumerStatefulWidget {
  const LineChart({
    super.key,
    required this.data,
    required this.showCat,
  });
  final List<List> data;
  final bool showCat;

  @override
  ConsumerState<LineChart> createState() => _LineChartState();
}

class _LineChartState extends ConsumerState<LineChart> {
  @override
  Widget build(BuildContext context) {
    final Map<String, Selection> selections2 = {
      "tooltipMouse": PointSelection(
        on: {GestureType.hover},
        devices: {PointerDeviceKind.touch},
        nearest: false,
      ),
      "tooltipTouch": PointSelection(
        on: {
          GestureType.scaleUpdate,
          GestureType.tapDown,
          GestureType.longPressMoveUpdate,
        },
        devices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
        nearest: false,
      ),
    };
    final tooltipGuide = TooltipGuide(
      selections: {"tooltipTouch", "tooltipMouse"},
      followPointer: [false, false],
      renderer: (size, anchor, selectedTuples) {
        final amount = selectedTuples.entries.first.value["amount"];
        final Offset labelOffset = anchor + const Offset(0, -30);
        final Color textColor = Theme.of(context).colorScheme.secondary;
        final Color backgroundColor =
            Theme.of(context).colorScheme.secondaryContainer;
        Color? borderColor;
        if (widget.showCat) {
          borderColor = Color(
            ref
                .read(categoriesProvider)
                .firstWhere(
                  (element) =>
                      element.name ==
                      selectedTuples.entries.first.value["category"],
                )
                .color,
          );
        }
        return [
          OvalElement(
            oval: Rect.fromCircle(center: anchor, radius: 5),
            style: PaintStyle(
              fillColor: textColor,
              strokeWidth: 2,
            ),
          ),
          RectElement(
            rect: Rect.fromCenter(center: labelOffset, width: 60, height: 30),
            borderRadius: BorderRadius.circular(15),
            style: PaintStyle(
              fillColor: backgroundColor,
              strokeWidth: 4,
              strokeColor: borderColor,
            ),
          ),
          LabelElement(
            text: amount.toString(),
            anchor: labelOffset,
            style: LabelStyle(
              textStyle: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ];
      },
    );
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

    final Map<String, Variable<List<dynamic>, dynamic>> variables =
        widget.showCat
            ? {
                "day": Variable(
                  accessor: (List spot) {
                    final String dayMonth = DateFormat("d MMM yy")
                        .format(DateTime.parse(spot[0] as String));
                    return dayMonth;
                  },
                ),
                "category": Variable(
                  accessor: (List spot) => spot[1].name as String,
                  scale: OrdinalScale(tickCount: 0),
                ),
                "amount": Variable(
                  accessor: (List spot) => spot[2] as double,
                  scale: LinearScale(
                    min: 0,
                    marginMax: 0.2,
                  ),
                ),
              }
            : {
                "day": Variable(
                  accessor: (List spot) {
                    final String dayMonth = DateFormat("d MMM yy")
                        .format(DateTime.parse(spot[0] as String));
                    return dayMonth;
                  },
                ),
                "amount": Variable(
                  accessor: (List spot) => spot[1] as double,
                  scale: LinearScale(
                    min: 0,
                    marginMax: 0.2,
                  ),
                ),
              };

    final List<Mark<Shape>> marks = widget.showCat
        ? [
            IntervalMark(
              size: SizeEncode(value: 20),
              position: Varset("day") * Varset("amount") / Varset("category"),
              shape: ShapeEncode(
                value: RectShape(borderRadius: BorderRadius.circular(2)),
              ),
              color: ColorEncode(
                variable: "category",
                values: ref
                    .read(categoriesProvider)
                    .map((e) => Color(e.color))
                    .toList(),
              ),
              transition: Transition(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOutCubicEmphasized,
              ),
              entrance: {MarkEntrance.opacity, MarkEntrance.y},
              modifiers: [StackModifier()],
            ),
          ]
        : [
            LineMark(
              size: SizeEncode(value: 5),
              shape: ShapeEncode(value: BasicLineShape(smooth: true)),
              color: ColorEncode(
                value: Theme.of(context)
                    .colorScheme
                    .secondary
                    .withValues(alpha: 0.8),
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
                value: Theme.of(context)
                    .colorScheme
                    .secondary
                    .withValues(alpha: 0.2),
              ),
              transition: Transition(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOutCubicEmphasized,
              ),
              entrance: {MarkEntrance.opacity, MarkEntrance.y},
            ),
          ];
// ? Here I do some maths to scale the graph to the number of days
    final List days = [];
    for (final element in widget.data) {
      days.add(element[0]);
    }
    final int nDays = days.toSet().length;
    // ? Cutoff assumes 10 bars can fit on screen comfortably
    const int cutOff = 10;
    final rectCoord = RectCoord(
      horizontalRange: nDays >= cutOff
          ? [
              -(1 / cutOff) * (nDays - cutOff),
              1,
            ]
          : [0, 1],
      horizontalRangeUpdater: Defaults.horizontalRangeEvent,
    );
    // ? The mouse region allows the chart interaction to take priority
    return widget.data.every((element) => element.last == 0)
        ? const NoData()
        : Chart(
            data: widget.data,
            variables: variables,
            marks: marks,
            axes: axes,
            coord: rectCoord,
            selections: selections2,
            tooltip: tooltipGuide,
          );
  }
}
