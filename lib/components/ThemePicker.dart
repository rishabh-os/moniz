import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/components/input/ColorPicker.dart";
import "package:moniz/data/SimpleStore/themeStore.dart";

class ThemePicker extends ConsumerStatefulWidget {
  const ThemePicker({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ThemePickerState();
}

class _ThemePickerState extends ConsumerState<ThemePicker> {
  late bool isDark;
  late bool isDynamic;

  @override
  void initState() {
    super.initState();
    isDark = ref.read(brightnessProvider) == Brightness.dark;
    isDynamic = ref.read(dynamicProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 40,
        ),
        ColorPicker(
          colorCallback: (selectedColor) {
            ref
                .read(themeColorProvider.notifier)
                .update((state) => selectedColor);
          },
        ),
        SwitchListTile(
          title: const Text("Dark Mode"),
          value: isDark,
          onChanged: (value) {
            ref.watch(brightnessProvider.notifier).update((state) {
              return isDark ? Brightness.light : Brightness.dark;
            });
            setState(() {
              isDark = value;
            });
          },
        ),
        // SwitchListTile(
        //   title: const Text("Dynamic Theme"),
        //   value: isDynamic,
        //   onChanged: (value) {
        //     ref.watch(dynamicProvider.notifier).update((state) {
        //       GetStorage().write("isDynamic", value);
        //       return value;
        //     });
        //     setState(() {
        //       isDynamic = value;
        //     });
        //   },
        // )
      ],
    );
  }
}
