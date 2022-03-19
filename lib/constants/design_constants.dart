// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';

final ThemeData kThemeData = ThemeData(
  textTheme: kTextTheme,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF075985),
  ),
  primaryColor: const Color(0xFF075985),
  scaffoldBackgroundColor: const Color(0xFF2A303C),
  canvasColor: const Color(0xFF242933),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFF2C313E),
    focusColor: Color(0xFF111318),
  ),
);

final TextTheme kTextTheme = TextTheme(
  headline1: GoogleFonts.notoSans(fontSize: 113, fontWeight: FontWeight.w300, letterSpacing: -1.5, color: Colors.white),
  headline2: GoogleFonts.notoSans(fontSize: 71, fontWeight: FontWeight.w300, letterSpacing: -0.5, color: Colors.white),
  headline3: GoogleFonts.notoSans(fontSize: 57, fontWeight: FontWeight.w400, color: Colors.white),
  headline4: GoogleFonts.notoSans(fontSize: 40, fontWeight: FontWeight.w400, letterSpacing: 0.25, color: Colors.white),
  headline5: GoogleFonts.notoSans(fontSize: 28, fontWeight: FontWeight.w400, color: Colors.white),
  headline6: GoogleFonts.notoSans(fontSize: 24, fontWeight: FontWeight.w500, letterSpacing: 0.15, color: Colors.white),
  subtitle1: GoogleFonts.notoSans(fontSize: 19, fontWeight: FontWeight.w400, letterSpacing: 0.15, color: Colors.white),
  subtitle2: GoogleFonts.notoSans(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.1, color: Colors.white),
  bodyText1: GoogleFonts.merriweather(fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.5, color: Colors.white),
  bodyText2: GoogleFonts.merriweather(fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 0.25, color: Colors.white),
  button: GoogleFonts.merriweather(fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 1.25, color: Colors.white),
  caption: GoogleFonts.merriweather(fontSize: 11, fontWeight: FontWeight.w400, letterSpacing: 0.4, color: Colors.white),
  overline: GoogleFonts.merriweather(fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5, color: Colors.white),
);

// Spacings
const double kSpacingTiny = 5.0;
const double kSpacingSmall = 10.0;
const double kSpacingMedium = 15.0;
const double kSpacingLarge = 20.0;
const double kSpacingExtraLarge = 30.0;
