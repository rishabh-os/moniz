import "dart:math" show sqrt, max;
import "dart:ui" show lerpDouble;
import "package:flutter/material.dart";
import "package:moniz/data/category.dart";
import "package:moniz/data/transactions.dart";
import "package:moniz/screens/accounts/AccountEditor.dart";
import "package:moniz/screens/entries/EntryEditor.dart";

class DeleteRoute<T> extends MaterialPageRoute<T> {
  final Widget page;
  DeleteRoute({
    required this.page,
    this.duration = const Duration(milliseconds: 400),
    required this.startPositionGlobal,
  }) : super(builder: (_) => page);
  final Duration duration;
  final Alignment startPositionGlobal;

  @override
  Duration get transitionDuration => this.duration;

  @override
  Widget buildTransitions(context, animation, secondaryAnimation, child) {
    return ClipPath(
      clipper: CircularRevealClipper(
        fraction: animation.value,
        centerAlignment: startPositionGlobal,
      ),
      child: child,
    );
  }
}

@immutable
class CircularRevealClipper extends CustomClipper<Path> {
  const CircularRevealClipper({
    required this.fraction,
    required this.centerAlignment,
  });
  final double fraction;
  final Alignment centerAlignment;
  final Offset centerOffset = const Offset(0, 0);
  final double minRadius = 0;
  final double maxRadius = 900;

  @override
  Path getClip(Size size) {
    final Offset center = centerAlignment.alongSize(size);
    final minRadius = this.minRadius;
    final maxRadius = this.maxRadius;

    return Path()
      ..addOval(
        Rect.fromCircle(
          center: center,
          radius: lerpDouble(minRadius, maxRadius, fraction)!,
        ),
      );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;

  static double calcMaxRadius(Size size, Offset center) {
    final w = max(center.dx, size.width - center.dx);
    final h = max(center.dy, size.height - center.dy);
    return sqrt(w * w + h * h);
  }
}

void handleTap(GlobalKey widgetKey, BuildContext context, dynamic content) {
  RenderBox renderbox =
      widgetKey.currentContext!.findRenderObject() as RenderBox;
  Offset position = renderbox.localToGlobal(Offset.zero);
  double y = position.dy;
  double heightW = renderbox.size.height;
  double height = MediaQuery.of(context).size.height;
  Navigator.push(
    context,
    DeleteRoute(
      // * Yes I know this is bad code (nested ternaries)
      page: content.runtimeType == Transaction
          ? EntryEditor(transaction: content)
          : content.runtimeType == TransactionCategory
              ? AccountEditor(
                  editedCategory: content,
                  type: "Category",
                )
              : AccountEditor(
                  editedAccount: content,
                  type: "Account",
                ),
      startPositionGlobal:
          // ? Convert and scale global coordinates to Alignment values
          // ? This makes the animation start from the center of the widget
          Alignment(0, (y + heightW / 2) / height * 2 - 1),
    ),
  );
}
