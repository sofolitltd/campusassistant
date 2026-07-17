import '/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'routes/router_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart'
    show PathUrlStrategy, setUrlStrategy;
import 'package:go_router/go_router.dart';
import '/core/providers/theme_provider.dart';
import '/core/providers/app_refresh_provider.dart';
import '/core/theme/app_theme.dart';
import '/core/cache/cache_manager.dart';
import '/core/cache/connectivity_service.dart';
import '/core/cache/sync_manager.dart';
import '/core/websocket/websocket_service.dart';
import '/core/widgets/offline_banner.dart';
import '/features/auth/presentation/providers/auth_provider.dart';

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

    // Initialize connectivity listener and WebSocket
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initConnectivity();
      _initWebSocket();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _initConnectivity() async {
    final connectivity = ref.read(connectivityServiceProvider);

    // Listen for connectivity changes and update the provider
    connectivity.onConnectivityChanged.listen((isConnected) {
      ref.read(isConnectedProvider.notifier).update(isConnected);

      // When connection returns, process pending syncs
      if (isConnected) {
        final syncManager = ref.read(syncManagerProvider);
        syncManager.processPendingSyncs();
      }
    });

    // Perform initial check (emits result to stream, caught by listener above)
    await connectivity.checkConnectivity();
  }

  void _initWebSocket() {
    // Listen for auth state changes to connect/disconnect WebSocket
    ref.listen(currentUserProvider, (previous, next) {
      final user = next.value;
      if (user != null && !kIsWeb) {
        // User logged in - connect WebSocket
        _connectWebSocket();
      } else if (user == null) {
        // User logged out - disconnect WebSocket
        final wsService = ref.read(websocketServiceProvider);
        wsService.disconnect();
        ref.read(websocketConnectedProvider.notifier).update(false);
      }
    });

    // If user is already logged in, connect now
    final userAsync = ref.read(currentUserProvider);
    if (userAsync.value != null && !kIsWeb) {
      _connectWebSocket();
    }
  }

  Future<void> _connectWebSocket() async {
    try {
      final storage = ref.read(secureStorageProvider);
      final token = await storage.read(
        key: AuthLocalDataSourceImpl.cachedTokenKey,
      );
      if (token != null && token.isNotEmpty) {
        final wsService = ref.read(websocketServiceProvider);
        await wsService.connect(token);
        ref
            .read(websocketConnectedProvider.notifier)
            .update(wsService.isConnected);
      }
    } catch (e) {
      debugPrint('[Main] WebSocket connection failed: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // If user just cleared cache, skip automatic refresh
      ref.read(cacheManagerProvider).isRecentlyCleared().then((recentlyCleared) {
        if (!recentlyCleared) {
          ref.read(refreshAppDataProvider);
        }
      });

      // Process pending syncs when app resumes
      if (!kIsWeb) {
        final syncManager = ref.read(syncManagerProvider);
        syncManager.processPendingSyncs();

        // Reconnect WebSocket if needed
        final wsService = ref.read(websocketServiceProvider);
        wsService.reconnectIfNeeded();
      }
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
        builder: (context, child) =>
            OfflineBanner(child: child ?? const SizedBox.shrink()),
      ),
      loading: () => MaterialApp.router(
        title: 'Campus Assistant',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: buildLightTheme(),
        darkTheme: buildDarkTheme(),
        routerConfig: router,
        builder: (context, child) =>
            OfflineBanner(child: child ?? const SizedBox.shrink()),
      ),
      error: (_, _) => MaterialApp.router(
        title: 'Campus Assistant',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: buildLightTheme(),
        darkTheme: buildDarkTheme(),
        routerConfig: router,
        builder: (context, child) =>
            OfflineBanner(child: child ?? const SizedBox.shrink()),
      ),
    );
  }
}
