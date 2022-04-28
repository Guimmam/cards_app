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
    colorScheme: const ColorScheme.light(),
    //primarySwatch: generateMaterialColor(primaryColor),
    textTheme: GoogleFonts.nunitoSansTextTheme().copyWith(
      bodyText2: GoogleFonts.nunito(color: lightFontColor),
      headline3: GoogleFonts.nunito(
        color: lightFontColor,
        fontWeight: FontWeight.bold,
      ),
      headline5: GoogleFonts.nunito(
        color: lightFontColor,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      contentTextStyle: GoogleFonts.nunito(),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          textStyle: MaterialStateProperty.all(
              GoogleFonts.nunito(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
            // side: BorderSide(color: Colors.red),
          )),
          // backgroundColor: MaterialStateProperty.all(accentColor),
          padding:
              MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 14.h))),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
          textStyle: MaterialStateProperty.all(
              GoogleFonts.nunito(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
            // side: BorderSide(color: Colors.red),
          )),
          //backgroundColor: MaterialStateProperty.all(accentColor),
          padding:
              MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 14.h))),
    ),
    inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r))));

ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(),
    //primarySwatch: generateMaterialColor(primaryColor),
    textTheme: GoogleFonts.nunitoSansTextTheme().copyWith(
        bodyText2: GoogleFonts.nunito(color: Colors.white70),
        headline3: GoogleFonts.nunito(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        headline5: GoogleFonts.nunito(
          color: Colors.white,
        ),
        subtitle1: GoogleFonts.nunito(color: Colors.white70)),
    snackBarTheme: SnackBarThemeData(
      contentTextStyle: GoogleFonts.nunito(color: Colors.black87),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          textStyle: MaterialStateProperty.all(
              GoogleFonts.nunito(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
            // side: BorderSide(color: Colors.red),
          )),
          //backgroundColor: MaterialStateProperty.all(accentColor),
          padding:
              MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 14.h))),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
          textStyle: MaterialStateProperty.all(
              GoogleFonts.nunito(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
            // side: BorderSide(color: Colors.red),
          )),
          //backgroundColor: MaterialStateProperty.all(accentColor),
          padding:
              MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 14.h))),
    ),
    inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r))));
