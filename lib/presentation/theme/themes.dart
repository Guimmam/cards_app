import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.5),
    100: tintColor(color, 0.4),
    200: tintColor(color, 0.3),
    300: tintColor(color, 0.2),
    400: tintColor(color, 0.1),
    500: tintColor(color, 0),
    600: tintColor(color, -0.1),
    700: tintColor(color, -0.2),
    800: tintColor(color, -0.3),
    900: tintColor(color, -0.4),
  });
}

int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1);

const primaryColor = Color(0xff2c5229);
const accentColor = Color(0XFF649c4b);
const textFieldColor = Color(0XFFdce7af);
const lightFontColor = Color(0XFF1b1b1b);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: generateMaterialColor(primaryColor),
  primaryColor: primaryColor,
  textTheme: GoogleFonts.nunitoSansTextTheme().copyWith(
      headline4: GoogleFonts.nunito(
    color: lightFontColor,
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
  )),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(accentColor),
        padding:
            MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 14.h))),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
);
