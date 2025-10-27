

import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';

class TAppBarTheme{
  TAppBarTheme._();

  static  AppBarTheme lightAppBarTheme = const AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    centerTitle: false,
    scrolledUnderElevation: 0,
    titleTextStyle: TextStyle(fontSize: 20,
        fontFamily: 'Urbanist',
        fontWeight: FontWeight.bold, color: TColors.textblack),
    iconTheme: IconThemeData(color: TColors.backgroundDark,size: 24),
    actionsIconTheme: IconThemeData(color: TColors.backgroundDark,size: 24),
  );

  static  AppBarTheme darkAppBarTheme = const AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    centerTitle: false,
    scrolledUnderElevation: 0,
    titleTextStyle: TextStyle(fontSize: 20,
        fontFamily: 'Urbanist',
        fontWeight: FontWeight.bold, color: TColors.textWhite),
    iconTheme: IconThemeData(color: TColors.backgroundLight,size: 24),
    actionsIconTheme: IconThemeData(color: TColors.backgroundLight,size: 24),
  );
}