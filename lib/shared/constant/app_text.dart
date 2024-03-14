import 'package:flutter/material.dart';

import 'app_color.dart';

class AppText {
  AppText._();

  static const TextStyle titleMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.tBlackColor,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.tGreyColor,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.tBlackColor,
  );

  static const TextStyle titleExtraLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.tBlackColor,
  );
}
