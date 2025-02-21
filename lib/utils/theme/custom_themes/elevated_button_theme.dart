import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: TColors.white,
      backgroundColor: TColors.primaryColor,
      disabledForegroundColor: TColors.grey,
      disabledBackgroundColor: TColors.grey,
      side: const BorderSide(color: TColors.primaryColor),
      padding: const EdgeInsets.all(10.0),
      textStyle: const TextStyle(
          fontSize: 16, color: TColors.white, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: TColors.white,
      backgroundColor: TColors.primaryColor,
      disabledForegroundColor: TColors.grey,
      disabledBackgroundColor: TColors.grey,
      side: const BorderSide(color: TColors.primaryColor),
      padding: const EdgeInsets.all(10.0),
      textStyle: const TextStyle(
          fontSize: 16, color: TColors.white, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
