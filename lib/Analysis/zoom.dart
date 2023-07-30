import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ZoomableChart extends StatefulWidget {
  const ZoomableChart({
    super.key,
    required this.maxX,
    required this.builder,
  });

  final double maxX;
  final Widget Function(double, double) builder;

  @override
  State<ZoomableChart> createState() => _ZoomableChartState();
}

class _ZoomableChartState extends State<ZoomableChart> {
  late double minX;
  late double maxX;

  late double lastMaxXValue;
  late double lastMinXValue;

  @override
  void initState() {
    super.initState();
    resetScale();
  }

  void resetScale() {
    minX = 0;
    maxX = widget.maxX;
    lastMinXValue = minX;
    lastMaxXValue = maxX;
  }

  @override
  void didUpdateWidget(covariant ZoomableChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    resetScale();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => tapMethod(1.5),
      onVerticalDragUpdate: (details) {
        print(details.delta);
      },
      onHorizontalDragStart: (details) {
        lastMinXValue = minX;
        lastMaxXValue = maxX;
      },
      onHorizontalDragUpdate: (details) {
        var horizontalDistance = details.primaryDelta ?? 0;
        if (horizontalDistance == 0) return;
        var lastMinMaxDistance = max(lastMaxXValue - lastMinXValue, 0.0);

        setState(() {
          minX -= lastMinMaxDistance * 0.005 * horizontalDistance;
          maxX -= lastMinMaxDistance * 0.005 * horizontalDistance;

          if (minX < 0) {
            minX = 0;
            maxX = lastMinMaxDistance;
          }
          if (maxX > widget.maxX) {
            maxX = widget.maxX;
            minX = maxX - lastMinMaxDistance;
          }
        });
      },
      // onScaleStart: (details) {
      //   print("Scale started");
      // },
      // onScaleUpdate: (details) {
      //   if (details.scale != 1.0) {
      //     print(details.focalPointDelta);
      //     zoom(details.scale);
      //   }
      // },
      onSecondaryTap: () => tapMethod(1.5),
      child: Listener(
          onPointerSignal: (pointerSignal) {
            if (pointerSignal is PointerScrollEvent) {
              zoom(pointerSignal.scrollDelta.dy);
            }
          },
          child: widget.builder(minX, maxX)),
    );
  }

  void zoom(double dy) {
    if (dy < 0) {
      minX += 1;
      maxX -= 1;
    } else {
      minX -= 1;
      maxX += 1;
    }
    lastMinXValue = minX;
    lastMaxXValue = maxX;
    setState(() {});
  }

  void tapMethod(double scale) {
    var horizontalScale = scale;
    if (horizontalScale == 0) return;

    var lastMinMaxDistance = max(lastMaxXValue - lastMinXValue, 0);
    var newMinMaxDistance = max(lastMinMaxDistance / horizontalScale, 10);
    var distanceDifference = newMinMaxDistance - lastMinMaxDistance;

    final newMinX = max(
      lastMinXValue - distanceDifference,
      0.0,
    );
    final newMaxX = min(
      lastMaxXValue + distanceDifference,
      widget.maxX,
    );

    if (newMaxX - newMinX > 2) {
      minX = newMinX;
      maxX = newMaxX;
    }
    setState(() {});
  }
}
