import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';

import '../../constants/sizes.dart';

class TOutlineButtonTheme {
  TOutlineButtonTheme._();

  static final lightOutlineButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: TColors.primary,
      backgroundColor: const Color(0xffE8F7ED),
      disabledBackgroundColor: Colors.grey,
      disabledForegroundColor: Colors.grey,
      side: const BorderSide(color: TColors.borderGrey),
      padding: const EdgeInsets.symmetric(vertical: TSizes.md, horizontal: TSizes.md),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TSizes.buttonRadius)),
      textStyle: const TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.w600),
    ),
  );

  static final darkOutlineButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: TColors.primary,
      backgroundColor: const Color(0xffE8F7ED),
      disabledBackgroundColor: Colors.grey,
      disabledForegroundColor: Colors.grey,
      side: const BorderSide(color: TColors.borderGrey),
      padding: const EdgeInsets.symmetric(vertical: TSizes.md, horizontal: TSizes.md),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TSizes.buttonRadius)),
      textStyle: const TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.w600),
    ),
  );
}
