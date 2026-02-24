import 'dart:ui';

import 'package:app/app/core/utils/app_images.dart';
import 'package:app/app/gobal_controllers/buy_points_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../config/routes/app_pages.dart';
import '../../core/utils/app_icons.dart';
import '../../core/utils/colors_manager.dart';
import '../../core/utils/strings_manager.dart';
import '../../core/utils/styles_manager.dart';
import '../../data/model/project.dart';
import '../../modules/contractor/contractor_dashboard/controllers/contractor_dashboard_controller.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;

  const ProjectCard({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onProjectTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7.r),
        child: Container(
          margin: EdgeInsets.only(bottom: 20.h),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 18,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 151.h,
                    child: Image.network(
                      project.image,
                      height: 151.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (project.isLocked)
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          color: Colors.white.withOpacity(0.3),
                          child: Center(
                            child: Icon(
                              Icons.lock,
                              color: Colors.black,
                              size: 40.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.projectTitle,
                            style: semiBoldStyle(
                              color: AppColors.primaryColor,
                              fontSize: 20,
                            ),
                          ),
                          10.verticalSpace,
                          Row(
                            children: [
                              SvgPicture.asset(
                                AppIcons.users,
                                height: 20.h,
                                width: 20.w,
                              ),
                              8.horizontalSpace,
                              Text(
                                '${project.offersNumber} ${AppStrings.offers.tr}',
                                style: Get.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _statusChip(project.projectStatus),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusChip(bool status) => Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: status
              ? AppColors.successColor.withOpacity(0.1)
              : AppColors.errorColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Text(
          status ? AppStrings.active.tr : AppStrings.closed.tr,
          style: Get.textTheme.bodySmall,
        ),
      );

  void openLockedProject() {
    LockedProjectDialog.show(
      onConfirm: () => Get.toNamed('${Routes.PROJECT}/${project.projectId}'),
    );
  }

  void pointsDialog() {
    PointsProjectDialog.show(
      onConfirm: () {
        Get.find<BuyPointsController>().openDialog();
      },
    );
  }

  void onProjectTap() {
    /*
    1
المشروع مفتوح يقدر يدخل المقاول لصفحة تفاصيل المشروع مباشرة بدون اي رسالة تنبيهية

2
المشروع مقفل والمقاول يملك رصيد
يتم اظهار رسالة تنبيه انه سيتم خصم نقطة عند فتح المشروع لاول مرة فقط

3
المشروع مقفل والمقاول رصيده صفر
يظهرلو رسالة الرجاء شحن الرصيد الموجودة حاليا

4
المشروع غير مقفل والمقاول لا يملك رصيد
لاداعي للرصيد هنا بما ان المشروع مفتوح يدخل متى يشاء للتفاصيل
     */

    if (!project.isLocked) {
      Get.toNamed('${Routes.PROJECT}/${project.projectId}');
    } else {
      final remainingOffers = Get.find<ContractorDashboardController>()
          .statistics()
          .remainingOffers;
      if (remainingOffers > 0) {
        openLockedProject();
      } else {
        pointsDialog();
      }
    }
  }
}

class LockedProjectDialog {
  static void show({required VoidCallback onConfirm}) {
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 12.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_rounded,
                color: const Color(0xFFE6B400),
                size: 80.sp,
              ),
              6.verticalSpace,
              Text(
                AppStrings.note.tr,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              16.verticalSpace,
              Text(
                AppStrings.lockedProjectMessage.tr,
                maxLines: null,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12.sp,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              32.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[400],
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        AppStrings.back.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  16.horizontalSpace,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        onConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        AppStrings.continue_.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
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
}

class PointsProjectDialog {
  static void show({required VoidCallback onConfirm}) {
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 12.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppImages.pointStar,
                height: 80.sp,
              ),
              6.verticalSpace,
              Text(
                AppStrings.youDOntHavePoints.tr,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              16.verticalSpace,
              Text(
                AppStrings.lockedProjectMessage1.tr,
                maxLines: null,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12.sp,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              32.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[400],
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        AppStrings.back.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  16.horizontalSpace,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        onConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        AppStrings.continue_.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
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
}
