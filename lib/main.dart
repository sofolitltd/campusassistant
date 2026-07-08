                import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:campusassistant/routes/router_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart'
    show PathUrlStrategy, setUrlStrategy;
import 'package:go_router/go_router.dart';
import 'package:campusassistant/core/providers/theme_provider.dart';
import 'package:campusassistant/core/providers/app_refresh_provider.dart';
import 'package:campusassistant/core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");

  if (kIsWeb) {
    setUrlStrategy(PathUrlStrategy());
  }
  GoRouter.optionURLReflectsImperativeAPIs = true;

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(refreshAppDataProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final themeModeAsync = ref.watch(themeProvider);

    return themeModeAsync.when(
      data: (themeMode) => MaterialApp.router(
        title: 'Campus Assistant',
        debugShowCheckedModeBanner: false,
        themeMode: themeMode,
        theme: buildLightTheme(),
        darkTheme: buildDarkTheme(),
        routerConfig: router,
      ),
      loading: () => MaterialApp.router(
        title: 'Campus Assistant',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: buildLightTheme(),
        darkTheme: buildDarkTheme(),
        routerConfig: router,
      ),
      error: (_, _) => MaterialApp.router(
        title: 'Campus Assistant',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: buildLightTheme(),
        darkTheme: buildDarkTheme(),
        routerConfig: router,
      ),
    );
  }
}
