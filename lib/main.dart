import "dart:io";
import "package:dynamic_color/dynamic_color.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:flutter_native_splash/flutter_native_splash.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:get_storage/get_storage.dart";
import "package:moniz/data/SimpleStore/basicStore.dart";
import "package:moniz/data/SimpleStore/themeStore.dart";
import "package:moniz/data/account.dart";
import "package:moniz/data/category.dart";
import "package:moniz/data/transactions.dart";
import "package:moniz/screens/Settings.dart";
import "package:moniz/screens/Welcome.dart";
import "package:moniz/screens/homescreen/HomeScreen.dart";
import "package:window_manager/window_manager.dart";

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // ? Enables the mouse to drag, makes debugging easier on Linux
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

void main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await GetStorage.init();
  if (Platform.isLinux) {
    const WindowOptions windowOptions = WindowOptions(
      size: Size(400, (18 / 9) * 400),
      center: false,
      title: "Moniz",
      alwaysOnTop: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    await windowManager.ensureInitialized();
    await windowManager.waitUntilReadyToShow(windowOptions, () {
      windowManager.show();
      windowManager.focus();
    });
  }
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  Future<void> loadData() async {
    // ? This part should just be run on first app startup to make sure the database itself is not empty
    await ref.read(dBProvider).initAccounts();
    await ref.read(dBProvider).initCategories();
    // ? This loads the data from the database into the app
    await ref.read(categoriesProvider.notifier).loadCategories();
    await ref.read(accountsProvider.notifier).loadAccounts();
    ref.read(transactionsProvider.notifier).filterTransactions();
    FlutterNativeSplash.remove();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        ThemeData theme;
        if (lightDynamic != null && ref.watch(dynamicProvider)) {
          final platformBrightness =
              SchedulerBinding.instance.platformDispatcher.platformBrightness;
          final ColorScheme dynamicScheme =
              platformBrightness == Brightness.dark
                  ? darkDynamic!
                  : lightDynamic;
          theme = ThemeData(
            colorScheme: dynamicScheme,
            useMaterial3: true,
          );
          Future.delayed(const Duration(milliseconds: 1), () {
            ref
                .watch(brightnessProvider.notifier)
                .update((state) => platformBrightness);
          });
        } else {
          theme = ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: ref.watch(themeColorProvider),
              brightness: ref.watch(brightnessProvider),
            ),
            useMaterial3: true,
          );
        }
        return MaterialApp(
          scrollBehavior: MyCustomScrollBehavior(),
          title: "Moniz",
          theme: theme,
          debugShowCheckedModeBanner: false,
          builder: FToastBuilder(),
          initialRoute:
              GetStorage().read("welcome") == null ? "/welcome" : "/home",
          routes: {
            "/welcome": (context) => const Welcome(),
            // ? Why not just "/"? Because that causes duplicate GlobalKeys for reasons unknown
            "/home": (context) => const HomeScreen(),
            "/settings": (context) => const Settings(),
          },
        );
      },
    );
  }
}
