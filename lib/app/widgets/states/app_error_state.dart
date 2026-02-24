import 'package:app/app/core/utils/strings_manager.dart';
import 'package:app/app/widgets/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
     required this.onRetry,
   });

    final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final String buttonLabel =  AppStrings.retry.tr;
    final IconData effectiveIcon = Icons.warning_amber_rounded;

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
                  AppStrings.errorOccurred.tr,
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                24.verticalSpace,
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    onTap: onRetry,
                    text: buttonLabel,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
