import 'package:app/app/config/routes/app_pages.dart';
import 'package:app/app/core/utils/app_icons.dart';
import 'package:app/app/core/utils/colors_manager.dart';
import 'package:app/app/core/utils/scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/utils/strings_manager.dart';
import '../../../../gobal_controllers/user_controller.dart';
import '../controllers/contractor_profile_controller.dart';

class ContractorProfileView extends GetView<ContractorProfileController> {
  const ContractorProfileView({super.key});

  @override
  ContractorProfileController get controller =>
      Get.put(ContractorProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            children: [
              _actionTile(
                svgIcon: AppIcons.userOutlined,
                title: AppStrings.myProfile.tr,
                onTap: ()=>Get.toNamed(Routes.CONTRACTOR_PROFILE_DETAILS)
              ),
              _actionTile(
                svgIcon: AppIcons.badgeOutlined,
                title: AppStrings.ratings.tr,
                  onTap: ()=>Get.toNamed(Routes.CONTRACTOR_RATINGS)
              ),
              _actionTile(
                svgIcon: AppIcons.logout,
                title: AppStrings.logout.tr,
                showArrow: false,
                onTap: Get.find<UserController>().onLogout,
              ),
              _actionTile(
                svgIcon: AppIcons.logout,
                title: AppStrings.deleteAccount.tr,
                showArrow: false,
                onTap: _showDeleteAccountDialog,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    if (Get.isDialogOpen ?? false) {
      return;
    }

    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_rounded,
                color: Colors.red,
                size: 48.sp,
              ),
              12.verticalSpace,
              Text(
                AppStrings.confirmDeleteAccount.tr,
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              12.verticalSpace,
              Text(
                AppStrings.accountDeletionNotice.tr,
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  fontSize: 13.sp,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              24.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black87,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(AppStrings.cancel.tr),
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.find<UserController>().onLogout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        AppStrings.confirm.tr,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _actionTile({
    required String svgIcon,
    required String title,
    bool showArrow = true,
    VoidCallback? onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 53.w,
                height: 53.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  svgIcon,
                  width: 22.w,
                  color: Colors.white,
                ),
              ),
              16.horizontalSpace,
              Expanded(
                child: Text(
                  title,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                  ),
                ),
              ),
              Visibility(
                visible: showArrow,
                child: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ),
      );
}
