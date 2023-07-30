import 'package:flutter/material.dart';

class AccountIcon extends StatelessWidget {
  const AccountIcon(
      {super.key, required this.color, required this.iconCodepoint, this.size});

  final int color;
  final int iconCodepoint;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: ColorScheme.fromSeed(
              seedColor: Color(color), brightness: Theme.of(context).brightness)
          .primaryContainer,
      child: Icon(
        IconData(iconCodepoint, fontFamily: 'MaterialIcons'),
        color: ColorScheme.fromSeed(
                seedColor: Color(color),
                brightness: Theme.of(context).brightness)
            .primary,
        // size: size,
      ),
    );
  }
}
