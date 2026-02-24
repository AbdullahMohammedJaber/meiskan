import 'package:app/app/core/utils/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../core/utils/colors_manager.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? shadowColor, textColor, surfaceTintColor, buttonColor;
  final Color borderColor;
  final bool bordered;
  final bool loading;
  final String? svgIcon;
  final double? width;
  final Widget? prefixIcon;
  final bool enabled;

  const AppButton(
      {super.key,
      required this.text,
      this.onTap,
      this.width,
      this.prefixIcon,
      this.margin,
      this.shadowColor,
      this.padding,
      this.surfaceTintColor,
      this.textColor,
      this.buttonColor,
      this.borderColor = AppColors.primaryColor,
      this.bordered = false,
      this.loading = false,
      this.svgIcon,
      this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ElevatedButton(
        onPressed: enabled ? onTap ?? () {} : null,
        style: ElevatedButton.styleFrom(
          surfaceTintColor: surfaceTintColor,
          shadowColor: shadowColor,
          backgroundColor: bordered
              ? Colors.transparent
              : buttonColor ?? AppColors.primaryColor,
          padding: padding ?? EdgeInsets.symmetric(vertical: 14.h),
          elevation: bordered ? 0 : null,
          side: !bordered ? null : BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (svgIcon != null)
              SvgPicture.asset(
                svgIcon!,
                color: textColor ?? Colors.white,
              ),
            if (prefixIcon != null) prefixIcon!,
            if (svgIcon != null || prefixIcon != null) 10.horizontalSpace,
            Text(
              text,
              textAlign: TextAlign.center,
              style: Get.textTheme.bodyMedium!.copyWith(
                  fontSize: 14.sp,
                  color: textColor ??
                      (bordered ? borderColor : textColor ?? Colors.white)),
            ),
            if (loading)
              Container(
                margin:
                    EdgeInsets.symmetric(horizontal: AppPadding.defaultPadding),
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: textColor ??
                      (bordered ? borderColor : textColor ?? Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
