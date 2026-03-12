import 'package:app/app/config/routes/app_pages.dart';
import 'package:app/app/core/enums/enums.dart';
import 'package:app/app/core/utils/app_icons.dart';
import 'package:app/app/core/utils/colors_manager.dart';
import 'package:app/app/gobal_controllers/user_controller.dart';
import 'package:app/app/modules/contractor/contractor_home/controllers/counter_controller.dart';
import 'package:app/app/modules/owner/owner_dashboard/controllers/counter_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../core/utils/app_images.dart';
import '../../core/utils/strings_manager.dart';
import 'appbar_controller.dart';

dynamic counters;

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(65.h);
}

class _CustomAppBarState extends State<CustomAppBar> {
  Future<void> _initCounter() async {
    final userController = Get.find<UserController>();

    final user = userController.user.value;

    if (user == null) return;

    if (user.type == AccountType.owner) {
      if (!Get.isRegistered<CountersController>()) {
        counters = Get.put(CountersController(), permanent: true);
      } else {
        counters = Get.find<CountersController>();
      }
    } else {
      if (!Get.isRegistered<CountersControllerContractor>()) {
        counters = Get.put(CountersControllerContractor(), permanent: true);
      } else {
        counters = Get.find<CountersControllerContractor>();
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _initCounter();
  }

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<TopDrawerController>()) {
      Get.put(TopDrawerController(), permanent: true);
    }

    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      elevation: 3,
      shadowColor: AppColors.primaryColor.withOpacity(0.2),
      titleSpacing: 0,
      centerTitle: true,
      title: _buildAppBarContainer(context),
    );
  }
}

Widget _buildAppBarContainer(BuildContext context) {
  final controller = TopDrawerController.to;

  return Obx(
    () {
      final user = Get.find<UserController>().user();
      final isGuest = user == null;
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            _buildActionButton(
              pngIcon: AppImages.logo,
              backgroundColor: const Color(0xffE9E9E9),
              onTap: onLogoPressed,
            ),
            const Spacer(),
            if (isGuest) ...[
              _buildTextButton(
                text: AppStrings.loginHere.tr,
                onTap: () => _goToAuthRoute(Routes.LOGIN),
              ),
              10.horizontalSpace,
              _buildTextButton(
                text: AppStrings.new_.tr,
                onTap: () => _goToAuthRoute(Routes.REGISTER),
                isPrimary: true,
              ),
            ] else ...[
              _buildActionButton(
                  svgIcon: AppIcons.bell,
                  badgeCount: counters?.unreadNotifications,
                  onTap: () {
                    counters?.resetNotifications();
                    Get.toNamed(Routes.NOTIFICATIONS);
                  }),
              10.horizontalSpace,
              _buildActionButton(
                svgIcon: AppIcons.email,
                badgeCount: counters?.unreadMessages,
                onTap: () => Get.toNamed(Routes.MESSAGES),
              ),
              10.horizontalSpace,
              if (user.type == AccountType.owner)
                _buildActionButton(
                  svgIcon: AppIcons.addCircle,
                  onTap: () => Get.toNamed(Routes.CREATE_PROJECT),
                )
              else
                _buildActionButton(
                  svgIcon: AppIcons.user,
                  onTap: () => Get.toNamed(Routes.CONTRACTOR_PROFILE_DETAILS),
                ),
            ],
            10.horizontalSpace,
            _buildAppBarDivider(),
            10.horizontalSpace,
            Obx(() => _buildActionButton(
                  icon:
                      controller.isDrawerOpen.value ? Icons.close : Icons.menu,
                  isActive: true,
                  backgroundColor: AppColors.primaryColor,
                  onTap: () {
                    controller.toggleDrawer();
                    if (controller.isDrawerOpen.value) {
                      _showTopDrawer(context);
                    }
                  },
                )),
          ],
        ),
      );
    },
  );
}

void onLogoPressed() {
  final userController =
      Get.isRegistered<UserController>() ? Get.find<UserController>() : null;
  final user = userController?.user();
  if (user == null) {
    Get.toNamed(Routes.HOME);
    return;
  }

  final targetRoute = user.type == AccountType.owner
      ? Routes.OWNER_DASHBOARD
      : Routes.CONTRACTOR_HOME;
  if (Get.currentRoute == targetRoute) return;
  Get.offAllNamed(targetRoute);
}

void _goToAuthRoute(String route) {
  if (Get.currentRoute == route) return;
  Get.offAllNamed(route);
  return;
}

Widget _buildTextButton({
  required String text,
  required VoidCallback onTap,
  bool isPrimary = false,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 50.w,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: isPrimary
            ? AppColors.primaryColor
            : const Color(0xffD8E7E4).withOpacity(0.5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        text,
        style: Get.textTheme.bodyMedium!.copyWith(
          fontSize: 14.sp,
          color: isPrimary ? Colors.white : AppColors.primaryColor,
        ),
      ),
    ),
  );
}

void _showTopDrawer(BuildContext context) {
  final controller = TopDrawerController.to;

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation1, animation2) {
      return _Drawer(animation1: animation1, animation2: animation2);
    },
  ).then((_) {
    controller.closeDrawer();
  });
}

