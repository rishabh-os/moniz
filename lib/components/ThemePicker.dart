import "dart:io";

import "package:device_info_plus/device_info_plus.dart";
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
    isDark = ref.watch(brightnessProvider) == Brightness.dark;
    isDynamic = ref.watch(dynamicProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 40,
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(
            // ? Width has to be set to something large otherwise the animation doesn't work properly
            width: double.maxFinite,
          ),
          secondChild: themeOptions(),
          crossFadeState:
              isDynamic ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 200),
        ),
        SwitchListTile(
          title: const Text("Dynamic Theme"),
          value: isDynamic,
          onChanged: (value) {
            ref.watch(dynamicProvider.notifier).update((state) {
              return value;
            });

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
            ref
                .read(themeColorProvider.notifier)
                .update((state) => selectedColor);
          },
        ),
        SwitchListTile(
          key: const Key("Dark Mode"),
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
      ],
    );
  }
}
