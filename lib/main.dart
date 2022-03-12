import 'dart:io';

import 'package:cards_app/presentation/screens/home_screen.dart';
import 'package:cards_app/presentation/screens/welcome_screen.dart';
import 'package:cards_app/presentation/theme/theme_menager.dart';
import 'package:cards_app/presentation/theme/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
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
    if (Platform.isAndroid) {
      FlutterDisplayMode.setHighRefreshRate();
    }
    return ScreenUtilInit(
        designSize: const Size(360, 640),
        builder: () => MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: _themeManager.themeMode,
            home: StreamBuilder<User?>(
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
                    body: const Center(child: Text('Something went wrong')),
                  );
                } else {
                  return const WelcomeScreen();
                }
              },
            )));
  }
}
