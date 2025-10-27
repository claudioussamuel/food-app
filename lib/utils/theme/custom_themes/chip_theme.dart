

import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';

class TChipTheme{
  TChipTheme._();

  static ChipThemeData lightChipTheme = const ChipThemeData(
    disabledColor: Colors.grey,
    labelStyle: TextStyle(color :TColors.textblack),
    selectedColor: TColors.primary,
    padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
    checkmarkColor: Colors.white,
  );

  static ChipThemeData darkChipTheme = const ChipThemeData(
    disabledColor: Colors.grey,
    labelStyle: TextStyle(color : TColors.textWhite),
    selectedColor: TColors.primary,
    padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
    checkmarkColor: Colors.white,
  );


}