import "package:flutter/material.dart";

class AccountIcon extends StatelessWidget {
  const AccountIcon({
    super.key,
    required this.color,
    required this.iconCodepoint,
    this.size,
    this.showBgColor = true,
  });

  final int color;
  final int iconCodepoint;
  final double? size;
  final bool showBgColor;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: showBgColor
          ? ColorScheme.fromSeed(
              dynamicSchemeVariant: DynamicSchemeVariant.rainbow,
              seedColor: Color(color),
              brightness: Theme.of(context).brightness,
            ).primaryContainer
          : Colors.transparent,
      child: Icon(
        IconData(iconCodepoint, fontFamily: "MaterialIcons"),
        color: ColorScheme.fromSeed(
          dynamicSchemeVariant: DynamicSchemeVariant.rainbow,
          seedColor: Color(color),
          brightness: Theme.of(context).brightness,
        ).primary,
        // size: size,
      ),
    );
  }
}
