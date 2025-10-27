import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';

class TCardTheme {
  TCardTheme._();

  static CardThemeData lightCardTheme = CardThemeData(
    surfaceTintColor: TColors.backgroundLight,
    color: TColors.backgroundLight,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    elevation: 2.0,
  );

  static CardThemeData darkCardTheme = CardThemeData(
    surfaceTintColor: TColors.backgroundDark,
    color: TColors.darkCard,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    elevation: 2.0,
  );
}
