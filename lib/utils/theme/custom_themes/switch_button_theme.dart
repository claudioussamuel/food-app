

import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';

class  TSwitchTheme {
  TSwitchTheme._();

  static SwitchThemeData lightSwitchTheme =  SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.white;
      }
      return Colors.white;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return TColors.primary;
      }
      return Colors.grey.shade300;
    }),
  );

  static SwitchThemeData darkSwitchTheme =  SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.white;
      }
      return Colors.white;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return TColors.primary;
      }
      return TColors.darkCard;
    }),
  );
}