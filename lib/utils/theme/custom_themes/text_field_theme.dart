import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';

class TTextFormFieldTheme {
  TTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
      filled: true,
      errorMaxLines: 3,
      prefixIconColor: TColors.primary,
      suffixIconColor: TColors.textGrey,
      fillColor: TColors.textFieldFillColor,
      errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
      hintStyle: const TextStyle().copyWith(fontSize: 14, color: TColors.textGrey),
      contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
      floatingLabelStyle: const TextStyle().copyWith(color: Colors.black.withValues(alpha:0.8)),
      border: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(width: 1, color: TColors.primary),
      ),
      errorBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(width: 1, color: Colors.red),
      ),
      focusedErrorBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(width: 1, color: Colors.orange),
      ));

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
      filled: true,
      errorMaxLines: 3,
      prefixIconColor: TColors.primary,
      suffixIconColor: TColors.textGrey,
      fillColor: TColors.textFieldFillColor,
      errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
      hintStyle: const TextStyle().copyWith(fontSize: 14, color: TColors.textGrey),
      contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
      floatingLabelStyle: const TextStyle().copyWith(color: Colors.black.withValues(alpha:0.8)),
      border: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(width: 1, color: TColors.primary),
      ),
      errorBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(width: 1, color: Colors.red),
      ),
      focusedErrorBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(width: 1, color: Colors.orange),
      ));
}
