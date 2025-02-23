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
import "package:moniz/env/env.dart";
import "package:moniz/screens/Settings.dart";
import "package:moniz/screens/Welcome.dart";
import "package:moniz/screens/homescreen/HomeScreen.dart";
import "package:posthog_flutter/posthog_flutter.dart";
import "package:sentry_flutter/sentry_flutter.dart";
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
      SentryWidgetsFlutterBinding.ensureInitialized();
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
  } else {
// ? Posthog doesn't support Linux (for now)
    final config = PostHogConfig(Env.posthogApikey);
    config.debug = true;
    config.captureApplicationLifecycleEvents = true;
    config.host = "https://eu.i.posthog.com";
    await Posthog().setup(config);
  }
  await SentryFlutter.init(
    (options) {
      options.dsn =
          "https://3e6550282cb26ab69d067815cbe9a91a@o4508771833282560.ingest.de.sentry.io/4508771834462288";
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      // The sampling rate for profiling is relative to tracesSampleRate
      // Setting to 1.0 will profile 100% of sampled transactions:
      options.profilesSampleRate = 1.0;
      options.experimental.replay.sessionSampleRate = 1.0;
      options.experimental.replay.onErrorSampleRate = 1.0;
    },
    appRunner: () => runApp(
      const ProviderScope(
        child: MyApp(),
      ),
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
        if (lightDynamic != null && ref.watch(dynamicColorProvider)) {
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
            ref.watch(brightProvider.notifier).state = platformBrightness;
          });
        } else {
          theme = ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: ref.watch(themeColorProvider),
              brightness: ref.watch(brightProvider),
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
