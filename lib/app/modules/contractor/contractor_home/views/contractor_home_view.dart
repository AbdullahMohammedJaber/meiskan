import 'package:app/app/core/utils/app_icons.dart';
import 'package:app/app/core/utils/colors_manager.dart';
import 'package:app/app/core/utils/strings_manager.dart';
import 'package:app/app/widgets/appbar/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../contractor_dashboard/widgets/contractor_filter_drawer.dart';
import '../controllers/contractor_home_controller.dart';

class ContractorHomeView extends GetView<ContractorHomeController> {
  const ContractorHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const ContractorFilterDrawer(),
        drawerEnableOpenDragGesture: false,
        key: controller.scaffoldKey,
        appBar: const CustomAppBar(),
        bottomNavigationBar: _bottomNavBar(),
        body: Obx(() => controller.pages[controller.selectedIndex()]));
  }

  _bottomNavBar() => Container(
        height: 75.h,
        padding: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.1),
              blurRadius: 14,
              offset: const Offset(0, -7),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              svgIcon: AppIcons.house,
              label: AppStrings.projects.tr,
              index: 0,
            ),
            _buildNavItem(
              svgIcon: AppIcons.bell,
              label: AppStrings.notifications.tr,
              index: 1,
            ),
            _buildNavItem(
              svgIcon: AppIcons.profile,
              label: AppStrings.myProfile.tr,
              index: 2,
            ),
          ],
        ),
      );

  Widget _buildNavItem({
    required String svgIcon,
    required String label,
    required int index,
  }) =>
      Obx(
        () {
          final selectedIndex = controller.selectedIndex();
          final isSelected = selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => controller.selectedIndex(index),
              child: Container(
                height: double.infinity,
                color: Colors.transparent,
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      svgIcon,
                      width: 24.w,
                      height: 24.h,
                      color: isSelected ? Colors.white : AppColors.grey,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      label,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.grey,
                        fontSize: 11.sp,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
}
