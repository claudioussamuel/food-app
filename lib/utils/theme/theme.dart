import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/theme/custom_themes/app_bar_theme.dart';
import 'package:foodu/utils/theme/custom_themes/card_theme.dart';
import 'package:foodu/utils/theme/custom_themes/check_box_theme.dart';
import 'package:foodu/utils/theme/custom_themes/chip_theme.dart';
import 'package:foodu/utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:foodu/utils/theme/custom_themes/outline_button_theme.dart';
import 'package:foodu/utils/theme/custom_themes/switch_button_theme.dart';
import 'package:foodu/utils/theme/custom_themes/tab_bar_theme.dart';
import 'package:foodu/utils/theme/custom_themes/text_field_theme.dart';
import 'package:foodu/utils/theme/custom_themes/text_theme.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Urbanist',
    brightness: Brightness.light,
    primaryColor: TColors.primary,
    scaffoldBackgroundColor: TColors.backgroundLight,
    textTheme: TTextTheme.lightTextTheme,
    checkboxTheme: TCheckBoxTheme.lightCheckBoxTheme,
    chipTheme: TChipTheme.lightChipTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    cardTheme: TCardTheme.lightCardTheme,
    outlinedButtonTheme: TOutlineButtonTheme.lightOutlineButtonTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
    tabBarTheme: TTabBarTheme.lightTabBarTheme,
    switchTheme: TSwitchTheme.lightSwitchTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Urbanist',
    brightness: Brightness.dark,
    primaryColor: TColors.primary,
    scaffoldBackgroundColor: TColors.backgroundDark,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    textTheme: TTextTheme.darkTextTheme,
    checkboxTheme: TCheckBoxTheme.darkCheckBoxTheme,
    chipTheme: TChipTheme.darkChipTheme,
    tabBarTheme: TTabBarTheme.darkTabBarTheme,
    outlinedButtonTheme: TOutlineButtonTheme.darkOutlineButtonTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
    switchTheme: TSwitchTheme.darkSwitchTheme,
  );
}
