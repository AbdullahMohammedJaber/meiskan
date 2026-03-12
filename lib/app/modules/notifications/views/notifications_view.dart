import 'package:app/app/config/routes/app_pages.dart';
import 'package:app/app/core/utils/app_icons.dart';
import 'package:app/app/core/utils/colors_manager.dart';
import 'package:app/app/core/utils/scroll_behavior.dart';
import 'package:app/app/core/utils/strings_manager.dart';
import 'package:app/app/data/model/notification.dart';
import 'package:app/app/widgets/appbar/appbar.dart';
import 'package:app/app/widgets/states/app_empty_state.dart';
import 'package:app/app/widgets/states/app_error_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../controllers/notifications_controller.dart';

class NotificationsView extends StatefulWidget {
  final bool showAppBar;

  const NotificationsView({super.key, this.showAppBar = true});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  late NotificationsController controller;

  @override
  void initState() {
    super.initState();

    controller =
        Get.put(NotificationsController(), tag: UniqueKey().toString());
  }

  @override
  void dispose() {
    Get.delete<NotificationsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !widget.showAppBar ? null : const CustomAppBar(),
      body: SafeArea(
        child: Obx(() {
          if (controller.hasError.value) {
            return AppErrorState(
              onRetry: () => controller.fetch(refresh: true),
            );
          }

          if (controller.isLoading.value && controller.notifications.isEmpty) {
            return Center(child: Text(AppStrings.loading.tr));
          }

          if (!controller.isLoading.value && controller.notifications.isEmpty) {
            return const AppEmptyState(
              title: AppStrings.noNotifications,
              description: AppStrings.noNotificationsDescription,
              icon: Icons.notifications_none_outlined,
            );
          }

          return RefreshIndicator(
            onRefresh: () async => await controller.fetch(refresh: true),
            child: ScrollConfiguration(
              behavior: CustomScrollBehavior(),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: controller.notifications.length +
                          (controller.isLoading.value &&
                                  !controller.hasError.value
                              ? 1
                              : 0),
                      separatorBuilder: (_, __) => 1.verticalSpace,
                      itemBuilder: (context, index) {
                        if (index >= controller.notifications.length) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(child: Text(AppStrings.loading.tr)),
                          );
                        }

                        final notification = controller.notifications[index];
                        return _NotificationCard(item: notification);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.item});

  final NotificationModel item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('${Routes.PROJECT}/${item.projectId.toString()}');
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        color: item.seen ? Colors.white : Colors.grey.shade300,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 54.w,
                height: 54.w,
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  AppIcons.bell,
                  width: 25.w,
                ),
              ),
              14.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      maxLines: null,
                      overflow: TextOverflow.visible,
                      style: Get.textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                    2.verticalSpace,
                    Text(
                      item.message,
                      maxLines: null,
                      overflow: TextOverflow.visible,
                      style: Get.textTheme.bodySmall!.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    6.verticalSpace,
                    Text(
                      DateFormat('yyyy-MM-dd – kk:mm').format(item.createdAt),
                      style: Get.textTheme.bodySmall!.copyWith(
                        color: AppColors.grey,
                        fontSize: 10.sp,
                      ),
                      maxLines: null,
                      overflow: TextOverflow.visible,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
