import 'package:in_app_update/in_app_update.dart';

import '/screens/auth/new_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '/screens/auth/new_home_screen.dart';
import '/screens/community/notice/notice_screen.dart';
import '/services/firebase_api.dart';
import 'notification/fcm_api.dart';
import 'services/firebase_options.dart';
import 'utils/constants.dart';
import 'utils/theme.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // init firebase
  WidgetsFlutterBinding.ensureInitialized();

  // test devices
  List<String> devices = ["51FE053E52184B1F4740F5EE7C51E10B"];

  //  admob init
  if (!kIsWeb) {
    await MobileAds.instance.initialize();
    RequestConfiguration requestConfiguration = RequestConfiguration(
      testDeviceIds: devices,
    );
    MobileAds.instance.updateRequestConfiguration(requestConfiguration);
  }

  //firebase init
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //status bar transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  // remove # in web

  // run main app
  runApp(const MyApp());
}

//
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // call your async stuff here
    if (!kIsWeb) {
      _initApp();
    }
  }

  //
  Future<void> _initApp() async {
    // fcm
    await checkForUpdate();
    await FcmApi().initPushNotifications();
  }

  //
  Future<void> checkForUpdate() async {
    print('checking for Update');
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          print('update available');
          update();
        }
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  void update() async {
    print('Updating');
    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((e) {
      print(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: kAppName,
      darkTheme: darkThemeData(context),
      theme: lightThemeData(context),
      navigatorKey: navigatorKey,
      routes: {
        NoticeScreen.routeName: (context) => const NoticeScreen(),
        NewHomeScreen.routeName: (context) => const NewHomeScreen(),
        // "/export": (context) => const ExportStudentInfo(),
      },
      home: const NewSplashScreen(),
      // home: ExportStudentInfo(),
    );
  }
}
