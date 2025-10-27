import 'package:flutter/material.dart';

class TColors {
  TColors._();

  // App Basic Color
  static const Color primary = Color(0xff1BAC4B);

  // Background Color

  static const Color backgroundLight = Colors.white;
  static const Color backgroundDark = Color(0xff181A20);
  static const Color darkCard = Color(0xFF1F222A);

  // Text Color
  static const Color textPrimary = Color(0xff1BAC4B);
  static const Color textblack = Color(0xFF212121);
  static const Color textGrey = Color(0xFF9E9E9E);
  static const Color textWhite = Colors.white;
  static const Color disabledTextLight = Color(0xFFD1D5DB);

  // Button Color
  static const Color buttonPrimary = Color(0xff1BAC4B);
  static const Color buttonSecondary = Color(0xffE8F7ED);

  //Container Border
  static const Color borderGrey = Color(0xFFEEEEEE);

  //Container Shadow Color
  static const Color containerShadow = Color(0x3F1BAC4B);

  //Text Field Fill Color
  static const Color textFieldFillColor = Color(0xFFF9F9F9);
  static const Color otpTextFieldFillColor = Color(0xFFF0F0F0);
  static const Color textFieldFillTapColor = Color(0x141BAC4B);

  //Rating Color
  static const Color rating = Colors.orange;

  // Gradient color
  static const Gradient greenGradient = LinearGradient(
    begin: Alignment(-0.96, 0.28),
    end: Alignment(0.96, -0.28),
    colors: [Color(0xFF1BAC4B), Color(0xFF46D375)],
  );

  static const Gradient orangeGradient = LinearGradient(
    begin: Alignment(-0.96, 0.28),
    end: Alignment(0.96, -0.28),
    colors: [Color(0xFFFB9400), Color(0xFFFFAB38)],
  );

  static const Gradient redGradient = LinearGradient(
    begin: Alignment(-0.96, 0.28),
    end: Alignment(0.96, -0.28),
    colors: [Color(0xFFFF4D67), Color(0xFFFF8A9B)],
  );

  static const Gradient blueGradient = LinearGradient(
    begin: Alignment(-0.96, 0.28),
    end: Alignment(0.96, -0.28),
    colors: [Color(0xFF246BFD), Color(0xFF4F89FF)],
  );

  // Border colors
  static const Color borderPrimary = primary;
  static const Color borderLight = Color(0xFFD1D5DB); // Gray 30
  static const Color borderDark = Color(0xFF9CA3AF); // Gray 40

  // Error and validation colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);

  // Neutral Shades
  static const Color black = Color(0xFF232323);
  static const Color teal90 = Color(0xFF004D40);
  static const Color teal80 = Color(0xFF00695C);
  static const Color teal20 = Color(0xFF99F6E4);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color grey10 = Color(0xFFF3F4F6);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);

}
