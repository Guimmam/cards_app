import 'dart:io';

import 'package:cards_app/presentation/screens/welcome_screen.dart';
import 'package:cards_app/presentation/theme/theme_menager.dart';
import 'package:cards_app/presentation/theme/themes.dart';
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
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: _themeManager.themeMode,
            home: const WelcomeScreen()));
  }
}
