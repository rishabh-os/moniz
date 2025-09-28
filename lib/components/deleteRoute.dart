import "dart:math" show max, sqrt;
import "dart:ui" show lerpDouble;

import "package:flutter/material.dart";
import "package:moniz/data/account.dart";
import "package:moniz/data/category.dart";
import "package:moniz/data/transactions.dart";
import "package:moniz/screens/entries/EntryEditor.dart";
import "package:moniz/screens/manage/AccountEditor.dart";

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
  Duration get transitionDuration => duration;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curveTween = CurveTween(curve: Curves.easeIn);
    return ClipPath(
      clipper: CircularRevealClipper(
        fraction: animation.drive(curveTween).value,
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
  Offset get centerOffset => Offset.zero;
  double get minRadius => 0;
  double get maxRadius => 900;

  @override
  Path getClip(Size size) {
    final Offset center = centerAlignment.alongSize(size);
    final minRadius = this.minRadius;
    final maxRadius = this.maxRadius;

    return Path()..addOval(
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
  final RenderBox renderbox =
      widgetKey.currentContext!.findRenderObject()! as RenderBox;
  final Offset position = renderbox.localToGlobal(Offset.zero);
  final double y = position.dy;
  final double heightW = renderbox.size.height;
  final double height = MediaQuery.of(context).size.height;
  Navigator.push(
    context,
    DeleteRoute<void>(
      // * Yes I know this is bad code (nested ternaries)
      page: content.runtimeType == Transaction
          ? EntryEditor(transaction: content as Transaction)
          : content.runtimeType == TransactionCategory
          ? AccountEditor(
              editedCategory: content as TransactionCategory,
              type: "Category",
            )
          : AccountEditor(editedAccount: content as Account, type: "Account"),
      startPositionGlobal:
          // ? Convert and scale global coordinates to Alignment values
          // ? This makes the animation start from the center of the widget
          Alignment(0, (y + heightW / 2) / height * 2 - 1),
    ),
  );
}
