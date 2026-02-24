import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/colors_manager.dart';
import '../../core/utils/fonts_manager.dart';
import '../../core/utils/styles_manager.dart';

ThemeData getLightThemeData() => ThemeData(
      cardColor: Colors.white,
      fontFamily: FontFamilyManager.defaultArabicFamily,
      fontFamilyFallback: [
        FontFamilyManager.defaultLatinFamily,
      ],
      primaryColor: AppColors.primaryColor,
      colorScheme: const ColorScheme.light(primary: AppColors.primaryColor),
      highlightColor: AppColors.primaryColor,
      hoverColor: AppColors.primaryColor,
      dividerColor: AppColors.inputBorderColor,
      dividerTheme: DividerThemeData(
        color: AppColors.inputBorderColor,
        thickness: 1,
        space: 30.h,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.primaryColor,
          refreshBackgroundColor: AppColors.scaffoldBackgroundColor),
      scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
      splashColor: Colors.transparent,
      brightness: Brightness.light,
      appBarTheme: AppBarTheme(
        titleTextStyle: boldStyle(
          color: AppColors.primaryColor,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
      ),
      iconTheme: IconThemeData(size: 22.sp),
      inputDecorationTheme: InputDecorationTheme(
        errorMaxLines: 10,
        fillColor: AppColors.inputFillColor,
        filled: true,
        errorStyle: semiBoldStyle(color: AppColors.errorColor, fontSize: 12),
        hintStyle: regularStyle(color: AppColors.grey, fontSize: 14),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide:
              const BorderSide(color: AppColors.inputBorderColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide:
              const BorderSide(color: AppColors.inputBorderColor, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: AppColors.errorColor, width: 1),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide:
              const BorderSide(color: AppColors.inputBorderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: AppColors.grey, width: 1.5),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: semiBoldStyle(color: AppColors.textColor, fontSize: 16),
        headlineLarge: regularStyle(color: AppColors.textColor, fontSize: 30),
        headlineMedium: regularStyle(color: AppColors.textColor, fontSize: 18),
        titleMedium: boldStyle(
            color: AppColors.textColor,
            fontSize: 18,
            fontWeight: FontWeight.w800),
        titleLarge: boldStyle(
          color: AppColors.textColor,
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
        titleSmall: boldStyle(
          color: AppColors.textColor,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
        bodyLarge: mediumStyle(color: AppColors.textColor, fontSize: 24),
        bodySmall: mediumStyle(color: AppColors.textColor, fontSize: 12),
        bodyMedium: regularStyle(color: AppColors.textColor, fontSize: 18),
        labelMedium: regularStyle(color: AppColors.textColor, fontSize: 18),
        labelLarge: regularStyle(color: AppColors.textColor, fontSize: 24),
        labelSmall: regularStyle(
          color: AppColors.textColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      tabBarTheme:
          const TabBarThemeData(indicatorColor: AppColors.primaryColor),
    );
