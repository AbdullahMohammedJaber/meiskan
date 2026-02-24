import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../core/utils/colors_manager.dart';

class StatisticCard extends StatelessWidget {
  final String value;
  final String label;
  final String iconAsset;
  final Color iconBackground;
  final Color? iconColor;

  const StatisticCard({
    super.key,
 required   this.value,
    required  this.label,
    required  this.iconAsset,
    required   this.iconBackground, this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 42.w,
            width: 42.w,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(10.w),
            child: SvgPicture.asset(
              iconAsset,
              colorFilter:   ColorFilter.mode(
                iconColor??  AppColors.primaryColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          13.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Get.textTheme.bodyMedium!.copyWith(
                    fontSize: 19.sp,
                  ),
                ),
                Text(
                  label,
                  style: Get.textTheme.bodySmall!.copyWith(
                    color: AppColors.grey,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
