import "package:flutter/material.dart";
import "package:flutter_iconpicker/flutter_iconpicker.dart";
import "package:moniz/data/AllIcons.dart";
import "package:moniz/screens/manage/AccountIcon.dart";

class IconPicker extends StatefulWidget {
  const IconPicker({
    super.key,
    required this.iconCallback,
    required this.color,
    required this.iconCodepoint,
  });
  final int color;
  final Function(IconData selectedColor) iconCallback;
  final int iconCodepoint;

  @override
  State<IconPicker> createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
  late IconData _icon;
  @override
  void initState() {
    super.initState();
    // ? This is a huge list, so it isn't synchronous
    allIcons.removeWhere((key, value) => !key.contains("rounded"));
    _icon = IconData(widget.iconCodepoint);
  }

  _pickIcon() async {
    IconData? icon = await FlutterIconPicker.showIconPicker(context,
        iconPackModes: [IconPack.custom], customIconPack: allIcons);

    setState(() {
      if (icon != null) {
        _icon = icon;
        widget.iconCallback(_icon);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.5,
      child: IconButton(
        icon: AccountIcon(
          color: widget.color,
          iconCodepoint: _icon.codePoint,
          size: 50,
        ),
        onPressed: () {
          _pickIcon();
        },
      ),
    );
  }
}
