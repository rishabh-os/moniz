import "package:flutter/material.dart";
import "package:flutter_iconpicker/Models/configuration.dart";
import "package:flutter_iconpicker/flutter_iconpicker.dart";
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
    _icon = IconData(widget.iconCodepoint);
  }

  Future<void> _pickIcon() async {
    final icon = await showIconPicker(
      context,
      configuration: const SinglePickerConfiguration(
        // ? Remember to run
        // ? dart run flutter_iconpicker:generate_packs --packs roundedMaterial
        iconPackModes: [IconPack.roundedMaterial],
      ),
    );

    setState(() {
      if (icon != null) {
        _icon = icon.data;
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
