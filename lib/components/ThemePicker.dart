import "dart:io";

import "package:animated_size_and_fade/animated_size_and_fade.dart";
import "package:device_info_plus/device_info_plus.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/components/input/ColorPicker.dart";
import "package:moniz/components/input/Header.dart";
import "package:moniz/data/SimpleStore/themeStore.dart";

class ThemePicker extends ConsumerStatefulWidget {
  const ThemePicker({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ThemePickerState();
}

class _ThemePickerState extends ConsumerState<ThemePicker> {
  late bool isDark;
  late bool isDynamic;
  late bool showDynamic;

  @override
  void initState() {
    super.initState();
    supportsDynamic().then((value) => showDynamic = value);
  }

  Future<bool> supportsDynamic() async {
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      final release = androidInfo.version.release;
      return int.parse(release) >= 12 ? true : false;
    }
    // ? For development only
    else if (Platform.isLinux) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    isDark = ref.watch(brightProvider) == Brightness.dark;
    isDynamic = ref.watch(dynamicColorProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 40,
        ),
        const Header(text: "Pick your theme"),
        AnimatedSizeAndFade.showHide(
          show: !isDynamic,
          fadeDuration: 200.ms,
          sizeDuration: 200.ms,
          child: themeOptions(),
        ),
        SwitchListTile(
          title: const Text("Dynamic Theme"),
          value: isDynamic,
          onChanged: (value) {
            ref.watch(dynamicColorProvider.notifier).state = value;
            setState(() {
              isDynamic = value;
            });
          },
        ),
      ],
    );
  }

  Column themeOptions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ColorPicker(
          colorCallback: (selectedColor) {
            ref.read(themeColorProvider.notifier).state = selectedColor;
          },
        ),
        SwitchListTile(
          key: const Key("Dark Mode"),
          title: const Text("Dark Mode"),
          value: isDark,
          onChanged: (value) {
            ref.watch(brightProvider.notifier).state =
                isDark ? Brightness.light : Brightness.dark;

            setState(() {
              isDark = value;
            });
          },
        ),
      ],
    );
  }
}
