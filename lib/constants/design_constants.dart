// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';

final ThemeData kThemeData = ThemeData(
  primaryColor: kPrimaryColor,
  textTheme: kTextTheme,
  appBarTheme: const AppBarTheme(
    backgroundColor: kPrimaryColor,
  ),
  scaffoldBackgroundColor: kGrayDark,
  canvasColor: kGrayDarkest,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: kPrimaryColor,
    selectedItemColor: Colors.white,
    unselectedItemColor: kGrayLighter,
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: kPrimaryColor,
    focusColor: kGrayDarkest,
  ),
);

final TextTheme kTextTheme = TextTheme(
  headline1: GoogleFonts.carterOne(fontSize: 113, fontWeight: FontWeight.w300, letterSpacing: -1.5, color: Colors.white),
  headline2: GoogleFonts.carterOne(fontSize: 71, fontWeight: FontWeight.w300, letterSpacing: -0.5, color: Colors.white),
  headline3: GoogleFonts.carterOne(fontSize: 57, fontWeight: FontWeight.w400, color: Colors.white),
  headline4: GoogleFonts.carterOne(fontSize: 40, fontWeight: FontWeight.w400, letterSpacing: 0.25, color: Colors.white),
  headline5: GoogleFonts.carterOne(fontSize: 28, fontWeight: FontWeight.w400, color: Colors.white),
  headline6: GoogleFonts.carterOne(fontSize: 24, fontWeight: FontWeight.w500, letterSpacing: 0.15, color: Colors.white),
  subtitle1: GoogleFonts.manrope(fontSize: 19, fontWeight: FontWeight.w400, letterSpacing: 0.15, color: Colors.white),
  subtitle2: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.1, color: Colors.white),
  bodyText1: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.5, color: Colors.white),
  bodyText2: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 0.25, color: Colors.white),
  button: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 1.25, color: Colors.white),
  caption: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w400, letterSpacing: 0.4, color: Colors.white),
  overline: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5, color: Colors.white),
);

// Colors
const Color kPrimaryColor = Color(0xFF075985);
const Color kSecondaryColor = Color(0xFF071A85);
const Color kTertiaryColor = Color(0xFF078572);
const Color kHighlightColor = Color(0xFF0B8CD1);

const Color kGrayLighter = Color(0xFF929292);
const Color kGrayLight = Color(0xFF666666);
const Color kGrayDark = Color(0xFF2C313E);
const Color kGrayDarker = Color(0xFF242933);
const Color kGrayDarkest = Color(0xFF111318);

// Spacings
const double kSpacingTiny = 5.0;
const double kSpacingSmall = 10.0;
const double kSpacingMedium = 15.0;
const double kSpacingLarge = 20.0;
const double kSpacingExtraLarge = 30.0;

// Icons
const double kAppBarIconHeight = 42.0;
const double kDecorationIconCenterHeight = 92.0;