Widget _buildDrawerMenuItem({
  required String title,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(
        horizontal: 40.w,
        vertical: 20.h,
      ),
      child: Text(
        title,
        style: Get.textTheme.bodyMedium!.copyWith(
          fontSize: 16.sp,
        ),
      ),
    ),
  );
}

Widget _buildAppBarDivider() {
  return Container(
    width: 1.w,
    height: 43.w,
    color: AppColors.primaryColor,
  );
}

Widget _buildActionButton({
  IconData? icon,
  String? svgIcon,
  String? pngIcon,
  Color backgroundColor = const Color(0xffFAFAFA),
  VoidCallback? onTap,
  bool isActive = false,
  RxInt? badgeCount,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.r),
            border: isActive
                ? null
                : Border.all(
                    color: const Color(0xffEFEFEF),
                    width: 1.25,
                  ),
          ),
          alignment: Alignment.center,
          child: icon != null
              ? Icon(
                  icon,
                  color: isActive ? Colors.white : const Color(0xFF2C2C2E),
                  size: 22.sp,
                )
              : svgIcon != null
                  ? SvgPicture.asset(
                      svgIcon,
                      width: 25.w,
                      height: 25.w,
                      fit: BoxFit.scaleDown,
                      color: AppColors.primaryColor,
                    )
                  : Image.asset(
                      pngIcon!,
                      width: 30.w,
                      height: 30.w,
                      color: AppColors.primaryColor,
                    ),
        ),
        if (badgeCount != null && badgeCount.value > 0)
          Obx(() {
            return Positioned(
              right: -6,
              top: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                constraints: BoxConstraints(
                  minWidth: 18.w,
                  minHeight: 18.w,
                ),
                child: Center(
                  child: Text(
                    badgeCount.value > 99 ? '99+' : badgeCount.value.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }),
      ],
    ),
  );
}

class _Drawer extends StatelessWidget {
  final Animation<double> animation1;
  final Animation<double> animation2;

  const _Drawer({
    required this.animation1,
    required this.animation2,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TopDrawerController.to;
    return Padding(
      padding: EdgeInsets.only(top: Get.mediaQuery.padding.top + 65.h),
      child: GestureDetector(
        onTap: () {
          controller.closeDrawer();
          Navigator.pop(context);
        },
        child: Container(
          height: double.infinity,
          color: Colors.black54,
          child: Align(
            alignment: Alignment.topCenter,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation1,
                curve: Curves.easeOutCubic,
              )),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.r),
                      bottomRight: Radius.circular(10.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(height: 1),
                      /* Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: AppTextField(
                          inputDecoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                            ),
                          ),
                          svgIcon: AppIcons.search,
                          hint: AppStrings.searchForProjects.tr,
                        ),
                      ),
                      10.verticalSpace,*/
                      _buildDrawerMenuItem(
                        title: AppStrings.homePage.tr,
                        onTap: () {
                          Navigator.pop(context);
                          controller.closeDrawer();
                          Get.toNamed(Routes.HOME);
                        },
                      ),
                      Obx(() {
                        final user = Get.find<UserController>().user();
                        return Visibility(
                          visible: user != null,
                          child: Column(
                            children: [
                              const Divider(height: 1),
                              _buildDrawerMenuItem(
                                title: AppStrings.allProjects.tr,
                                onTap: () {
                                  Navigator.pop(context);
                                  controller.closeDrawer();
                                  if (user!.type == AccountType.owner) {
                                    Get.toNamed(Routes.OWNER_DASHBOARD);
                                  } else {
                                    Get.toNamed(Routes.CONTRACTOR_HOME);
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                      const Divider(height: 1),
                      _buildDrawerMenuItem(
                        title: AppStrings.termsAndConditions.tr,
                        onTap: () {
                          Navigator.pop(context);
                          controller.closeDrawer();
                          Get.toNamed(Routes.TERMS_AND_CONDITIONS);
                        },
                      ),
                      const Divider(height: 1),
                      // Custom logout button with red color and icon
                      Obx(
                        () {
                          final isGuest =
                              Get.find<UserController>().user() == null;

                          return Visibility(
                            visible: !isGuest,
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    controller.closeDrawer();
                                    Get.find<UserController>().onLogout();
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    color: Colors.transparent,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 40.w,
                                      vertical: 20.h,
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppIcons.logout,
                                          width: 20.w,
                                          height: 20.w,
                                          color: Colors.red,
                                        ),
                                        15.horizontalSpace,
                                        Text(
                                          AppStrings.logout.tr,
                                          style: Get.textTheme.bodyMedium!
                                              .copyWith(
                                            fontSize: 16.sp,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                10.verticalSpace,
                                GestureDetector(
                                  onTap: () {
                                    controller.closeDrawer();
                                    Navigator.pop(context);
                                    Future.microtask(_showDeleteAccountDialog);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    color: Colors.transparent,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 40.w,
                                      vertical: 20.h,
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppIcons.logout,
                                          width: 20.w,
                                          height: 20.w,
                                          color: Colors.red,
                                        ),
                                        15.horizontalSpace,
                                        Text(
                                          AppStrings.deleteAccount.tr,
                                          style: Get.textTheme.bodyMedium!
                                              .copyWith(
                                            fontSize: 16.sp,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
}
