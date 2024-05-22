import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/data/SimpleStore/themeStore.dart";

class ColorPicker extends ConsumerStatefulWidget {
  const ColorPicker({
    super.key,
    required this.colorCallback,
  });

  final Function(Color selectedColor) colorCallback;
  @override
  ConsumerState<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends ConsumerState<ColorPicker> {
  late bool isDark;
  List<Color> listOfColors = Colors.primaries;
  @override
  void initState() {
    super.initState();
    isDark = ref.read(brightnessProvider) == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 10,
        runSpacing: 10,
        children: [
          ...List.generate(
            listOfColors.length,
            (index) => IconButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(listOfColors[index]),
              ),
              onPressed: () => widget.colorCallback(listOfColors[index]),
              icon: Container(
                width: 2,
              ),
            ),
            growable: false,
          ),
        ],
      ),
    );
  }
}
