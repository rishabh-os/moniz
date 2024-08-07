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
    final GlobalKey k = GlobalKey();
    isDark = ref.watch(brightnessProvider) == Brightness.dark;
    isDynamic = ref.watch(dynamicProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 40,
        ),
        AnimatedOpacity(
          opacity: isDynamic ? 0 : 1,
          duration: const Duration(milliseconds: 200),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: SizedBox(
              height: isDynamic ? 0 : null,
              child: Column(
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
              ),
            ),
          ),
        ),
        SwitchListTile(
          key: k,
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
}
