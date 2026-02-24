import 'package:app/app/core/utils/app_images.dart';
import 'package:app/app/core/utils/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_icons.dart';

class HomeFooter extends StatelessWidget {
  const HomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: const Color(0xffE4DFD7),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 21.h,
              horizontal: 40.w,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.logoNamed,
                  height: 125.h,
                ),
                10.verticalSpace,
                Text(
                  AppStrings.homeFooterTitle.tr,
                  maxLines: null,
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.center,
                  style: Get.textTheme.bodyMedium!.copyWith(
                    fontSize: 14.sp,
                  ),
                ),
                13.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialIcon(
                      icon: AppIcons.facebook,
                    ),
                    10.horizontalSpace,
                    _buildSocialIcon(
                      icon: AppIcons.instagram,
                    ),
                    10.horizontalSpace,
                    _buildSocialIcon(
                      icon: AppIcons.tiktok,
                    ),
                  ],
                ),
                30.verticalSpace,
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 0.45,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF4A4A4A),
                  Colors.transparent,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          70.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildSocialIcon({
    required String icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 35.w,
        height: 35.w,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            icon,
            width: 18.w,
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
    );
  }
}
