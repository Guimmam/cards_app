import 'dart:io';

import 'package:cards_app/data/providers/auth_provider.dart';
import 'package:cards_app/presentation/screens/add_gift_card.dart';
import 'package:cards_app/presentation/screens/add_loyalty_card_screen.dart';
import 'package:cards_app/presentation/screens/home_screen.dart';
import 'package:cards_app/presentation/screens/scan_code_screen.dart';
import 'package:cards_app/presentation/screens/welcome_screen.dart';
import 'package:cards_app/presentation/theme/theme_menager.dart';
import 'package:cards_app/presentation/theme/themes.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (Platform.isAndroid) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (androidInfo.version.sdkInt! > 23) {
      FlutterDisplayMode.setHighRefreshRate();
    }
  }

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider<AuthProvider>(
        create: (context) => AuthProvider(),
      ),
    ], child: const MyApp()));
  });
}

ThemeManager _themeManager = ThemeManager();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();
  @override
  void initState() {
    _themeManager.addListener(() {
      themeListener();
    });
    super.initState();
  }

  @override
  void dispose() {
    _themeManager.removeListener(() {
      themeListener();
    });
    super.dispose();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      builder: (_, child) => MaterialApp(
        scrollBehavior: const MaterialScrollBehavior(
            androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthScreen(),
          AddLoyaltyCardScreen.routeName: (context) =>
              const AddLoyaltyCardScreen(),
          ScanCodeScreen.routeName: (context) => const ScanCodeScreen(),
        },
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: _themeManager.themeMode,
      ),
    );
  }
}

class AuthScreen extends StatelessWidget {
  const AuthScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const HomeScreen();
        }
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Something went wrong')),
          );
        } else {
          return const WelcomeScreen();
        }
      },
    );
  }
}
