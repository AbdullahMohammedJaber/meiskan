 import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.showButton = false,
    this.buttonText,
    this.onButtonPressed,
  });

  final String title;
  final String? description;
  final IconData? icon;
  final bool showButton;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final IconData effectiveIcon = icon ?? Icons.inbox_outlined;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 360.w),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72.w,
                  height: 72.w,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    effectiveIcon,
                    size: 36.w,
                    color: colorScheme.primary,
                  ),
                ),
                20.verticalSpace,
                Text(
                  title.tr,
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (description != null) ...[
                  8.verticalSpace,
                  Text(
                    description!.tr,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 14.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                if (showButton && buttonText != null) ...[
                  24.verticalSpace,
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onButtonPressed,
                      child: Text(buttonText!.tr),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}